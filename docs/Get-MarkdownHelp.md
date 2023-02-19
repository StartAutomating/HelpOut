---
CommandName: Get-MarkdownHelp
Parameters: 
  - Name: GitHubDocRoot
    Type: System.String
    Aliases: 
    - GitHubPageRoot
  - Name: IncludeYamlHeader
    Type: System.Management.Automation.SwitchParameter
    Aliases: 
    - IncludeFrontMatter
    - IncludeHeader
  - Name: NoValidValueEnumeration
    Type: System.Management.Automation.SwitchParameter
    Aliases: 
    
  - Name: Rename
    Type: System.String
    Aliases: 
    
  - Name: SectionOrder
    Type: System.String[]
    Aliases: 
    
  - Name: Wiki
    Type: System.Management.Automation.SwitchParameter
    Aliases: 
    
  - Name: YamlHeaderInformationType
    Type: System.String[]
    Aliases: 
    - YamlHeaderInfoType
  - Name: Name
    Type: System.String
    Aliases: 
    
Synopsis: Gets Markdown Help
Description: |
  
  Gets Help for a given command, in Markdown
  
  
  
HelpOut.TellStory: True
HelpOut.Story.Process: On Each Command Or Topic
---


Get-MarkdownHelp
----------------


### Synopsis
Gets Markdown Help

---


### Description

Gets Help for a given command, in Markdown

---


### Related Links
* [Save-MarkdownHelp](Save-MarkdownHelp.md)



* [Get-Help](https://docs.microsoft.com/powershell/module/Microsoft.PowerShell.Core/Get-Help)



---


### Examples
#### EXAMPLE 1
```PowerShell
Get-MarkdownHelp Get-Help
```

---


### Parameters
#### **Name**

The name of the specified command or concept.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|



---
#### **Wiki**

If set, will generate a markdown wiki.  Links will be relative to the current path, and will not include the .md extensions






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
#### **GitHubDocRoot**

If set, will interlink documentation as if it were for GitHub pages, beneath a given directory






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |



---
#### **Rename**

If provided, will rename the help topic before getting markdown.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|



---
#### **SectionOrder**

The order of the sections.
If not provided, this will be the order they are defined in the formatter.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



---
#### **NoValidValueEnumeration**

If set, will not enumerate valid values and enums of parameters.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|



---
#### **IncludeYamlHeader**

If set, will not attach a YAML header to the generated help.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|



---
#### **YamlHeaderInformationType**

The type of information to include in the YAML Header



Valid Values:

* Command
* Help
* Metadata






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |named   |false        |



---


### Outputs
* [string]

The documentation for a single command, in Markdown.




---


Story
-----

## On Each Input
 We start off by copying the bound parameters and then we call Get-Help.  If we could not call Get-Help error out.  Next we need to tweak the output of Get-Help.  Get-Help can return either a help topic or help about a command.

 Help topics will be returned as a string (which we will output as-is for now) Command help is the interesting scenario.  In this case, we want to prepare the object to become markdown in a few ways.  
* Clear the typenames and decorate the return object.  
* If -Rename was passed, put that on the help object.  
* Add the -SectionOrder to the help object.  
* Add -Wiki to the help object, as .WikiLink.  
* Add -GitHubDocRoot as .DocLink.  
* Pass down -NoValidValueEnumeration.

 Now, when we output this object, the PowerShell.Markdown.Help formatter will display it.
Story
-----

## On Each Input
 We start off by copying the bound parameters and then we call Get-Help.  If we could not call Get-Help error out.  Next we need to tweak the output of Get-Help.  Get-Help can return either a help topic or help about a command.

 Help topics will be returned as a string (which we will output as-is for now) Command help is the interesting scenario.  In this case, we want to prepare the object to become markdown in a few ways.  
* Clear the typenames and decorate the return object.  
* If -Rename was passed, put that on the help object.  
* Add the -SectionOrder to the help object.  
* Add -Wiki to the help object, as .WikiLink.  
* Add -GitHubDocRoot as .DocLink.  
* Pass down -NoValidValueEnumeration.

 Now, when we output this object, the PowerShell.Markdown.Help formatter will display it.
---


### Syntax
```PowerShell
Get-MarkdownHelp [[-Name] <String>] [-Wiki] [-GitHubDocRoot <String>] [-Rename <String>] [-SectionOrder <String[]>] [-NoValidValueEnumeration] [-IncludeYamlHeader] [-YamlHeaderInformationType <String[]>] [<CommonParameters>]
```
