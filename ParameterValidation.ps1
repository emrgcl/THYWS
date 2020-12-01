# Functions
<#
 Parameter Valdiation
 1) *length
 2) *array count
 3) Regex
 4) **choose from a set
 5) *script validation
 6) mandatory/optional
 7) Null/empty
#>

Function Do-Sth {
[CmdletBinding()]
Param(
    
    [Parameter(Mandatory=$true,ParameterSetName='Name')]
    [ValidateCount(1,3)]
    [string[]]$Names,

    [Parameter(Mandatory=$true,ParameterSetName='SurName')]
    [ValidateCount(1,3)]
    [string[]]$SurNames,
    
    [Parameter(Mandatory=$true)]
    [ValidateScript({Test-Path $_})]
    [Alias('Directory','Folder')]
    [string]$Path
    
)

Write-Verbose "Function started. Current parametersetname: $($PSCmdlet.ParameterSetName)"

'Chris Isac - Baby did a bad bad thing'
 
    
switch ($PSCmdlet.ParameterSetName) {
    
    'Name'     {Foreach($Name in $Names){ "Cleaning folder for $name. FolderName = $Path"}}
    'SurName'  {Foreach ($Surname in $Surnames ){"Cleaning folder for Mr. $Surname. FolderName = $Path"}}
    
}




}

