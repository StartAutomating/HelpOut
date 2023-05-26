@{
    Copyright='2019-2023 Start-Automating'
    Description='A Helpful Toolkit for Managing PowerShell Help'
    CompanyName='Start-Automating'
    Guid='3f57070a-240f-4406-8e8e-6351ffe6f85b'
    Author='James Brundage'
    ModuleToProcess='HelpOut.psm1'
    FormatsToProcess='HelpOut.format.ps1xml'
    TypesToProcess='HelpOut.types.ps1xml'
    ModuleVersion='0.4.5'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/HelpOut'
            LicenseURI = 'https://github.com/StartAutomating/HelpOut/blob/master/LICENSE'

            Tags = 'Markdown', 'Help','PowerShell'
            ReleaseNotes = @'
### HelpOut 0.4.5:

* You can now sponsor HelpOut (#126)
* Added ScriptMethods to PowerShell.Markdown.Help (#125)
* Now allowing Save-MarkDownHelp to be extended by any HelpOut.SaveMarkdownHelp file or function (#123)
* Auto-documenting extended types (#101)

---

Additional Changes in [ChangeLog](/CHANGELOG.md)
'@
        }
    }
}
