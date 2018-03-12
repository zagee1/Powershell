Function ListMenu ($List, $ListObject, $NenuTitle, $MsgBeforeSelect){

    $Num=0
    $T = "=" * $NenuTitle.length
    Write-host " $NenuTitle `n $T `n" -ForegroundColor Yellow
    FOREACH ($Menu in $List) {
        $Num=$Num+1
        Write-Host -ForegroundColor Cyan $Num")" $Menu.Name
    }
    $T = "-" * $MsgBeforeSelect.length
    Write-Host " $MsgBeforeSelect `n $T" -ForegroundColor Yellow
    $chosen = Read-host "Choose A Number"
    if (([int]$chosen -ge 1) -and ([int]$chosen -le $num)) {
        $Return = $List.$ListObject[$chosen-1]
        Write-Host $Return -ForegroundColor Yellow
        Return $Return
    } 
    else { 
        Write-Host "ERROR - No Company chosen or chosen number is out of scope. Nothing to do... `n
        No change mades - Please restart the script" -ForegroundColor Red
        break
    }
}
Clear-Host
Write-Host "Created By - Guy Zagar AKA ZRIZ. Ofek Advanced Technologies 2017.`n" -ForegroundColor Cyan
Write-Host "WARNING:`t That Script Is Going to Delete a Complete Company From The Exchange!!! `n
             `t After You Finish Plese Delete the Company From PineApp `n" -ForegroundColor Yellow
Pause
$TempList = Get-ADOrganizationalUnit -Filter * -SearchBase "OU=Email,DC=Host,DC=Local" | Select-Object Name | Sort-Object Name
$Domain = ListMenu -List $TempList -ListObject "Name" -NenuTitle "Damain List" -MsgBeforeSelect "What Company You Want To Delete From The Domain?"

$TempList = Get-AddressBookPolicy -Identity * | Select-Object Name | Sort-Object Name
$Company = ListMenu -List $TempList -ListObject "Name" -NenuTitle "Company List" -MsgBeforeSelect "What Company You Want To Delete From The Exchange?"

Write-Host "Please Wait, Looking For Recipients In $Company ... `n" -ForegroundColor Cyan

$ABP = Get-Recipient | Where-Object {$_.AddressBookPolicy -eq $Company}
If ($ABP){
    Write-Host "`t I Found Recipients In The AddressBook `n
    `t Starting To Delete $Company ($Domain) To Cancel Press Ctrl+C " -ForegroundColor Yellow
    Pause
    $ABP | Remove-Mailbox -Confirm:$False
    }
Else {
    Write-Host "No Recipients Found In The AddressBook `n
    `t Starting To Delete $Company ($Domain) To Cancel Press Ctrl+C " -ForegroundColor Yellow
    Pause
}

Get-AddressBookPolicy -Identity $Company* | Remove-AddressBookPolicy -Confirm:$False
Get-EmailAddressPolicy -Identity $Company* | Remove-EmailAddressPolicy -Confirm:$False
Get-OfflineAddressBook -Identity $Company* | Remove-OfflineAddressBook -Confirm:$False
Get-AddressList -Identity $Company* | Remove-AddressList -Confirm:$False
Get-GlobalAddressList -Identity $Company* | Remove-GlobalAddressList -Confirm:$False
Get-AcceptedDomain -Identity $Domain | Remove-AcceptedDomain -Confirm:$False
Set-ADForest -Identity host.local -UPNSuffixes @{Remove="$Domain"}
Get-ADOrganizationalUnit -Filter 'Name -eq $Domain' -SearchBase "OU=Email,DC=Host,DC=Local" | Set-ADObject -ProtectedFromAccidentalDeletion:$false -PassThru | Remove-ADOrganizationalUnit -Recursive  -Confirm:$False

Write-Host "`t All Done! `n
    `t If You Didn't Seen An Error $Domain Is No More" -ForegroundColor Cyan