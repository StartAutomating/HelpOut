#requires -Module HelpOut
#requires -Module PSDevOps
Push-Location $PSScriptRoot

New-GitHubWorkflow -Name "Test, Tag, Release, and Publish" -On Demand, Push -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, HelpOut, RunEZOut |
    Set-Content .\.github\workflows\TestReleaseAndPublish.yml -Encoding UTF8 -PassThru

Pop-Location