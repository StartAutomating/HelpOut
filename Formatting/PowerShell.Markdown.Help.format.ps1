Write-FormatView -TypeName PowerShell.Markdown.Help -Action {
    $helpObject = $_
    @(
        Format-Markdown -Heading $helpObject.Name

        Format-Markdown -HeadingSize 3 -Heading "Synopsis"

        $helpObject.Synopsis | Out-String -Width 1mb
        
        '---'
        foreach ($desc in $helpObject.Description) {
            [Environment]::NewLine + $desc.text  + [Environment]::NewLine
        }


        if ($helpObject.RelatedLinks) {
            '---'

            Format-Markdown -Heading "Related:" -headingsize 3

            foreach ($nav in $helpObject.RelatedLinks.navigationLink) {
                if ($nav.Uri) {
                    Format-Markdown -Link $nav.Uri -inputObject $nav.LinkText -BulletPoint
                } elseif ($helpObject.WikiLink) {
                    $linkedCmd = $ExecutionContext.SessionState.InvokeCommand.GetCommand($nav.LinkText, 'All')
                    $linkUrl = if ($linkedCmd -and $linkedCmd.Module -like 'microsoft.*') {
                        "https://docs.microsoft.com/powershell/module/$($linkedCmd.Module)/$linkedCmd"

                    } else {
                        $nav.LinkText                        
                    }

                    Format-Markdown -Link $linkUrl -inputObject $nav.LinkText -BulletPoint
                } elseif ($ehlpObject.DocLink) {
                    Format-Markdown -inputObject "$($helpObject.docLink)/$($nav.LinkText.md)" -BulletPoint
                } else {
                    Format-Markdown -inputObject $nav.LinkText -BulletPoint
                }
            }
        }


        if ($helpObject.Examples) {
            '---'
            Format-Markdown -Heading "Examples:" -headingsize 3

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
            Format-Markdown -Heading "Parameters:" -HeadingSize 3

            foreach ($parameter in $helpObject.Parameters.parameter) {                
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
                    Type = $parameter.type.name
                    Requried = $parameter.required
                    Postion = $parameter.position
                    PipelineInput = $parameter.pipelineInput                    
                } | Format-Markdown
                '---'
            }
        }
    ) -join [Environment]::NewLine
}
 