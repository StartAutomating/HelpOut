---
CommandName: PowerShell.Markdown.Help.ToMarkdown
Parameters: 
  - Name: View
    Type: System.String
    Aliases: 
    
Synopsis: Returns this topic as a markdown string
Description: |
  
  Returns the content of this help topic as a markdown string.
---


PowerShell.Markdown.Help.ToMarkdown()
-------------------------------------




### Synopsis
Returns this topic as a markdown string



---


### Description

Returns the content of this help topic as a markdown string.



---


### Examples
#### EXAMPLE 1
```PowerShell
(Get-MarkDownHelp Get-MarkDownHelp).ToMarkdown()
```


---


### Parameters
#### **View**

An optional view.
This would need to be declared in a .format.ps1xml file by another loaded module.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |1       |false        |





---
