FROM msopenstack/sentinel-windowsservercore
RUN puppet module install puppetlabs-stdlib
RUN puppet module install puppetlabs-powershell
RUN puppet module install puppet-windowsfeature
