---
CommandName: PowerShell.Markdown.Help.ShowSection
Parameters: 
  - Name: SectionNames
    Type: System.String[]
    Aliases: 
    - SectionName

Synopsis: Shows sections of markdown help
Description: |
  
  Shows sections of a command's markdown help.
---


PowerShell.Markdown.Help.ShowSection
------------------------------------




### Synopsis
Shows sections of markdown help



---


### Description

Shows sections of a command's markdown help.



---


### Parameters
#### **SectionNames**

One or more section names



Valid Values:

* Name
* Synopsis
* Description
* RelatedLinks
* Examples
* Parameters
* Inputs
* Outputs
* Notes
* Story
* Syntax






|Type        |Required|Position|PipelineInput|Aliases    |
|------------|--------|--------|-------------|-----------|
|`[String[]]`|false   |1       |false        |SectionName|





---


### Syntax
```PowerShell
PowerShell.Markdown.Help.ShowSection [[-SectionNames] <String[]>] [<CommonParameters>]
```
