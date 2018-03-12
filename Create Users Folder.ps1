Get-ADUser -Filter {Enabled -eq $true} -SearchBase "OU=TEST,DC=ambrosia,DC=local" | foreach-Object{
$sam = $_.SamAccountName
new-item "F:\Users Folder\$sam" -itemtype directory
$rule=new-object System.Security.AccessControl.FileSystemAccessRule ("tdy\$sam","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl = Get-ACL -Path "F:\Users Folder\$sam"          
    $acl.SetAccessRule($rule)            
    Set-ACL -Path "F:\Users Folder\$sam" -ACLObject $acl   
}