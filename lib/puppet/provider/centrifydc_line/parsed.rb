require 'puppet/provider/parsedfile'

target = '/etc/centrifydc/centrifydc.conf'

Puppet::Type.type(:centrifydc_line).provide(
  :parsed,
  :parent => Puppet::Provider::ParsedFile,
  :default_target => target,
  :filetype => :flat
) do
  desc 'The centrifydc_line provider that uses the ParsedFile class'
  
  text_line :comment, :match => /^\s*#/

  text_line :blank, :match => /^\s*$/

  record_line :parsed, :fields => %w{setting value}, :separator => /\s*:\s+/
end
