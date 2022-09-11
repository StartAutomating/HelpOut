@{
    Copyright='2019-2022 Start-Automating'
    Description='A Helpful Toolkit for Managing PowerShell Help'
    CompanyName='Start-Automating'
    Guid='3f57070a-240f-4406-8e8e-6351ffe6f85b'
    Author='James Brundage'
    ModuleToProcess='HelpOut.psm1'
    FormatsToProcess='HelpOut.format.ps1xml'
    ModuleVersion='0.3.4'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/HelpOut'
            LicenseURI = 'https://github.com/StartAutomating/HelpOut/blob/master/LICENSE'

            Tags = 'Markdown', 'Help','PowerShell'
            ReleaseNotes = @'
### 0.3.4
* Fixing accidental heading names in .Link and parameter properties (Fixes #73)
---

### 0.3.3
* Markdown Help now uses fewer tables (improves default GitHub Page rendering) (fixes #71)
---
### 0.3.2
* Save-MarkdownHelp Bugfix (Fixes #69)
---

### 0.3.1
* Save-MarkdownHelp:  
  * Can now -ReplaceLink (Fixes #66)
  * -ReplaceLink will always replace -OutputPath (Fixes #67)
  * Changing Aliases for -SkipCommandType (Fixes #65)
---
### 0.3:
* Get-MarkdownHelp: Fixing Property Table rendering issues with ValidValues (#58)
* Workflow improvements:  Building formatting / types in CI/CD (#63)
---
### 0.2.9:
* Get-MarkdownHelp: Fixing Property Table rendering issues with ValidValues (#58)
* Action improvements:
  * Pulling just before push (#59)
  * Improving username / email detection (#60)
---

### 0.2.8:
* Save-MarkdownHelp:
  * Adding -ExcludeTopic (#55)
  * -IncludeTopic excludes deeply nested topics (#54)
  * -IncludeExtension default now includes .svg files (#53)
---

### 0.2.7
* Save-MarkdownHelp:
  * Adding -Command, -ReplaceCommandName, -ReplaceCommandNameWith (#45)
  * Fixing -ReplaceScriptName issue (#46)
* Save-MAML:
  * -PassThru now returns files, not file contents (#47)
* HelpOut.HelpOut.ps1 Added (Selfhosting Action (#48))
---

### 0.2.6
* Save-MarkdownHelp:
  * Improving Inline Documentation
  * Allowing -ScriptPath to be a Regex (#41)
  * Fixing Relative Paths with -IncludeExtension (#42)
  * Improving -IncludeTopic regex behavior (#43)
---
### 0.2.5
* Save-MarkdownHelp:
  * Adding -IncludeExtension (#35)
  * Applying -PassThru to -IncludeTopic (#34)
  * Allowing wildcards in -IncludeTopic (#33)
* Preliminary support for GitHub Pages Publishing (#32)
---
### 0.2.4
* Save-MarkdownHelp:
  * Adding -SkipCommandType (#29)
  * -ScriptPath now allows wildcards (#28)
* Formatting now Handles Arrays of Enums (#30)
---
### 0.2.3
* Get/Save-MarkdownHelp:  Support for -NoValidValueEnumeration (re #25)
* Save-MarkdownHelp:  Adding -IncludeTopic (Fixes #24, #26)
* Adding ValidateSet/Enum Formatting for Markdown Help (Fixing #25)

---
### 0.2.2
* Fixing issue generating docs (#22)
* HelpOut Action Fix (#20)
---

### 0.2.1
* Get/Save-MarkdownHelp:  Support for -SectionOrder (#19)
* Save-MarkdownHelp:  Adding -Passthru (#17).  Converting Markdown Help into a string (#18)
* Get-MarkdownHelp: Returning Object (#18)
* Fixing URL-only related links (#14)
* Adding Get-MarkdownHelp -Rename (#13)
* Retitling Script Files with relative path (#12)
---
### 0.2
* Adding Install-MAML (#1/ #7)
* Adding Get-MarkdownHelp (#4)
* Adding Save-MarkdownHelp (#10)
* Adding HelpOut Action (#5)
* Adding Measure-Help (#11)
* Adding Get-ScriptStory (#3)
* Adding Get-ScriptReference (#2)
* Renmaing ConvertTo-MAML->Get-MAML
---
'@
        }
    }
}
