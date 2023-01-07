---
CommandName: Get-MarkdownHelp
Parameters: 
  - Name: Name
    Type: System.String
    Aliases: 
    
  - Name: Wiki
    Type: System.Management.Automation.SwitchParameter
    Aliases: 
    
  - Name: GitHubDocRoot
    Type: System.String
    Aliases: 
    - GitHubPageRoot
  - Name: Rename
    Type: System.String
    Aliases: 
    
  - Name: SectionOrder
    Type: System.String[]
    Aliases: 
    
  - Name: NoValidValueEnumeration
    Type: System.Management.Automation.SwitchParameter
    Aliases: 
    
  - Name: IncludeYamlHeader
    Type: System.Management.Automation.SwitchParameter
    Aliases: 
    - IncludeFrontMatter
    - IncludeHeader
  - Name: YamlHeaderInformationType
    Type: System.String[]
    Aliases: 
    - YamlHeaderInfoType

Synopsis: Gets Markdown Help
Description: |
  
  Gets Help for a given command, in Markdown
  
  
  
HelpOut.TellStory: True
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
### Syntax
```PowerShell
Get-MarkdownHelp [[-Name] <String>] [-Wiki] [-GitHubDocRoot <String>] [-Rename <String>] [-SectionOrder <String[]>] [-NoValidValueEnumeration] [-IncludeYamlHeader] [-YamlHeaderInformationType <String[]>] [<CommonParameters>]
```
---
