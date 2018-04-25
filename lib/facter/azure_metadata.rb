#
# Azure Metadata Fact
# Keiran Sweet <keiran@gmail.com>
# ---------------------------------
# This fact exposes the Azure metadata as a Puppet fact in the az_metadata
# namespace.
#

require 'open-uri'
require 'json'

begin
  Facter.add(:az_metadata) do
    confine :cloud do |value|
      value['provider'] == 'azure'
    end
    setcode do
      url_metadata = 'http://169.254.169.254/metadata/instance?api-version=2017-12-01'
      metadataraw = open(url_metadata, 'Metadata' => 'true', proxy: false).read
      metadata = JSON.parse(metadataraw)
      tags = metadata['compute']['tags'].split(';')
      metadata['compute']['tags'] = Hash[tags.map { |tag| tag.split(':', 2) }]
      metadata
    end
  end
rescue
  warn 'Unable to resolve az_metadata - This is not an Azure instance or unable to contact the Azure instance-data web server.'
end
