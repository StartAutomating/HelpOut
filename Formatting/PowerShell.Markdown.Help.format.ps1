Write-FormatView -TypeName PowerShell.Markdown.Help -Action {
    $helpObject = $_
    @(
        $helpObject.Synopsis | Format-Markdown -Heading $helpObject.Name

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
                } elseif ($helpObject.UriRoot) {
                    Format-Markdown -Link $nav.LinkText -inputObject $nav.LinkText -BulletPoint
                } else {
                    Format-Markdown -inputObject $nav.LinkText -BulletPoint
                }
            }
        }


        if ($helpObject.Examples) {
            '---'
            Format-Markdown -Heading "Examples:" -headingsize 3

            foreach ($example in $helpObject.Examples.Example) {
                (Format-Markdown -Heading $example.Title -HeadingSize 4) -replace '^[-\s]+' -replace '[-\s+]$'

                if ($example.Code) {
                    $example.Code | Format-Markdown -CodeLanguage PowerShell
                }

                if ($example.Remarks) {
                    $example.Remarks | Out-String -Width 1mb
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
                @{
                    Type = $parameter.type.name
                    Requried = $parameter.required
                } | Format-Markdown                

                ($parameter.description | Out-String -Width 1mb) -split '(?>\r\n|\n)' -replace '^-\s', '* ' -join [Environment]::NewLine
            }
        }
    ) -join [Environment]::NewLine
}
 