
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



> **Type**: ```[String[]]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **ScriptBlock**

One or more PowerShell ScriptBlocks



> **Type**: ```[ScriptBlock[]]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue, ByPropertyName)



---
#### **Recurse**

If set, will recursively find references.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Get-ScriptReference [-FilePath] <String[]> [-Recurse] [<CommonParameters>]
```
```PowerShell
Get-ScriptReference [-ScriptBlock] <ScriptBlock[]> [-Recurse] [<CommonParameters>]
```
---


