<#
.SYNOPSIS
    Convert HelpInfo to json
.DESCRIPTION
    Converts a HelpInfo object to a JSON representation of the object.
.EXAMPLE
    (Get-Help Get-Help).ToJson()
#>

param()

$helpObject = $this
[Ordered]@{
    Synopsis = $helpObject.Synopsis
    Description = $helpObject.Description.text -join ([Environment]::NewLine * 2)
    Parameters = @(foreach ($parameter in $helpObject.Parameters) {
        [Ordered]@{
            Name = $parameter.Name
            Type = $parameter.Type.Name
            Description = $parameter.Description.text -join ([Environment]::NewLine * 2)
            Required = $parameter.Required -match $true
            Position = if ($null -ne ($parameter.Position -as [int])) {
                $parameter.Position -as [int]
            } else {
                -1
            }
            Aliases = $parameter.Aliases
            DefaultValue = $parameter.DefaultValue
            Globbing = $parameter.Globbing -match $true
            PipelineInput = $parameter.PipelineInput
            variableLength = $parameter.variableLength -match $true
        }
    })
    Notes = @($helpObject.alertSet.alert.text)
    CommandType = $helpObject.Category
    Component = @($helpObject.Component)
    Inputs = @(
        $helpObject.InputTypes.InputType.Type.Name
    )
    Outputs = @(
        $helpObject.ReturnValues.ReturnValue.Type.Name
    )
    Links = @(
        foreach ($relLink in $this.RelatedLinks.navigationLink) {
            if ($relLink.uri) {
                $relLink.uri
            } else {
                $relLink.text
            }
        }
    )
    Examples = @(
        foreach ($example in $helpObject.Examples.Example) {                    
            # Combine the code and remarks
            $exampleLines = 
                @(
                    $example.Code
                    foreach ($remark in $example.Remarks.text) {
                        if (-not $remark) { continue }
                        $remark
                    }
                ) -join ([Environment]::NewLine) -split '(?>\r\n|\n)' # and split into lines

            # Anything until the first non-comment line is a markdown predicate to the example
            $nonCommentLine = $false
            $markdownLines = @()
            
            # Go thru each line in the example as part of a loop
            $codeBlock = @(foreach ($exampleLine in $exampleLines) {
                if ($exampleLine -match '^\#' -and -not $nonCommentLine) {
                    $markdownLines += $exampleLine -replace '^\#' -replace '^\s+'
                } else {
                    $nonCommentLine = $true
                    $exampleLine
                }
            }) -join [Environment]::NewLine
            [Ordered]@{
                Title = ($example.Title -replace '^[-\s]+' -replace '[-\s]+$')
                Markdown = $markdownLines -join [Environment]::NewLine
                Code = $codeBlock
            }                        
        }        
    )
} | ConvertTo-Json -Depth 10