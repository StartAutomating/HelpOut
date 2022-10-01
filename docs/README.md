# HelpOut
## A Helpful Toolkit for Managing PowerShell Help

HelpOut is a Helpful Toolkit for Managing PowerShell Help.

It helps you to:

* Make Markdown Documentation and Wikis For Your Module
* Measure how much documentation is in a script or a function
* Find references within a script.

### Generating MAML
~~~PowerShell
Get-Module HelpOut | Save-Maml # Will generate MAML files for all of the commands in HelpOut
~~~

### Generating Markdown /docs
~~~PowerShell
Get-Module HelpOut | Save-MarkdownHelp  # Will generate a /docs folder containing markdown help (interlinked for GitHub Pages)
~~~

### Generating Wikis
~~~PowerShell
Get-Module HelpOut | Save-MarkdownHelp -Wiki  # Will generate a ../HelpOut.wiki folder containing markdown help (interlinked for wikis)
~~~


### Using HelpOut as a GitHub Action.

You can use HelpOut as a GitHub Action.  Doing so will run whatever .HelpOut.ps1 files exist in your repository.  If a -CommitMessage is provided, or attached to any files returned by the .HelpOut.ps1, the changes will be commited.

