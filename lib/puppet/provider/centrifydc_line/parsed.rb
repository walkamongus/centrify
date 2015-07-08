require 'puppet/provider/parsedfile'

Puppet::Type.type(:centrifydc_line).provide(
  :parsed,
  :parent => Puppet::Provider::ParsedFile,
  :default_target => '/etc/centrifydc/centrifydc.conf',
  :filetype => :flat
) do
  desc 'The centrifydc_line provider that uses the ParsedFile class'
  
  text_line :comment, :match => /^\s*#/

  text_line :blank, :match => /^\s*$/

  record_line :parsed,
    :fields => %w{setting value},
    :match => /^\s*([\w\.:]+): (.+)$/,
    :to_line  => proc { |h| 
      str = h[:setting]
      str += ': '
      str += h[:value]
      str
    }
end
