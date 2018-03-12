#Invoke-Command -ComputerName (Get-ADComputer -Filter * -SearchBase 'OU=VDIs,DC=CYP,DC=local' | Select-Object -ExpandProperty Name) -FilePath .\Install-Adobe_DC.ps1
# Silent install Adobe Reader DC
# https://get.adobe.com/nl/reader/enterprise/

# Path for the workdir
$workdir = "c:\installer\"

# Check if work directory exists if not create it

If (Test-Path -Path $workdir -PathType Container)
{ Write-Host "$workdir already exists" -ForegroundColor Red}
ELSE
{ New-Item -Path $workdir  -ItemType directory }

# Download the installer

$source = "http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/1502320053/AcroRdrDC1502320053_en_US.exe"
$destination = "$workdir\adobeDC.exe"
Invoke-WebRequest $source -OutFile $destination

# Start the installation

Start-Process -FilePath "$workdir\adobeDC.exe" -ArgumentList "/sPB /rs"

# Wait XX Seconds for the installation to finish

Start-Sleep -s 35

# Remove the installer

rm -Force $workdir\adobe*