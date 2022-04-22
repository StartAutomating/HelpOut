Write-FormatView -TypeName File.Documentation.Percentage, Documentation.Percentage -Property Name,CommentPercent -AutoSize -VirtualProperty @{
    CommentPercent = { '' + ([Math]::Round($_.CommentPercent,2)) + '%' }
} -ColorProperty @{
    CommentPercent = {
        Format-Heatmap -HeatMapMax 20 -InputObject $_.CommentPercent -HeatMapHot "#11ff11" -HeatMapCool "#ff1111"
    }
}
