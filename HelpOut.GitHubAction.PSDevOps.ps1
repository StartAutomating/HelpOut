#requires -Module PSDevOps
#requires -Module HelpOut
Import-BuildStep -ModuleName HelpOut
New-GitHubAction -Name "OutputHelp" -Description @'
Output Help for a PowerShell Module, using HelpOut
'@ -Action HelpOutAction -Icon help-circle -OutputPath .\action.yml
