param([string]$vmname, [uint64]$ram, [uint64]$vhdsize, [string]$mac, [string]$vhdpath)

$vmswitch = (Get-VMSwitch)[0]

$vm = new-VM $vmname -MemoryStartupBytes $ram -NewVHDPath $vhdpath -NewVHDSize $vhdsize
$vm | Add-VMNetworkAdapter -IsLegacy 1 -StaticMacAddress $mac

Connect-VMNetworkAdapter $vm.Name -SwitchName $vmswitch.Name
Start-VM $vm
