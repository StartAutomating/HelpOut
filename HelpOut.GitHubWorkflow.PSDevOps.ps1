#requires -Module HelpOut
#requires -Module PSDevOps
#requires -Module GitPub
Push-Location $PSScriptRoot

Import-BuildStep -Module GitPub

New-GitHubWorkflow -Name "Test, Tag, Release, and Publish" -On Demand, Push -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, HelpOut, RunEZOut |
    Set-Content .\.github\workflows\TestReleaseAndPublish.yml -Encoding UTF8 -PassThru

New-GitHubWorkflow -On Issue, Demand -Job RunGitPub -Name OnIssueChanged |
    Set-Content (Join-Path $PSScriptRoot .github\workflows\OnIssue.yml) -Encoding UTF8 -PassThru

Pop-Location