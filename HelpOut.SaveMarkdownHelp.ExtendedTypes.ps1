<#
.SYNOPSIS
    Saves Markdown Help for Extended Types
.DESCRIPTION
    This saves Markdown Help from Extended Types (types.ps1xml) files.
#>
param(
# The module that contains extended types
$Module
)

# If there is no module, return
if (-not $module) { return }

# If the module is a string, get the actual module
if ($module -is [string]) {
    $module = Get-Module -Name $module
}

# If there were not exported type files, return
if (-not $module.ExportedTypeFiles) {
    return
}

# Get each extended type name
$extendedTypeNames = 
    @($module.ExportedTypeFiles) |
    Select-Xml //Type -Path { $_ } |
    Select-Object -ExpandProperty Node |
    Select-Object -ExpandProperty Name

# and be ready to replace most punctuation
$replaceMostPunctuation = '[\p{P}-[\-\._]]'
# go over each extended type
foreach ($extendedType in $extendedTypeNames) {
    # and get the actual type data
    $actualTypeData = Get-TypeData -TypeName $extendedType
    foreach ($member in $actualTypeData.Members.Values) {
        # If the script looks like it does not have inline help, continue
        

        foreach ($potentialProperty in 'Script','GetScriptBlock','SetScriptBlock') {
            if ($member.$PotentialProperty -notlike '*<#*.synopsis*#>*') { continue }
            $markdownSplat = @{}
            # Create a temporary function to hold the help.
            $getSetNothing = 
                if ($potentialProperty -eq 'GetScriptBlock') {
                    "get_"
                }
                elseif ($potentialProperty -eq 'SetScriptBlock') {
                    "set_"
                }
                elseif ($potentialProperty -eq 'Script') {
                    ''                    
                }
            $temporaryFunctionName = "$($extendedType).$GetSetNothing$($member.Name)" -replace $replaceMostPunctuation
            $markdownSplat.Rename = "$temporaryFunctionName()"        
            $ExecutionContext.SessionState.PSVariable.Set("function:$($temporaryFunctionName)", $member.$PotentialProperty)
            # Then Get-MarkdownHelp,
            $markdownHelp = Get-MarkdownHelp -Name $temporaryFunctionName @getMarkdownHelpSplatBase @markdownSplat
            $markdownHelp.HideSection("Syntax")
            # .Save it,
            $markdownHelp.Save((Join-Path $outputPath "$($temporaryFunctionName).md"))            
            # and remove the temporary function (it would have gone out of scope anyways)
            $ExecutionContext.SessionState.PSVariable.Remove("function:$($temporaryFunctionName)")
        }

        
    }
}
