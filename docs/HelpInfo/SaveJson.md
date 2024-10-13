HelpInfo.SaveJson()
-------------------

### Synopsis
Saves a Help Topic as json

---

### Description

Saves a Help Topic to a json file.

---

### Related Links
* HelpInfo.ToJson

---

### Examples
> EXAMPLE 1

```PowerShell
(Get-MarkdownHelp Get-MarkdownHelp).SaveJson(".\test.json")
```

---

### Parameters
#### **FilePath**
The path to the file.
If this does not exist it will be created.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |1       |false        |

---

### Notes
This will not save to files that have illegal names on Windows.

---
