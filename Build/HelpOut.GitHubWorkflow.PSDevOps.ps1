#requires -Module PSDevOps
#requires -Module GitPub
Push-Location $PSScriptRoot

Import-BuildStep -Module GitPub

Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubWorkflow

Push-Location ($PSScriptRoot | Split-Path)

New-GitHubWorkflow -Name "Test, Tag, Release, and Publish" -On Demand, Push -Job PowerShellStaticAnalysis, 
    TestPowerShellOnLinux, 
    TagReleaseAndPublish, 
    BuildHelpOut -OutputPath .\.github\workflows\TestReleaseAndPublish.yml -Env ([Ordered]@{        
        "AT_PROTOCOL_HANDLE" = "mrpowershell.bsky.social"
        "AT_PROTOCOL_APP_PASSWORD" = '${{ secrets.AT_PROTOCOL_APP_PASSWORD }}'    
        REGISTRY = 'ghcr.io'
        IMAGE_NAME = '${{ github.repository }}'        
    })

New-GitHubWorkflow -On Demand, 
    Released -Job RunGitPub -Name OnIssueOrRelease -OutputPath .\.github\workflows\GitPub.yml


Pop-Location