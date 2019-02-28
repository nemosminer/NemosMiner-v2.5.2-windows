if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}
 
$Path = ".\Bin\NVIDIA-Ethminer018rc0\ethminer.exe"
$Uri = "https://github.com/ethereum-mining/ethminer/releases/download/v0.18.0-rc.0/ethminer-0.18.0-rc.0-cuda10.0-windows-amd64.zip"
$Commands = [PSCustomObject]@{
    #"ethash" = "" #Ethash
}
$Port = $Variables.NVIDIAMinerAPITCPPort
$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
	$Algo = Get-Algorithm($_)
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "--cuda-devices $($Config.SelGPUDSTM) --api-port -$Port -U -P stratum://$($Pools.($Algo).User):x@$($Pools.($Algo).Host):$($Pools.($Algo).Port)$($Commands.$_)"
        HashRates = [PSCustomObject]@{($Algo) = $Stats."$($Name)_$($Algo)_HashRate".Day} 
        API       = "ethminer"
        Port      = $Variables.NVIDIAMinerAPITCPPort
        Wrap      = $false
        URI       = $Uri    
        User      = $Pools.($Algo).User
        Host = $Pools.($Algo).Host
        Coin = $Pools.($Algo).Coin
    }
}
