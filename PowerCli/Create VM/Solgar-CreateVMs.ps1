$CSV = Import-Csv .\solgar-servers.csv
$vHOST = "172.16.18.113"
$FOLDER = "Solgar.local"
$DS = "Infini_VMFS25"
$NETWORK = "Solgar_Host_10G"

$CSV | ForEach-Object { 
    
    # Create VM
    New-VM -VMHost $vHOST -Version v8 -Name $_.VMname -GuestId $_.OS -Location $FOLDER -Datastore $DS -DiskGB $_.HD1 -MemoryGB $_.RAM -NumCpu 1  -CD
    
    $GVM = Get-VM -Name $_.VMname
    
    # Set NIC's
    $GVM | Get-NetworkAdapter | Set-NetworkAdapter -Type Vmxnet3 -NetworkName $NETWORK -MacAddress $_.MAC1
    
    If($_.MAC2){
        $GVM | New-NetworkAdapter -NetworkName $NETWORK -MacAddress $_.MAC2 -Type Vmxnet3
    }
    # Set Storage
    If ($_.HD2){
        $GVM | New-HardDisk -CapacityGB $_.HD2
    }
    If ($_.HD3){
        $GVM | New-HardDisk -CapacityGB $_.HD3
    }
    # Set CPU 
    $TotalvCPU = [INT]$_.CPU * [INT]$_.Core

    $spec = New-Object –Type VMware.Vim.VirtualMAchineConfigSpec –Property @{“NumCoresPerSocket” = $_.Core}
    ($GVM).ExtensionData.ReconfigVM_Task($spec)
    $GVM | set-vm -numcpu $TotalvCPU
}

