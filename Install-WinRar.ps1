#Invoke-Command -ComputerName (Get-ADComputer -Filter * -SearchBase 'OU=VDIs,DC=CYP,DC=local' | Select-Object -ExpandProperty Name) -FilePath .\Install-WinRar.ps1
# Silent Install Winrar
# http://www.winrar.com

# Path for the workdir
$workdir = "c:\installer\"

# Check if work directory exists if not create it

If (Test-Path -Path $workdir -PathType Container)
{ Write-Host "$workdir already exists" -ForegroundColor Red}
ELSE
{ New-Item -Path $workdir  -ItemType directory }

# Download the installer

$source = "http://rarlab.com/rar/winrar-x64-540.exe"
$destination = "$workdir\winrar.exe"
Invoke-WebRequest $source -OutFile $destination

# Start the installation

Start-Process -FilePath "$workdir\winrar.exe" -ArgumentList "/S"

# Wait XX Seconds for the installation to finish

Start-Sleep -s 35

# Remove the installer

rm -Force $workdir\w*

$Hostname = hostname
Write-Host "Installation Complaint On $Hostname"