# Risk Mitigation

Function Remove-DomainPartition {

[CmdletBinding(

    SupportsShouldProcess = $true,
    ConfirmImpact = 'High'

)]
Param(

[PArameter(Mandatory=$true)]
[string[]]$Domains,
[switch]$EnableLogging

)

Foreach ($Domain in $Domains) {

Write-Verbose "Deleting domain $Domain with EnableLogging = $EnableLogging"

# Risky Operation Below


        if ($pscmdlet.ShouldProcess($Domain, "Deleting Domain"))
        {
            "Deleted $domain"
        }


}

}