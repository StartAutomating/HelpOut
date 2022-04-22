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
    $Rename
    )


    process
    {
        $paramCopy = @{} + $PSBoundParameters
        $myParams  = @{} + $PSBoundParameters
        $paramCopy.Remove('Wiki')
        $paramCopy.Remove('GitHubDocRoot')
        $paramCopy.Remove('Rename')
        $gotHelp = Get-Help @paramCopy 
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
                        $helpObj | Add-Member NoteProperty WikiLink ($Wiki -as [bool]) -Force
                        if ($myParams.ContainsKey("GitHubDocRoot")) {
                            $helpObj | Add-Member NoteProperty DocLink $GitHubDocRoot -Force
                        }
                        $helpObj
                    }
                } 
            }        
    }

        

}
