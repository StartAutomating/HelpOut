---
CommandName: Save-MarkdownHelp
Parameters: 
  - Name: Command
    Type: System.Management.Automation.CommandInfo[]
    Aliases: 
    
  - Name: ExcludeFile
    Type: System.String[]
    Aliases: 
    
  - Name: ExcludeTopic
    Type: System.String[]
    Aliases: 
    
  - Name: IncludeExtension
    Type: System.String[]
    Aliases: 
    
  - Name: IncludeTopic
    Type: System.String[]
    Aliases: 
    
  - Name: IncludeYamlHeader
    Type: System.Management.Automation.SwitchParameter
    Aliases: 
    - IncludeFrontMatter
    - IncludeHeader
  - Name: Module
    Type: System.String[]
    Aliases: 
    
  - Name: NoValidValueEnumeration
    Type: System.Management.Automation.SwitchParameter
    Aliases: 
    
  - Name: OutputPath
    Type: System.String
    Aliases: 
    
  - Name: PassThru
    Type: System.Management.Automation.SwitchParameter
    Aliases: 
    
  - Name: ReplaceCommandName
    Type: System.String[]
    Aliases: 
    
  - Name: ReplaceCommandNameWith
    Type: System.String[]
    Aliases: 
    
  - Name: ReplaceLink
    Type: System.String[]
    Aliases: 
    
  - Name: ReplaceLinkWith
    Type: System.String[]
    Aliases: 
    
  - Name: ReplaceScriptName
    Type: System.String[]
    Aliases: 
    
  - Name: ReplaceScriptNameWith
    Type: System.String[]
    Aliases: 
    
  - Name: ScriptPath
    Type: System.String[]
    Aliases: 
    
  - Name: SectionOrder
    Type: System.String[]
    Aliases: 
    
  - Name: SkipCommandType
    Type: System.Management.Automation.CommandTypes[]
    Aliases: 
    - SkipCommandTypes
    - ExcludeCommandType
    - ExcludeCommandTypes
  - Name: Wiki
    Type: System.Management.Automation.SwitchParameter
    Aliases: 
    
  - Name: YamlHeaderInformationType
    Type: System.String[]
    Aliases: 
    - YamlHeaderInfoType

Synopsis: Saves a Module's Markdown Help
Description: |
  
  Get markdown help for each command in a module and saves it to the appropriate location.
---


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






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **OutputPath**

The output path.
If not provided, will be assumed to be the "docs" folder of a given module (unless -Wiki is specified)






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|



#### **Wiki**

If set, will interlink documentation as if it were a wiki.  Implied when -OutputPath contains 'wiki'.
If provided without -OutputPath, will assume that a wiki resides in a sibling directory of the module.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|



#### **Command**

If provided, will generate documentation for additional commands.






|Type             |Required|Position|PipelineInput        |
|-----------------|--------|--------|---------------------|
|`[CommandInfo[]]`|false   |named   |true (ByPropertyName)|



#### **ReplaceCommandName**

Replaces parts of the names of the commands provided in the -Command parameter.
-ReplaceScriptName is treated as a regular expression.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **ReplaceCommandNameWith**

If provided, will replace parts of the names of the scripts discovered in a -Command parameter with a given Regex replacement.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **ScriptPath**

If provided, will generate documentation for any scripts found within these paths.
-ScriptPath can be either a file name or a full path.
If an exact match is not found -ScriptPath will also check to see if there is a wildcard match.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **ReplaceScriptName**

If provided, will replace parts of the names of the scripts discovered in a -ScriptDirectory beneath a module.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **ReplaceScriptNameWith**

If provided, will replace parts of the names of the scripts discovered in a -ScriptDirectory beneath a module with a given Regex replacement.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **ReplaceLink**

If provided, will replace links discovered in markdown content.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **ReplaceLinkWith**

If provided, will replace links discovered in markdown content with a given Regex replacement.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **PassThru**

If set, will output changed or created files.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **SectionOrder**

The order of the sections.  If not provided, this will be the order they are defined in the formatter.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **IncludeTopic**

One or more topic files to include.
Topic files will be treated as markdown and directly copied inline.
By default ```\.help\.txt$``` and ```\.md$```






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **ExcludeTopic**

One or more topic file patterns to exclude.
Topic files that match this pattern will not be included.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **ExcludeFile**

One or more files to exclude.
By default, this is treated as a wildcard.
If the file name starts and ends with slashes, it will be treated as a Regular Expression.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **IncludeExtension**

One or more extensions to include.
By default, .css, .gif, .htm, .html, .js, .jpg, .jpeg, .mp4, .png, .svg






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **NoValidValueEnumeration**

If set, will not enumerate valid values and enums of parameters.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|



#### **IncludeYamlHeader**

If set, will not attach a YAML header to the generated help.






|Type      |Required|Position|PipelineInput        |Aliases                             |
|----------|--------|--------|---------------------|------------------------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|IncludeFrontMatter<br/>IncludeHeader|



#### **YamlHeaderInformationType**

The type of information to include in the YAML Header



Valid Values:

* Command
* Help
* Metadata






|Type        |Required|Position|PipelineInput|Aliases           |
|------------|--------|--------|-------------|------------------|
|`[String[]]`|false   |named   |false        |YamlHeaderInfoType|



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





---


### Syntax
```PowerShell
Save-MarkdownHelp [-Module <String[]>] [-OutputPath <String>] [-Wiki] [-Command <CommandInfo[]>] [-ReplaceCommandName <String[]>] [-ReplaceCommandNameWith <String[]>] [-ScriptPath <String[]>] [-ReplaceScriptName <String[]>] [-ReplaceScriptNameWith <String[]>] [-ReplaceLink <String[]>] [-ReplaceLinkWith <String[]>] [-PassThru] [-SectionOrder <String[]>] [-IncludeTopic <String[]>] [-ExcludeTopic <String[]>] [-ExcludeFile <String[]>] [-IncludeExtension <String[]>] [-NoValidValueEnumeration] [-IncludeYamlHeader] [-YamlHeaderInformationType <String[]>] [-SkipCommandType {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] [<CommonParameters>]
```
