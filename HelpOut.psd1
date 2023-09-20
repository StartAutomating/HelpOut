@{
    Copyright='2019-2023 Start-Automating'
    Description='A Helpful Toolkit for Managing PowerShell Help'
    CompanyName='Start-Automating'
    Guid='3f57070a-240f-4406-8e8e-6351ffe6f85b'
    Author='James Brundage'
    ModuleToProcess='HelpOut.psm1'
    FormatsToProcess='HelpOut.format.ps1xml'
    TypesToProcess='HelpOut.types.ps1xml'
    ModuleVersion='0.4.8'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/HelpOut'
            LicenseURI = 'https://github.com/StartAutomating/HelpOut/blob/master/LICENSE'

            Tags = 'Markdown', 'Help','PowerShell'
            ReleaseNotes = @'
### HelpOut 0.4.8:

* Markdown Help Improvements:
    * Fixing Long Examples (Fixes #141)
    * Allowing first comment lines in an example to be markdown (#143)
    * Also, switching numbered example headings to blockquotes
* Save-MarkdownHelp updates:
    * Fixing Piping Behavior (#140)
    * Not Saving to illegal windows paths (#132)
* Improving Extended Types Doc Generation
    * Now puts extended type documentation into subfolders (#135)
    * Also, generates a summary file for each type (#133)
* Updating links to Microsoft modules (#142)
* Integrating PSA into HelpOut (#144)

---

Additional Changes in [Changelog](/CHANGELOG.md)
'@
        }
    }
}
