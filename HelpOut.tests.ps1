describe HelpOut {
    context 'ConvertTo-MAML' {
        it 'Can Convert commands to MAML' {
            $maml = Get-Command ConvertTo-Maml | ConvertTo-Maml
            $maml = [xml]$maml
            $maml.helpItems.command.details.name | Should -be 'ConvertTo-MAML'
        }
    }

    context 'Save-MAML' {
        it 'Can save all help from a module into MAML' {
            $savedMaml = Save-MAML -Module HelpOut -PassThru
            [xml]$savedMaml
            
        }
    }
}
