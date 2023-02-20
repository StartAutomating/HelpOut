#requires -Module HelpOut
#requires -Module PSDevOps
#requires -Module GitPub
Push-Location $PSScriptRoot

Import-BuildStep -Module GitPub

Import-BuildStep -Module HelpOut

New-GitHubWorkflow -Name "Test, Tag, Release, and Publish" -On Demand, Push -Job PowerShellStaticAnalysis, 
    TestPowerShellOnLinux, 
    TagReleaseAndPublish, 
    BuildHelpOut -OutputPath .\.github\workflows\TestReleaseAndPublish.yml

New-GitHubWorkflow -On Issue, 
    Demand, 
    Released -Job RunGitPub -Name OnIssueOrRelease -OutputPath .\.github\workflows\OnIssue.yml


Pop-Location