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

if (-not $args -and (Test-Path (Join-Path $PSScriptRoot '.git'))) {
    $options["Development"] = $true
}

$validKeys = 'Development', 'Production'
foreach ($k in $options.Keys) {
    if ($validKeys -notcontains $k) {
        throw "Invalid option: $k"
    }
}

if ($options.Development) {
    foreach ($file in Get-Childitem -LiteralPath $PSScriptRoot -Filter '*-*.ps1' -Recurse) {
        . $file.FullName    
    }
}

if ($options.Production -or -not $options.Development) {
    . $PSScriptRoot\allcommands.ps1
}
