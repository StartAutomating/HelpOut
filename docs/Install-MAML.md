
Install-MAML
------------
### Synopsis
Installs MAML into a module

---
### Description

Installs MAML into a module.  

This generates a single script that: 
* Includes all commands
* Removes their multiline comments
* Directs the commands to use external help

You should then include this script in your module import.

Ideally, you should use the allcommands script

---
### Related Links
* [Save-MAML](docs/Save-MAML.md)
* [ConvertTo-MAML](docs/ConvertTo-MAML.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Install-MAML -Module HelpOut
```

---
### Parameters
#### **Module**

The name of one or more modules.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|true    |1      |true (ByPropertyName)|
---
#### **NoRefresh**

If set, will refresh the documentation for the module before generating the commands file.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **Compact**

If set, will compact the generated MAML.  This will be ignored if -Refresh is not passed, since no new MAML will be generated.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **ScriptName**

The name of the combined script.  By default, allcommands.ps1.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |2      |true (ByPropertyName)|
---
#### **FunctionRoot**

The root directories containing functions.  If not provided, the function root will be the module root.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **NoRecurse**

If set, the function roots will not be recursively searched.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **Encoding**

The encoding of the combined script.  By default, UTF8.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[Encoding]```|false   |3      |true (ByPropertyName)|
---
#### **Exclude**

A list of wildcards to exclude.  This list will always contain the ScriptName.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **NoVersion**

If set, the generate MAML will not contain a version number.  
This slightly reduces the size of the MAML file, and reduces the rate of changes in the MAML file.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **Culture**

If provided, will save the MAML to a different directory than the current UI culture.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[CultureInfo]```|false   |named  |true (ByPropertyName)|
---
#### **PassThru**

If set, will return the files that were generated.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
### Outputs
System.Nullable


System.IO.FileInfo


---
### Syntax
```PowerShell
Install-MAML [-Module] <String[]> [-NoRefresh] [-Compact] [[-ScriptName] <String>] [-FunctionRoot <String[]>] [-NoRecurse] [[-Encoding] <Encoding>] [-Exclude <String[]>] [-NoVersion] [-Culture <CultureInfo>] [-PassThru] [<CommonParameters>]
```
---


