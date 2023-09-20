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
$punctuationNotDashOrUnderscore = '[\p{P}-[\-_]]'
# go over each extended type
foreach ($extendedType in $extendedTypeNames) {
    # and get the actual type data
    $actualTypeData = Get-TypeData -TypeName $extendedType    

    $memberFiles = 
    @(foreach ($member in $actualTypeData.Members.Values) {
        foreach ($potentialProperty in 'Script','GetScriptBlock','SetScriptBlock') {
            # If the script looks like it does not have inline help, continue        
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
            $fullExtendedTypeInfo = "$($extendedType).$GetSetNothing$($member.Name)"
            $temporaryFunctionName = "$($extendedType).$GetSetNothing$($member.Name)" -replace $replaceMostPunctuation
            $markdownSplat.Rename = "$temporaryFunctionName()"        
            $ExecutionContext.SessionState.PSVariable.Set("function:$($temporaryFunctionName)", $member.$PotentialProperty)
            # Then Get-MarkdownHelp,
            $markdownHelp = Get-MarkdownHelp -Name $temporaryFunctionName @getMarkdownHelpSplatBase @markdownSplat
            if ($markdownHelp -is [string]) {
                $ExecutionContext.SessionState.PSVariable.Remove("function:$($temporaryFunctionName)")
                continue    
            }
            $markdownHelp.HideSection("Syntax")

            $etsDocPath = Join-Path $outputPath "$(
                @($fullExtendedTypeInfo -split $punctuationNotDashOrUnderscore) -join [IO.Path]::DirectorySeparatorChar
            ).md"
            
            # .Save it,
            $markdownHelp.Save($etsDocPath)            
            # and remove the temporary function (it would have gone out of scope anyways)
            $ExecutionContext.SessionState.PSVariable.Remove("function:$($temporaryFunctionName)")
        }

        
    })

    $ExtendedTypeDocFile = Join-Path $outputPath "$(
        ($extendedType -split $punctuationNotDashOrUnderscore) -join [IO.Path]::DirectorySeparatorChar
    )$([IO.Path]::DirectorySeparatorChar)README.md"

    $getSetFile = '\.(?>get|set)_'
    $ExtendedTypeDocContent = @(
        "## $extendedType"
        [Environment]::NewLine

        if ($actualTypeData.Members -and $actualTypeData.Members["README"].Value) {
            $actualTypeData.Members["README"].Value
        }
        
        
        $propertyMemberFiles = $memberFiles | Where-Object Name -Match $getSetFile
        if ($propertyMemberFiles) {
            "### Script Properties"
            [Environment]::NewLine
            foreach ($memberFile in $propertyMemberFiles | Sort-Object { $_.Name -replace $getSetFile}) {                
                "* [$(@($memberFile.Name -split '[\p{P}-[_]]')[-2])]($($memberFile.Name))"
            }
        }
        $methodMemberFiles = $memberFiles | Where-Object Name -NotMatch $getSetFile
        if ($methodMemberFiles) {
            "### Script Methods"
            [Environment]::NewLine
            foreach ($memberFile in $methodMemberFiles) {
                "* [$(@($memberFile.Name -split '[\p{P}-[_]]')[-2])]($($memberFile.Name))"
            }
        }
    
    )  -join ([Environment]::NewLine)
    
    $ExtendedTypeDocContent | Set-Content -Path $ExtendedTypeDocFile
    if ($?) {
        Get-Item -Path $ExtendedTypeDocFile
    }
    
    $memberFiles
}
