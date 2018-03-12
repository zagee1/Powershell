cls
Set-PSDebug -Trace 0
Write-Host 'Welcome to new company domain exchange creator' -ForegroundColor Cyan
Write-Host 'Please enter the required details to proceed' -ForegroundColor Cyan
Write-host '--------------------------------------------' -ForegroundColor Yellow
Write-Host 'Created By - Nir Ashkenazi. Ofek Advanced Technologies 2016.' -ForegroundColor Cyan
Write-Host '--------------------------------------------' -ForegroundColor Yellow
echo 'What is the Fully Qualified Domain Name (FQDN) of the new Company?'
$Domain = Read-Host 'FQDN'
echo 'What is the name of the company?'
$Company = Read-Host 'Company'

write-host "You have chosen the following deatils, please confirm:" -ForegroundColor Yellow
write-host 'Domain Name:' $Domain -ForegroundColor Magenta
write-host 'Company name:' $Company -ForegroundColor Magenta

$confirmation = Read-Host "Are you Sure You Want To Proceed?"
if ($confirmation -eq 'y') {
#Creaet a OU for the first Tenant (Company Domain)
#New-ADOrganizationalUnit -Name $Domain -Path "OU=Email,DC=Host,DC=Local"

#Register New UPN Suffix
Set-ADForest -Identity host.local -UPNSuffixes @{add="$Domain"}

# Add Accepted Domain for Clients domain:
#New-AcceptedDomain -Name "$Domain" -DomainName "$Domain" -DomainType:Authoritative

# Create a Global Address List for Client's domain & direct to OU:
New-GlobalAddressList -Name "$Company - GAL" -IncludedRecipients MailboxUsers -RecipientContainer "host.local/Email/$Domain"
$host.UI.RawUI.ReadKey()

# Create All Rooms Address list:
New-AddressList -Name "$Company - All Rooms" -RecipientFilter "(RecipientDisplayType -eq 'ConferenceRoomMailbox')" -RecipientContainer "host.local/Email/$Domain"
$host.UI.RawUI.ReadKey()
# Create All Users Address List:
New-AddressList -Name "$Company - All Users" -RecipientFilter "(ObjectClass -eq 'User')" -RecipientContainer "host.local/Email/$Domain"
$host.UI.RawUI.ReadKey()
# Create All Contacts Address List
New-AddressList -Name "$Company - All Contacts" -RecipientFilter "(ObjectClass -eq 'Contact')" -RecipientContainer "host.local/Email/$Domain"
$host.UI.RawUI.ReadKey()
# Create All Groups Address List
New-AddressList -Name "$Company - All Groups" -RecipientFilter "(ObjectClass -eq 'Group')" -RecipientContainer "host.local/Email/$Domain"
$host.UI.RawUI.ReadKey()
# Create Offline Address Book
New-OfflineAddressBook -Name "$Company" -AddressLists "$Company - GAL"
$host.UI.RawUI.ReadKey()
# Create Email Address Policy
Write-host 'Creating Email Address Policy'
New-EmailAddressPolicy -Name "$Company - EAP" -RecipientContainer "host.local/Email/$Domain" -IncludedRecipients "AllRecipients" -EnabledEmailAddressTemplates SMTP:%g@$Domain
$host.UI.RawUI.ReadKey()

# Create Address Book Policy
New-AddressBookPolicy -Name "$Company" -AddressLists "$Company - All Users", "$Company - All Contacts", "$Company - All Groups" -GlobalAddressList "$Company - GAL" -OfflineAddressBook "$Company" -RoomList "$Company - All Rooms"
$host.UI.RawUI.ReadKey()

#Assign All Users in Domain to Policy
write-host 'filter goes here'
Get-Mailbox -Filter {(emailaddresses -like "*@$Domain")} | Set-Mailbox -AddressBookPolicy "$Company"

# Remove Debug level from Powershell
Set-PSDebug -Trace 0
}
else {write-host Set-PSDebug -Trace 0 "Script Aborted"}
