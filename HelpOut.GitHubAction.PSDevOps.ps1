#requires -Module PSDevOps
#requires -Module HelpOut
Import-BuildStep -ModuleName HelpOut
New-GitHubAction -Name "OutputHelp" -Description 'Output Help for a PowerShell Module, using HelpOut' -Action HelpOutAction -Icon help-circle  -ActionOutput ([Ordered]@{
    HelpOutScriptRuntime = [Ordered]@{
        description = "The time it took the .HelpOutScript parameter to run"
        value = '${{steps.HelpOutAction.outputs.HelpOutScriptRuntime}}'
    }
    HelpOutPS1Runtime = [Ordered]@{
        description = "The time it took all .HelpOut.ps1 files to run"
        value = '${{steps.HelpOutAction.outputs.HelpOutPS1Runtime}}'
    }
    HelpOutPS1Files = [Ordered]@{
        description = "The .HelpOut.ps1 files that were run (separated by semicolons)"
        value = '${{steps.HelpOutAction.outputs.HelpOutPS1Files}}'
    }
    HelpOutPS1Count = [Ordered]@{
        description = "The number of .HelpOut.ps1 files that were run"
        value = '${{steps.HelpOutAction.outputs.HelpOutPS1Count}}'
    }
}) |
    Set-Content .\action.yml -Encoding UTF8 -PassThru
