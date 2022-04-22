﻿<#
.Synopsis
    GitHub Action for HelpOut
.Description
    GitHub Action for HelpOut.  This will:

    * Import HelpOut
    * Run all *.HelpOut.ps1 files beneath the workflow directory
    * Run a .HelpOutScript parameter

    Any files changed can be outputted by the script, and those changes can be checked back into the repo.
    Make sure to use the "persistCredentials" option with checkout.
#>

param(
# A PowerShell Script that uses HelpOut.  
# Any files outputted from the script will be added to the repository.
# If those files have a .Message attached to them, they will be committed with that message.
[string]
$HelpOutScript,

# If set, will not process any files named *.HelpOut.ps1
[switch]
$SkipHelpOutPS1,

# The name of the module for which types and formats are being generated.
# If not provided, this will be assumed to be the name of the root directory.
[string]
$ModuleName,

# If provided, will commit any remaining changes made to the workspace with this commit message.
# If no commit message is provided, changes will not be committed.
[string]
$CommitMessage,

# The user email associated with a git commit.
[string]
$UserEmail,

# The user name associated with a git commit.
[string]
$UserName
)

"::group::Parameters" | Out-Host
[PSCustomObject]$PSBoundParameters | Format-List | Out-Host
"::endgroup::" | Out-Host

if ($env:GITHUB_ACTION_PATH) {
    $HelpOutModulePath = Join-Path $env:GITHUB_ACTION_PATH 'HelpOut.psd1'
    if (Test-path $HelpOutModulePath) {
        Import-Module $HelpOutModulePath -Force -PassThru | Out-String
    } else {
        throw "HelpOut not found"
    }
} elseif (-not (Get-Module HelpOut)) {    
    throw "Action Path not found"
}

"::notice title=ModuleLoaded::HelpOut Loaded from Path - $($HelpOutModulePath)" | Out-Host

$anyFilesChanged = $false
$processScriptOutput = { process { 
    $out = $_
    $outItem = Get-Item -Path $out -ErrorAction SilentlyContinue
    $fullName, $shouldCommit = 
        if ($out -is [IO.FileInfo]) {
            $out.FullName, (git status $out.Fullname -s)
        } elseif ($outItem) {
            $outItem.FullName, (git status $outItem.Fullname -s)
        }
    if ($shouldCommit) {
        git add $fullName
        if ($out.Message) {
            git commit -m "$($out.Message)"
        } elseif ($out.CommitMessage) {
            git commit -m "$($out.CommitMessage)"
        }
        $anyFilesChanged = $true
    }
    $out
} }


if (-not $UserName) { $UserName = $env:GITHUB_ACTOR }
if (-not $UserEmail) { $UserEmail = "$UserName@github.com" }
git config --global user.email $UserEmail
git config --global user.name  $UserName

if (-not $env:GITHUB_WORKSPACE) { throw "No GitHub workspace" }

git pull | Out-Host

$HelpOutScriptStart = [DateTime]::Now
if ($HelpOutScript) {
    Invoke-Expression -Command $HelpOutScript |
        . $processScriptOutput |
        Out-Host
}
$HelpOutScriptTook = [Datetime]::Now - $HelpOutScriptStart
"::set-output name=HelpOutScriptRuntime::$($HelpOutScriptTook.TotalMilliseconds)"   | Out-Host

$HelpOutPS1Start = [DateTime]::Now
$HelpOutPS1List  = @()
if (-not $SkipHelpOutPS1) {
    $HelpOutFiles = @(
    Get-ChildItem -Recurse -Path $env:GITHUB_WORKSPACE |
        Where-Object Name -Match '\.EZ(Out|Format)\.ps1$')
        
    if ($HelpOutFiles) {
        $HelpOutFiles|        
        ForEach-Object {
            $HelpOutPS1List += $_.FullName.Replace($env:GITHUB_WORKSPACE, '').TrimStart('/')
            $HelpOutPS1Count++
            "::notice title=Running::$($_.Fullname)" | Out-Host
            . $_.FullName |            
                . $processScriptOutput  | 
                Out-Host
        }
    }
}

$HelpOutPS1EndStart = [DateTime]::Now
$HelpOutPS1Took = [Datetime]::Now - $HelpOutPS1Start
"::set-output name=HelpOutPS1Count::$($HelpOutPS1List.Length)"   | Out-Host
"::set-output name=HelpOutPS1Files::$($HelpOutPS1List -join ';')"   | Out-Host
"::set-output name=HelpOutPS1Runtime::$($HelpOutPS1Took.TotalMilliseconds)"   | Out-Host
if ($CommitMessage -or $anyFilesChanged) {
    if ($CommitMessage) {
        dir $env:GITHUB_WORKSPACE -Recurse |
            ForEach-Object {
                $gitStatusOutput = git status $_.Fullname -s
                if ($gitStatusOutput) {
                    git add $_.Fullname
                }
            }

        git commit -m $ExecutionContext.SessionState.InvokeCommand.ExpandString($CommitMessage)
    }    

    $checkDetached = git symbolic-ref -q HEAD
    if (-not $LASTEXITCODE) {
        "::notice::Pushing Changes" | Out-Host
        git push        
        "Git Push Output: $($gitPushed  | Out-String)"
    } else {
        "::notice::Not pushing changes (on detached head)" | Out-Host
        $LASTEXITCODE = 0
        exit 0
    }
}
