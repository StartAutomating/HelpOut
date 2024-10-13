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
    
    # We will want to keep track of methods and properties in order, 
    # so we don't have to sort or resolve them later.
    $methodsByName = [Ordered]@{}
    $propertiesByName = [Ordered]@{}

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
            
            $markdownSplat.Rename = 
                if ($getSetNothing) {
                    "$getSetNothing$($member.Name)"
                } else {
                    "$temporaryFunctionName()"
                }
            $ExecutionContext.SessionState.PSVariable.Set("function:$($temporaryFunctionName)", $member.$PotentialProperty)
            # Then Get-MarkdownHelp,
            $markdownHelp = Get-MarkdownHelp -Name $temporaryFunctionName @getMarkdownHelpSplatBase @markdownSplat
            if ($markdownHelp -is [string]) {
                $ExecutionContext.SessionState.PSVariable.Remove("function:$($temporaryFunctionName)")
                continue    
            }
            $markdownHelp.HideSection("Syntax")

            $TopicPathSegments = @(
                $extendedType -split $punctuationNotDashOrUnderscore
                $member.Name -replace $replaceMostPunctuation
            )
            $etsDocPath = Join-Path $outputPath "$(
                $TopicPathSegments -join [IO.Path]::DirectorySeparatorChar
            ).md"
            
            # .Save it,
            $memberFile = $markdownHelp.Save($etsDocPath)
            # and remove the temporary function (it would have gone out of scope anyways).
            $ExecutionContext.SessionState.PSVariable.Remove("function:$($temporaryFunctionName)")

            # Emit the member file
            $memberFile

            if ($getSetNothing) {
                if (-not $propertiesByName[$member.Name]) {
                    $propertiesByName[$member.Name] = $memberFile
                } else {
                    $propertiesByName[$member.Name] = @($propertiesByName[$member.Name]) + $memberFile
                }                
            } else {
                $methodsByName[$member.Name] = $memberFile
            }
        }

        
    })

    # If there were no member files, there's no point in generating a summary.
    if (-not $memberFiles) { continue }

    # Determine the path to the README.md file
    $ExtendedTypeDocFile = Join-Path $outputPath "$(
        ($extendedType -split $punctuationNotDashOrUnderscore) -join [IO.Path]::DirectorySeparatorChar
    )$([IO.Path]::DirectorySeparatorChar)README.md"

    # Make a pattern to match get_ and set_ files (including hidden properties)
    $getSetFile = '\.?(?>get|set)_'
    $ExtendedTypeDocContent = @(
        "## $extendedType"
        [Environment]::NewLine

        # If the type had a .README member, include it inline
        if ($actualTypeData.Members -and $actualTypeData.Members["README"].Value) {
            $actualTypeData.Members["README"].Value
        }
         
        # Sort the member files into properties and methods
        $methodMemberFiles = $memberFiles | Where-Object Name -NotMatch $getSetFile
        $propertyMemberFiles = $memberFiles | Where-Object Name -Match $getSetFile

        # If any member files were found, list them.
        if ($memberFiles) {
            # Properties should come before methods
            if ($propertyMemberFiles) {
                "### Script Properties"
                [Environment]::NewLine
                # and be sorted by property name.
                foreach ($memberKeyValue in $propertiesByName.GetEnumerator()) {
                    # If there are multiple files for a property, it's got a get and a set.
                    if ($memberKeyValue.Value -is [array]) {
                        "* [get_$($memberKeyValue.Key)]($($memberKeyValue.Value[0].Name))"
                        "* [set_$($memberKeyValue.Key)]($($memberKeyValue.Value[1].Name))"
                    } else {
                        "* [get_$($memberKeyValue.Key)]($($memberKeyValue.Value.Name))"
                    }
                }
                [Environment]::NewLine
            }
            # Methods should come after properties.
            if ($methodMemberFiles) {
                "### Script Methods"
                [Environment]::NewLine
                # and will be sorted alphabetically.
                foreach ($memberKeyValue in $methodsByName.GetEnumerator()) {
                    "* [$($memberKeyValue.Key)()]($($memberKeyValue.Value.Name))"
                }
            }
        }
    )  -join ([Environment]::NewLine)
    
    $ExtendedTypeDocContent | Set-Content -Path $ExtendedTypeDocFile
    if ($?) {
        Get-Item -Path $ExtendedTypeDocFile
    }
    
    $memberFiles
}
