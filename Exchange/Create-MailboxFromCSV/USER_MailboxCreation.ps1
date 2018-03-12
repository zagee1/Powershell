$Database = "NDC-DAG-MBXDB-2GB-01"
$OUpath = "host.local/Email/sigma-invest.co.il"

$users = Import-CSV .\Mailboxes_Template.csv
$users| ForEach-Object{
    $Password = convertto-securestring $_.Password -asplaintext -force
    $Alias = $_.Firstname + "." + $_.Lastname
    $name = $_.Firstname + " " + $_.Lastname
    new-mailbox -name $name -alias $Alias -FirstName $_.Firstname -LastName $_.Lastname -Database $Database -userPrincipalName  $_.EmailAddress -OrganizationalUnit $OUpath -Password $Password –ResetPasswordOnNextLogon:$false
    Set-Mailbox -Identity $Alias -DeliverToMailboxAndForward $true -ForwardingSMTPAddress "Office@Sigma-Premium.com"
}