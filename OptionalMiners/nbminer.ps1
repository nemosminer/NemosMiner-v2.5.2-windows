if (!(IsLoaded(".\Includes\include.ps1"))) { . .\Includes\include.ps1; RegisterLoaded(".\Includes\include.ps1") }

$Path = ".\Bin\NVIDIA-nbminer252\nbminer.exe"
$Uri = "https://github.com/NebuTech/NBMiner/releases/download/v25.2/NBMiner_25.2_Win.zip"

$Commands = [PSCustomObject]@{
    #"grincuckatoo31" = " -a cuckatoo -o nicehash+tcp://" #grincuckatoo31 (8gb cards work win7,8, 8.1 & Linux. Win10 requires 10gb+vram)
    "grincuckarood29" = " -a cuckarood -o nicehash+tcp://" #grincuckaroo29
    #"grincuckaroo29"  = " -a cuckaroo -o nicehash+tcp://" #grincuckaroo29
    #"cuckoocycle"     = " -a cuckoo_ae -o nicehash+tcp://" #cuckoocycle  
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    $Algo = Get-Algorithm($_)
    switch ($_) {
        "ethash" { $Fee = 0.0065 }
        default { $Fee = 0.02 }
    }
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "$($Commands.$_)$($Pools.($Algo).Host):$($Pools.($Algo).Port) -no-nvml --cuckoo-intensity 0 --api 127.0.0.1:$($Variables.NVIDIAMinerAPITCPPort) -d $($Config.SelGPUCC) -u $($Pools.($Algo).User):$($Pools.($Algo).Pass)"
        HashRates = [PSCustomObject]@{($Algo) = $Stats."$($Name)_$($Algo)_HashRate".Day * (1 - $Fee) } # substract devfee
        API       = "NBMiner"
        Port      = $Variables.NVIDIAMinerAPITCPPort #4068
        Wrap      = $false
        URI       = $Uri
        User      = $Pools.($Algo).User
        Host      = $Pools.($Algo).Host
        Coin      = $Pools.($Algo).Coin
    }
}
