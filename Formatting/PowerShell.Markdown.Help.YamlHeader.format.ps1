Write-FormatView -TypeName PowerShell.Markdown.Help.YamlHeader -Action {
    @("---"
    Format-YAML -InputObject $_
    "---") -join [Environment]::NewLine
}
