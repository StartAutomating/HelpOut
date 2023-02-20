---
CommandName: Measure-Help
Parameters: 
  - Name: FilePath
    Type: System.String
    Aliases: 
    - Fullname
  - Name: Name
    Type: System.String
    Aliases: 
    
  - Name: ScriptBlock
    Type: System.Management.Automation.ScriptBlock
    Aliases: 
    
Synopsis: Determines the percentage of documentation
Description: |
  
  Determines the percentage of documentation in a given script
---


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






|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[String]`|true    |1       |true (ByPropertyName)|Fullname|



#### **ScriptBlock**

A PowerShell script block






|Type           |Required|Position|PipelineInput        |
|---------------|--------|--------|---------------------|
|`[ScriptBlock]`|true    |named   |true (ByPropertyName)|



#### **Name**

The name of the script being measured.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|





---


### Syntax
```PowerShell
Measure-Help [-FilePath] <String> [<CommonParameters>]
```
```PowerShell
Measure-Help -ScriptBlock <ScriptBlock> [-Name <String>] [<CommonParameters>]
```
