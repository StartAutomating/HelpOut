<#
.SYNOPSIS
    Gets HelpInfo notes
.DESCRIPTION
    Gets the `Notes` section of a HelpInfo object.
.EXAMPLE
    (Get-Help Get-Help).Note
#>
param()

@($this.alertSet.alert.text)