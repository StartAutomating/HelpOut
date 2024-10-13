@{
    Copyright='2019-2024 Start-Automating'
    Description='A Helpful Toolkit for Managing PowerShell Help'
    CompanyName='Start-Automating'
    Guid='3f57070a-240f-4406-8e8e-6351ffe6f85b'
    Author='James Brundage'
    ModuleToProcess='HelpOut.psm1'
    FormatsToProcess='HelpOut.format.ps1xml'
    TypesToProcess='HelpOut.types.ps1xml'
    ModuleVersion='0.5.5'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/HelpOut'
            LicenseURI = 'https://github.com/StartAutomating/HelpOut/blob/master/LICENSE'

            Tags = 'Markdown', 'Help', 'PowerShell'
            ReleaseNotes = @'
### HelpOut 0.5.5:

* Save-MarkdownHelp `-JsonDataPath/-NoJson` (#208, #179)
* Extending `HelpInfo`:
  * `HelpInfo.ToJson` (#205)
  * `HelpInfo.get_Note` (#206)
  * `HelpInfo.SaveJson` (#207)
* Extended Type Help Improvements:
  * Fixing Summary Titles (#202)
  * Separating Script Properties (#203)
* Special Thanks: 
  * @potatoqualitee

---

Additional Changes in [Changelog](/CHANGELOG.md)
Like It?  Star It.  Love It?  Support It.

'@
        }
    }
}
