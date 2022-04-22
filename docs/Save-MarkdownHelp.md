
Save-MarkdownHelp
-----------------
### Synopsis
Saves a Module's Markdown Help

---
### Description

Get markdown help for each command in a module and saves it to the appropriate location.

---
### Related Links
* [Get-MarkdownHelp](Get-MarkdownHelp.md)
---
### Examples
#### EXAMPLE 1
```PowerShell
Save-MarkdownHelp -Module HelpOut  # Save Markdown to HelpOut/docs
```

#### EXAMPLE 2
```PowerShell
Save-MarkdownHelp -Module HelpOut -Wiki # Save Markdown to ../HelpOut.wiki
```

---
### Parameters
#### **Module**

The name of one or more modules.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **OutputPath**

The output path.  
If not provided, will be assumed to be the "docs" folder of a given module (unless -Wiki is specified)



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |named  |true (ByPropertyName)|
---
#### **Wiki**

If set, will interlink documentation as if it were a wiki.  Implied when -OutputPath contains 'wiki'.
If provided without -OutputPath, will assume that a wiki resides in a sibling directory of the module.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
#### **ScriptDirectory**

If provided, will generate documentation for any scripts found within these sub directories.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **ReplaceScriptName**

If provided, will replace parts of the names of the scripts discovered in a -ScriptDirectory beneath a module.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **ReplaceScriptNameWith**

If provided, will replace parts of the names of the scripts discovered in a -ScriptDirectory beneath a module with a given Regex replacement.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
### Syntax
```PowerShell
Save-MarkdownHelp [-Module <String[]>] [-OutputPath <String>] [-Wiki] [-ScriptDirectory <String[]>] [-ReplaceScriptName <String[]>] [-ReplaceScriptNameWith <String[]>] [<CommonParameters>]
```
---


