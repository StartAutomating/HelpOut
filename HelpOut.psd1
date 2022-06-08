@{
    Copyright='2019-2022 Start-Automating'
    Description='A Helpful Toolkit for Managing PowerShell Help'
    CompanyName='Start-Automating'
    Guid='3f57070a-240f-4406-8e8e-6351ffe6f85b'
    Author='James Brundage'
    ModuleToProcess='HelpOut.psm1'
    FormatsToProcess='HelpOut.format.ps1xml'
    ModuleVersion='0.2.4'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/HelpOut'
            LicenseURI = 'https://github.com/StartAutomating/HelpOut/blob/master/LICENSE'

            Tags = 'Markdown', 'Help','PowerShell'
            ReleaseNotes = @'
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
