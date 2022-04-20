#requires -version 3.0
function Get-ScriptReference
{
    <#
    .Synopsis
        Gets a script's references
    .Description
        Gets the external references of a given PowerShell command.  These are the commands the script calls, and the types the script uses.
    .Example
        Get-Command Get-ScriptReference | Get-ScriptReference
    #>
    [CmdletBinding(DefaultParameterSetName='FilePath')]
    param(
    # The path to a file
    [Parameter(Mandatory=$true,Position=0,ParameterSetName='FilePath',ValueFromPipelineByPropertyName=$true)]
    [Alias('Fullname')]
    [string[]]
    $FilePath,

    # One or more PowerShell ScriptBlocks
    [Parameter(Mandatory=$true,Position=0,ParameterSetName='ScriptBlock',ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [Alias('Definition')]
    [ScriptBlock[]]
    $ScriptBlock,

    # If set, will recursively find references.
    [switch]
    $Recurse
    )


    begin {
        # Let's declare some collections we'll need:        
        $allFiles = [Collections.ArrayList]::new() # * A list of all files (if any are piped in)
        $LookedUpCommands = @{} # * The commands we've already looked up (to save time) 
    }
    process {
        
        #region Process Piped in Files
        if ($PSCmdlet.ParameterSetName -eq 'FilePath') { # If we're piping in files, 
            $allFiles.AddRange($FilePath) # add them to the list and process them in the end,
            return # and stop processing for good measure.
        }
        #endregion Process Piped in Files
                
        #region Get the Script References
        
        # To start off with, take all of the scripts passed in and put them in a queue.
        $scriptBlockQueue = [Collections.Generic.Queue[ScriptBlock]]::new($ScriptBlock)
        $resolvedCmds = @{} # Then create a hashtable to store the resolved references 
        $alreadyChecked = [Collections.Generic.List[ScriptBlock]]::new() # and a list of all of the ScriptBlock's we've already taken a look at.

        # Now it's time for some syntax trickery that should probably be explained.
        
        
        # We're going to want to be able to recursively find references too.  
        # By putting this in a queue, we've already done part of the work, 
        # because we can just enqueue the nested commands.
        # However, we also want to know _which nested command had which references_
        # This means we have to collect all of the references as we go, 
        # and output them in a different way if we're running recursively.


        # Got all that?
        
        
        # First, we need a tracking variable
        $CurrentCommand = '.' # for the current command.

        # Now the syntax trickery: We put the do loop inside of a lambda running in our scope (. {}).
        # This gives us all of our variables, but lets the results stream to the pipeline.
        # This is actually pretty important, since this way our tracking variable is accurate when we're outputting the results.
        
        # Now that we understand how it works, let's get to:
        
        #region Process the Queue of Script Blocks   
        
        . { 
            $alreadyChecked = [Collections.ArrayList]::new()
            do { 
                $scriptBlock = $scriptBlockQueue.Dequeue()                
                if ($alreadyChecked -contains $scriptBlock) { continue } 
                $null=  $alreadyChecked.Add($ScriptBlock)
                $foundRefs = $Scriptblock.Ast.FindAll({
                    param($ast) 
                    $ast -is [Management.Automation.Language.CommandAst] -or 
                    $ast -is [Management.Automation.Language.TypeConstraintAst] -or 
                    $ast -is [Management.Automation.Language.TypeExpressionAst]
                }, $true)


                $cmdRefs = [Collections.ArrayList]::new()
                $cmdStatements = [Collections.ArrayList]::new()
                $typeRefs = [Collections.ArrayList]::new()

                foreach ($ref in $foundRefs) {
                    if ($ref -is [Management.Automation.Language.CommandAst]) {                    
                        $null = $cmdStatements.Add($ref)
                        if (-not $ref.CommandElements) { continue } 
                        $theCmd = $ref.CommandElements[0]
                        if ($theCmd.Value) {
                            
                            if (-not $LookedUpCommands[$theCmd.Value]) {
                                $LookedUpCommands[$thecmd.Value] = $ExecutionContext.InvokeCommand.GetCommand($theCmd.Value, 'Cmdlet, Function, Alias')
                            }
                            if ($cmdRefs -notcontains $LookedUpCommands[$theCmd.Value]) {
                                $null = $cmdRefs.Add($LookedUpCommands[$thecmd.Value])                            
                            }
                        } else {
                            # referencing a lambda, leave it alone for now
                        }
                    } elseif ($ref.TypeName) {
                        $refType = $ref.TypeName.Fullname -as [type]
                        if ($typeRefs -notcontains $refType) {
                            $null = $typeRefs.Add($refType)
                        }                        
                    }
                }


                [PSCustomObject][Ordered]@{
                    Commands = $cmdRefs.ToArray()
                    Statements = $cmdStatements.ToArray()
                    Types = $typeRefs.ToArray()
                }

                

            if ($Recurse) {
                $uniqueCmdRefs | 
                    & { process {
                        if ($resolvedCmds.ContainsKey($_.Name)) { return }
                        $nextScriptBlock = $_.ScriptBlock
                        if (-not $nextScriptBlock -and $_.ResolvedCommand.ScriptBlock)  {
                            $nextScriptBlock = $_.ResolvedCommand.ScriptBlock
                        }
                        if ($nextScriptBlock) { 
                            $scriptBlockQueue.Enqueue($nextScriptBlock)
                            $resolvedCmds[$_.Name] = $true
                        }
                    } }                 
            }                
        } while ($ScriptBlockQueue.Count) } | 
        #endregion Process the Queue of Script Blocks
        #region Handle Each Output
            & { 
                begin {
                    $refTable = @{}
                }
                process {
                    if (-not $Recurse) { return $_ } 
                }
            }
        #endregion Handle Each Output
        #endregion Get the Script References
                    
    }

    end {
        $myParams = @{} + $PSBoundParameters
        if (-not $allFiles.Count) { return }
        $c, $t, $id = 0, $allFiles.Count, $(Get-Random)
        foreach ($file in $allFiles) {
            $c++ 
            $resolvedFile=  try { $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($file)} catch { $null }
            if (-not $resolvedFile) { continue } 
            $resolvedFile = [IO.FileInfo]"$resolvedFile"
            if (-not $resolvedFile.Name) { continue }
            if (-not $resolvedFile.Length) { continue }
            if ('.ps1', '.psm1' -notcontains $resolvedFile.Extension) { continue }   
            $p = $c * 100 / $t
            $text = [IO.File]::ReadAllText($resolvedFile.FullName)
            $scriptBlock= [ScriptBlock]::Create($text)
            Write-Progress "Getting References" " $($resolvedFile.Name) " -PercentComplete $p -Id $id
            if (-not $scriptBlock) { continue }
            
            Get-ScriptReference -ScriptBlock $scriptBlock |
                & { process {
                    $_.psobject.properties.add([Management.Automation.PSNoteProperty]::new('FileName',$resolvedFile.Name))
                    $_.psobject.properties.add([Management.Automation.PSNoteProperty]::new('FilePath',$resolvedFile.Fullname))
                    $_.pstypenames.add('HelpOut.Script.Reference')
                    $_  
                } }                

            Write-Progress "Getting References" " " -Completed -Id $id
        }
    }
}