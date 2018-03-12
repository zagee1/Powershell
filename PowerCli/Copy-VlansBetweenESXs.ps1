$NewSRV = Read-Host "Enter the server IP where you want to create the VLans"
$CopyFromSRV = Read-Host "Enter the server IP to copy the VLans from"
$NewSRVvSwitch = Get-VirtualSwitch -VMHost $NewSRV -Name vSwitch1
Get-VirtualSwitch -VMHost $CopyFromSRV -Name vSwitch1 | Get-VirtualPortGroup |
foreach-Object {
    New-VirtualPortGroup -VirtualSwitch $NewSRVvSwitch -Name $_.Name -VLanId $_.VLanId
}
