---
CommandName: Get-ScriptStory
Parameters: 
  - Name: ScriptBlock
    Type: System.Management.Automation.ScriptBlock
    Aliases: 
    
  - Name: Text
    Type: System.String
    Aliases: 
    - ScriptContents
    - Definition
  - Name: RegionName
    Type: System.Collections.IDictionary
    Aliases: 
    
  - Name: HeadingSize
    Type: System.Int32
    Aliases: 
    
Synopsis: Gets a Script's story
Description: |
  
  Gets the Script's "Story"
  
  Script Stories are a simple markdown summary of all single-line comments within a script (aside from those in the param block).
---
Get-ScriptStory
---------------
### Synopsis
Gets a Script's story

---
### Description

Gets the Script's "Story"

Script Stories are a simple markdown summary of all single-line comments within a script (aside from those in the param block).

---
### Examples
#### EXAMPLE 1
```PowerShell
Get-Command Get-ScriptStory | Get-ScriptStory
```

---
### Parameters
#### **ScriptBlock**

A script block



> **Type**: ```[ScriptBlock]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
#### **Text**

A block of text



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue, ByPropertyName)



---
#### **RegionName**

The friendly names of code regions or begin,process, or end blocks.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **HeadingSize**

> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Get-ScriptStory [-ScriptBlock] <ScriptBlock> [-RegionName <IDictionary>] [-HeadingSize <Int32>] [<CommonParameters>]
```
```PowerShell
Get-ScriptStory [-Text] <String> [-RegionName <IDictionary>] [-HeadingSize <Int32>] [<CommonParameters>]
```
---
