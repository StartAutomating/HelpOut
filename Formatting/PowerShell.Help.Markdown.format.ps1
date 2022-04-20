Write-FormatView -TypeName PowerShell.Help.Markdown.Format -Action {
    $helpObject = $_
    @(
        $helpObject.Synopsis | Format-Markdown -Heading $helpObject.Name

        '-' * $host.UI.RawUI.BufferSize.Width
        foreach ($desc in $helpObject.Description) {
            [Environment]::NewLine + $desc.text  + [Environment]::NewLine
        }


        if ($helpObject.RelatedLinks) {
            Format-Markdown -horizontalRule

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
    ) -join [Environment]::NewLine
}
