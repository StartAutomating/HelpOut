
Save-MAML
---------
### Synopsis
Saves a Module's MAML

---
### Description

Generates a Module's MAML file, and then saves it to the appropriate location.

---
### Related Links
* [ConvertTo-MAML](docs/ConvertTo-MAML.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Save-Maml -Module HelpOut
```

#### EXAMPLE 2
```PowerShell
Save-Maml -Module HelpOut -WhatIf
```

#### EXAMPLE 3
```PowerShell
Save-Maml -Module HelpOut -PassThru
```

---
### Parameters
#### **Module**

The name of one or more modules.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **Compact**

If set, the generated MAML will be compact (no extra whitespace or indentation).  If not set, the MAML will be indented.



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
#### **NoVersion**

If set, the generate MAML will not contain a version number.  
This slightly reduces the size of the MAML file, and reduces the rate of changes in the MAML file.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **PassThru**

If set, will return the files that were generated.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.
    
If you pass ```-Confirm:$false``` you will not be prompted.
    
    
If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.

---
### Outputs
System.Nullable


---
### Syntax
```PowerShell
Save-MAML [-Compact] [-Culture <CultureInfo>] [-NoVersion] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Save-MAML [-Module <String[]>] [-Compact] [-Culture <CultureInfo>] [-NoVersion] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---

