puppet-hyper_v
==============
This module contains basic configuration tasks for Microsoft Hyper-V. It is still a work in progress project with the following implemented functionality:

 1. Install Hyper-V role.
 2. Install additional features: Hyper-V module for PowerShell and GUI management tools.
 3. Configure live migration parameters.
 4. Create and configure virtual switches.

Basic usage
-----------
The basic scenario allows the user to configure the **Hyper-V role** and the additional tools:

    class { 'hyper_v':
      ensure_powershell => present,
      ensure_tools      => present,
    }

To configure **live migration** parameters, an specific class is provided:

    class { 'hyper_v::live_migration':
      enabled                      => true,
      authentication_type          => 'Kerberos',
      simultaneous_live_migrations => 3,
    }

Finally, a custom type has been implemented to define **virtual switches** in Hyper-V:

    virtual_switch { 'test switch':
      notes             => 'Switch bound to main address fact',
      type              => External,
      os_managed        => true,
      interface_address => $::ipaddress,
    }


Contributors
------------
 * Peter Pouliot <peter@pouliot.net>
 * Luis Fernandez Alvarez <luis.fernandez.alvarez@cern.ch>
 * Octavian Ciuhandu <ociuhandu@cloudbasesolutions.com>
 * Vijay Tripathi 
 * Tim Rogers

Copyright and License
---------------------

Copyright (C) 2013 Peter J. Pouliot

Peter Pouliot can be contacted at: peter@pouliot.net

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

