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
}
