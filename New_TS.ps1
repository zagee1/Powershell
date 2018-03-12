$OfficeVer = Read-Host -Prompt "what office version to instal (2016\2013)?"
$Drive = Read-Host -Prompt "where to create the Public & User Folder  (C\D\E...)?"
Import-Module ServerManager
Get-WindowsFeature | Where-Object {$_.Installed -match “True”} | Select-Object -ExpandProperty Name | Write-Host

Add-WindowsFeature File-Services,FS-FileServer,FS-Search-Service,Remote-Desktop-Services,RDS-RD-Server,RDS-Licensing,Desktop-Experience,Ink-Handwriting,IH-Ink-Support,RSAT,RSAT-Role-Tools,RSAT-RDS,RSAT-RDS-RemoteApp,RSAT-RDS-Licensing,SNMP-Services,SNMP-Service,Telnet-Client

Add-WindowsFeature Remote-Desktop-Services,RDS-Licensing,RDS-Licensing-UI,RDS-Licensing,SNMP-Service,RDS-RD-Server

New-Item -Path $Drive":\" -Name Public -ItemType "directory"
New-Item -Path $Drive":\" -Name "Users Folder" -ItemType "directory"

# Build a Public Shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\Public.lnk")
$Shortcut.IconLocation = "%SystemRoot%\system32\imageres.dll, 169"
$Shortcut.TargetPath = $Drive+":\Public"
$Shortcut.Save()

# Build a Users Folder Shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\Users Folder.lnk")
$Shortcut.IconLocation = "%SystemRoot%\system32\imageres.dll, 117"
$Shortcut.TargetPath = $Drive+":\Users Folder"
$Shortcut.Save()



$CT = "C:\Users\Public\Desktop\"
If ($OfficeVer -eq 2013){# Ofiice 2013

    Copy-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2013\Excel 2013.lnk" -Destination $CT
    Copy-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2013\Outlook 2013.lnk" -Destination $CT
    Copy-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2013\PowerPoint 2013.lnk" -Destination $CT
    Copy-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2013\Word 2013.lnk" -Destination $CT
}
If ($OfficeVer -eq 2016){#Office 2016

    Copy-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel 2016.lnk" -Destination $CT
    Copy-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook 2016.lnk" -Destination $CT
    Copy-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint 2016.lnk" -Destination $CT
    Copy-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word 2016.lnk" -Destination $CT
    }

if ([Environment]::OSVersion.Version.Major -eq 6){#Server 2008R2
    Copy-Item -Path "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Internet Explorer.lnk" -Destination $CT
}


if ([Environment]::OSVersion.Version.Major -eq 10){#Server 2016
    Copy-Item -Path "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Accessories\Internet Explorer.lnk" -Destination $CT
}
#New-LocalUse
$password = ConvertTo-SecureString -String (Read-Host -Prompt "password") -AsPlainText -Force
New-LocalUser -Name (read-host -Prompt "user:") -Password $password -PasswordNeverExpires
Add-LocalGroupMember -Member (Get-LocalUser | ? {$_.Description -eq ""}) -Group "Remote Desktop Users"

#Users Folder
Get-LocalUser | ? {$_.Description -eq ""} | foreach-Object{
$sam = $_.Name
new-item "E:\Users Folder\$sam" -itemtype directory
$rule=new-object System.Security.AccessControl.FileSystemAccessRule ("$sam","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl = Get-ACL -Path "E:\Users Folder\$sam"          
    $acl.SetAccessRule($rule)            
    Set-ACL -Path "E:\Users Folder\$sam" -ACLObject $acl   
}