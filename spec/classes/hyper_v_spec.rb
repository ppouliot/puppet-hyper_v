require 'spec_helper'

describe 'hyper_v', :type => :class do

  context "on Windows platforms" do

    let(:facts) {{ :osfamily => 'windows' }}

    context "with defaults parameters" do
      it {
        should contain_windows_common__configuration__feature('Hyper-V').with( {'ensure'=>'present'})
        should contain_windows_common__configuration__feature('Hyper-V-Tools').with( {'ensure' => 'absent'} )
        should contain_windows_common__configuration__feature('Hyper-V-PowerShell').with( {'ensure' => 'present'} )
      }
    end

    context "with ensure_powershell => absent" do
      let(:params) {{:ensure_powershell => 'absent'}}

      it {
        should contain_windows_common__configuration__feature('Hyper-V').with( {'ensure'=>'present'})
        should contain_windows_common__configuration__feature('Hyper-V-Tools').with( {'ensure' => 'absent'} )
        should contain_windows_common__configuration__feature('Hyper-V-PowerShell').with( {'ensure' => 'absent'} )
      }
    end

    context "with ensure_tools => present" do
      let(:params) {{:ensure_tools => 'present'}}

      it {
        should contain_windows_common__configuration__feature('Hyper-V').with( {'ensure'=>'present'})
        should contain_windows_common__configuration__feature('Hyper-V-Tools').with( {'ensure' => 'present'} )
        should contain_windows_common__configuration__feature('Hyper-V-PowerShell').with( {'ensure' => 'present'} )
      }
    end

    context "with ensure_tools => not present nor absent" do
      let(:params) {{:ensure_tools => 'ok'}}
      it {
        expect { should raise_error(Puppet::Error) }
      }
    end

    context "with ensure_powershell => not present nor absent" do
      let(:params) {{:ensure_powershell => 'ok'}}
      it {
        expect { should raise_error(Puppet::Error) }
      }
    end
  end

  context "on an unsupported OS" do
    let (:facts) {{ :osfamily => 'linux' }}

    it {
      expect { should raise_error(Puppet::Error) }
    }
  end
end
