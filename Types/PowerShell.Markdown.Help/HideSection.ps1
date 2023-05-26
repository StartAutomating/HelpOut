<#
.SYNOPSIS
    Hides sections of markdown help
.DESCRIPTION
    Hides sections of a command's markdown help.
#>
param(
# One or more section names.
[ValidateSet('Name','Synopsis','Description','RelatedLinks','Examples','Parameters','Inputs','Outputs','Notes','Story','Syntax')]
[Alias('SectionName')]
[string[]]
$SectionNames
)


$skipSectionNames = @($This.HideSections)
foreach ($SectionName in $SectionNames) {
    if ($skipSectionNames -notcontains $SectionName) {     
        $skipSectionNames += $SectionName 
    }
}

$this | 
    Add-Member NoteProperty HideSections $skipSectionNames -Force
