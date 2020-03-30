If (-not (IsLoaded(".\Includes\include.ps1"))) { . .\Includes\include.ps1; RegisterLoaded(".\Includes\include.ps1") }

$Path = ".\Bin\CPU-ccminerverushash37\ccminer.exe"
$Uri = "https://github.com/Minerx117/ccminer-Verus/releases/download/3.7/ccminer3_7.7z"
$Commands = [PSCustomObject]@{ 
   #"verus"     = "" #Verus
    "verushash" = "" #Verushash
}
$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName
$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object { 
    switch ($_) { 
        default { $ThreadCount = $Variables.ProcessorCount - 1 }
    }
    $Algo = Get-Algorithm($_)
    [PSCustomObject]@{ 
        Type      = "CPU"
        Path      = $Path
        Arguments = "-t $($ThreadCount) -N 1 -R 1 -b $($Variables.CPUMinerAPITCPPort) -o stratum+tcp://$($Pools.$Algo.Host):$($Pools.$Algo.Port) -a verus -u $($Pools.$Algo.User) -p $($Pools.$Algo.Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{$Algo = $Stats."$($Name)_$($Algo)_HashRate".Week }
        API       = "ccminer"
        Port      = $Variables.CPUMinerAPITCPPort
        Wrap      = $false
        URI       = $Uri
        User      = $Pools.$Algo.User
        Host      = $Pools.$Algo.Host
        Coin      = $Pools.$Algo.Coin
    }
}
