---
CommandName: Get-ScriptReference
Parameters: 
  - Name: Recurse
    Type: System.Management.Automation.SwitchParameter
    Aliases: 
    
  - Name: FilePath
    Type: System.String[]
    Aliases: 
    - Fullname
  - Name: ScriptBlock
    Type: System.Management.Automation.ScriptBlock[]
    Aliases: 
    - Definition

Synopsis: Gets a script's references
Description: |
  
  Gets the external references of a given PowerShell command.  These are the commands the script calls, and the types the script uses.
---


Get-ScriptReference
-------------------


### Synopsis
Gets a script's references

---


### Description

Gets the external references of a given PowerShell command.  These are the commands the script calls, and the types the script uses.

---


### Examples
#### EXAMPLE 1
```PowerShell
Get-Command Get-ScriptReference | Get-ScriptReference
```

---


### Parameters
#### **FilePath**

The path to a file






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|true    |1       |true (ByPropertyName)|



---
#### **ScriptBlock**

One or more PowerShell ScriptBlocks






|Type             |Required|Position|PipelineInput                 |
|-----------------|--------|--------|------------------------------|
|`[ScriptBlock[]]`|true    |1       |true (ByValue, ByPropertyName)|



---
#### **Recurse**

If set, will recursively find references.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---


### Syntax
```PowerShell
Get-ScriptReference [-FilePath] <String[]> [-Recurse] [<CommonParameters>]
```
```PowerShell
Get-ScriptReference [-ScriptBlock] <ScriptBlock[]> [-Recurse] [<CommonParameters>]
```
