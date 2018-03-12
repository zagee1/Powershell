function Create-Object ($LogonDate, $SessionTime){
    $properties = [ordered]@{ LogonDate = $LogonDate
                              SessionTime = $SessionTime
                            }
    $object = New-Object -TypeName PSObject -Property $properties
    return $object
}

param
	(
		[Parameter(ParameterSetName="Name")]
		[String]$Name

	)

if($Name -eq $null){
    $Name = Read-Host -Prompt "Give Me User Name And I Will Show You How Long He Was Connected And When"
}
# ID 24 = Connect, ID 25 = Disconnect

$allEvents = Get-WinEvent -LogName Microsoft-Windows-TerminalServices-LocalSessionManager/Operational -Oldest |
    ? {$_.Id -eq 25 -or $_.Id -eq 24 -and $_.Message -like "*User:*$Name*"} | Select-Object TimeCreated,Id

for($i=0;$allEvents[$i];$i=$i+2){

    if($allEvents[$i].Id -eq 25 -and $allEvents[$i+1]){
        
        $eventDate = $allEvents[$i].TimeCreated.ToShortDateString()
    
        $totalTime = $allEvents[$i+1].TimeCreated - $allEvents[$i].TimeCreated
<#        
        $totalTime = [string]$totalTime
        $totalTime = $totalTime.Split(".")
        if($totalTime[2]){
            $totalTime = $totalTime[0] + ":" + $totalTime[1]
        }
        else {
            $totalTime = $totalTime[0]
        }
        #>
        Create-Object -LogonDate $eventDate -SessionTime $totalTime
    }
    else{
     $i++
    }
}
