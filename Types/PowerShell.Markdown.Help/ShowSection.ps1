<#
.SYNOPSIS
    Shows sections of markdown help
.DESCRIPTION
    Shows sections of a command's markdown help.
#>
param(
# One or more section names
[ValidateSet('Name','Synopsis','Description','RelatedLinks','Examples','Parameters','Inputs','Outputs','Notes','Story','Syntax')]
[Alias('SectionName')]
[string[]]
$SectionNames
)

$skipSectionNames = @($This.HideSections)
foreach ($SectionName in $SectionNames) {
    if ($skipSectionNames -contains $SectionName) {     
        $skipSectionNames = @($skipSectionNames -ne $SectionName)
    }
}

$this | 
    Add-Member NoteProperty HideSections $skipSectionNames -Force


