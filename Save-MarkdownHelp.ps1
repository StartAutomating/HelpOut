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
    $PassThru
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

        #region Save the Markdowns
        foreach ($m in $Module) { # Walk thru the list of module names.            
            if ($t -gt 1) {
                $c++
                Write-Progress 'Saving Markdown' $m -PercentComplete $p  -Id $id
            }

            $theModule = Get-Module $m # Find the module
            if (-not $theModule) { continue } # (continue if we couldn't).
            $theModuleRoot = $theModule | Split-Path # Find the module's root,
            if (-not $psBoundParameters.OutputPath) {                
                $OutputPath = 
                    if ($Wiki) {
                        Split-Path $theModuleRoot | Join-Path -ChildPath "$($theModule.Name).wiki"
                    } else {
                        Join-Path $theModuleRoot "docs"                        
                    }                
            }
            
            if (-not (Test-Path $OutputPath)) {
                $null = New-Item -ItemType Directory -Path $OutputPath
            }

            $outputPathItem = Get-Item $OutputPath
            if ($outputPathItem -isnot [IO.DirectoryInfo]) {
                Write-Error "-OutputPath '$outputPath' must point to a directory"
                return
            }

            $myHelpParams = @{}
            if ($wiki) { $myHelpParams.Wiki = $true}
            else { $myHelpParams.GitHubDocRoot = $OutputPath | Split-Path}            

            foreach ($cmd in $theModule.ExportedCommands.Values) {
                $docOutputPath = Join-Path $outputPath ($cmd.Name + '.md')
                $getMarkdownHelpSplat = @{Name="$cmd"}
                if ($Wiki) { $getMarkdownHelpSplat.Wiki = $Wiki}
                else { $getMarkdownHelpSplat.GitHubDocRoot = "$($outputPath|Split-Path -Leaf)"}
                & $GetMarkdownHelp @getMarkdownHelpSplat| Out-String -Width 1mb | Set-Content -Path $docOutputPath -Encoding utf8
                if ($PassThru) {
                    Get-Item -Path $docOutputPath -ErrorAction SilentlyContinue
                }
            }

            if ($ScriptPath) {
                $childitems = Get-ChildItem -Path $theModuleRoot -Recurse 
                foreach ($sp in $ScriptPath) {
                    $childitems |
                        Where-Object { $_.Name -eq $sp -or $_.FullName -eq $sp } |
                        Get-ChildItem |
                        Where-Object Extension -eq '.ps1' |
                        ForEach-Object {
                            $ps1File = $_
                            $getMarkdownHelpSplat = @{Name="$($ps1File.FullName)"}

                            $replacedFileName = $ps1File.Name
                            @(for ($ri = 0; $ri -lt $ReplaceScriptName.Length; $ri++) {
                                if ($ReplaceScriptNameWith[$ri]) {
                                    $replacedFileName = $replacedFileName -replace $ReplaceScriptName[$ri], $ReplaceScriptNameWith[$ri]
                                } else {
                                    $replacedFileName = $replacedFileName -replace $ReplaceScriptName[$ri]
                                }
                            })
                            $docOutputPath = Join-Path $outputPath ($replacedFileName + '.md')
                            $relativePath = $ps1File.FullName.Substring("$theModuleRoot".Length).TrimStart('/\').Replace('\','/')
                            $getMarkdownHelpSplat.Rename = $relativePath
                            if ($Wiki) { $getMarkdownHelpSplat.Wiki = $Wiki}
                            else { $getMarkdownHelpSplat.GitHubDocRoot = "$($outputPath|Split-Path -Leaf)"}
                            & $GetMarkdownHelp @getMarkdownHelpSplat| Out-String -Width 1mb | Set-Content -Path $docOutputPath -Encoding utf8
                            if ($PassThru) {
                                Get-Item -Path $docOutputPath -ErrorAction SilentlyContinue
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
