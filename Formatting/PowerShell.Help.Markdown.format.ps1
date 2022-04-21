Write-FormatView -TypeName PowerShell.Markdown.Help.Format -Action {
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
            Format-Markdown -Heading "Related:" -headingsize 3

            foreach ($example in $helpObject.Examples.Example) {
                (Format-Markdown -Heading $example.Title -HeadingSize 4) -replace '^[-\s]+' -replace '[-\s+]$'                
            }
        }
    ) -join [Environment]::NewLine
}
