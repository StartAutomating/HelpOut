﻿function Save-MarkdownHelp
{
    <#
    .Synopsis
        Saves a Module's Markdown Help
    .Description
        Get markdown help for each command in a module and saves it to the appropriate location.
    .Link
        Get-MarkdownHelp
    .Example
        Save-MarkdownHelp -Module HelpOut  # Save Markdown to HelpOut/docs
    .Example
        Save-MarkdownHelp -Module HelpOut -Wiki # Save Markdown to ../HelpOut.wiki
    #>
    param(
    # The name of one or more modules.
    [Parameter(ParameterSetName='ByModule',ValueFromPipelineByPropertyName)]
    [Alias('Name')]
    [string[]]
    $Module,

    # The output path.
    # If not provided, will be assumed to be the "docs" folder of a given module (unless -Wiki is specified)
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $OutputPath,

    # If set, will interlink documentation as if it were a wiki.  Implied when -OutputPath contains 'wiki'.
    # If provided without -OutputPath, will assume that a wiki resides in a sibling directory of the module.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Wiki,

    # If provided, will generate documentation for additional commands.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Management.Automation.CommandInfo[]]
    $Command,

    # Replaces parts of the names of the commands provided in the -Command parameter.
    # -ReplaceScriptName is treated as a regular expression.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $ReplaceCommandName,

    # If provided, will replace parts of the names of the scripts discovered in a -Command parameter with a given Regex replacement.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $ReplaceCommandNameWith = @(),

    # If provided, will generate documentation for any scripts found within these paths.
    # -ScriptPath can be either a file name or a full path.
    # If an exact match is not found -ScriptPath will also check to see if there is a wildcard match.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $ScriptPath,

    # If provided, will replace parts of the names of the scripts discovered in a -ScriptDirectory beneath a module.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $ReplaceScriptName,

    # If provided, will replace parts of the names of the scripts discovered in a -ScriptDirectory beneath a module with a given Regex replacement.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $ReplaceScriptNameWith = @(),

    # If provided, will replace links discovered in markdown content.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $ReplaceLink,

    # If provided, will replace links discovered in markdown content with a given Regex replacement.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $ReplaceLinkWith = @(),

    # If set, will output changed or created files.
    [switch]
    $PassThru,

    # The order of the sections.  If not provided, this will be the order they are defined in the formatter.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $SectionOrder,

    # One or more topic files to include.
    # Topic files will be treated as markdown and directly copied inline.
    # By default ```\.help\.txt$``` and ```\.md$```
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $IncludeTopic = @('\.help\.txt$', '\.md$'),

    # One or more topic file patterns to exclude.
    # Topic files that match this pattern will not be included.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $ExcludeTopic = @('\.ps1{0,1}\.md$'),

    # One or more files to exclude.
    # By default, this is treated as a wildcard.
    # If the file name starts and ends with slashes, it will be treated as a Regular Expression.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ExcludePath','ExcludeDirectory','ExcludeFolder')]
    [string[]]
    $ExcludeFile,

    # A whitelist of files or directories to include.
    # If this is provided, only files that match these criteria will be included.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('IncludePath','IncludeDirectory','IncludeFolder')]
    [string[]]
    $IncludeFile,

    # One or more extensions to include.
    # By default, .css, .gif, .htm, .html, .js, .jpg, .jpeg, .mp4, .png, .svg
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $IncludeExtension = @('.css','.gif', '.htm', '.html','.js', '.jpg', '.jpeg', '.mp4', '.png', '.svg'),

    # One or more extensions to exclude.
    # By default, not extensions are specifically excluded.    
    [string[]]
    $ExcludeExtension,

    # If set, will explicitly include submodule directories.
    [switch]
    $IncludeSubmodule,

    # If set, will explicitly exclude submodule directories.
    # This is the default.
    [switch]
    $ExcludeSubModule,

    # If set, will not enumerate valid values and enums of parameters.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $NoValidValueEnumeration,

    # If set, will not attach a YAML header to the generated help.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('IncludeFrontMatter', 'IncludeHeader')]
    [switch]
    $IncludeYamlHeader,

    # The type of information to include in the YAML Header
    [ValidateSet('Command','Help','Metadata')]
    [Alias('YamlHeaderInfoType')]
    [string[]]
    $YamlHeaderInformationType,

    # A list of command types to skip.
    # If not provided, all types of commands from the module will be saved as a markdown document.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('SkipCommandTypes','ExcludeCommandType','ExcludeCommandTypes')]
    [Management.Automation.CommandTypes[]]
    $SkipCommandType,

    # The formatting used for unknown attributes.
    # Any key or property in this object will be treated as a potential typename
    # Any value will be the desired formatting.
    # If the value is a [ScriptBlock], the [ScriptBlock] will be run.
    # If the value is a [string], it will be expanded
    # In either context, `$_` will be the current attribute.
    [PSObject]
    $FormatAttribute
    )

    begin {
        # First, let's cache a reference to Get-MarkdownHelp
        $GetMarkdownHelp =
            if ($MyInvocation.MyCommand.ScriptBlock.Module) {
                $MyInvocation.MyCommand.ScriptBlock.Module.ExportedCommands['Get-MarkdownHelp']
            } else {
                $ExecutionContext.SessionState.InvokeCommand.GetCommand('Get-MarkdownHelp', 'Function')
            }

        $NotExcluded = {
            if ($IncludeFile) {
                $shouldIncludePath = 
                    foreach ($include in $IncludeFile) {
                        if ($include -match '^/' -and $include -match '/$') {
                            if ([Regex]::New(
                                $include -replace '^/' -replace '/$', 'IgnoreCase,IgnorePatternWhitespace'
                            ).Match($_.FullName)) {
                                $true;break
                            }
                        } else {
                            if ($_.FullName -like $include -or $_.Name -like $include) {
                                $true;break
                            }
                        }
                    }
                if (-not $shouldIncludePath) { return $false }
            }
            if (-not $ExcludeFile) { return $true }
            foreach ($ex in $ExcludeFile) {
                if ($ex -match '^/' -and $ex -match '/$') {
                    if ([Regex]::New(
                        $ex -replace '^/' -replace '/$', 'IgnoreCase,IgnorePatternWhitespace'
                    ).Match($_.FullName)) {
                        return $false
                    }
                } else {
                    if ($_.FullName -like $ex -or $_.Name -like $ex) {
                        return $false
                    }
                }
            }
            return $true
        }

        $filesChanged = @()
    }

    process {
        $getMarkdownHelpSplatBase = @{}

        foreach ($param in $psBoundParameters.Keys) {
            if ($GetMarkdownHelp.Parameters[$param]) {
                $getMarkdownHelpSplatBase[$param] = $psBoundParameters[$param]
            }
        }

        $c = 0
        $t = $Module.Count        

        #region Save the Markdowns
        foreach ($m in $Module) { # Walk thru the list of module names.
            if ($t -gt 1) {
                $c++
                $p = $c * 100 / $t
                Write-Progress 'Saving Markdown' $m -PercentComplete $p  -Id $id
            }

            $theModule = Get-Module $module # Find the module
            if (-not $theModule) { continue } # (continue if we couldn't).
            $theModuleRoot = $theModule | Split-Path # Find the module's root.
            if (-not $psBoundParameters.OutputPath) { # If no -OutputPath was provided
                $OutputPath =
                    if ($Wiki) { # set the default.  If it's a wiki, it's a sibling directory
                        Split-Path $theModuleRoot | Join-Path -ChildPath "$($theModule.Name).wiki"
                    } else {
                        Join-Path $theModuleRoot "docs" # Otherwise, it's the docs subdirectory.
                    }
            } else { 
                # If -OutputPath was provided, we want to make sure it becomes an absolute path
                $OutputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
            }

            # If the -OutputPath does not exist
            if (-not (Test-Path $OutputPath)) {
                $null = New-Item -ItemType Directory -Path $OutputPath # create it.
            }

            if ((-not $ExcludeSubModule) -and (-not $IncludeSubmodule)) {
                Push-Location $theModuleRoot
                
                $gitCmd = $ExecutionContext.SessionState.InvokeCommand.GetCommand('git','Alias,Application')
                $submoduleRoots = 
                    if ($gitCmd -is [Management.Automation.AliasInfo]) {
                        git submodule | Select-Object -ExpandProperty Submodule
                    }
                    else {
                        git submodule | & { process {@($_ -split '\s')[1]} }
                    }

                if ($submoduleRoots) {
                    $ExcludeFile += "$($pwd)$([io.path]::DirectorySeparatorChar)$submoduleRoot$([io.path]::DirectorySeparatorChar)*"
                }

                Pop-Location
            }

            $outputPathName = $OutputPath | Split-Path -Leaf
            $ReplaceLink   += "^$outputPathName[\\/]"

            # Double-check that the output path
            $outputPathItem = Get-Item $OutputPath
            if ($outputPathItem -isnot [IO.DirectoryInfo]) { # is not a directory
                # (if it is, error out).
                Write-Error "-OutputPath '$outputPath' must point to a directory"
                return
            }

            # Next we're going to call Get-MarkdownHelp on each exported command.
            foreach ($cmd in $theModule.ExportedCommands.Values) {
                # If we specified command types to skip, skip them now.
                if ($SkipCommandType -and $SkipCommandType -contains $cmd.CommandType) {
                    continue
                }

                # Determine the output path for each item.
                $docOutputPath = Join-Path $outputPath ($cmd.Name + '.md')
                # Prepare a splat for this command by copying out base splat.
                $getMarkdownHelpSplat = @{Name="$cmd"} + $getMarkdownHelpSplatBase

                # If -Wiki was passed, call Get-MarkDownHelp with -Wiki (this impacts link format)
                if ($Wiki) { $getMarkdownHelpSplat.Wiki = $Wiki }
                # otherwise, pass down the parent of $OutputPath.
                else { $getMarkdownHelpSplat.GitHubDocRoot = "$($outputPath|Split-Path -Leaf)"}

                $markdownTopic = Get-MarkdownHelp @getMarkdownHelpSplat                
                $markdownFile  =
                    if ($markdownTopic.Save) {
                        $markdownTopic.Save($docOutputPath)
                    } else { $null }

                if ($markdownFile) {                
                    $filesChanged += $markdownFile

                    if ($PassThru) { # If -PassThru was provided, get the path.
                        $markdownFile
                    }
                }
            }

            if ($Command) {
                foreach ($cmd in $Command) {
                    # For each script that we find, prepare to call Get-MarkdownHelp
                    $getMarkdownHelpSplat = @{
                        Name= if ($cmd.Source) { "$($cmd.Source)" } else { "$cmd" }
                    } + $getMarkdownHelpSplatBase

                    $replacedCmdName =
                        if ($cmd.DisplayName) {
                            $cmd.DisplayName
                        } elseif ($cmd.Name -and $cmd.Name.Contains([IO.Path]::DirectorySeparatorChar)) {
                            $cmd.Name
                        }

                    @(for ($ri = 0; $ri -lt $ReplaceCommandName.Length; $ri++) { # Walk over any -ReplaceScriptName(s) provided.
                        # Replace it with the -ReplaceScriptNameWith parameter (if present).
                        if ($ReplaceCommandNameWith -and $ReplaceCommandNameWith[$ri]) {
                            $replacedCmdName = $replacedCmdName -replace $ReplaceCommandName[$ri], $ReplaceCommandNameWith[$ri]
                        } else {
                            # Otherwise, just remove the replacement.
                            $replacedCmdName = $replacedCmdName -replace $ReplaceCommandName[$ri]
                        }
                    })

                    # Determine the output path for each item.
                    $docOutputPath = Join-Path $outputPath ($replacedCmdName + '.md')
                    $getMarkdownHelpSplat.Rename = $replacedCmdName
                    if ($Wiki) { $getMarkdownHelpSplat.Wiki = $Wiki}
                    else { $getMarkdownHelpSplat.GitHubDocRoot = "$($outputPath|Split-Path -Leaf)"}
                    $markdownFile  = $null
                    try {
                        $markdownTopic = Get-MarkdownHelp @getMarkdownHelpSplat
                        $markdownFile  =
                            if ($markdownTopic.Save) {
                                $markdownTopic.Save($docOutputPath)
                            } else { $null }
                    }
                    catch {
                        $ex = $_
                        Write-Error -Exception $ex.Exception -Message "Could not Get Help for $($cmd.Name): $($ex.Exception.Message)" -TargetObject $getMarkdownHelpSplat
                    }

                    if ($markdownFile) {
                        $filesChanged += # add the file to the changed list.
                            $markdownFile

                        # If -PassThru was provided (and we're not going to change anything)
                        if ($PassThru -and -not $ReplaceLink) {
                            $filesChanged[-1] # output the file changed now.
                        }
                    }

                }
            }
            # If a -ScriptPath was provided
            if ($ScriptPath) {
                # get the child items beneath the module root.
                Get-ChildItem -Path $theModuleRoot -Recurse |
                    Where-Object {
                        # Any Script Path whose Name or FullName is
                        foreach ($sp in $ScriptPath) {
                            $_.Name -eq $sp -or     # an exact match,
                            $_.FullName -eq $sp -or
                            $_.Name -like $sp -or   # a wildcard match,
                            $_.FullName -like $sp -or $(
                                $spRegex = $sp -as [regex]
                                $spRegex -and (    # or a regex match
                                    $_.Name -match $spRegex -or
                                    $_.FullName -match $spRegex
                                )
                            )
                        }
                        # will be included.
                    } |
                    # Any child items of that path will also be included
                    Get-ChildItem -Recurse |
                    Where-Object Extension -eq '.ps1' | # (as long as they're PowerShell Scripts).
                    Where-Object $NotExcluded | # (and as long as they're not excluded)
                    ForEach-Object {
                        $ps1File = $_
                        # For each script that we find, prepare to call Get-MarkdownHelp
                        $getMarkdownHelpSplat = @{Name="$($ps1File.FullName)"} + $getMarkdownHelpSplatBase
                        # because not all file names will be valid (or good) topic names
                        $replacedFileName = $ps1File.Name # prepare to replace the file.
                        @(for ($ri = 0; $ri -lt $ReplaceScriptName.Length; $ri++) { # Walk over any -ReplaceScriptName(s) provided.
                            if ($ReplaceScriptNameWith -and $ReplaceScriptNameWith[$ri]) {
                                # Replace it with the -ReplaceScriptNameWith parameter (if present).
                                $replacedFileName = $replacedFileName -replace $ReplaceScriptName[$ri], $ReplaceScriptNameWith[$ri]
                            } else {
                                # Otherwise, just remove the replacement.
                                $replacedFileName = $replacedFileName -replace $ReplaceScriptName[$ri]
                            }
                        })
                        # Determine the output path
                        $docOutputPath = Join-Path $outputPath ($replacedFileName + '.md')
                        # and the relative path of this .ps1 to the module root.
                        $relativePath = $ps1File.FullName.Substring("$theModuleRoot".Length).TrimStart('/\').Replace('\','/')
                        # Then, rename the potential topic with it's relative path.
                        $getMarkdownHelpSplat.Rename = $relativePath
                        if ($Wiki) { $getMarkdownHelpSplat.Wiki = $Wiki}
                        else { $getMarkdownHelpSplat.GitHubDocRoot = "$($outputPath|Split-Path -Leaf)"}
                        # Call Get-MarkdownHelp, .Save it, and
                        $markdownTopic = Get-MarkdownHelp @getMarkdownHelpSplat
                        $markdownFile  =
                            if ($markdownTopic.Save) {
                                $markdownTopic.Save($docOutputPath)
                            } else { $null }
                        if ($markdownFile) {
                            $filesChanged += $markdownFile # add the file to the changed list.

                            # If -PassThru was provided (and we're not going to change anything)
                            if ($PassThru -and -not $ReplaceLink) {
                                $markdownFile # output the file changed now.
                            }
                        }
                    }
            }

            # If -IncludeTopic was provided
            if ($IncludeTopic) {
                # get all of the children beneath the module root
                $filesArray = @(Get-ChildItem -Path $theModuleRoot -Recurse -File)
                # then reverse that list, so that the most shallow items come last.
                [array]::reverse($filesArray)
                $filesArray |
                    Where-Object $NotExcluded | # (and as long as they're not excluded)
                    ForEach-Object {
                        $fileInfo = $_
                        # Determine the relative path of the file.
                        $relativePath  =
                            $fileInfo.FullName.Substring("$theModuleRoot".Length) -replace '^[\\/]'
                        # If it is more than one layer deep, ignore it.
                        if ([Regex]::Matches($relativePath, "[\\/]").Count -gt 1) {
                            return
                        }
                        :NextTopicFile foreach ($inc in $IncludeTopic) { # find any files that should be included
                            $matches = $null
                            if ($fileInfo.Name -eq $inc -or
                                $fileInfo.Name -like $inc -or
                                $(
                                    $incRegex = $inc -as [regex]
                                    $incRegex -and $fileInfo.Name -match $incRegex
                                )
                            ) {
                                # Double-check that the file should not excluded.
                                foreach ($exclude in $ExcludeTopic) {
                                    if (
                                        $fileInfo.Name -eq $exclude -or
                                        $fileInfo.Name -like $exclude -or
                                        $(
                                            $exclude -as [regex] -and
                                            $fileInfo.Name -match $exclude
                                        )
                                    ) {
                                        continue NextTopicFile
                                    }
                                }
                                $replacedName =
                                    if ($matches) { # If $inc was a regex
                                        $fileInfo.Name -replace $inc # just replace it
                                    } else {
                                        # Otherwise, strip the file of it's extension
                                        $fileInfo.Name.Substring(0,
                                            $fileInfo.name.Length - $fileInfo.Extension.Length) -replace '\.help$' # (and .help).
                                    }

                                if ($replacedName -eq "about_$module") { # If the replaced named was "about_$Module"
                                    $replacedName = 'README' # treat it as the README
                                }
                                # Determine the output path
                                $dest = Join-Path $OutputPath ($replacedName + '.md')
                                # and make sure we're not overwriting ourselves
                                if ($fileInfo.FullName -ne "$dest") {
                                    $filesChanged += # copy the file and add it to the change list.
                                        $fileInfo | Copy-Item -Destination $dest -PassThru
                                }

                                # If -PassThru was passed and we're not changing anything.
                                if ($PassThru -and -not $ReplaceLink) {
                                    $filesChanged[-1] # output the file now.
                                }
                            }
                        }
                    }
            }

            # If -IncludeExtension was provided
            if ($IncludeExtension) {
                # get all files beneath the root
                Get-ChildItem -Path $theModuleRoot -Recurse -File |
                    Where-Object $NotExcluded | # (and as long as they're not excluded)
                    ForEach-Object {
                        $fileInfo = $_
                        if ($ExcludeExtension) {
                            foreach ($ext in $ExcludeExtension) {
                                if ($fileInfo.Extension -eq $ext -or $fileInfo.Extension -eq ".$ext") {
                                    return
                                }
                            }
                        }
                        foreach ($ext in $IncludeExtension) { # and see if they are the right extension
                            if ($fileInfo.Extension -eq $ext -or $fileInfo.Extension -eq ".$ext") {
                                # Determine the relative path
                                $relativePath   = $fileInfo.FullName.Substring("$theModuleRoot".Length) -replace '^[\\/]'
                                $outputPathLeaf = $outputPath | Split-Path -Leaf
                                # and use that to determine the destination of this file.
                                $dest = Join-Path $OutputPath $relativePath
                                if ($fileInfo.FullName -ne "$dest" -and
                                    $relativePath -notlike "$outputPathLeaf$([IO.Path]::DirectorySeparatorChar)*") {
                                    # Create the file (so it creates the folder structure).
                                    $createdFile = New-Item -ItemType File -Path $dest -Force
                                    if (-not $createdFile) { # If we could not, write and error and stop trying for this file.
                                        Write-Error "Unable to initialize file: '$dest'"
                                        break
                                    }
                                    # Copy the file to the destination.
                                    if ($fileInfo.FullName -ne "$dest") {
                                        $filesChanged += # and add it to the change list.
                                            $fileInfo | Copy-Item -Destination $dest -PassThru:$PassThru
                                    }

                                    # If -PassThru was passed and we're not changing anything.
                                    if ($PassThru -and -not $ReplaceLink) {
                                        $filesChanged[-1] # output the file now.
                                    }
                                }
                                break
                            }
                        }
                    }
            }

            #region Run Extensions to this Command
            $MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
            $ScriptPattern   = "$($MyModule.Name)\.$($MyInvocation.MyCommand.Name -replace '\p{P}')\.(?<Name>(?:.|\s){0,}?(?=\z|\.ps1))\.ps1"
            $commandWildcard = "$($MyModule.Name).$($MyInvocation.MyCommand.Name)*" 
            $commandPattern  = "$($myModule.Name)\.$($MyInvocation.MyCommand.Name -replace '\p{P}')\.(?<Name>(?:.|\s){0,}?(?=\z|\.ps1))"
            $myExtensions = @(
                foreach ($loadedModule in Get-Module){
                    if ($loadedModule -eq $MyModule -or 
                        $loadedModule -eq $m -or 
                        $loadedModule.Tags -contains $MyModule.Name) {
                        foreach ($file in Get-ChildItem -Recurse -Filter *.ps1 (
                            Split-Path $loadedModule.Path
                        )) {

                            if ($file.Name -notmatch $ScriptPattern) {
                                continue
                            }
                            $scriptCmd = $ExecutionContext.SessionState.InvokeCommand.GetCommand($file.FullName, 'ExternalScript')
                            $scriptCmd.psobject.Members.Add([psnoteproperty]::new("ExtensionName", $Matches.Name), $true)
                            if ($scriptCmd.pstypenames -notcontains "$($myModule.Name).Extension") {                        
                                $scriptCmd.pstypenames.insert(0, "$($myModule.Name).Extension")
                            }
                            $scriptCmd
                        }
                    }                
                }
                foreach ($cmdFound in $ExecutionContext.SessionState.InvokeCommand.GetCommands(
                    $commandWildcard, 'Function,Alias,Cmdlet', $true
                ) -match $commandPattern) {
                    $cmdFound.psobject.Members.Add([psnoteproperty]::new("ExtensionName", $Matches.Name), $true)
                    if ($cmdFound.pstypenames -notcontains "$($myModule.Name).Extension") {
                        $cmdFound.pstypenames.insert(0, "$($myModule.Name).Extension")
                    }
                    $cmdFound
                }
            )

            $extensionOutputs = @(foreach ($extension in $myExtensions) {
                $extensionSplat = [Ordered]@{}
                if ($extension.Parameters.Module) {
                    $extensionSplat.Module = $theModule
                }
                & $extension @extensionSplat                
            })

            if ($extensionOutputs) {
                foreach ($extensionOutput in $extensionOutputs) {
                    if ($extensionOutput -is [IO.FileInfo]) {
                        if ($extensionOutput.Extension -in '.md', '.markdown' -and $ReplaceLink) {
                            $filesChanged += $extensionOutput
                        } elseif ($PassThru) {
                            $extensionOutput
                        }                        
                    }
                }
            }
            #endregion Run Extensions to this Command
        }        

        if ($t -gt 1) {
            Write-Progress 'Saving Markdown' 'Complete' -Completed -Id $id
        }
        #endregion Save the Markdowns
    }

    end {
        if ($PassThru -and $ReplaceLink) {
            $linkFinder = [Regex]::new("
            (?<IsImage>\!)?    # If there is an exclamation point, then it is an image link
            \[                 # Markdown links start with a bracket
            (?<Text>[^\]\r\n]+)
            \]                 # anything until the end bracket is the link text.
            \(                 # The link uri is within parenthesis
            (?<Uri>[^\)\r\n]+)
            \)
            ", 'IgnoreCase,IgnorePatternWhitespace')
            foreach ($file in $filesChanged) {
                if ($file.Extension -notin '.md', '.markdown') {
                    $file
                    continue
                }
                $fileContent = Get-Content $file.FullName -Raw
                $fileContent = $linkFinder.Replace($fileContent, {
                    param($LinkMatch)
                    $linkReplacementNumber = 0

                    $linkUri  = $LinkMatch.Groups["Uri"].ToString()
                    $linkText = $linkMatch.Groups["Text"].ToString()
                    foreach ($linkToReplace in $ReplaceLink) {
                        $replacement = "$($ReplaceLinkWith[$linkReplacementNumber])"
                        $linkUri  = $linkUri  -replace $linkToReplace, $replacement
                        $linkText = $linkText -replace $linkToReplace, $replacement
                    }

                    if ($linkUri -match '\#.+$') {
                        $lowerCaseAnchor = ($matches.0).ToLower()
                        $linkUri = $linkUri -replace '\#.+$', $lowerCaseAnchor
                    }

                    if ($LinkMatch.Groups["IsImage"].Length) {
                        "![$linkText]($linkUri)"
                    } else {
                        "[$linkText]($linkUri)"
                    }
                })

                Set-Content $file.FullName -Encoding UTF8 -Value $fileContent.Trim()

                if ($PassThru) {
                    Get-Item -LiteralPath $file.FullName
                }
            }
        }
    }
}
