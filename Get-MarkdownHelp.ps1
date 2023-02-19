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
    .LINK
        Get-Help
    .OUTPUTS
        [string]

        The documentation for a single command, in Markdown.
    #>
    [Reflection.AssemblyMetadata("HelpOut.TellStory", $true)]
    [Reflection.AssemblyMetadata("HelpOut.Story.Process", "For each Command")]
    [OutputType('PowerShell.Markdown.Help')]
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
    $NoValidValueEnumeration,

    # If set, will not attach a YAML header to the generated help.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('IncludeFrontMatter', 'IncludeHeader')]
    [switch]
    $IncludeYamlHeader,

    # The type of information to include in the YAML Header
    [ValidateSet('Command','Help','Metadata')]
    [Alias('YamlHeaderInfoType')]
    [string[]]
    $YamlHeaderInformationType
    )

    process
    {
        # We start off by copying the bound parameters
        $myParams= @{} + $PSBoundParameters
        # and then we call Get-Help.
        $getHelp = @{name=$Name}
        $gotHelp = Get-Help @getHelp
        
        
        # If we could not Get-Help,
        if (-not $gotHelp) {
            Write-Error "Could not get help for $name"
            return # we error out.
        }

        # We need to decorate the output of Get-Help so it renders as markdown,
        # so we pipe thru all results from Get-Help.    

        $gotHelp |
            & { process {
                    # Get-Help can return either a help topic or command help.
                    $in = $_
                    # Help topics will be returned as a string
                    if ($in -is [string]) {
                        $in # (which we will output as-is for now).
                    } else {


                        
                        $helpObj = $_
                        # Command Help will be returned as an object
                        # We decorate that object with the typename `PowerShell.Markdown.Help`.
                        $helpObj.pstypenames.clear()
                        $helpObj.pstypenames.add('PowerShell.Markdown.Help')

                        # Then we attach parameters passed to this command to the help object.
                        # * `-Rename` will become `[string] .Rename`
                        if ($Rename) {
                            $helpObj | Add-Member NoteProperty Rename $Rename -Force
                        }

                        # * `-SectionOrder` will become `[string[]] .SectionOrder`
                        if ($SectionOrder) {
                            $helpObj | Add-Member NoteProperty SectionOrder $SectionOrder -Force
                        }
                        # * `-Wiki`  will become `[bool] .WikiLink`
                        $helpObj | Add-Member NoteProperty WikiLink ($Wiki -as [bool]) -Force
                        # * `-GitHubDocRoot` will become `.DocLink`
                        if ($myParams.ContainsKey("GitHubDocRoot")) {
                            $helpObj | Add-Member NoteProperty DocLink $GitHubDocRoot -Force
                        }
                        # * `-NoValidValueEnumeration`
                        $helpObj | Add-Member NoteProperty NoValidValueEnumeration $NoValidValueEnumeration -Force
                        # * `-IncludeYamlHeader`
                        $helpObj | Add-Member NoteProperty IncludeYamlHeader $IncludeYamlHeader -Force
                        # * `-NoValidValueEnumeration`
                        $helpObj | Add-Member NoteProperty YamlHeaderInformationType $YamlHeaderInformationType -Force


                        # After we've attached all of the properties, we simply output the object.
                        # PowerShell.Markdown.Help formatter will display it exactly as we'd like it.                        
                        $helpObj
                    }
                }
            }
    }
}
