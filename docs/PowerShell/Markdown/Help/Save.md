PowerShell.Markdown.Help.Save()
-------------------------------

### Synopsis
Saves a Markdown Help Topic

---

### Description

Saves a Markdown Help Topic to a file.

---

### Related Links
* PowerShell.Markdown.Help.ToMarkdown

---

### Examples
> EXAMPLE 1

```PowerShell
(Get-MarkdownHelp Get-MarkdownHelp).Save(".\test.md")
```

---

### Parameters
#### **FilePath**
The path to the file.
If this does not exist it will be created.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |1       |false        |

#### **View**
An optional view.
This would need to be declared in a .format.ps1xml file by another loaded module.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |

---

### Notes
This will not save to files that have illegal names on Windows.

---
