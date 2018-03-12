$colRights = [System.Security.AccessControl.FileSystemRights]"ReadData, AppendData, Synchronize" 

$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit 
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::NoPropagateInherit 

$objType =[System.Security.AccessControl.AccessControlType]::Allow 

$objUser = New-Object System.Security.Principal.NTAccount("obiz\Domain Users") 

$objACE = New-Object System.Security.AccessControl.FileSystemAccessRule `
    ($objUser, $colRights, $InheritanceFlag, $PropagationFlag, $objType) 

$objACL = Get-ACL "C:\TEST" 
$objACL.AddAccessRule($objACE) 

Set-ACL "C:\Test" $objACL
