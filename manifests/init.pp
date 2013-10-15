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
# == Authors
#
class hyper_v (
  $ensure_powershell = present,
  $ensure_tools      = absent,
){

  windows_common::feature { 'Hyper-V':
    ensure => present,
  }

  exec {'Hyper-V Restart':
    command     => "shutdown.exe /r /t 0",
    path        => $::path,
    refreshonly => true,
    subscribe   => Windows_common::Feature['Hyper-V']
  }

  windows_common::configuration::feature { 'Hyper-V-Tools':
     ensure  => $ensure_tools,
     require => Windows_common::Feature['Hyper-V'],
  }

  windows_common::configuration::feature { 'Hyper-V-PowerShell':
     ensure  => $ensure_powershell,
     require => Windows_common::Feature['Hyper-V'],
  }
}
