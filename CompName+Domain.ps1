Rename-Computer -NewName "Server044" -DomainCredential Domain01\Admin01 -Force
$domain = "fmarket.local"
$password = "GMUMn0w!" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\administrator" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential