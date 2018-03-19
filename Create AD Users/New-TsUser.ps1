[CmdletBinding()]
param(
    [Parameter(ValueFrompiPeline=$true)]
    [string[]]$GivenName,
    [Parameter(ValueFrompiPeline=$true)]
    [string[]]$Surname,
    [Parameter(ValueFrompiPeline=$true)]
    [String[]]$Password
    )

$Name = $GivenName+' '+$Surname
$SamAccountName = "$GivenName"
#$AccountPassword = (ConvertTo-SecureString $Password -AsPlainText -Force)

#try {
    New-ADUser -Name "$Name" -GivenName "$GivenName" -Surname "$Surname" -SamAccountName $SamAccountName -AccountPassword (ConvertTo-SecureString "$Password" -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $false –PasswordNeverExpires $true
#}
<#catch {
    if($_.Exception.Message -eq "The specified account already exists"){
    $SamAccountName += $Surname.substring(0,1)
    $obj | New-ADUser -Enabled $true -ChangePasswordAtLogon $false –PasswordNeverExpires $true
    }
}
Finally{
    Write-Output "$obj"
}
#>






