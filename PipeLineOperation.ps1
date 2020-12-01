
#Developing Pipeline Functions

Function Do-ServerOperation {

[CmdletBinding()]
Param(

[Parameter(ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
[Alias('Node','DisplayName','DnsName')]
[string[]]$ServerName

)

Begin {

Write-Verbose 'Pipeline is starting'

}

Process {


    Foreach ($Server in $ServerName) {
    
    Write-Verbose "Pipeline is processing $Server"
    "Doing some Operation on $Server"
    
    }

}

End {

Write-Verbose 'Pipeline Ended. Keyfine bak ama önce temizlik yap tabi.'

}

}



Import-Csv -Path c:\temp\ServerList.csv | Do-ServerOperation -Verbose
Do-ServerOperation -ServerName 'Server1','Server2','Server3','Server4'
Get-Content -Path c:\temp\ServerList.txt | do-ServerOperation
