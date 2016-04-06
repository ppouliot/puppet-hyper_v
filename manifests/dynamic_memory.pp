# == Class hyper_v::dynamic_memory
# Disable Dynamic Memory
# ----------------------
# If the Hyper-V or Container Host is itself a Hyper-V Virtual machine, dynamic memory must
# be disabled on the container host virtual machine. This can be configured through
# the settings of the virtual machine, or with the following commands:
#   Diable Command:
#   'Set-VMMemory -VMName <VM Name> DynamicMemoryEnabled $false'
#   Enable Command:
#   'Set-VMMemory -VMName <VM Name> DynamicMemoryEnabled $true'
define hyper_V::dynamic_memory($dm_enable){
  validate_bool(dm_enable)
  exec{'disable_dynamic_memory':
    command   => "Set-VMMemory -VMName ${name} DynamicMemoryEnabled \$${dm_enable}",
    provider  => powershell,
    logoutput => true,
    require   => Class['hyper_v::config']
  }
}
