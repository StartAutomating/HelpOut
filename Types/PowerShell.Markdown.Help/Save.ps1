<#
.SYNOPSIS
    Saves a Markdown Help Topic
.DESCRIPTION
    Saves a Markdown Help Topic to a file.
.NOTES
    This will not save to files that have illegal names on Windows.
.EXAMPLE
    (Get-MarkdownHelp Get-MarkdownHelp).Save(".\test.md")
.LINK
    PowerShell.Markdown.Help.ToMarkdown
#>
param(
# The path to the file.
# If this does not exist it will be created.
[string]
$FilePath,

# An optional view.
# This would need to be declared in a .format.ps1xml file by another loaded module.
[string]
$View = 'PowerShell.Markdown.Help'
)

if ($filePath -match '[\<\>\|\?\*\:]') {
    Write-Warning "Will not .Save to $filePath, because that path will not be readable on all operating systems."
    return
}

if (-not (Test-Path $FilePath)) {
    $createdFile = New-Item -ItemType File -Path $FilePath -Force
    if (-not $createdFile) { return }
}

Set-Content -Path $filePath -Value $this.ToMarkdown($view)

if ($?) {
    Get-Item -Path $FilePath
}