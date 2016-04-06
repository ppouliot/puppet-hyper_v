# === Class: hyper_v::folders
#
# This module contains basic foldersmen and configuration tasks for Microsoft Hyper-V
#
class hyper_v::folders () inherits hyper_v::params {
  #
  # Configure the host folders
  #
  exec{ 'ensure-virtual-hard-disk-folder':
    command  => "Set-VMHost -VirtualHardDiskPath \"${hyper_v::virtual_hard_disks_folder}\"",
    unless   => "if ((Get-VMHost).VirtualHardDiskPath -ne \"${hyper_v::virtual_hard_disks_folder}\") { exit 1 }",
    provider => powershell,
    require  => Class['hyper_v::deploy'],
  }

  exec{ 'ensure-virtual-machines-folder':
    command  => "Set-VMHost -VirtualMachinePath \"${hyper_v::virtual_machines_folder}\"",
    unless   => "if ((Get-VMHost).VirtualMachinePath -ne \"${hyper_v::virtual_machines_folder}\") { exit 1 }",
    provider => powershell,
    require  => Class['hyper_v::deploy'],
  }

}
