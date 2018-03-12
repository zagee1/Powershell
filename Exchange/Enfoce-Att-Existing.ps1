cls
Set-PSDebug -Trace 2
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
#Set-ADForest -Identity host.local -UPNSuffixes @{add="$Domain"}

# Add Accepted Domain for Clients domain:
#New-AcceptedDomain -Name "$Company" -DomainName "$Domain" -DomainType:Authoritative

# Create a Global Address List for Client's domain & direct to OU:
Write-host 'Set Global Address list with Attribute'
#Set-GlobalAddressList -Identity "$Company - GAL" -ConditionalCustomAttribute1 $Comapny -IncludedRecipients MailboxUsers -RecipientContainer "host.local/Email/$Domain"
Set-GlobalAddressList -Identity "$Company - GAL" -ConditionalCustomAttribute1 $Company -IncludedRecipients MailboxUsers -RecipientContainer "host.local/Email/$Domain"
$host.UI.RawUI.ReadKey()

# Create All Rooms Address list:
Set-AddressList -Identity "$Company - All Rooms" -RecipientFilter "(CustomAttribute1 -eq '$Company') -and (RecipientDisplayType -eq 'ConferenceRoomMailbox')" -RecipientContainer "host.local/Email/$Domain"
$host.UI.RawUI.ReadKey()
# Create All Users Address List:
Set-AddressList -Identity "$Company - All Users" -RecipientFilter "(CustomAttribute1 -eq '$Company') -and (ObjectClass -eq 'User')" -RecipientContainer "host.local/Email/$Domain"
$host.UI.RawUI.ReadKey()
# Create All Contacts Address List
Set-AddressList -Identity "$Company - All Contacts" -RecipientFilter "(CustomAttribute1 -eq '$Company') -and (ObjectClass -eq 'Contact')" -RecipientContainer "host.local/Email/$Domain"
$host.UI.RawUI.ReadKey()
# Create All Groups Address List
Set-AddressList -Identity "$Company - All Groups" -RecipientFilter "(CustomAttribute1 -eq '$Company') -and (ObjectClass -eq 'Group')" -RecipientContainer "host.local/Email/$Domain"
$host.UI.RawUI.ReadKey()
# Create Offline Address Book
#Set-OfflineAddressBook -Name "$Company" -AddressLists "$Company - GAL"
$host.UI.RawUI.ReadKey()
# Create Email Address Policy
#New-EmailAddressPolicy -Name "$Company - EAP" -RecipientContainer "host.local/Email/$Domain" -IncludedRecipients "AllRecipients" -ConditionalCustomAttribute1 $Company -EnabledEmailAddressTemplates SMTP:%g@$Domain -EnabledPrimarySMTPAddressTemplate SMTP:%g@$Domain
Set-EmailAddressPolicy -Identity "$Company - EAP" -RecipientContainer "host.local/Email/$Domain" -IncludedRecipients "AllRecipients" -ConditionalCustomAttribute1 $Company -EnabledEmailAddressTemplates SMTP:%g@$Domain
$host.UI.RawUI.ReadKey()
# Create Address Book Policy
Set-AddressBookPolicy -Identity "$Company" -AddressLists "$Company - All Users", "$Company - All Contacts", "$Company - All Groups" -GlobalAddressList "$Company - GAL" -OfflineAddressBook "$Company" -RoomList "$Company - All Rooms"
$host.UI.RawUI.ReadKey()
# Set Existing Users with CustomeAttribute1 from OU & Company
Get-Mailbox -OrganizationalUnit "host.local/Email/$Domain" | Set-Mailbox -CustomAttribute1 "$Company"
$host.UI.RawUI.ReadKey()
# Remove Debug level from Powershell
Set-PSDebug -Trace 0
}
else {write-host Set-PSDebug -Trace 0 "Script Aborted"}
