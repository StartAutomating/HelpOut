Write-FormatView -TypeName PowerShell.Markdown.Help -Action {
    $helpObject = $_

    @(
        Format-Markdown -Heading $helpObject.Name

        Format-Markdown -HeadingSize 3 -Heading "Synopsis"

        $helpObject.Synopsis | Out-String -Width 1mb
        
        '---'
        Format-Markdown -HeadingSize 3 -Heading "Description"
        foreach ($desc in $helpObject.Description) {
            [Environment]::NewLine + $desc.text  + [Environment]::NewLine
        }


        if ($helpObject.RelatedLinks) {
            '---'

            Format-Markdown -Heading "Related Links" -headingsize 3

            foreach ($nav in $helpObject.RelatedLinks.navigationLink) {
                $linkedCmd = $ExecutionContext.SessionState.InvokeCommand.GetCommand($nav.LinkText, 'All')
                $linkUrl = 
                    if ($nav.Uri) {
                        $nav.Uri
                    }
                    elseif ($linkedCmd -and ($linkedCmd.Module -like 'microsoft.*' -or $linkedCmd.Source -like 'microsoft.*')) {
                        $linkSrc = if ($linkedCmd.Module) { $linkedCmd.Module} else { $linkedCmd.Source }
                        "https://docs.microsoft.com/powershell/module/$linkSrc/$linkedCmd"
                    } elseif ($helpObject.WikiLink) {
                        $nav.LinkText
                    } elseif ($null -ne $helpObject.DocLink) {
                        "$($helpObject.docLink)/$($nav.LinkText.md)"
                    }
                    else {
                        ""
                    }
                
                Format-Markdown -Link $linkUrl -inputObject $nav.LinkText -BulletPoint                
            }
        }


        if ($helpObject.Examples) {
            '---'
            Format-Markdown -Heading "Examples" -headingsize 3

            foreach ($example in $helpObject.Examples.Example) {
                (Format-Markdown -Heading ($example.Title -replace '^[-\s]+' -replace '[-\s]+$') -HeadingSize 4)

                if ($example.Code) {
                    $example.Code | Format-Markdown -CodeLanguage PowerShell
                }

                if ($example.Remarks) {
                    ($example.Remarks | Out-String -Width 1mb).Trim()
                }
            }
        }
                

        if ($helpObject.Parameters) {
            '---'
            Format-Markdown -Heading "Parameters" -HeadingSize 3

            $parameterTotal= $helpObject.parameters.parameter.Length
            $parameterCounter = 0 
            foreach ($parameter in $helpObject.Parameters.parameter) {
                $parameterCounter++
                $parameterDisplayName = 
                    if ($parameter.required) {
                        "**$($parameter.Name)**"
                    } else {
                        $parameter.Name
                    }

                Format-Markdown -HeadingSize 4 -Heading $parameterDisplayName

                if ($parameter.Name -in 'WhatIf', 'Confirm') {
                    "-$($parameter.Name) " +  
                        'is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.'
                    if ($parameter.Name -eq 'WhatIf') {
                        "-WhatIf is used to see what would happen, or return operations without executing them"
                    }
                    if ($parameter.Name -eq 'Confirm') {
                        '-Confirm is used to -Confirm each operation.

If you pass ```-Confirm:$false``` you will not be prompted.


If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.
'
                    }
                    continue
                }

                ($parameter.description | Out-String -Width 1mb) -split '(?>\r\n|\n)' -replace '^-\s', '* ' -join [Environment]::NewLine

                [Ordered]@{
                    Type = '```' + "[" + $($parameter.type.name -replace 'SwitchParameter', 'Switch') + "]" + '```'
                    Requried = $parameter.required
                    Postion = $parameter.position
                    PipelineInput = $parameter.pipelineInput                    
                } | Format-Markdown
                if ($parameterCounter -lt $parameterTotal) { '---' } 
            }            
        }

        if ($helpObject.returnValues) {
            '---'
            Format-Markdown -Heading "Outputs" -HeadingSize 3
            foreach ($returnValue in $helpObject.returnValues.returnValue) {
                $returnValue.Text
                [Environment]::NewLine
            }
        }

        if ($helpObject.syntax.syntaxItem) {
            '---'
            Format-Markdown -Heading "Syntax" -HeadingSize 3
            ($helpObject.syntax | Out-String) -split '(?>\r\n|\n)' -ne '' | Format-Markdown -CodeLanguage PowerShell
        }

        if ($helpObject.alertset) {
            '---'
            Format-Markdown -Heading "Notes" -HeadingSize 3
            foreach ($note in $helpObject.AlertSet.alert) {
                ($note | Out-String).Trim() + [Environment]::NewLine
            }            
        }

    ) -join [Environment]::NewLine
}
 