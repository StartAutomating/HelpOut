
Measure-Help
------------
### Synopsis
Determines the percentage of documentation

---
### Description

Determines the percentage of documentation in a given script

---
### Related Links
* [Get-Help](https://docs.microsoft.com/powershell/module/Microsoft.PowerShell.Core/Get-Help)
---
### Examples
#### EXAMPLE 1
```PowerShell
dir -Filter *.ps1 | Measure-Help
```

#### EXAMPLE 2
```PowerShell
Get-Command -Module HelpOut | Measure-Help
```

#### EXAMPLE 3
```PowerShell
Measure-Help {
    # This script has some documentation, and then a bunch of code that literally does nothing
    $null = $null # The null equivilancy 
    $null * 500 # x times nothing is still nothing
    $null / 100 # Nothing out of 100             
} | Select-Object -ExpandProperty PercentageDocumented
```

---
### Parameters
#### **FilePath**

The path to the file



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|true    |1      |true (ByPropertyName)|
---
#### **ScriptBlock**

A PowerShell script block



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[ScriptBlock]```|true    |named  |true (ByPropertyName)|
---
#### **Name**

The name of the script being measured.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
### Syntax
```PowerShell
Measure-Help [-FilePath] <String> [<CommonParameters>]
```
```PowerShell
Measure-Help -ScriptBlock <ScriptBlock> [-Name <String>] [<CommonParameters>]
```
---


