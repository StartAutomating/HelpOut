function Get-ScriptStory
{
    <#
    .Synopsis
        Gets a Script's story
    .Description
        Gets the Script's "Story"

        Script Stories are a simple markdown summary of all single-line comments within a script (aside from those in the param block).
    .Example
        Get-Command Get-ScriptStory | Get-ScriptStory
    .Notes
        
    #>
    [CmdletBinding(DefaultParameterSetName='ScriptBlock')]
    param(
    # A script block
    [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ParameterSetName='ScriptBlock')]
    [ScriptBlock]
    $ScriptBlock,

    # A block of text
    [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='ScriptText')]
    [Alias('ScriptContents', 'Definition')]
    [string]
    $Text,
    
    # The friendly names of code regions or begin,process, or end blocks.
    [Collections.IDictionary]
    $RegionName = @{
        begin = "Before any input"
        process = "On Each Input"
        end = "After all input"
    },
    
    [int]
    $HeadingSize = 3)

    process {
        function foo($x, $y) {
            # Documentation should be ignored
        }

        # First, we want to convert any text input to -ScriptBlock.
        if ($PSCmdlet.ParameterSetName -eq 'ScriptText') {
            $ScriptBlock = [ScriptBlock]::Create($Text)
        }

        # Next, we tokenize the script and force it into an array.
        $tokens = @([Management.Automation.PSParser]::Tokenize("$ScriptBlock", [ref]$null))
        # We need to keep track of how many levels of regions we're in, so create a $RegionStack.
        $regionStack = [Collections.Stack]::new()
        # We'll also want to make a StringBuilder (because it will be faster).
        $sb= [text.stringbuilder]::new()
        # Last but not least, we'll want to keep track of a block depth, so initialize that to zero. 
        $blockDepth = 0 
        #region Walk Thru Tokens
        for ($i =0; $i -lt $tokens.Length; $i++) {
            
            # As we pass GroupStarts and GroupEnds, nudge the block depth.
            if ($tokens[$i].Type -eq 'GroupStart') { $blockDepth++ }
            if ($tokens[$i].Type -eq 'GroupEnd') { $blockDepth-- } 

            #region Handle natural regions
            
            # In addition to any regions specified in documentation, 
            # we can treat the begin, process, and end blocks as effective regions.
            if ($tokens[$i].Type -eq 'keyword' -and 
                'begin', 'process', 'end' -contains $tokens[$i].content -and 
                $blockDepth -le 1 ) {
                # When we encounter one of these regions, pop the region stack
                if ($regionStack.Count) { $null = $regionStack.Pop() }
                # and push the current region.
                $null =$regionStack.Push($tokens[$i].Content)


                # Generate the header, which consists of:
                $keywordHeader = 
                    # a newline,
                    [Environment]::NewLine + 
                    # N Markdown headers, 
                    ('#' * ([Math]::Min(6, $regionStack.Count + $HeadingSize - 1))) + ' ' +
                    # the friendly name for the region (or just it's content),
                    $(if ($RegionName[$tokens[$i].Content]) {
                        $RegionName[$tokens[$i].Content]
                    } else { 
                        $tokens[$i].Content
                    }) +
                    # and another newline.
                    [Environment]::NewLine

                # Then, append the header.
                $null = $sb.Append($keywordHeader)
                continue
            }
            #endregion Handle natural regions

            #region Skip Parameter Block

            # We don't want all of the documentation.


            # Specifically, we want to avoid any parameter documentation and nested functions.
            # To do this, we need to notice the param and function keyword when it shows up.            
            if ($tokens[$i].Type -eq 'keyword' -and 'param', 'function' -contains $tokens[$i].Content) {
                
                
                # Once we've found it, we advance until we find the next GroupStart.  
                $j = $i + 1  
                while ($tokens[$j].Type -ne 'GroupStart') { $j++ }

                
                $skipGroupCount = 1
                if ($tokens[$j].Content -eq '(' -and  # If the GroupStart was an open paranthesis 
                    $tokens[$i].Content -eq 'function'# and we're dealing with a nested function,
                ) {
                    $skipGroupCount = 2 # we're going to need to this next bit twice.
                }


                foreach ($n in 1..$skipGroupCount) {
                    # Look for the GroupStart.
                    while ($tokens[$j].Type -ne 'GroupStart') { $j++ }                
                    # Then we set a variable to track depth 
                    $depth = 0  
                    do {
                        # and walk thru the tokens
                        if ($tokens[$j].Type -eq 'GroupStart') { $depth++ }
                        if ($tokens[$j].Type -eq 'GroupEnd') { $depth-- }
                        $j++
                    } while ($depth -and $tokens[$j]) # until the depth is 0 again.
                }

                
                $i = $j # Finally we set the iterator to current position (thus skipping the param block).
            }
            #endregion Skip Parameter Block

            #region Check for Paragraph Breaks

            # Next we need to check for paragraph breaks. 
            
            if ($i -ge 2 -and
                $tokens[$i].Type -eq 'Newline' -and # If the current token is a newline,
                $tokens[$i -1].Type -eq 'Newline')  # and the token before that was also a newline,
            {
                # then it's probably a paragraph break
                if ($i -ge 3 -and $tokens[$i - 2].Type -eq 'GroupEnd') 
                {
                    # (Unless it followed a GroupEnd).
                    continue
                }


                # When we encounter a paragraph break, output two newlines.
                $null = $sb.Append([Environment]::NewLine * 2)
            }
            #endregion Check for Paragraph Breaks

            #region Process Comments

            # At this point, we don't care about anything other than comments.            
            # So if it's not a comment, continue past them.
            if ($tokens[$i].Type -ne 'Comment') { continue }
            $Comment = $tokens[$i].Content.Trim([Environment]::NewLine).Trim()  
            if ($Comment.StartsWith('<')) { # If it's a block comment,
                # make sure it's not a special-purpose block comment (like inline help).
                $trimmedComment = $comment.Trim('<#').Trim([Environment]::NewLine).Trim()
                if ('?', '.', '{','-','|' -contains $trimmedComment[0]) { # If it was,
                    continue  # continue on.
                }
                # If it wasn't, trim the block comment and newlines.
                $Comment = $Comment.Trim().Trim("><#").Trim([Environment]::NewLine)
            }
                        
            
            # We'll need to know if it's a region
            # so we'll use some fancy Regex to extract it's name
            # (and if it's an EndRegion or not).

            if ($Comment.Trim() -match '#(?<IsEnd>end){0,1}region(?<RegionName>.{1,})') {
                $thisRegionName = $Matches.RegionName.Trim()
                if ($Matches.IsEnd) {
                    # If it was an EndRegion, pop it off of the Region Stack.
                    $null = $regionStack.Pop()
                } else {
                    # If it wasn't, push it onto the Region Stack.
                    $null = $regionStack.Push($thisRegionName)
                    # Then, output it's name a markdown header, 
                    # using the count of RegionStack to determine H1, H2, etc.                    
                    $regionContent = 
                        [Environment]::NewLine + 
                        ('#' * ([Math]::Min(6, $regionStack.Count + $HeadingSize - 1))) + ' '+ 
                        $(if ($RegionName[$thisRegionName]) {
                            $RegionName[$thisRegionName]
                        } else { 
                            $Matches.RegionName.Trim()
                        }) +
                        [Environment]::NewLine
                    $null = $sb.Append($regionContent)
                }


                # We still don't want the region name to become part of the story, 
                # so continue to the next token.
                continue
            }


            # Whatever comment is left is new story content.
            $newStory = $Comment.TrimStart('#').Trim()
                        
            # If there's any content already, 
            if ($sb.Length) {
                # before we put it into the string, 
                $null = 
                    if ($sb[-1] -eq '.') {
                        # add a double space (after a period),  
                        $sb.Append('  ')
                    } else {
                        # or a single space.
                        $sb.Append(' ')   
                    }                
            }
            
            $shouldHaveNewline = 
                $newStory.StartsWith('*') -or 
                $newStory.StartsWith('-') -or 
                ($lastStory -and ($lastStory.StartsWith('*') -or $lastStory.StartsWith('-')))
            if ($shouldHaveNewline) {
                $null = $sb.Append([Environment]::NewLine)
            }
            # Finally, append the new story content.
            $null = $sb.Append($newStory)
            #endregion Process Comments            
        }


        #endregion Walk Thru Tokens
    
        
        # After everything is done, output the content of the string builder.
        "$sb"
    }
}

 
