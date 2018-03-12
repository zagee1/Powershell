$LanIP = Read-Host "Enter PBX LocalIP"
$WanIP = Read-Host "Enter PBX Public IP"
$ClientAdress = Read-Host "Enter ClientAdress"
$ClientName = Read-Host "Enter ClientName"
$ClientInterface = Read-Host "Enter ClientInterface"

$Content = Get-Content .\VoipRoles.txt

$Content = $Content.Replace('$LanIP', $LanIP)
$Content = $Content.Replace('$WanIP', "$WanIP")
$Content = $Content.Replace('$ClientName', "$ClientName")
$Content = $Content.Replace('$ClientInterface', "$ClientInterface")
$Content = $Content.Replace('$ClientAdress', "$ClientAdress")

$Content | Set-Clipboard
#$Content | Set-Content .\VoipRoles.txt