# == Class: hyper-v::tools::createvm
class hyper_v::tools::createvm {
  $powershell_path  = 'c:\\Windows\\sysnative\\WindowsPowerShell\\v1.0\\'
  $path_extend      = 'c:\\Windows;c:\\Windows\\sysnative;c:\\Windows\\sysnative\\Wbem'
  $drive_letter     = 'p:'
  $quartermaster_ip = '10.21.7.1'
  $pxecfg           = 'pxe-cfg'
  $unc              = "\\\\${quartermaster_ip}\\${pxecfg}"
  $hwtype           = '01'
  $vmfiles          = [ 'c:/vm/','c:/vm/bin','c:/vm/vhd',]
  $ram              = 1073741824
  $vhdsize          = 21474836480
  $macaddress       = '00-15-5d-d4-97-20'
  $mac              = regsubst($macaddress, '(\-)','','G')
  $path             = "${powershell_path};${path_extend};${::path}"

  file {$vmfiles:
    ensure => directory,
  }
  file { 'create_vm.ps1':
    ensure  => file,
    path    => 'c:/vm/bin/create_vm.ps1',
    source  => 'puppet:///modules/createvm/create_vm.ps1',
    require => File['c:/vm/bin'],
  }
  exec { 'mount':
    command => "c:/windows/system32/net.exe use ${drive_letter} \\\\${quartermaster_ip}\\${pxecfg} /persist:yes",
  }
  exec { 'unmount':
    command => "c:/windows/system32/net.exe use ${drive_letter} /delete",
    require => File['macaddr_file'],
  }

  file { 'macaddr_file':
    ensure  => file,
    path    => "p:/${hwtype}-${::macaddress}",
    content => template('createvm/mac.erb'),
    require => Exec['mount'],
    #notify => Exec['unmount'],
  }
  exec { 'create_vm':
    command => "${powershell_path}\\powershell.exe -executionpolicy remotesigned -File c:/vm/bin/create_vm.ps1 -vmname ${mac} -ram ${ram} -vhdsize ${vhdsize} -mac ${mac} -vhdpath c:/vm/vhd/${mac}.vhdx",
    cwd     => 'c:/vm/vhd',
    creates => "c:/vm/vhd/${mac}vhd",
    require =>  File['create_vm.ps1','c:/vm/vhd'],
  }

#exec { 'new-vm':
#  command     => "${powershell_path}\\powershell.exe -executionpolicy remotesigned -Command New-VM -Name ctrl-test -ComputerName ctrl-test -MemoryStartupBytes 1 GB -BootDevice LegacyNetworkAdapter -NewVHDPath c:\\vm\vhd\\testvm.vhdx -NewVHDSize 20 GB -Path c:\\vm\\vhd",
#  cwd	    => "c:/vm/vhd",
#  creates     => "c:/vm/vhd/testvm.vhdx",
#  require     =>  File['create_vm.ps1',"c:/vm/vhd"],
#  refreshonly => true,
#}

}
