#requires -Module HelpOut
describe HelpOut {
    context 'Get-MAML' {
        it 'Can get MAML' {
            $maml = Get-Command Get-MAML | Get-MAML
            $maml = [xml]$maml
            $maml.helpItems.command.details.name | Should -be 'Get-MAML'
        }
    }

    context 'Save-MAML' {
        it 'Can save all help from a module into MAML' {
            $savedMaml = Save-MAML -Module HelpOut -PassThru
            [xml]$savedMaml

        }
    }

    context 'Install-MAML' {
        it 'Can install MAML' {
            Install-MAML -Module HelpOut
        }        
    }

    context 'Get-ScriptReference' {
        it 'Can discover references in a script' {
            Get-Command Save-MAML | Get-ScriptReference
        }
    }

    context 'Measure-Help' {
        it 'Can measure documentation within a script' {
            Get-Command Save-MAML | Measure-Help | Select-Object -ExpandProperty CommentPercent | Should -BeGreaterThan 20
        }
    }

    context 'Get-MarkdownHelp' {
        $markdownHelp = "$(Get-MarkdownHelp -Name Get-MarkdownHelp | Out-String -Width 1mb)"
        $markdownHelp | Should -Match "^\s{0,}Get-MarkdownHelp[\s\n\r]{0,}[\-=]+"
    }

    context 'Save-MarkdownHelp' {
        $savedMarkdown = Save-MarkdownHelp -PassThru -Module HelpOut
        $savedMarkdown | Select-Object -ExpandProperty FullName | Should -BeLike *HelpOut*docs*
    }
}
