#requires -Module PSSVG
Push-Location ($PSScriptRoot | Split-Path)
$psChevronPolygonPoints = @(
    "40,20"
    "45,20"
    "60,50"
    "35,80"
    "32.5,80"
    "55,50"
) -join ' '

$psChevronPolygon = 
    svg.polygon -Points $psChevronPolygonPoints

$psChevron = 
    svg.symbol -Id psChevron -Content @(
        $psChevronPolygon
    ) -ViewBox 100, 100 -PreserveAspectRatio $false



$assetsPath = Join-Path $pwd Assets

if (-not (Test-Path $assetsPath)) {
    $null = New-Item -ItemType Directory -Path $assetsPath -Force
}

svg @(
    $psChevron
    svg.use -href '#psChevron'  -X '67.5%' -Y '-2%' -Width '9.5%' -Stroke '#4488ff' -Fill '#4488ff' -Opacity .8
    svg.text @(
        svg.tspan "Help" -FontFamily 'sans-serif'
        svg.tspan "Out" -FontFamily 'sans-serif' -Dx '-0.3em' -Rotate 1 -Dy '0.0em' -FontSize 24 -Opacity .9
    ) -FontSize 36 -Fill '#4488ff' -X 50% -DominantBaseline 'middle' -TextAnchor 'middle' -Y 50%
) -ViewBox 300, 100 -OutputPath (Join-Path $assetsPath HelpOut.svg)
Pop-Location