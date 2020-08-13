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

Facter.add(:az_metadata) do
  confine Facter::value(:cloud)['provider'] => 'azure'
  setcode do
    url_metadata = 'http://169.254.169.254/metadata/instance?api-version=2020-06-01'
    metadataraw = open(url_metadata, 'Metadata' => 'true', 'User-Agent' => 'Puppet', proxy: false).read
    metadata = JSON.parse(metadataraw)
    tags = metadata['compute']['tags'].split(';')
    metadata['compute']['tags'] = Hash[tags.map { |tag| tag.split(':', 2) }]
    metadata
  end
end
