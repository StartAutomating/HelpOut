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
* [Save-MAML](Save-MAML.md)

* [ConvertTo-MAML](ConvertTo-MAML.md)

---

### Examples
> EXAMPLE 1

```PowerShell
Install-MAML -Module HelpOut
```

---

### Parameters
#### **Module**
The name of one or more modules.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|true    |1       |true (ByPropertyName)|

#### **NoRefresh**
If set, will refresh the documentation for the module before generating the commands file.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Compact**
If set, will compact the generated MAML.  This will be ignored if -Refresh is not passed, since no new MAML will be generated.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **ScriptName**
The name of the combined script.  By default, allcommands.ps1.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **FunctionRoot**
The root directories containing functions.  If not provided, the function root will be the module root.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|

#### **NoRecurse**
If set, the function roots will not be recursively searched.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Encoding**
The encoding of the combined script.  By default, UTF8.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[Encoding]`|false   |3       |true (ByPropertyName)|

#### **Exclude**
A list of wildcards to exclude.  This list will always contain the ScriptName.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|

#### **NoVersion**
If set, the generated MAML will not contain a version number.  
This slightly reduces the size of the MAML file, and reduces the rate of changes in the MAML file.

|Type      |Required|Position|PipelineInput        |Aliases    |
|----------|--------|--------|---------------------|-----------|
|`[Switch]`|false   |named   |true (ByPropertyName)|Unversioned|

#### **Culture**
If provided, will save the MAML to a different directory than the current UI culture.

|Type           |Required|Position|PipelineInput        |
|---------------|--------|--------|---------------------|
|`[CultureInfo]`|false   |named   |true (ByPropertyName)|

#### **NoComment**
If set, will remove comments within functions when generating allcommands.ps1

|Type      |Required|Position|PipelineInput        |Aliases                                          |
|----------|--------|--------|---------------------|-------------------------------------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|NoBlockComments<br/>NoBlockComment<br/>NoComments|

#### **PassThru**
If set, will return the files that were generated.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Minify**
If set, will minify the code in allcommands.ps1.
By default, this will stream down the latest version of [PSMinifier](https://github.com/StartAutomating/PSMinifier).

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **MinifierSource**
If -MinifierSource is like `*Gallery*`, it will use the PowerShell Gallery to download.
If -MinifierSource is an alternate URL, it will download the contents of that URL (it must define a function named Compress-ScriptBlock).

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

---

### Outputs
* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)

* [IO.FileInfo](https://learn.microsoft.com/en-us/dotnet/api/System.IO.FileInfo)

---

### Syntax
```PowerShell
Install-MAML [-Module] <String[]> [-NoRefresh] [-Compact] [[-ScriptName] <String>] [-FunctionRoot <String[]>] [-NoRecurse] [[-Encoding] <Encoding>] [-Exclude <String[]>] [-NoVersion] [-Culture <CultureInfo>] [-NoComment] [-PassThru] [-Minify] [-MinifierSource <String>] [<CommonParameters>]
```
