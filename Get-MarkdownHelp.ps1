function Get-MarkdownHelp {
    <#
    .SYNOPSIS
        Gets Markdown Help
    .DESCRIPTION
        Gets Help for a given command, in Markdown
    .EXAMPLE
        Get-MarkdownHelp Get-Help
    .LINK
        Save-MarkdownHelp
    .OUTPUTS
        [string]

        The documentation for a single command, in Markdown.
    #>
    param(
    # The name of the specified command or concept.
    [Parameter(Position=0, ValueFromPipelineByPropertyName)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,

    # If set, will generate a markdown wiki.  Links will be relative to the current path, and will not include the .md extensions    
    [switch]
    $Wiki,

    # If set, will interlink documentation as if it were for GitHub pages, beneath a given directory
    [Alias('GitHubPageRoot')]    
    [string]
    $GitHubDocRoot,

    # If provided, will rename the help topic before getting markdown.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Rename,

    # The order of the sections.
    # If not provided, this will be the order they are defined in the formatter.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $SectionOrder,

    # If set, will not enumerate valid values and enums of parameters.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $NoValidValueEnumeration
    )

    process
    {
        $getHelp = @{name=$Name}
        $myParams= @{} + $PSBoundParameters        
        $gotHelp = Get-Help @getHelp 
        if (-not $gotHelp) {
            Write-Error "Could not get help for $name"
            return
        }
        $gotHelp |
            & { process {
                    $in = $_
                    if ($in -is [string]) {
                        $in
                    } else {
                        $helpObj = $_
                        if ($Rename) {
                            $helpObj | Add-Member NoteProperty Rename $Rename -Force
                        }
                        $helpObj.pstypenames.clear()
                        $helpObj.pstypenames.add('PowerShell.Markdown.Help')
                        if ($SectionOrder) {
                            $helpObj | Add-Member NoteProperty SectionOrder $SectionOrder -Force    
                        }
                        $helpObj | Add-Member NoteProperty WikiLink ($Wiki -as [bool]) -Force
                        if ($myParams.ContainsKey("GitHubDocRoot")) {
                            $helpObj | Add-Member NoteProperty DocLink $GitHubDocRoot -Force
                        }
                        $helpObj | Add-Member NoteProperty NoValidValueEnumeration $NoValidValueEnumeration -Force
                        $helpObj
                    }
                } 
            }        
    }

        

}
