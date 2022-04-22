function Install-MAML
{
    <#
    .Synopsis
        Installs MAML into a module
    .Description
        Installs MAML into a module.  
        
        This generates a single script that: 
        * Includes all commands
        * Removes their multiline comments
        * Directs the commands to use external help
        
        You should then include this script in your module import.

        Ideally, you should use the allcommands script 
    .Example
        Install-MAML -Module HelpOut
    .Link
        Save-MAML
    .Link
        ConvertTo-MAML
    #>
    [OutputType([Nullable], [IO.FileInfo])]
    param(
    # The name of one or more modules.
    [Parameter(Mandatory=$true,Position=0,ParameterSetName='Module',ValueFromPipelineByPropertyName=$true)]
    [string[]]
    $Module,
    
    # If set, will refresh the documentation for the module before generating the commands file.
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [switch]
    $NoRefresh,

    # If set, will compact the generated MAML.  This will be ignored if -Refresh is not passed, since no new MAML will be generated.
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [switch]
    $Compact,
   
    # The name of the combined script.  By default, allcommands.ps1.
    [Parameter(Position=1,ValueFromPipelineByPropertyName=$true)]
    [string]
    $ScriptName = 'allcommands.ps1',

    # The root directories containing functions.  If not provided, the function root will be the module root.
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [string[]]
    $FunctionRoot,

    # If set, the function roots will not be recursively searched.
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [switch]
    $NoRecurse,

    # The encoding of the combined script.  By default, UTF8.
    [Parameter(Position=2,ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNull()]
    [Text.Encoding]
    $Encoding = [Text.Encoding]::UTF8,

    # A list of wildcards to exclude.  This list will always contain the ScriptName.
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [string[]]
    $Exclude,

    # If set, the generate MAML will not contain a version number.  
    # This slightly reduces the size of the MAML file, and reduces the rate of changes in the MAML file.
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [Alias('Unversioned')]
    [switch]
    $NoVersion,

    # If provided, will save the MAML to a different directory than the current UI culture.
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [Globalization.CultureInfo]
    $Culture,

    # If set, will return the files that were generated.
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [switch]
    $PassThru
    )

    process {        
        if ($ScriptName -notlike '*.ps1') { # First, let's check that the scriptname is a .PS1.
            $ScriptName += '.ps1' # If it wasn't, add the extension.
        }

        $Exclude += $ScriptName # Then, add the script name to the list of exclusions.

        if (-not $Culture) { # If no culture was specified,
            $Culture = [Globalization.CultureInfo]::CurrentUICulture # use the current UI culture.
        }

        foreach ($m in $Module) { 
            $theModule = Get-Module $m # Resolve the module.
            if (-not $theModule) { continue }  # If we couldn't, continue to the next.
            $theModuleRoot =  $theModule | Split-Path # Find the module's root.
            
            if ($PSBoundParameters.FunctionRoot) { # If we provided a function root parameter
                $functionRoot = foreach ($f in $FunctionRoot) { # then turn each root into an absolute path.
                    if ([IO.File]::Exists($F)) {
                        $f
                    } else {
                        Join-Path $theModuleRoot $f
                    }
                }
            } else {
                $FunctionRoot = "$theModuleRoot" # otherwise, just use the module root.
            }
            
            $fileList = @(foreach ($f in $FunctionRoot) { # Walk thru each function root.
                Get-ChildItem -Path $f -Recurse:$(-not $Recurse) -Filter *.ps1 | # recursively find all .PS1s
                    & { process {
                        if ($_.Name -notlike '*-*' -or $_.Name -like '*.*.*') { return  }  
                        foreach ($ex in $Exclude) { 
                            if ($_.Name -like $ex) { return } 
                        }
                        return $_
                    } }
            })

            #region Save the MAMLs
            if (-not $NoRefresh) { # If we're refreshing the MAML,
                $saveMamlCmd =  # find the command Save-MAML
                    if ($MyInvocation.MyCommand.ScriptBlock.Module) {
                        $MyInvocation.MyCommand.ScriptBlock.Module.ExportedCommands['Save-MAML']
                    } else {
                        $ExecutionContext.SessionState.InvokeCommand.GetCommand('Save-MAML', 'Function')
                    }
                $saveMamlSplat = @{} + $PSBoundParameters # and pick out the parameters that this function and Save-MAML have in common.
                foreach ($k in @($saveMamlSplat.Keys)) {
                    if (-not $saveMamlCmd.Parameters.ContainsKey($k)) {
                        $saveMamlSplat.Remove($k)
                    }
                }
                $saveMamlSplat.Module = $m # then, set the module
                Save-MAML @saveMamlSplat # and call Save-MAML
            }
            #endregion Save the MAMLs

            #region Generate the Combined Script
            # Prepare a regex to find function definitions.
            $regex = [Regex]::new('
                (?<![-\s\#]{1,}) # not preceeded by a -, or whitespace, or a comment
                function # function keyword
                \s{1,1} # a single space or tab
                (?<Name>[^\-]{1,1}\S+) # any non-whitespace, starting with a non-dash
                \s{0,} # optional whitespace
                [\(\{] # opening parenthesis or brackets
', 'MultiLine,IgnoreCase,IgnorePatternWhitespace', '00:00:05')

            
            $newFileContent = # We'll assign new file content by
                foreach ($f in $fileList) { # walking thru each file. 
                    $fCmd = $ExecutionContext.SessionState.InvokeCommand.GetCommand($f.FullName, 'ExternalScript')
                    $fileContent = $fCmd.ScriptBlock # and read it as a string.
                    $start = 0
                    do { 
                        $matched = $regex.Match($fileContent,$start) # See if we find a functon. 
                        if ($matched.Success) { # If we found one,
                            $insert = ([Environment]::NewLine + "#.ExternalHelp $M-Help.xml" + [Environment]::NewLine) # insert a line for help.
                            $fileContent = if ($matched.Index) {
                                $fileContent.Insert($matched.Index - 1, $insert)
                            } else {
                                $insert + $fileContent
                            }
                            $start += $matched.Index + $matched.Length
                            $start += $insert.Length # and update our starting position.
                        }        
                        # Keep doing this until we've reached the end of the file or the end of the matches.
                    } while ($start -le $filecontent.Length -and $matched.Success) 
  
                    # Then output the file content.
                    $fileContent
                }
            
            # Last but not least, we 
            $combinedCommandsPath = Join-Path $theModuleRoot $ScriptName # determine the path for our combined commands file.

            "### DO NOT EDIT THIS FILE DIRECTLY ###" | Set-Content -Path $combinedCommandsPath -Encoding $Encoding.HeaderName.Replace('-','') # add a header
            [IO.File]::AppendAllText($combinedCommandsPath, $newFileContent, $Encoding) # and add our content.
            #endregion Generate the Combined Script

            if ($PassThru) {
                Get-Item -Path $combinedCommandsPath
            }
        }
    }
}
