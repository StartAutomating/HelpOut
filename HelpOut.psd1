@{
    Copyright='2019-2024 Start-Automating'
    Description='A Helpful Toolkit for Managing PowerShell Help'
    CompanyName='Start-Automating'
    Guid='3f57070a-240f-4406-8e8e-6351ffe6f85b'
    Author='James Brundage'
    ModuleToProcess='HelpOut.psm1'
    FormatsToProcess='HelpOut.format.ps1xml'
    TypesToProcess='HelpOut.types.ps1xml'
    ModuleVersion='0.5.4'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/HelpOut'
            LicenseURI = 'https://github.com/StartAutomating/HelpOut/blob/master/LICENSE'

            Tags = 'Markdown', 'Help','PowerShell'
            ReleaseNotes = @'
### HelpOut 0.5.4:

* HelpOut containization
  * Dockerfile (#182)
  * Publishing to `https://ghcr.io/startautomating/helpout` (#183)
  * Container.init.ps1 (#191)
  * Container.start.ps1 (#193)
  * Container.stop.ps1 (#194)
* Get/Save-Maml -IncludeAlias/-SkipCommandType (#178) (thanks @potatoqualitee ! )
* Get-MarkdownHelp keeps alias names (#200)
* HelpOut repository improvements
  * Organizing Files (#184, #185, #186, #187)
* HelpOut is now exported as `$HelpOut` (#188)
* HelpOut's root is now exported as `HelpOut:` (#189)
* Extended Type Help Improvement:
  * Extended Member Titles (#198)
  * Fixing Grouping (#197)
  * Fixing Type File Naming (#196)

---

Additional Changes in [Changelog](/CHANGELOG.md)
Like It?  Star It.  Love It?  Support It.

'@
        }
    }
}
