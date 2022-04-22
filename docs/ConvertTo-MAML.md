
ConvertTo-MAML
--------------
### Synopsis
Converts command help to MAML

---
### Description

Converts command help to MAML (Microsoft Assistance Markup Language).

---
### Related Links
* [Get-Help](https://docs.microsoft.com/powershell/module/Microsoft.PowerShell.Core/Get-Help)
* [Save-MAML](docs/Save-MAML.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
ConvertTo-Maml -Name ConvertTo-Maml
```

#### EXAMPLE 2
```PowerShell
Get-Command ConvertTo-Maml | ConvertTo-Maml
```

#### EXAMPLE 3
```PowerShell
ConvertTo-Maml -Name ConvertTo-Maml -Compact
```

#### EXAMPLE 4
```PowerShell
ConvertTo-Maml -Name ConvertTo-Maml -XML
```

---
### Parameters
#### **Name**

The name of or more commands.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |1      |true (ByPropertyName)|
---
#### **Module**

The name of one or more modules.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **CommandInfo**

The CommandInfo object (returned from Get-Command).



|Type                 |Requried|Postion|PipelineInput |
|---------------------|--------|-------|--------------|
|```[CommandInfo[]]```|true    |named  |true (ByValue)|
---
#### **Compact**

If set, the generated MAML will be compact (no extra whitespace or indentation).  If not set, the MAML will be indented.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **XML**

If set, will return the MAML as an XmlDocument.  The default is to return the MAML as a string.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **NoVersion**

If set, the generate MAML will not contain a version number.  
This slightly reduces the size of the MAML file, and reduces the rate of changes in the MAML file.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
### Inputs
[Management.Automation.CommandInfo]
Accepts a command

---
### Outputs
[String]
The MAML, as a String.  This is the default.


[Xml]
The MAML, as an XmlDocument (when -XML is passed in)


---
### Syntax
```PowerShell
ConvertTo-MAML [-Compact] [-XML] [-NoVersion] [<CommonParameters>]
```
```PowerShell
ConvertTo-MAML [[-Name] <String[]>] [-Compact] [-XML] [-NoVersion] [<CommonParameters>]
```
```PowerShell
ConvertTo-MAML [-Module <String[]>] [-Compact] [-XML] [-NoVersion] [<CommonParameters>]
```
```PowerShell
ConvertTo-MAML -CommandInfo <CommandInfo[]> [-Compact] [-XML] [-NoVersion] [<CommonParameters>]
```
---


