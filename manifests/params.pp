# == Class: hyper_v::params
class hyper_v::params{

  # init.pp-variables
  $ensure_powershell               = present
  $ensure_tools                    = absent
  $virtual_hard_disks_folder       = "$([environment]::GetFolderPath(\"CommonDocuments\"))\Hyper-V\Virtual Hard Disks"
  $virtual_machines_folder         = "$([environment]::GetFolderPath(\"CommonApplicationData\"))\Microsoft\Windows\Hyper-V"

  # Live-Migration
  $enable                          = true
  $authentication_type             = 'Kerberos'
  $allowed_networks                = undef
  $simultaneous_storage_migrations = 2
  $simultaneous_live_migrations    = 2

}
