cls
Write-host '------------------------------------------------------------' -ForegroundColor Yellow
Write-Host 'Welcome to new company users creator' -ForegroundColor Cyan
Write-Host 'Please enter the required details to proceed' -ForegroundColor Cyan
Write-host '------------------------------------------------------------' -ForegroundColor Yellow
Write-Host 'Created By - Nir Ashkenazi. Ofek Advanced Technologies 2016.' -ForegroundColor Cyan
Write-Host '------------------------------------------------------------' -ForegroundColor Yellow
echo 'What is the Fully Qualified Domain Name (FQDN) of the new Company?'
$Domain = Read-Host 'FQDN'
echo 'What is the name of the company?'
$Company = Read-Host 'Company'

write-host "You have chosen the following deatils, please confirm:" -ForegroundColor Yellow
write-host 'Domain Name:' $Domain -ForegroundColor Magenta
write-host 'Company name:' $Company -ForegroundColor Magenta
Write-host '------------------------------------------------------------------------'
Write-Host 'The script will use the current folder Users.csv file for required users' -ForegroundColor Yellow
Write-host '------------------------------------------------------------------------'
write-host
write-host "The following users will be added:" -ForegroundColor yellow
IMPORT-CSV Users.csv | format-table -autosize
$dbList=Get-MailboxDatabase -Status | select Name,DatabaseSize,AvailableNewMailboxSpace
$Num=0
Write-host "Available Databases" -ForegroundColor Yellow
write-host
Write-host "Database Name `t`t`t Database Size"
FOREACH ($db in $dbList) {
$Num=$Num+1
write-host -ForegroundColor Cyan $Num")" $db.name`t $db.Databasesize.ToGb() `t"(GB)"
}
write-host
write-host "Before proceeding - You MUST select a database for Users Mailbox Creation." -ForegroundColor Yellow
write-host "--------------------------------------------------------------------------"
$chosen = Read-host "Please Choose Database Number"
if (([int]$chosen -ge 1) -and ([int]$chosen -le $num)) {
write-host $dblist.name[$chosen-1] -ForegroundColor Yellow
} 
else 
{ 
write-host "ERROR - No database chosen or chosen number is out of scope. Nothing to do..." -ForegroundColor Red
write-host "No change mades - Please restart the script" -ForegroundColor Red
break
}
$UserList=IMPORT-CSV Users.csv
write-host
write-host 'Domain Name:' "`t`t"$Domain -ForegroundColor Cyan
write-host 'Company Name:' "`t`t"$Company -ForegroundColor Cyan
write-host 'Database Type:' "`t`t"$dblist.name[$chosen-1] -ForegroundColor Cyan
Write-host
$confirmation = Read-Host "Are you Sure You Want To Proceed?"
if ($confirmation -eq 'y') {

FOREACH ($Person in $UserList) {
$Username=$Person.Firstname
$UPN=$Username+"@"+$Domain
$Name=$Person.Firstname+” “+$Person.Lastname
$Alias=$Company+"_"+$Person.Firstname
$Sam=$Company+"_"+$Person.Firstname
$Pass=$Person.Firstname.substring(0,2)+"@2016!"
$Pass=$Pass.substring(0,1).toupper()+$Pass.substring(1)
$SecPass=ConvertTo-SecureString $pass -AsPlainText -Force
#Create users by loop strings
new-mailbox -Name $Name -Alias $Alias -database $dblist.name[$chosen-1] -OrganizationalUnit host.local/Email/$Domain -UserPrincipalName $UPN -SamAccountName $Sam -FirstName $Person.Firstname -LastName $Person.Lastname -Password $SecPass -ResetPasswordOnNextLogon $false -AddressBookPolicy $Company
}
}