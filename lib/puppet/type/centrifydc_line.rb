Puppet::Type.newtype(:centrifydc_line) do
  @doc = "Manage the contents of the centrifydc.conf file
  centrifydc_line { 'log':
    ensure => present,
    value  => 'INFO',
  }"

  ensurable

  newparam(:setting, :namevar => true) do
    desc 'The configuration setting to manage'
  end

  newproperty(:value) do
    desc 'The value for the configuration setting'
    newvalues(/^[\.\w]+:?[\.\w]*$/)
  end

  newproperty(:target) do
    desc 'Location of the centrifydc.conf file'
    defaultto {
      if @resource.class.defaultprovider.ancestors.include? (Puppet::Provider::ParsedFile)
        @resource.class.defaultprovider.default_target
      else
        nil
      end
    }
  end
end
