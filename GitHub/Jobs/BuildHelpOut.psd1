@{
    "runs-on" = "ubuntu-latest"    
    if = '${{ success() }}'
    steps = @(
        @{
            name = 'Check out repository'
            uses = 'actions/checkout@v2'
        }, 
        @{    
            name = 'Use PSSVG Action'
            uses = 'StartAutomating/PSSVG@main'
            id = 'PSSVG'
        },
        'RunPipeScript',
        'RunEZOut',
        @{
            name = 'Run Help Out (on master)'
            if   = '${{github.ref_name == ''master''}}'
            uses = 'StartAutomating/HelpOut@master'
            id = 'HelpOutMaster'
        },                
        @{
            name = 'Run Help Out (on branch)'
            if   = '${{github.ref_name != ''master''}}'
            uses = './'
            id = 'HelpOutBranch'
        }      
        
    )
}