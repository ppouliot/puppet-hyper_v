# == Class hyper_v::mac_address_spoofing
# Mac Address Spoofing
# --------------------
# If the container host is running inside of a Hyper-V virtual machine,
# MAC spoofing must be enabled. This allows each container to receive an IP Address.
# To enable MAC address spoofing, run the following command on the Hyper-V host.
# The VMName property will be the name of the container host.
define hyper_v::mac_address_spoofing($spoofing){
  validate_re($spoofing, '^(On|Off)$', 'valid values for spoofing are \'On\' or \'Off\'')
  exec{"configure_mac_address_spoofing-${name}":
    command   => "Get-VMNetworkAdapter -VMName ${name} | Set-VMNetworkAdapter -MacAddressSpoofing ${spoofing}",
    provider  => powershell,
    logoutput => true,
    require   => Class['hyper_v::config']
  }
}


