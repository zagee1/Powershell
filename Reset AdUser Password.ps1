Get-ADUser -Filter * -SearchBase "OU=TEST,DC=ambrosia,DC=local" | Set-ADAccountPassword -Rese
t -NewPassword (Read-Host -AsSecureString "Enter NewPass For all Users")

Get-ADUser -Filter * -SearchBase "OU=TEST,DC=ambrosia,DC=local" | Set-ADUser –ChangePasswordAtLogon $true -PasswordNeverExpires $false

















