#requires -Module PSDevOps
Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubAction

Push-Location ($PSScriptRoot | Split-Path)

New-GitHubAction -Name "OutputHelp" -Description @'
Output Help for a PowerShell Module, using HelpOut
'@ -Action HelpOutAction -Icon help-circle -OutputPath .\action.yml


Pop-Location