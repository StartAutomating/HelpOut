---
CommandName: Get-MarkdownHelp
Parameters: 
  - Name: Name
    Type: System.String
    Aliases: 
    
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

Synopsis: Gets Markdown Help
Description: |
  
  Gets Help for a given command, in Markdown
  
  
  
HelpOut.TellStory: True
HelpOut.Story.Process: For each Command
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



#### **Wiki**

If set, will generate a markdown wiki.  Links will be relative to the current path, and will not include the .md extensions






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **GitHubDocRoot**

If set, will interlink documentation as if it were for GitHub pages, beneath a given directory






|Type      |Required|Position|PipelineInput|Aliases       |
|----------|--------|--------|-------------|--------------|
|`[String]`|false   |named   |false        |GitHubPageRoot|



#### **Rename**

If provided, will rename the help topic before getting markdown.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|



#### **SectionOrder**

The order of the sections.
If not provided, this will be the order they are defined in the formatter.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **NoValidValueEnumeration**

If set, will not enumerate valid values and enums of parameters.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|



#### **IncludeYamlHeader**

If set, will not attach a YAML header to the generated help.






|Type      |Required|Position|PipelineInput        |Aliases                             |
|----------|--------|--------|---------------------|------------------------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|IncludeFrontMatter<br/>IncludeHeader|



#### **YamlHeaderInformationType**

The type of information to include in the YAML Header



Valid Values:

* Command
* Help
* Metadata






|Type        |Required|Position|PipelineInput|Aliases           |
|------------|--------|--------|-------------|------------------|
|`[String[]]`|false   |named   |false        |YamlHeaderInfoType|





---


### Outputs
* [string]

The documentation for a single command, in Markdown.






---


How It Works
------------

### For each Command
 We start off by copying the bound parameters and then we call Get-Help.



 If we could not Get-Help, we error out.  We need to decorate the output of Get-Help so it renders as markdown, so we pipe thru all results from Get-Help.

 Get-Help can return either a help topic or command help.  Help topics will be returned as a string (which we will output as-is for now).





 Command Help will be returned as an object We decorate that object with the typename `PowerShell.Markdown.Help`.  Then we attach parameters passed to this command to the help object.  
* `-Rename` will become `[string] .Rename` 
* `-SectionOrder` will become `[string[]] .SectionOrder` 
* `-Wiki`  will become `[bool] .WikiLink` 
* `-GitHubDocRoot` will become `.DocLink` 
* `-NoValidValueEnumeration` 
* `-IncludeYamlHeader` 
* `-NoValidValueEnumeration`



 After we've attached all of the properties, we simply output the object.  PowerShell.Markdown.Help formatter will display it exactly as we'd like it.


---


### Syntax
```PowerShell
Get-MarkdownHelp [[-Name] <String>] [-Wiki] [-GitHubDocRoot <String>] [-Rename <String>] [-SectionOrder <String[]>] [-NoValidValueEnumeration] [-IncludeYamlHeader] [-YamlHeaderInformationType <String[]>] [<CommonParameters>]
```
