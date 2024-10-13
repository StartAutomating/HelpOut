<#
.SYNOPSIS
    Saves a Help Topic as json
.DESCRIPTION
    Saves a Help Topic to a json file.
.NOTES
    This will not save to files that have illegal names on Windows.
.EXAMPLE
    (Get-MarkdownHelp Get-MarkdownHelp).SaveJson(".\test.json")
.LINK
    HelpInfo.ToJson
#>
param(
# The path to the file.
# If this does not exist it will be created.
[string]
$FilePath
)

$illegalCharacters = @('<', '>', '|', '?', '*', ':')
$illegalCharacterRegex = '[' + ($illegalCharacters | Foreach-Object { [regex]::Escape($_) }) + ']'
$illegalCharacterReadable = ($illegalCharacters | Foreach-Object { "`"$_`"" }) -join ', '

$filePathWithoutQualifier = Split-Path $filePath -NoQualifier
if ($filePathWithoutQualifier -match $illegalCharacterRegex) {
    Write-Warning "Will not .Save to $filePath, because that path will not be readable on all operating systems. It cannot contain any of the characters $illegalCharacterReadable."
    return
}

New-Item -ItemType File -Path $FilePath -Force -Value $this.ToJson()
