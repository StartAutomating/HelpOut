<div align='center'>
<img src='Assets/HelpOut.svg' alt='HelpOut' />
<a href='https://www.powershellgallery.com/packages/HelpOut/'>
<img src='https://img.shields.io/powershellgallery/dt/HelpOut' />
</a>
</div>

## A Helpful Toolkit for Managing PowerShell Help

HelpOut is a Helpful Toolkit for Managing PowerShell Help.

It helps you to:

* Make Markdown Documentation and Wikis For Your Module
* Measure how much documentation is in a script or a function
* Find references within a script.

You can install HelpOut from the gallery, or use it as a GitHub Action.

## HelpOut as a GitHub action

To use HelpOut as a GitHub action, simply copy/paste this code into a job in your workflow

~~~yaml
   - name: UseHelpOut
     uses: StartAutomating/HelpOut@master
~~~

Then, create a `*.HelpOut.ps1` file.

This file should import your module and then use Save-MarkdownHelp with -PassThru

Files produced this way will be checked in if there are any changes.

**NOTE** You must allow repository write permissions to your GitHub Workflow for HelpOut to update files.

## Using HelpOut Locally

To use HelpOut locally, start off by installing it from the PowerShell Gallery:

~~~PowerShell
Install-Module HelpOut -Scope CurrentUser -Force
~~~

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
