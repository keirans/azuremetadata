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
  Facter.add(:az_metadata) do
    confine :virtual => 'hyperv'
    setcode do
      url_metadata = 'http://169.254.169.254/metadata/instance?api-version=2019-06-04'
      metadataraw = open(url_metadata, 'Metadata' => 'true', 'User-Agent' => 'Puppet', proxy: false).read
      metadata = JSON.parse(metadataraw)
      tags = metadata['compute']['tagsList']
      tagHash = Hash.new(0)
      tags.each do |child|
        tagHash[child['name']] = child['value']
      end
      metadata['compute']['tags'] = tagHash
      metadata
    end
  end
rescue
  warn 'Unable to resolve az_metadata - This is not an Azure instance or unable to contact the Azure instance-data web server.'
end
