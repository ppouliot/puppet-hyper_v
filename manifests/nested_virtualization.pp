# == Class: hyper_v::nested_virtualization
#
# Hyper-V Nested Virtualization
# ---------------------
# If hyper-v or container features will be running on a Hyper-V virtual machine, and will
# also be hosting Hyper-V VMs or Containers, nested virtualization needs to be enabled.
# This can be completed with the following PowerShell command.
define hyper_v::nested_virtualization($expose_virtualization_extensions) { 
  validate_re($name,'You must name a valid virtual machine name on this host')
  validate_bool($expose_virtual_extensions)
  exec{"configure_nested_virtualization-${name}":
    command   => "Set-VMProcessor -VMName ${name} -ExposeVirtualizationExtensions \$${expose_virtualization_extensions}",
    provider  => powershell,
    logoutput => true,
    require   => Class['windows_container::config']
  }
}


