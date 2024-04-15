Get-MAML
--------

### Synopsis
Gets MAML help

---

### Description

Gets help for a given command, as MAML (Microsoft Assistance Markup Language) xml.

---

### Related Links
* [Get-Help](https://learn.microsoft.com/powershell/module/Microsoft.PowerShell.Core/Get-Help)

* [Save-MAML](Save-MAML.md)

---

### Examples
> EXAMPLE 1

```PowerShell
Get-MAML -Name Get-MAML
```
> EXAMPLE 2

```PowerShell
Get-Command Get-MAML | Get-MAML
```
> EXAMPLE 3

```PowerShell
Get-MAML -Name Get-MAML -Compact
```
> EXAMPLE 4

```PowerShell
Get-MAML -Name Get-MAML -XML
```

---

### Parameters
#### **Name**
The name of or more commands.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |1       |true (ByPropertyName)|

#### **Module**
The name of one or more modules.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|

#### **CommandInfo**
The CommandInfo object (returned from Get-Command).

|Type             |Required|Position|PipelineInput |
|-----------------|--------|--------|--------------|
|`[CommandInfo[]]`|true    |named   |true (ByValue)|

#### **Compact**
If set, the generated MAML will be compact (no extra whitespace or indentation).  If not set, the MAML will be indented.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **XML**
If set, will return the MAML as an XmlDocument.  The default is to return the MAML as a string.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **NoVersion**
If set, the generate MAML will not contain a version number.  
This slightly reduces the size of the MAML file, and reduces the rate of changes in the MAML file.

|Type      |Required|Position|PipelineInput        |Aliases    |
|----------|--------|--------|---------------------|-----------|
|`[Switch]`|false   |named   |true (ByPropertyName)|Unversioned|

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

---

### Inputs
[Management.Automation.CommandInfo]
Accepts a command

---

### Outputs
* [String]
The MAML, as a String.  This is the default.

* [Xml]
The MAML, as an XmlDocument (when -XML is passed in)

---

### Syntax
```PowerShell
Get-MAML [-Compact] [-XML] [-NoVersion] [-SkipCommandType {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] [-IncludeAlias] [<CommonParameters>]
```
```PowerShell
Get-MAML [[-Name] <String[]>] [-Compact] [-XML] [-NoVersion] [-SkipCommandType {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] [-IncludeAlias] [<CommonParameters>]
```
```PowerShell
Get-MAML [-Module <String[]>] [-Compact] [-XML] [-NoVersion] [-SkipCommandType {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] [-IncludeAlias] [<CommonParameters>]
```
```PowerShell
Get-MAML -CommandInfo <CommandInfo[]> [-Compact] [-XML] [-NoVersion] [-SkipCommandType {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] [-IncludeAlias] [<CommonParameters>]
```
