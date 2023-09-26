### HelpOut 0.4.9:

* Supporting custom attribute formatting with -FormatAttribute (#147)
  * Markdown Formatter - Honoring .FormatAttribute (#148)
  * Get-MarkdownHelp -FormatAttribute (#149)
  * Save-MarkdownHelp -FormatAttribute (#150)
* Extended Type Formatting - Improving handling of empty directories (#146)
* Updating HelpOut PSA (#152)

---

### HelpOut 0.4.8:

* Markdown Help Improvements:
  * Fixing Long Examples (Fixes #141)
  * Allowing first comment lines in an example to be markdown (#143)
  * Also, switching numbered example headings to blockquotes
* Save-MarkdownHelp updates:
  * Fixing Piping Behavior (#140)
  * Not Saving to illegal windows paths (#132)
* Improving Extended Types Doc Generation
  * Now puts extended type documentation into subfolders (#135)
  * Also, generates a summary file for each type (#133)
* Updating links to Microsoft modules (#142)
* Integrating PSA into HelpOut (#144)

---

### HelpOut 0.4.7:

* Get-MarkdownHelp:  Automatically renaming help about aliases (Fixes #130)
* Save-MarkdownHelp:  Improving resiliency (avoiding null burps) (Fixes #128)

---

### HelpOut 0.4.6:

* Save-MarkdownHelp:  Improving resiliency (Fixes #128)

---

### HelpOut 0.4.5:

* You can now sponsor HelpOut (#126)
* Added ScriptMethods to PowerShell.Markdown.Help (#125)
* Now allowing Save-MarkDownHelp to be extended by any HelpOut.SaveMarkdownHelp file or function (#123)
* This is used in HelpOut.SaveMarkdownHelp.ExtendedTypes, which auto documents extended types (#101)

---

### HelpOut 0.4.4:

* Improved HelpOut action output (Fixes #121)
* HelpOut has a logo (Fixes #120)
* Save-MarkdownHelp now trims content (Fixes #119)

---

### HelpOut 0.4.3:

* Action Improvements:
  * Not obeying -InstallModule if a local module is found (Fixes #113)
  * Not adding files found outside of the workspace (Fixes #114)
  * Checking for detached branch before pulling (Fixes #103)

---

### HelpOut 0.4.2:

* Markdown Help Improvements:
  * Adding Aliases (Fixes #111)
  * Removing Horizontal Rule between parameters (Fixes #110)
  * Adding newline before and after each section
  * Supporting Script Stories (Fixes #104)
  * [Ordered] Synopsis and Description (Fixes #107)
  * Sorting front matter by Position (descending) and Name (Fixes #107)
  * Moving Syntax below Notes and Story (re #104)
* Get-ScriptStory:
  * Defaulting -HeadingSize to 3
* Action Improvements:
  * Better Terminal Output / Removing Output Variables (Fixes #109)
  * Improving branchless error behavior (Fixes #103)
  * Adding -InstallModule (Fixes #108)

---

### HelpOut 0.4.1:

* Parameter Properties are now rendered as a table (Fixes #98)
* Save-MarkdownHelp:  Adding -ExcludeFile (Fixes #97)

---

### HelpOut 0.4:

* Get/Save-MarkdownHelp:
  * Adding -YamlHeaderInformationType and including [Reflection.AssemblyMetaData] attributes (Fixes #93)
* Replacing anchor links with lowercase (Fixes #92)
* Returning unmodified files when no link is replaced (Fixes #91)

---

### HelpOut 0.3.9:

* No longer attempting to repair links if the file is not markdown (Fixes #88)

---

### HelpOut 0.3.8:

* YAML Header is now optional (with -IncludeYamlHeader) (Fixes #80)
* Save-MarkdownHelp trims content (Fixes #85)

---

### HelpOut 0.3.7:

All Markdown help now includes a YAML Header unless -NoYAMLHeader is passed (Fixes #80)

---

### HelpOut 0.3.6:
* Improvements to [OutputType] support (Fixes #78)
* GitHub Action No Longer Runs when not on a branch (Fixes #77)

---

### HelpOut 0.3.5:
* Markdown Help Improvements: Escaping Example Code (Fixes #75)

---

### HelpOut 0.3.4:
* Fixing accidental heading names in .Link and parameter properties (Fixes #73)

---

### HelpOut 0.3.3:
* Markdown Help now uses fewer tables (improves default GitHub Page rendering) (fixes #71)

---

### HelpOut 0.3.2:
* Save-MarkdownHelp Bugfix (Fixes #69)

---

### HelpOut 0.3.1:
* Save-MarkdownHelp:  
  * Can now -ReplaceLink (Fixes #66)
  * -ReplaceLink will always replace -OutputPath (Fixes #67)
  * Changing Aliases for -SkipCommandType (Fixes #65)

---


### HelpOut 0.3:
* Get-MarkdownHelp: Fixing Property Table rendering issues with ValidValues (#58)
* Workflow improvements:  Building formatting / types in CI/CD (#63)

---

### HelpOut 0.2.9:
* Get-MarkdownHelp: Fixing Property Table rendering issues with ValidValues (#58)
* Action improvements:
  * Pulling just before push (#59)
  * Improving username / email detection (#60)

---

### HelpOut 0.2.8:
* Save-MarkdownHelp:
  * Adding -ExcludeTopic (#55)
  * -IncludeTopic excludes deeply nested topics (#54)
  * -IncludeExtension default now includes .svg files (#53)

---

### HelpOut 0.2.7:
* Save-MarkdownHelp:
  * Adding -Command, -ReplaceCommandName, -ReplaceCommandNameWith (#45)
  * Fixing -ReplaceScriptName issue (#46)
* Save-MAML:
  * -PassThru now returns files, not file contents (#47)
* HelpOut.HelpOut.ps1 Added (Selfhosting Action (#48))

---

### HelpOut 0.2.6:
* Save-MarkdownHelp:
  * Improving Inline Documentation
  * Allowing -ScriptPath to be a Regex (#41)
  * Fixing Relative Paths with -IncludeExtension (#42)
  * Improving -IncludeTopic regex behavior (#43)

---

### HelpOut 0.2.5:
* Save-MarkdownHelp:
  * Adding -IncludeExtension (#35)
  * Applying -PassThru to -IncludeTopic (#34)
  * Allowing wildcards in -IncludeTopic (#33)
* Preliminary support for GitHub Pages Publishing (#32)

---

### HelpOut 0.2.4:
* Save-MarkdownHelp:
  * Adding -SkipCommandType (#29)
  * -ScriptPath now allows wildcards (#28)
* Formatting now Handles Arrays of Enums (#30)

---

### HelpOut 0.2.3:
* Get/Save-MarkdownHelp:  Support for -NoValidValueEnumeration (re #25)
* Save-MarkdownHelp:  Adding -IncludeTopic (Fixes #24, #26)
* Adding ValidateSet/Enum Formatting for Markdown Help (Fixing #25)


---

### HelpOut 0.2.2:
* Fixing issue generating docs (#22)
* HelpOut Action Fix (#20)

---

### HelpOut 0.2.1:
* Get/Save-MarkdownHelp:  Support for -SectionOrder (#19)
* Save-MarkdownHelp:  Adding -Passthru (#17).  Converting Markdown Help into a string (#18)
* Get-MarkdownHelp: Returning Object (#18)
* Fixing URL-only related links (#14)
* Adding Get-MarkdownHelp -Rename (#13)
* Retitling Script Files with relative path (#12)

---

### HelpOut 0.2:
* Adding Install-MAML (#1/ #7)
* Adding Get-MarkdownHelp (#4)
* Adding Save-MarkdownHelp (#10)
* Adding HelpOut Action (#5)
* Adding Measure-Help (#11)
* Adding Get-ScriptStory (#3)
* Adding Get-ScriptReference (#2)
* Renmaing ConvertTo-MAML->Get-MAML

---
