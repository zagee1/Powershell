Connect-VIServer -Server 172.16.18.100
$vLanID = '152'
$vLanName = 'Zriz'

Get-VMHost -Name 172.16.18* -Location BDC-DataCenter | Get-VirtualSwitch -Name vSwitch1 |
New-VirtualPortGroup -Name $vLanName'_Host_10G' -VLanId $vLanID

Get-VMHost -Name 172.16.18* -Location NHFA-Cluster-V4 | Get-VirtualSwitch -Name vSwitch0 |
Get-VirtualPortGroup | select Name, VLanId | Sort-Object -Unique VlanId