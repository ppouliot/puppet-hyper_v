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
}
