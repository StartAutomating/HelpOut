
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
#### **ScriptPath**

If provided, will generate documentation for any scripts found within these paths.
-ScriptPath can be either a file name or a full path.  
If an exact match is not found -ScriptPath will also check to see if there is a wildcard match.



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
#### **PassThru**

If set, will output changed or created files.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **SectionOrder**

The order of the sections.  If not provided, this will be the order they are defined in the formatter.



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **IncludeTopic**

One or more topic files to include.
Topic files will be treated as markdown and directly copied inline.
By default ```\.help\.txt$``` and ```\.md$```



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **IncludeExtension**

One or more extensions to include.
By default, .css, .gif, .htm, .html, .js, .jpg, .jpeg, .mp4, .png



|Type            |Requried|Postion|PipelineInput        |
|----------------|--------|-------|---------------------|
|```[String[]]```|false   |named  |true (ByPropertyName)|
---
#### **NoValidValueEnumeration**

If set, will not enumerate valid values and enums of parameters.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Switch]```|false   |named  |true (ByPropertyName)|
---
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
|Type                  |Requried|Postion|PipelineInput        |
|----------------------|--------|-------|---------------------|
|```[CommandTypes[]]```|false   |named  |true (ByPropertyName)|
---
### Syntax
```PowerShell
Save-MarkdownHelp [-Module <String[]>] [-OutputPath <String>] [-Wiki] [-ScriptPath <String[]>] [-ReplaceScriptName <String[]>] [-ReplaceScriptNameWith <String[]>] [-PassThru] [-SectionOrder <String[]>] [-IncludeTopic <String[]>] [-IncludeExtension <String[]>] [-NoValidValueEnumeration] [-SkipCommandType {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] [<CommonParameters>]
```
---


