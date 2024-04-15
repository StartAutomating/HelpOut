Save-MAML
---------

### Synopsis
Saves a Module's MAML

---

### Description

Generates a Module's MAML file, and then saves it to the appropriate location.

---

### Related Links
* [Get-MAML](Get-MAML.md)

---

### Examples
> EXAMPLE 1

```PowerShell
Save-Maml -Module HelpOut
```
> EXAMPLE 2

```PowerShell
Save-Maml -Module HelpOut -WhatIf
```
> EXAMPLE 3

```PowerShell
Save-Maml -Module HelpOut -PassThru
```

---

### Parameters
#### **Module**
The name of one or more modules.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|

#### **Compact**
If set, the generated MAML will be compact (no extra whitespace or indentation).  If not set, the MAML will be indented.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Culture**
If provided, will save the MAML to a different directory than the current UI culture.

|Type           |Required|Position|PipelineInput        |
|---------------|--------|--------|---------------------|
|`[CultureInfo]`|false   |named   |true (ByPropertyName)|

#### **NoVersion**
If set, the generated MAML will not contain a version number.  
This slightly reduces the size of the MAML file, and reduces the rate of changes in the MAML file.

|Type      |Required|Position|PipelineInput|Aliases    |
|----------|--------|--------|-------------|-----------|
|`[Switch]`|false   |named   |false        |Unversioned|

#### **SkipCommandType**
A list of command types to skip.
If not provided, all types of commands from the module will be saved as a markdown document.
Valid Values:

* Alias
* Function
* Filter
* Cmdlet
* ExternalScript
* Application
* Script
* Configuration
* All

|Type              |Required|Position|PipelineInput        |Aliases                                                        |
|------------------|--------|--------|---------------------|---------------------------------------------------------------|
|`[CommandTypes[]]`|false   |named   |true (ByPropertyName)|SkipCommandTypes<br/>ExcludeCommandType<br/>ExcludeCommandTypes|

#### **IncludeAlias**
If set, will include aliases in the MAML output.

|Type      |Required|Position|PipelineInput        |Aliases       |
|----------|--------|--------|---------------------|--------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|IncludeAliases|

#### **PassThru**
If set, will return the files that were generated.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

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
* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)

* [IO.FileInfo](https://learn.microsoft.com/en-us/dotnet/api/System.IO.FileInfo)

---

### Syntax
```PowerShell
Save-MAML [-Compact] [-Culture <CultureInfo>] [-NoVersion] [-SkipCommandType {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] [-IncludeAlias] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Save-MAML [-Module <String[]>] [-Compact] [-Culture <CultureInfo>] [-NoVersion] [-SkipCommandType {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] [-IncludeAlias] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```
