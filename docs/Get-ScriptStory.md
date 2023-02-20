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
  - Name: HeadingSize
    Type: System.Int32
    Aliases: 
    
  - Name: RegionName
    Type: System.Collections.IDictionary
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






|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |1       |true (ByValue)|



#### **Text**

A block of text






|Type      |Required|Position|PipelineInput                 |Aliases                      |
|----------|--------|--------|------------------------------|-----------------------------|
|`[String]`|true    |1       |true (ByValue, ByPropertyName)|ScriptContents<br/>Definition|



#### **RegionName**

The friendly names of code regions or begin,process, or end blocks.






|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |named   |false        |



#### **HeadingSize**




|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |named   |false        |





---


### Syntax
```PowerShell
Get-ScriptStory [-ScriptBlock] <ScriptBlock> [-RegionName <IDictionary>] [-HeadingSize <Int32>] [<CommonParameters>]
```
```PowerShell
Get-ScriptStory [-Text] <String> [-RegionName <IDictionary>] [-HeadingSize <Int32>] [<CommonParameters>]
```
