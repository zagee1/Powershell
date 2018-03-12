$Users = Import-Csv -Path ".\users.csv"            
foreach ($User in $Users)            
{            
    $Displayname = $User.Firstname
    $UserFirstname = $User.Firstname                    
    $OU = $User.OU            
    $SAM = $User.SAM            
    $UPN = $User.Firstname + "@" + $User.Maildomain            
    $Description = $User.Description            
    $Password = $User.Password            
    New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName $SAM -UserPrincipalName $UPN -GivenName "$UserFirstname" -Description "$Description" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -Path $OU -ChangePasswordAtLogon $false –PasswordNeverExpires $true
}