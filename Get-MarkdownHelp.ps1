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
        # We start off by copying the bound parameters
        $myParams= @{} + $PSBoundParameters
        # Then we call Get-Help.
        $getHelp = @{name=$Name}       
        $gotHelp = Get-Help @getHelp
        # If we could not call Get-Help
        if (-not $gotHelp) {
            Write-Error "Could not get help for $name"
            return # error out.
        }

        # Next we need to tweak the output of Get-Help.
        # Get-Help can return either a help topic or help about a command.

        $gotHelp |
            & { process {
                    $in = $_
                    # Help topics will be returned as a string
                    if ($in -is [string]) {
                        $in # (which we will output as-is for now)
                    } else {
                        # Command help is the interesting scenario.
                        $helpObj = $_
                        # In this case, we want to prepare the object to become markdown in a few ways.
                        # First, if -Rename was passed, put that on the help object.
                        if ($Rename) {
                            $helpObj | Add-Member NoteProperty Rename $Rename -Force
                        }
                        # Next, clear the typenames and decorate the return object.
                        $helpObj.pstypenames.clear()
                        $helpObj.pstypenames.add('PowerShell.Markdown.Help')
                        # Then, add the provided -SectionOrder to the help object.
                        if ($SectionOrder) {
                            $helpObj | Add-Member NoteProperty SectionOrder $SectionOrder -Force    
                        }
                        # Then, add a boolean indicating if it should be treated as a wiki.
                        $helpObj | Add-Member NoteProperty WikiLink ($Wiki -as [bool]) -Force
                        # Then add on the GitHubDocRoot as .DocLink, if provided.
                        if ($myParams.ContainsKey("GitHubDocRoot")) {
                            $helpObj | Add-Member NoteProperty DocLink $GitHubDocRoot -Force
                        }
                        # And finally, pass down our enumeraiton settings.
                        $helpObj | Add-Member NoteProperty NoValidValueEnumeration $NoValidValueEnumeration -Force
                        # Now, when we output this object, the PowerShell.Markdown.Help formatter will display it.                        
                        $helpObj
                    }
                } 
            }        
    }
}
