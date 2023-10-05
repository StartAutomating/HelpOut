@{
    Copyright='2019-2023 Start-Automating'
    Description='A Helpful Toolkit for Managing PowerShell Help'
    CompanyName='Start-Automating'
    Guid='3f57070a-240f-4406-8e8e-6351ffe6f85b'
    Author='James Brundage'
    ModuleToProcess='HelpOut.psm1'
    FormatsToProcess='HelpOut.format.ps1xml'
    TypesToProcess='HelpOut.types.ps1xml'
    ModuleVersion='0.5'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/HelpOut'
            LicenseURI = 'https://github.com/StartAutomating/HelpOut/blob/master/LICENSE'

            Tags = 'Markdown', 'Help','PowerShell'
            ReleaseNotes = @'
### HelpOut 0.5:

* Install-MAML - Adding -NoComment (#157)
* Install-MAML - Adding -Minify (#158)

Thanks @potatoqualitee ! 

---

Additional Changes in [Changelog](/CHANGELOG.md)
Like It?  Start It.  Love It?  Support It.

'@
        }
    }
}
