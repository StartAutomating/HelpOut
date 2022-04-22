function ConvertTo-MAML
{
    <#
    .Synopsis
        Converts command help to MAML
    .Description
        Converts command help to MAML (Microsoft Assistance Markup Language).
    .Example
        ConvertTo-Maml -Name ConvertTo-Maml
    .Example
        Get-Command ConvertTo-Maml | ConvertTo-Maml
    .Example
        ConvertTo-Maml -Name ConvertTo-Maml -Compact
    .Example
        ConvertTo-Maml -Name ConvertTo-Maml -XML
    .Link
        Get-Help
    .Link
        Save-MAML
    .INPUTS 
        [Management.Automation.CommandInfo]
        Accepts a command
    .Outputs
        [String]
        The MAML, as a String.  This is the default.
    .Outputs
        [Xml]
        The MAML, as an XmlDocument (when -XML is passed in)
    #>
    [CmdletBinding(DefaultParameterSetName='CommandInfo')]
    [OutputType([string],[xml])]
    param( 
    # The name of or more commands.
    [Parameter(ParameterSetName='ByName',Position=0,ValueFromPipelineByPropertyName=$true)]
    [string[]]
    $Name,

    # The name of one or more modules.
    [Parameter(ParameterSetName='ByModule',ValueFromPipelineByPropertyName=$true)]
    [string[]]
    $Module,

    # The CommandInfo object (returned from Get-Command).
    [Parameter(Mandatory=$true,ParameterSetName='FromCommandInfo', ValueFromPipeline=$true)]
    [Management.Automation.CommandInfo[]]
    $CommandInfo,

    # If set, the generated MAML will be compact (no extra whitespace or indentation).  If not set, the MAML will be indented.
    [switch]
    $Compact,
    
    # If set, will return the MAML as an XmlDocument.  The default is to return the MAML as a string.
    [switch]
    $XML,
    
    # If set, the generate MAML will not contain a version number.  
    # This slightly reduces the size of the MAML file, and reduces the rate of changes in the MAML file.
    [Alias('Unversioned')]
    [switch]
    $NoVersion)
    
    begin {
        # First, we need to create a list of all commands we encounter (so we can process them at the end)
        $allCommands = [Collections.ArrayList]::new()
        # Then, we want to get the type accelerators (so we don't have to keep getting them each time we're interested)
        $typeAccelerators = [PSOBject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get

        # Next up, we're going to declare a bunch of ScriptBlocks, which we'll call to construct the XML in pieces.
        # This way we can create a nested structure (in this case, XML), by calling the pieces we want and letting them return the XML in chunks


        #region Get TypeName        
        $GetTypeName = {param([Type]$t)
            # We'll want to check to see if there are any accelerators.
            if (-not $typeAccelerators -and $typeAccelerators.GetEnumerator) {  # If there weren't
                return $t.Fullname # return the fullname.
            }
             
            foreach ($_ in $typeAccelerators.GetEnumerator()) { # Loop through the accelerators.
                if ($_.Value -eq $t) { # If it's an accelrator for the target type
                    return $_.Key.Substring(0,1).ToUpper() + $_.Key.Substring(1) # return the key (and fix it's casing)
                }
            }
            return $t.Fullname # If we didn't find it in the accelerators list, return the fullname.
        }
        #endregion Get TypeName

        #region Write Type

        # Both Inputs and Outputs have the same internal tag structure for a value, so one script block handles both cases.        
        $WriteType = {param($t) 
            $typename = $t.type[0].name
            $descriptionLines = $null
            
            
            if ($in.description) { # If we have a description, 
                $descriptionLines = $in.Description[0].text -split "`n|`r`n" -ne '' # we we're good.
            } else { # If we didn't, it's probably because comment based help mangles things a bit (it puts everything in a long typename).
                # Let's fix this by assigning the inType from the first line, and setting the rest as description lines
                $typename, $descriptionLines = $t.type[0].Name -split "`n|`r`n" -ne ''
            }
            $typename = [Security.SecurityElement]::Escape("$typename".Trim())
            

            "<dev:type><maml:name>$typename</maml:name><maml:uri/><maml:description /></dev:type>" # Write the type information
            if ($descriptionLines) { # If we had a description
                '<maml:description>' 
                foreach ($line in $descriptionLines) { # Write each line in it's own para tag so that it renders right.
                    $esc = [Security.SecurityElement]::Escape($line)
                    "<maml:para>$esc</maml:para>"
                }
                '</maml:description>'
            }
        }
        #endregion Write Type

        #region Write Command Details
        $writeCommandDetails = {
            # The command.details tag has 5 parts we want to provide
            # * Name,
            # * Noun
            # * Verb
            # * Synopsis
            # * Version
            $Version = "<dev:version>$(if ($cmdInfo.Version) { $cmdInfo.Version.ToString() })</dev:version>"
           
            "<command:details>
                <command:name>$([Security.SecurityElement]::Escape($cmdInfo.Name))</command:name>
                <command:noun>$noun</command:noun>
                <command:verb>$verb</command:verb>
                <maml:description>
                    <maml:para>$([Security.SecurityElement]::Escape($commandHelp.Synopsis))</maml:para>
                </maml:description>
                $(if (-not $NoVersion) { $Version})
            </command:details>
            <maml:description>
                $(
                foreach ($line in @($commandHelp.Description)[0].text -split "`n|`r`n") {
                    if (-not $line) { continue }
                    "<maml:para>$([Security.SecurityElement]::Escape($Line))</maml:para>"
                    }
                )                
            </maml:description>
            "
        }
        #endregion Write Command Details
        
        #region Write Parameter 
        $WriteParameter = {
            # Prepare the command.parameter attributes:
            $position  = if ($param.Position -ge 0) { $param.Position } else {"named" } #* Position
            $fromPipeline = #*FromPipeline
                if ($param.ValueFromPipeline) { "True (ByValue)" }
                elseif ($param.ValueFromPipelineByPropertyName) { "True (ByPropertyName)" }
                else { "False" } 
            $isRequired = if ($param.IsMandatory) { "true" } else { "false" } #*Required
            
            
            # Pick out the help for a given parameter 
            $paramHelp = foreach ($_ in $commandHelp.parameters.parameter) {
                    if ( $_.Name -eq $param.Name ){
                        $_
                        break
                    }
                }
            $paramTypeName = & $GetTypeName $param.ParameterType # and get the type name of the parameter type.
                                
            "<command:parameter required='$isRequired' position='$position' pipelineInput='$fromPipeline' aliases='' variableLength='true' globbing='false'>" #* Echo the start tag
            "<maml:name>$($param.Name)</maml:name>" #* The maml.name tag
            '<maml:description>' #*The description tag
            foreach ($d in $paramHelp.Description) { 
                "<maml:para>$([Security.SecurityElement]::Escape($d.Text))</maml:para>"
            }
            '</maml:description>' 
            #*The parameterValue tag (which oddly enough, describes the parameter type)
            "<command:parameterValue required='$isRequired' variableLength='true'>$paramTypeName</command:parameterValue>" 
            #*The type tag (which is also it's type)
            "<dev:type><maml:name>$paramTypeName</maml:name><maml:uri /></dev:type>"
            #*and an empty default value.
            '<dev:defaultValue></dev:defaultValue>'
            #* Then close the parameter tag.
            '</command:parameter>'
        }
        #endregion Write Parameter 

        #region Write Parameters        
        $WriteCommandParameters = {
            '<command:parameters>' # *Open the parameters tag;
            foreach ($param in ($cmdMd.Parameters.Values | Sort-Object Name)) { #*Loop through the command's parameters alphabetically
                & $WriteParameter #*Write each parameter.
            }
            '</command:parameters>' #*Close the parameters tag
        } 
        #endregion Write Parameters


        #region Write Examples
        $WriteExamples = {
            # If there were no examples, return.            
            if (-not $commandHelp.Examples.example) { return }

            
            "<command:examples>" 
            foreach ($ex in $commandHelp.Examples.Example) { # For each example:
                '<command:example>' #*Start an example tag
                '<maml:title>'
                $ex.Title  #*Put it's title in a maml:title tag
                '</maml:title>'
                '<maml:introduction>'#* Put it's introduction in a maml:introduction tag
                foreach ($i in $ex.Introduction) {
                    '<maml:para>'
                    [Security.SecurityElement]::Escape($i.Text)
                    '</maml:para>'
                }
                '</maml:introduction>'
                '<dev:code>' #* Put it's code in a dev:code tag
                [Security.SecurityElement]::Escape($ex.Code)
                '</dev:code>'
                '<dev:remarks>' #* Put it's remarks in a dev:remarks tag
                foreach ($i in $ex.Remarks) {
                    if (-not $i -or -not $i.Text.Trim()) { continue }                        
                    '<maml:para>'
                    [Security.SecurityElement]::Escape($i.Text)
                    '</maml:para>'
                }
                '</dev:remarks>'
                '</command:example>'
            }
            '</command:examples>'
        }
        #endregion Write Examples

 

        #region Write Inputs
        $WriteInputs = {
            if (-not $commandHelp.inputTypes) { return } # If there were no input types, return.


            '<command:inputTypes>' #*Open the inputTypes Tag.
            foreach ($in in $commandHelp.inputTypes[0].inputType) { #*Walk thru each type in help.
                '<command:inputType>'  
                    & $WriteType $in #*Write the type information (in an inputType tag).
                '</command:inputType>'
            }
            '</command:inputTypes>' #*Close the Input Types Tag.
        }
        #endregion Write Inputs

        #region Write Outputs
        $WriteOutputs = {
            if (-not $commandHelp.returnValues) { return } # If there were no return values, return. 
            
            '<command:returnValues>' # *Open the returnValues tag
            foreach ($rt in $commandHelp.returnValues[0].returnValue) { # *Walk thru each return value
                '<command:returnValue>' 
                    & $WriteType $rt # *write the type information (in an returnValue tag)
                '</command:returnValue>'
            }
            '</command:returnValues>' #*Close the returnValues tag
        }
        #endregion Write Outputs

        #region Write Notes
        $WriteNotes = {
            if (-not $commandHelp.alertSet) { return } # If there were no notes, return.
            "<maml:alertSet><maml:title></maml:title>" #*Open the alertSet tag and emit an empty title
            foreach ($note in $commandHelp.alertSet[0].alert) { #*Walk thru each note
                "<maml:alert><maml:para>"                    
                    $([Security.SecurityElement]::Escape($note.Text)) #*Put each note in a maml:alert element
                "</maml:para></maml:alert>"
            } 
            "</maml:alertSet>" #*Close the alertSet tag
        }
        #endregion Write Notes

        #region Write Syntax
        $WriteSyntax = {
            if (-not $cmdInfo.ParameterSets) { return } # If this command didn't have parameters, return
            
            "<command:syntax>" #*Open the syntax tag
            foreach ($syn in $cmdInfo.ParameterSets) {#*Walk thru each parameter set
                "<command:syntaxItem><maml:name>$($cmdInfo.Name)</maml:name>"  #*Create a syntaxItem tag, with the name of the command. 
                foreach ($param in $syn.Parameters) { 
                    #* Skip parameters that are not directly declared (e.g. -ErrorAction)
                    if (-not $cmdMd.Parameters.ContainsKey($param.Name))  { continue } 
                    & $WriteParameter #* Write help for each parameter                    
                }
                "</command:syntaxItem>" #*Close the syntax item tag
            }
            "</command:syntax>"#*Close the syntax tag   
            
        }
        #endregion Write Syntax                

        #region Write Links
        $WriteLinks = {
            # If the command didn't have any links, return.
            if (-not $commandHelp.relatedLinks.navigationLink) { return }
            
            '<maml:relatedLinks>' #* Open a related Links tag            
            foreach ($l in $commandHelp.relatedLinks.navigationLink) { #*Walk thru each link
                $linkText, $LinkUrl = "$($l.linkText)".Trim(), "$($l.Uri)".Trim() # and write it's tag.
                '<maml:navigationLink>'
                    "<maml:linkText>$linkText</maml:linkText>"
                    "<maml:uri>$LinkUrl</maml:uri>"
                '</maml:navigationLink>'
            }
            '</maml:relatedLinks>' #* Close the related Links tag
        }    
        #endregion Write Links


        #- - -  Now that we've declared all of these little ScriptBlock parts, we'll put them in a list in the order they'll run.
        $WriteMaml = $writeCommandDetails, $writeSyntax,$WriteCommandParameters,$WriteInputs,$writeOutputs, $writeNotes, $WriteExamples, $writeLinks
        #- - -
    }
    
    process {
        
        if ($PSCmdlet.ParameterSetName -eq 'ByName') { # If we're getting comamnds by name,
            $CommandInfo = @(foreach ($n in $name) { 
                $ExecutionContext.InvokeCommand.GetCommands($N,'Function,Cmdlet', $true) # find each command (treating Name like a wildcard).
            })
        }


        if ($PSCmdlet.ParameterSetName -eq 'ByModule') { # If we're getting commands by module
            $CommandInfo = @(foreach ($m in $module) {  # find each module
                (Get-Module -Name $m).ExportedCommands.Values # and get it's exports.
            })
        }


        $filteredCmds = @(foreach ($ci in $CommandInfo) { # Filter the list of commands 
            if ($ci -is [Management.Automation.AliasInfo] -or # (throw out aliases and applications).
                $ci -is [Management.Automation.ApplicationInfo]) { continue }
            $ci 
        })
         
        if ($filteredCmds) { 
            $null = $allCommands.AddRange($filteredCmds)
        }
    }
    
    end {
        $c, $t, $id, $maml = # Create some variables for our progress bar, 
        0, $allCommands.Count, [Random]::new().Next(), [Text.StringBuilder]::new('<helpItems schema="maml">') # and initialize our MAML.
        
        foreach ($cmdInfo in $allCommands) { # Walk thru each command.
            $commandHelp = $null
            $c++
            $p = $c * 100 / $t
            Write-Progress 'Converting to MAML' "$cmdInfo [$c of $t]" -PercentComplete $p -Id $id # Write a progress message
            $commandHelp = $cmdInfo | Get-Help # get it's help
            $cmdMd = [Management.Automation.CommandMetaData]$cmdInfo # get it's command metadata 
            if (-not $commandHelp -or $commandHelp -is [string]) { # (error if we couldn't Get-Help)
                Write-Error "$cmdInfo Must have a help topic to convert to MAML"
                return
            }                
            $verb, $noun  = $cmdInfo.Name -split "-" # and split out the noun and verb.
            


            # Now we're ready to run all of those script blocks we declared in begin.
            # All we need to do is append the command node, run each of the script blocks in $WriteMaml, and close the node.
            $mamlCommand = 
                "<command:command 
                    xmlns:maml='http://schemas.microsoft.com/maml/2004/10' 
                    xmlns:command='http://schemas.microsoft.com/maml/dev/command/2004/10' 
                    xmlns:dev='http://schemas.microsoft.com/maml/dev/2004/10'>
                    $(foreach ($_ in $WriteMaml) { & $_ })
                </command:command>"
            $null = $maml.AppendLine($mamlCommand)
        }

        Write-Progress "Exporting Maml" " " -Completed -Id $id # Then we indicate we're done,
        $null = $maml.Append("</helpItems>") # close the opening tag. 
        $mamlAsXml = [xml]"$maml" # and convert the whole thing to XML.
        if (-not $mamlAsXml) { return }  # If we couldn't, return.
        
        
        if ($XML) { return $mamlAsXml } # If we wanted the XML, return it.

        
        $strWrite = [IO.StringWriter]::new() # Now for a little XML magic:


        # If we create a [IO.StringWriter], we can save it as pretty or compacted XML.
        $mamlAsXml.PreserveWhitespace = $Compact # Oddly enough, if we're compacting we're setting preserveWhiteSpace to true, which in turn strips all of the whitespace except that inside of your nodes.
        $mamlAsXml.Save($strWrite) # Anyways, we can save this to the string writer, and it will either make our XML perfectly balanced and indented or compact and free of most whitespace. 
        # Unfortunately, it will not get it's encoding declaration "right".  This is because $strWrite is Unicode, and in most cases we'll want our XML to be UTF8.  
        # The next step of the pipeline needs to convert it as it is saved, which is as easy as | Out-File -Encoding UTF8.
        "$strWrite".Replace('<?xml version="1.0" encoding="utf-16"?>','<?xml version="1.0" encoding="utf-8"?>') 
        $strWrite.Close()
        $strWrite.Dispose()
    }
}