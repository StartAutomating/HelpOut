@{
    Copyright='2019-2024 Start-Automating'
    Description='A Helpful Toolkit for Managing PowerShell Help'
    CompanyName='Start-Automating'
    Guid='3f57070a-240f-4406-8e8e-6351ffe6f85b'
    Author='James Brundage'
    ModuleToProcess='HelpOut.psm1'
    FormatsToProcess='HelpOut.format.ps1xml'
    TypesToProcess='HelpOut.types.ps1xml'
    ModuleVersion='0.5.3'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/HelpOut'
            LicenseURI = 'https://github.com/StartAutomating/HelpOut/blob/master/LICENSE'

            Tags = 'Markdown', 'Help','PowerShell'
            ReleaseNotes = @'
### HelpOut 0.5.3:

* Save-MarkdownHelp:
  * Fix saving markdown with Windows paths ( #175 )

Thanks @ShaunLawrie ! 

---

Additional Changes in [Changelog](/CHANGELOG.md)
Like It?  Star It.  Love It?  Support It.

'@
        }
    }
}
