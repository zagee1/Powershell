$CommunityString = "fwpublic"
$PermitedManagers = "172.16.16.31"
Function Configure_SNMP_Attributes ([string]$CommunityString , [string]$PermitedManagers)
{
    reg add "HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities\" /v $CommunityString /t REG_DWORD /d 4 /f | Out-Null -Verbose
    reg add "HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers\" /v 2 /t REG_SZ /d $PermitedManagers /f | Out-Null
    Write-Host  "SNMP Attributes Set On $env:COMPUTERNAME"  -ForegroundColor Green -BackgroundColor Black       
}

# Main script for Configuring SNMP

$SNMPInstallStatus = Get-WindowsOptionalFeature -Online | Sort-Object FeatureName | ? {$_.FeatureName -like "SNMP"}
    
    if  ($SNMPInstallStatus.State -ne "Enabled")
    {
        Write-Host "`nEnable SNMP on $env:COMPUTERNAME" -NoNewline   -ForegroundColor Black -BackgroundColor Green
        $SNMPInstallStatus | Enable-WindowsOptionalFeature  -Online -NoRestart -Verbose 
    }

Set-Service -Name $SNMPInstallStatus.FeatureName  -StartupType Automatic -Verbose   
Configure_SNMP_Attributes -CommunityString $CommunityString -PermitedManagers $PermitedManagers
Restart-Service -Name SNMP


