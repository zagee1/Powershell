function Split-UserColumn ($Path, $UserNameColumn) {
    $file = Import-Csv -Path $Path
    $properties = @{'GivenName' = $GivenName
                    'SN' = $SN
    }
    try {
        $file.$UserNameColumn | ForEach-Object {
        $_ = $_.trim()
        $Name = $_.Split(" ")
        $obj = New-Object -TypeName PSObject -Property $properties
        $obj.GivenName = $Name[0].substring(0,1).toupper()+$Name[0].substring(1).tolower()
        $obj.SN = $Name[1].substring(0,1).toupper()+$Name[1].substring(1).tolower()
        write-output $obj
        }
    }
        catch {
    }
}
