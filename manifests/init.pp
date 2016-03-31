# === Class: hyper_v
#
# This module contains basic configuration tasks for Microsoft Hyper-V
#
# === Parameters
#
# [*ensure_powershell*]
#   Specify if the Hyper-V Module for Windows PowerShell will be installed
#   in the host. Defaults to present. Valid values are: absent/present.
# [*ensure_tools*]
#   Specify if the Hyper-V GUI Management Tools are installed. Defaults
#   to absent. Valid values are: absent/present.
# [*virtual_hard_disks_folder*]
#   Specify the default folder to store virtual hard disk files.
# [*virtual_machines_folder*]
#   Specify the default folder to store virtual machines configuration files.
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

  $ensure_powershell         = $hyper_v::params::ensure_powershell,
  $ensure_tools              = $hyper_v::params::ensure_tools,
  $virtual_hard_disks_folder = $hyper_v::params::virtual_hard_disks_folder
  $virtual_machines_folder   = $hyper_v::params::virtual_machines_folder

){

  windows_common::configuration::feature { 'Hyper-V':
    ensure => present,
  }

  exec {'Hyper-V Restart':
    command     => 'shutdown.exe /r /t 0',
    path        => $::path,
    refreshonly => true,
    subscribe   => Windows_common::Configuration::Feature['Hyper-V'],
  }

  windows_common::configuration::feature { 'Hyper-V-Tools':
    ensure  => $ensure_tools,
    require => Windows_common::Configuration::Feature['Hyper-V'],
  }

  windows_common::configuration::feature { 'Hyper-V-PowerShell':
    ensure  => $ensure_powershell,
    require => Windows_common::Configuration::Feature['Hyper-V'],
  }

  #
  # Configure the host folders
  #
  exec{ 'ensure-virtual-hard-disk-folder':
    command  => "Set-VMHost -VirtualHardDiskPath \"${virtual_hard_disks_folder}\"",
    unless   => "if ((Get-VMHost).VirtualHardDiskPath -ne \"${virtual_hard_disks_folder}\") { exit 1 }",
    provider => powershell,
    require  => Windows_common::Configuration::Feature['Hyper-V'],
  }

  exec{ 'ensure-virtual-machines-folder':
    command  => "Set-VMHost -VirtualMachinePath \"${virtual_machines_folder}\"",
    unless   => "if ((Get-VMHost).VirtualMachinePath -ne \"${virtual_machines_folder}\") { exit 1 }",
    provider => powershell,
    require  => Windows_common::Configuration::Feature['Hyper-V'],
  }
}
