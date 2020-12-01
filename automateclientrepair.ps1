Function new-ClientOperationTable {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ClientName
    )
    @{
        '2'          = [ordered]@{
            'Fix-Wmi'         = @{ClientName = $ClientName; Threshold = '5'; ErrorAction = 'stop' }
            'Reinstall-Agent' = @{ClientName = $ClientName }
        }
        '5'          = [ordered]@{
            'Send-EMail' = @{ClientName = $ClientName }
        }
   
        '8'          = [ordered]@{
            'Reinstall-Agent' = @{ClientName = $ClientName }
        }
        '10'         = [ordered]@{
            'Set-ClientTime' = @{ClientName = $ClientName }                
        }
        '53'         = [ordered]@{
            'Check-Network' = @{ClientName = $ClientName }
            'Check-Sth'     = @{ClientName = $ClientName }                
        }    
        '112'        = [ordered]@{
            'Diskte-YerAc'    = @{ClientName = $ClientName }
            'Reinstall-Agent' = @{ClientName = $ClientName }                
        }
        '1450'       = [ordered]@{
            'Reboot-Client'   = @{ClientName = $ClientName }
            'Reinstall-Agent' = @{ClientName = $ClientName } 
        }
        '2147023174' = [ordered]@{
            'Check-Service'   = @{ClientName = $ClientName; ServiceName = 'RPCSS' }
            'Fix-Wmi'         = @{ClientName = $ClientName; Threshold = '5' }
            'Reinstall-Agent' = @{ClientName = $ClientName }
        }

    }

    Write-Verbose 'Operation Table Generated'
}

Function Check-Service {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ClientName,
        [Parameter(Mandatory = $true)]
        [string]$ServiceName

    )

    Write-Host '$ClientName için $ServiceName servisi kontrol ediliyor.'

}

Function Get-FunctionParameters {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$FunctionName,
        [Parameter(Mandatory = $true)]
        [HashTable]$ParameterHash
    )

    $ParameterHash."$FunctionName"
}

Function Get-ExecutionString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [HashTable]$ClienTable,
        [Parameter(Mandatory = $true)]
        [string]$ErrorCode
    )

    Foreach ($Function in $ClientTable."$ErrorCode".Keys) {
        $ParameterString = ''
        $ParameterHash = Get-FunctionParameters -FunctionName $Function -ParameterHash $ClientTable."$ErrorCode"
        $ParameterHash.Keys | ForEach-Object { $ParameterString += "-$_ $($ParameterHash[$_]) " }

        ("$Function " + $ParameterString).TrimEnd()
    }
}

Function Fix-Wmi {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ClientName,
        [int32]$Threshold 
    )

    Write-Output "Fixing Wmi of $ClientName. Threshold = $Threshold" 

}

Function Reinstall-Agent {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ClientName

    )

    Write-Output "Reinstalling $ClientName." 

}

Function Send-EMail {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ClientName
    )

    write-Output "Sending E-Mail for $ClientName."
    
}

Function Set-ClientTime {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ClientName

    ) 

    write-Output "Set Client Time for $ClientName."
       
}

Function Check-Network {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ClientName

    ) 

    write-Output "Check network for $ClientName."
    
}

Function Diskte-YerAC {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ClientName

    ) 
    write-Output "$ClientName in C diskinde yer aç."
        
}

Function Reboot-Client {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ClientName

    ) 
    write-Output "Reboot Client $ClientName"
        
}

Function Return_Result {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [HashTable]$ClientTable,
        [Parameter(Mandatory = $true)]
        [string]$ErrorCode
    )

    $err = Get-OperationsCode -ErrorCode $ErrorCode
    Write-Host $err
    
    switch ($err) {
        default { $(Get-ExecutionString -ClienTable $ClientTable -ErrorCode $err) | ForEach-Object { Invoke-Expression $_ } }
    }

}

Function Check-Sth {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ClientName

    ) 

    write-Output "Check sth for $ClientName."
    
}

Function Get-OperationsCode {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Error', 'Name', 'LastInstallationError')]
        [string]$ErrorCode,
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$ClientName
    )
    Process {
        $HashMap = @{

            "2"          = $('2', '2147749889', '2147749890', '2147749904', '2147749908', '8007045D', '800706BA', '80041001', '8004103B', '80070070', '87D0029E', '9', '2148007941', '1305', '-21470223779')
            "5"          = $('5', '7', '2147024891', '2147942405', '64', '1396')
            "8"          = $('8', '1003', '1053', '1068', '1603', '1618', '120')
            "53"         = $('53', '67', '86', '1203')
            "2147023174" = $('2147944122')

        }

        $Hashmap.Keys | ForEach-Object { if ($HashMap."$_" -contains $ErrorCode) { [PSCustomObject]@{ClientName = $ClientName; OperationsCode = $_ } } }
    }




}

Function Get-InstallationErrors {
    [CmdletBinding()]
    Param(

        [string]$SiteServer,
        [string]$SiteCode

    )

    $Query = @'
select 
    SYS.ResourceID,
    SYS.ResourceType,
    SYS.Name,
    SYS.SMSUniqueIdentifier,
    SYS.ResourceDomainORWorkgroup,
    SYS.Client,
    COL.LastInstallationError
from SMS_R_System as SYS 
Inner Join SMS_CM_RES_COLL_SMS00001 as COL on SYS.ResourceID = COL.ResourceID  
Where COL.LastInstallationError <> 0 
And (SYS.Client = 0  Or SYS.Client is null)
'@

    Get-WmiObject -ComputerName $SiteServer -Namespace "root\sms\site_$SiteCode" -Query $Query | Select-Object -Property @{Name = 'ClientName'; Expression = { $_.Sys.Name } }, @{Name = 'LastInstallationError'; Expression = { $_.Col.LastInstallationError } }

}

#Region

$LastInstallationErrors = Get-InstallationErrors -SiteServer SCCMSiteServerName -SiteCode CEN | Group-Object -Property LastInstallationError 
$OperationCodes = $LastInstallationErrors.Group | Select-Object -Property ClientName, @{Name = 'LastInstallationError'; Expression = { [string]$_.LastInstallationError } } | Get-OperationsCode

Foreach ($OperationsCode in $OperationCodes) {
    $ClientTable = new-ClientOperationTable -ClientName $OperationsCode.ClientName
    $(Get-ExecutionString -ClienTable $ClientTable -ErrorCode $OperationsCode.OperationsCode) | ForEach-Object { Invoke-Expression $_ }

}
#EndRegion 