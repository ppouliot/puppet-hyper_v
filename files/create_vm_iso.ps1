param([string]$vmname, [int]$ram, [int]$vhdsize, [string]$mac, [string]$vhdpath, [string]$isopath)

$vmswitch = (Get-VMSwitch)[0]

$vm = new-VM $vmname -MemoryStartupBytes $ram -NewVHDPath $vhdpath -NewVHDSize $vhdsize
$vm | Set-VMNetworkAdapter -StaticMacAddress $mac

Set-VMDvdDrive $vm.Name -Path $isopath
Connect-VMNetworkAdapter $vm.Name -SwitchName $vmswitch.Name
Start-VM $vm
