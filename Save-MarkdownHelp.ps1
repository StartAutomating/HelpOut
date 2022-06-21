function Save-MarkdownHelp
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
    [Parameter(ParameterSetName='ByModule',ValueFromPipelineByPropertyName=$true)]
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
    $ReplaceScriptNameWith,

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

    # One or more extensions to include.
    # By default, .css, .gif, .htm, .html, .js, .jpg, .jpeg, .mp4, .png
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $IncludeExtension = @('.css','.gif', '.htm', '.html','.js', '.jpg', '.jpeg', '.mp4', '.png'),

    # If set, will not enumerate valid values and enums of parameters.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $NoValidValueEnumeration,

    # A list of command types to skip.  
    # If not provided, all types of commands from the module will be saved as a markdown document.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('SkipCommandTypes','OmitCommandType','OmitCommandTypes')]
    [Management.Automation.CommandTypes[]]
    $SkipCommandType
    )

    begin {
        # First, let's cache a reference to Get-MarkdownHelp
        $GetMarkdownHelp = 
            if ($MyInvocation.MyCommand.ScriptBlock.Module) {
                $MyInvocation.MyCommand.ScriptBlock.Module.ExportedCommands['Get-MarkdownHelp']
            } else {
                $ExecutionContext.SessionState.InvokeCommand.GetCommand('Get-MarkdownHelp', 'Function')
            }
    }

    process {        
        $getMarkdownHelpSplatBase = @{}
        if ($SectionOrder) {
            $getMarkdownHelpSplatBase.SectionOrder =$SectionOrder
        }
        if ($NoValidValueEnumeration) {
            $getMarkdownHelpSplatBase.NoValidValueEnumeration =$true
        }
        #region Save the Markdowns
        foreach ($m in $Module) { # Walk thru the list of module names.            
            if ($t -gt 1) {
                $c++
                Write-Progress 'Saving Markdown' $m -PercentComplete $p  -Id $id
            }

            $theModule = Get-Module $m # Find the module
            if (-not $theModule) { continue } # (continue if we couldn't).
            $theModuleRoot = $theModule | Split-Path # Find the module's root.
            if (-not $psBoundParameters.OutputPath) { # If no -OutputPath was provided
                $OutputPath = 
                    if ($Wiki) { # set the default.  If it's a wiki, it's a sibling directory
                        Split-Path $theModuleRoot | Join-Path -ChildPath "$($theModule.Name).wiki"
                    } else {
                        Join-Path $theModuleRoot "docs" # Otherwise, it's the docs subdirectory.
                    }                
            }
            
            # If the -OutputPath does not exist
            if (-not (Test-Path $OutputPath)) {
                $null = New-Item -ItemType Directory -Path $OutputPath # create it.
            }

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

                & $GetMarkdownHelp @getMarkdownHelpSplat | # Call Get-MarkdownHelp 
                    Out-String -Width 1mb |                # output it as a string
                    Set-Content -Path $docOutputPath -Encoding utf8  # and set the encoding.

                if ($PassThru) { # If -PassThru was provided, get the path.
                    Get-Item -Path $docOutputPath -ErrorAction SilentlyContinue
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
                    ForEach-Object {
                        $ps1File = $_
                        # For each script that we find, prepare to call Get-MarkdownHelp
                        $getMarkdownHelpSplat = @{Name="$($ps1File.FullName)"} + $getMarkdownHelpSplatBase
                        # because not all file names will be valid (or good) topic names
                        $replacedFileName = $ps1File.Name # prepare to replace the file.
                        @(for ($ri = 0; $ri -lt $ReplaceScriptName.Length; $ri++) { # Walk over any -ReplaceScriptName(s) provided.
                            if ($ReplaceScriptNameWith[$ri]) { # Replace it with the -ReplaceScriptNameWith parameter (if present).
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
                        # Call Get-MarkdownHelp
                        & $GetMarkdownHelp @getMarkdownHelpSplat |
                            Out-String -Width 1mb | # format the result
                            Set-Content -Path $docOutputPath -Encoding utf8 # and save it to a file.
                        
                        if ($PassThru) { # If -PassThru was provided
                            Get-Item -Path $docOutputPath -ErrorAction SilentlyContinue # return the created file.
                        }
                    }                
            }

            if ($IncludeTopic) {
                Get-ChildItem -Path $theModuleRoot -Recurse -File |
                    ForEach-Object {
                        $fileInfo = $_
                        foreach ($inc in $IncludeTopic) {
                            $matches = $null
                            if ($fileInfo.Name -eq $inc -or $fileInfo.Name -like $inc -or 
                                (-not $inc.Contains('*') -and $(try {$fileInfo.Name -match $inc} catch {$null}))
                            ) {
                                $replacedName = 
                                    if ($matches) {
                                        $fileInfo.Name -replace $inc
                                    } else {
                                        $fileInfo.Name.Substring(0, $fileInfo.name.Length - $fileInfo.Extension.Length) -replace '\.help$'
                                    }
                                
                                if ($replacedName -eq "about_$module") {
                                    $replacedName = 'README'
                                }
                                $dest = Join-Path $OutputPath ($replacedName + '.md')
                                if ($fileInfo.FullName -ne "$dest") {
                                    $fileInfo | Copy-Item -Destination $dest -PassThru:$PassThru
                                }
                            }
                        }
                    }
            }

            if ($IncludeExtension) {
                Get-ChildItem -Path $theModuleRoot -Recurse -File |
                    ForEach-Object {
                        $fileInfo = $_
                        foreach ($ext in $IncludeExtension) {                            
                            if ($fileInfo.Extension -eq $ext -or $fileInfo.Extension -eq ".$ext") {
                                $relativePath   = $fileInfo.FullName.Substring("$theModuleRoot".Length) -replace '^[\\/]'
                                $outputPathLeaf = $outputPath | Split-Path -Leaf                                
                                $dest = Join-Path $OutputPath $relativePath
                                if ($fileInfo.FullName -ne "$dest" -and 
                                    $relativePath -notlike "$outputPathLeaf$([IO.Path]::DirectorySeparatorChar)*") {
                                    $fileInfo | Copy-Item -Destination $dest -PassThru:$PassThru
                                }
                                break
                            }
                        }
                    }
            }
         }

        if ($t -gt 1) {
            Write-Progress 'Saving Markdown' 'Complete' -Completed -Id $id
        }
        #endregion Save the Markdowns
    }
}
