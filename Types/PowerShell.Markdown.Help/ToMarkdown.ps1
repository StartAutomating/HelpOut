<#
.SYNOPSIS
    Returns this topic as a markdown string
.DESCRIPTION
    Returns the content of this help topic as a markdown string.
.EXAMPLE

#>
param(
# An optional view.
# This would need to be declared in a .format.ps1xml file by another loaded module.
[string]
$View = 'PowerShell.Markdown.Help'
)

($this |
    Format-Custom -View $View |
    Out-String -Width 1mb).Trim()