$options = @{}

foreach ($a in $args) {
    if ($a -is [string]) {
        foreach ($o in $a -split '[ ,]' -ne '') {
            $Options["$o".Trim()] = $true
        };
        continue
    }
    if ($a -is [Hashtable]) {foreach ($o in $a.Keys) {$options[$o] = $a[$o]};continue}
    throw 'Arguments must strings or hashtables'
}

$validKeys = 'Development', 'Production'
foreach ($k in $options.Keys) {
    if ($validKeys -notcontains $k) {
        throw "Invalid option: $k"
    }
}


if ($options.Development) {
    . $PSScriptRoot\ConvertTo-MAML.ps1
    . $PSScriptRoot\Save-MAML.ps1
    . $PSScriptRoot\Install-MAML.ps1
}

if ($options.Production -or -not $options.Development) {
    . $PSScriptRoot\allcommands.ps1
}
