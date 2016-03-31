# === Class: hyper_v
#
# This module contains basic configuration tasks for Microsoft Hyper-V
#
# === Parameters
#
# [*ensure_powershell*]
#   Specify if the Hyper-V Module for Windows PowerShell will be installed
#   in the host. Defaults to present. Valid values are: absent/present.
#
# [*ensure_tools*]
#   Specify if the Hyper-V GUI Management Tools are installed. Defaults
#   to absent. Valid values are: absent/present.
#
# [*virtual_hard_disks_folder*]
#   Specify the default folder to store virtual hard disk files.
#
# [*virtual_machines_folder*]
#   Specify the default folder to store virtual machines configuration files.
#
# [*enable*]
#   Specify if the migration should be
#   enabled or not in the hypervisor
#
# [*authentication_type*]
#   Determine the authentication method
#   used for migration: 'Kerberos' or 'CredSSP'
#
# [*allowed_networks*]
#   Contains a comma separated list of the
#   networks allowed to perform the migration.
#   If this value is undef, any network will
#   be allowed to perform the live migration.
#
# [*simultaneous_storage_migrations*]
#   Number of simultaneous storage migrations
#
# [*simultaneous_live_migrations*]
#   Number of simultaneous live migrations
#
# == Examples
#
#  class { 'hyper_v': }
#
#  class { 'hyper_v':
#    ensure_powershell => present,
#    ensure_tools      => present,
#  }
#
# class { 'hyper_v':
#    ensure_powershell         => present,
#    ensure_tools              => present,
#    virtual_hard_disks_folder => 'D:\Hyper-V-Disks',
#    virtual_machines_folder   => 'D:\Hyper-V',
#  }
#
# == Authors
#
class hyper_v (

  $ensure                          = $hyper_v::params::ensure,
  $hyperv_powershell               = $hyper_v::params::hyperv_powershell,
  $hyperv_tools                    = $hyper_v::params::hyperv_tools,
  $virtual_hard_disks_folder       = $hyper_v::params::virtual_hard_disks_folder,
  $virtual_machines_folder         = $hyper_v::params::virtual_machines_folder,
  $enable                          = $hyper_v::params::enable,
  $authentication_type             = $hyper_v::params::authentication_type,
  $allowed_networks                = $hyper_v::params::allowed_networks,
  $simultaneous_storage_migrations = $hyper_v::params::simultaneous_storage_migrations,
  $simultaneous_live_migrations    = $hyper_v::params::simultaneous_live_migrations

){

  windows_feature{'Hyper-V':
    ensure  => $hyper_v::ensure,
    restart => true,
  }

  if $hyper_v::hyperv_tools {
    windows_feature{'Hyper-V-Tools':
      ensure  => $hyper_v::ensure,
      require => Windows_feature['Hyper-V'],
    }
  }
  if $hyper_v::hyperv_powershell {
    windows_feature{'Hyper-V-PowerShell':
      ensure  => $hyper_v::ensure,
      require => Windows_feature['Hyper-V'],
    }
  }


  #
  # Configure the host folders
  #
  exec{ 'ensure-virtual-hard-disk-folder':
    command  => "Set-VMHost -VirtualHardDiskPath \"${virtual_hard_disks_folder}\"",
    unless   => "if ((Get-VMHost).VirtualHardDiskPath -ne \"${virtual_hard_disks_folder}\") { exit 1 }",
    provider => powershell,
    require  => Windows_feature['Hyper-V'],
  }

  exec{ 'ensure-virtual-machines-folder':
    command  => "Set-VMHost -VirtualMachinePath \"${virtual_machines_folder}\"",
    unless   => "if ((Get-VMHost).VirtualMachinePath -ne \"${virtual_machines_folder}\") { exit 1 }",
    provider => powershell,
    require  => Windows_feature['Hyper-V'],
  }
}
