
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



|Type               |Requried|Postion|PipelineInput |
|-------------------|--------|-------|--------------|
|```[ScriptBlock]```|true    |1      |true (ByValue)|
---
#### **Text**

A block of text



|Type          |Requried|Postion|PipelineInput                 |
|--------------|--------|-------|------------------------------|
|```[String]```|true    |1      |true (ByValue, ByPropertyName)|
---
#### **RegionName**

The friendly names of code regions or begin,process, or end blocks.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |named  |false        |
---
#### **HeadingSize**

|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Int32]```|false   |named  |false        |
---
### Syntax
```PowerShell
Get-ScriptStory [-ScriptBlock] <ScriptBlock> [-RegionName <IDictionary>] [-HeadingSize <Int32>] [<CommonParameters>]
```
```PowerShell
Get-ScriptStory [-Text] <String> [-RegionName <IDictionary>] [-HeadingSize <Int32>] [<CommonParameters>]
```
---


