# === Class: hyper_v::deploy
#
# This module contains basic deploymen and configuration tasks for Microsoft Hyper-V
#
class hyper_v::deploy () inherits hyper_v::params {

  windowsfeature{'Hyper-V':
    ensure  => $hyper_v::ensure,
    restart => true,
  }

  if $hyper_v::hyperv_tools {
    windowsfeature{'Hyper-V-Tools':
      ensure  => $hyper_v::ensure,
      require => Windowsfeature['Hyper-V'],
    }
  }
  if $hyper_v::hyperv_powershell {
    windowsfeature{'Hyper-V-PowerShell':
      ensure  => $hyper_v::ensure,
      require => Windowsfeature['Hyper-V'],
    }
  }


  #
  # Configure the host folders
  #
  exec{ 'ensure-virtual-hard-disk-folder':
    command  => "Set-VMHost -VirtualHardDiskPath \"${virtual_hard_disks_folder}\"",
    unless   => "if ((Get-VMHost).VirtualHardDiskPath -ne \"${virtual_hard_disks_folder}\") { exit 1 }",
    provider => powershell,
    require  => Windowsfeature['Hyper-V'],
  }

  exec{ 'ensure-virtual-machines-folder':
    command  => "Set-VMHost -VirtualMachinePath \"${virtual_machines_folder}\"",
    unless   => "if ((Get-VMHost).VirtualMachinePath -ne \"${virtual_machines_folder}\") { exit 1 }",
    provider => powershell,
    require  => Windowsfeature['Hyper-V'],
  }

}
