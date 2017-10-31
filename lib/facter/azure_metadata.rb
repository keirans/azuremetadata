#
# Azure Metadata Fact
# Keiran Sweet <keiran@gmail.com>
# ---------------------------------
# This fact exposes the Azure metadata as a Puppet fact in the az_metadata
# namespace.
#
# As there is no consistent way to contain the fact to azure right now we
# do it to hyperv for the time being. See the README for more information.
#

require 'open-uri'
require 'json'

url_metadata = 'http://169.254.169.254/metadata/instance?api-version=2017-08-01'
metadataraw = open(url_metadata, 'Metadata' => 'true', proxy: false).read
metadata = JSON.parse(metadataraw)

Facter.add(:compute) do
  confine virtual: 'hyperv'
  setcode do
    tags = metadata['compute']['tags'].split(';')
    metadata['compute']['tags'] = Hash[tags.map { |tag| tag.split(':') }]
    metadata['compute']
  end
end

Facter.add(:network) do
  confine virtual: 'hyperv'
  setcode do
    metadata['network']
  end
end
