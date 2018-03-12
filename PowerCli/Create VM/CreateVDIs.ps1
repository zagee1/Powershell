Function ListMenu ($List, $ListObject, $ListObject2, $NenuTitle, $NenuTitle2, $MsgBeforeSelect){
    $Num=0
    
    if ($ListObject2 -and $NenuTitle2){
        $T = "=" * $NenuTitle.length
        $T2 = "=" * $NenuTitle2.length
        
        Write-Host " $NenuTitle `t `t `t $NenuTitle2 `n $T `t `t $T2 `n" -ForegroundColor Yellow
        
        FOREACH ($Menu in $List) {
            $Num=$Num+1
            Write-Host -ForegroundColor Cyan  $Num")" $Menu.$ListObject "`t `t" $Menu.$ListObject2  
        }
    }
    else {
        $T = "=" * $NenuTitle.length
        
        Write-Host " $NenuTitle `n $T `n" -ForegroundColor Yellow
        
        FOREACH ($Menu in $List) {
            $Num=$Num+1
            Write-Host -ForegroundColor Cyan $Num")" $Menu.$ListObject
        }
    }
    $T = "-" * $MsgBeforeSelect.length
    Write-Host " $MsgBeforeSelect `n $T" -ForegroundColor Yellow
    $chosen = Read-host "Choose A Number"
    if (([int]$chosen -ge 1) -and ([int]$chosen -le $num)) {
        $Return = $List.$ListObject[$chosen-1]
        Write-Host $Return -ForegroundColor Yellow
        Return $Return
    } 
    else { 
        Write-Host "ERROR - No Company chosen or chosen number is out of scope. Nothing to do... `n
        No change mades - Please restart the script" -ForegroundColor Red
        break
    }
}

Clear-Host
Write-Host "Created By - Guy Zagar AKA ZRIZ. Ofek Advanced Technologies 2017.`n
            Loading..." -ForegroundColor Cyan


$myLocation = ListMenu -List (Get-Folder | Where-Object {$_.Parent -like "Domain Env."} |
Sort-Object -Property "Name") -ListObject "Name" -NenuTitle "OU" -MsgBeforeSelect "Select Folder To Create The VDI's In"

#$myResourcePool2 = ListMenu -List (Get-ResourcePool | Where-Object {$_.Parent -like "*Cluster*"}) -ListObject Parent -NenuTitle "Claster" -MsgBeforeSelect "Select A Claster Number"
$myResourcePool = Get-ResourcePool -Id (Get-VM -Location (Get-Folder -Name $myLocation | select -ExpandProperty Name) |select -First 1 -ExpandProperty ResourcePoolId)

$myTemplate = ListMenu -List (Get-Template) -ListObject Name -NenuTitle "Template" -MsgBeforeSelect "Select A Template Number"

$myFullDomain = $myLocation.Split("_")
$myFullDomain = $myFullDomain[1]
$myDomain = $myFullDomain.Split(".")
$myDomain = $myDomain[0]

#$mySpecification = ListMenu -List (Get-OSCustomizationSpec) -ListObject Name -NenuTitle "Customization Specifications" -MsgBeforeSelect "
#Select Your Customization Specification Template Number"
$mySpecification = Get-OSCustomizationSpec | ? {$_.Name -eq $myDomain + "_VDI"}

$tempName = Get-Vm -Name "*VDI*" -Location $myLocation | Sort-Object -Property Name -Descending
$myNetwork = $tempName[0] | Get-NetworkAdapter | Select -ExpandProperty NetworkName
$tempName = $tempName[0].Name
$tempName = $tempName.Split("-")
$dataCenter = $tempName[0]
$compName = $tempName[1]
[int]$i = $tempName[2].Replace("VDI","")
$i = $i + 1

if($myResourcePool.Parent -notlike "NHFA*"){
    $DSname = "Infini*"
}
else {
    $DSname = "HFA_Infini*"
}

$myDatastore = ListMenu -List (Get-Datastore |
    Where-Object {($_.Name -like $DSname) -and 
    ($_.Name -notlike "*Veeam*") -and 
    ($_.Name -notlike "*MBX*") -and 
    ($_.Name -notlike "*Acronis*") -and 
    ($_.FreeSpaceGB -ge 400)} | Sort-Object -Property FreeSpaceGB -Descending) -ListObject Name -ListObject2 FreeSpaceGB -NenuTitle "
    DataStore" -NenuTitle2 "FreeSpace(GB)" -MsgBeforeSelect "Select DataStore To Creat All the VDI's"

Write-Host "How Many VDI's To And?" -ForegroundColor Yellow
[int]$s = Read-Host
$s = $s + $i
for(;$i -lt $s;$i++){
    
    if($i -le  9){     #Add 0 If VDI Number is < 9 (VDI9 >> VDI09)
        $n = '0'+ $i
    }
    else{
        $n = $i
    }
    $myVM = $dataCenter + "-" + $compName + "-" + "VDI" + $n
    Write-Host $myVM
    
    if($myVM.Length -ge 15){
        Write-Warning "The VDI Name Is Exceeded 15 Characters, The NetBIOS Name will Not Be Set. `n Stoping The Script..." -WarningAction Stop
    }
    New-VM -Name $myVM -ResourcePool $myResourcePool -Location $myLocation -Datastore $myDatastore -Template $myTemplate -OSCustomizationSpec $mySpecification
    Get-VM $myVM | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $myNetwork -Confirm:$false
    Start-VM -VM $MyVM
}
