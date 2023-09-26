@{
    Copyright='2019-2023 Start-Automating'
    Description='A Helpful Toolkit for Managing PowerShell Help'
    CompanyName='Start-Automating'
    Guid='3f57070a-240f-4406-8e8e-6351ffe6f85b'
    Author='James Brundage'
    ModuleToProcess='HelpOut.psm1'
    FormatsToProcess='HelpOut.format.ps1xml'
    TypesToProcess='HelpOut.types.ps1xml'
    ModuleVersion='0.4.9'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/HelpOut'
            LicenseURI = 'https://github.com/StartAutomating/HelpOut/blob/master/LICENSE'

            Tags = 'Markdown', 'Help','PowerShell'
            ReleaseNotes = @'
### HelpOut 0.4.9:

* Supporting custom attribute formatting with -FormatAttribute (#147)
  * Markdown Formatter - Honoring .FormatAttribute (#148)
  * Get-MarkdownHelp -FormatAttribute (#149)
  * Save-MarkdownHelp -FormatAttribute (#150)
* Extended Type Formatting - Improving handling of empty directories (#146)
* Updating HelpOut PSA (#152)

---

Additional Changes in [Changelog](/CHANGELOG.md)
'@
        }
    }
}
