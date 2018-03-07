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

begin
  url_metadata = 'http://169.254.169.254/metadata/instance?api-version=2017-08-01'
  metadataraw = open(url_metadata, 'Metadata' => 'true', proxy: false).read
  metadata = JSON.parse(metadataraw)

  Facter.add(:az_metadata) do
    confine :virtual => 'hyperv'
    setcode do
      tags = metadata['compute']['tags'].split(';')
      metadata['compute']['tags'] = Hash[tags.map { |tag| tag.split(':', 2) }]
      metadata
    end
  end

rescue
  warn 'Unable to resolve az_metadata - This is not an Azure instance or unable to contact the Azure instance-data web server.'
end
