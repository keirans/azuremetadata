# azuremetadata

#### Table of Contents

1. [Description](#description)
2. [Setup](#setup)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Description

[Azure now has an instance metadata service that is GA globally !](https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-instancemetadataservice-overview)

To help with further automation, this modules exposes the Azure instance metadata as a structured fact for use in Puppet code.
If you would like to see this end up in Facter Core, please do vote for the JIRA below:
* [FACT-1383 - Azure Instance Metadata ](https://tickets.puppetlabs.com/browse/FACT-1383)

This has been tested with Puppet Enterprise 2017.2 on Windows 2016 and RHEL 7, however it should work on any platform that has a modern Ruby with open-uri and JSON support.

## Setup

### What azuremetadata affects 
This module deploys a single Ruby file that queries and exposes the Azure metadata as a structured fact.

### Setup Requirements

Include the module in your Puppetfile and include it in your roles / profiles and  factsync will do the rest for you.

Puppetfile entries


    # Directly from Git
    mod 'azuremetadata',
        :git => 'https://github.com/keirans/azuremetadata.git',
        :tag => '0.1.0'

    
    # Directly from the forge
    mod 'keirans-azuremetadata', '0.1.0'


Role / Profile inclusion



    include azuremetadata
    


## Usage

Once the fact is in place, you can use Facter on your Windows and Linux nodes to access the values as follows:


Returning the full set of metadata from Facter on Windows

    PS> facter az_metadata
    {
      compute => {
        location => "australiasoutheast",
        name => "Windows2016host",
        offer => "WindowsServer",
        osType => "Windows",
        platformFaultDomain => "0",
        platformUpdateDomain => "0",
        publisher => "MicrosoftWindowsServer",
        sku => "2016-Datacenter",
        version => "2016.127.20170510",
        vmId => "c9c75323-ec40-4646-969d-9d5903a3af75",
        vmSize => "Standard_DS1_v2"
      },
      network => {
        interface => [
          {
            ipv4 => {
              ipAddress => [
                {
                  privateIpAddress => "10.1.0.4",
                  publicIpAddress => "52.255.54.128"
                }
              ],
              subnet => [
                {
                  address => "10.1.0.0",
                  prefix => "24"
                }
              ]
            },
            ipv6 => {
              ipAddress => []
            },
            macAddress => "000D3AE0EEFA"
          }
        ]
      }
    }

Returning individual values of the metadata from Facter on Windows


    PS> facter  az_metadata.compute.location
    australiasoutheast
    PS>
    
You can then reference these values in your Puppet code using the facts hash such as:

    notice("The  Azure location for ${facts['networking']['fqdn']} is ${facts['az_metadata']['compute']['location']}")


## Limitations

### Fact containment to Azure only environments
Currently, there is no consistent way to contain the fact to Azure public cloud environments only, as such, the fact is only exposed when the virtual fact is of value  hyperv, however, if you are using both hyperv and azure environments this may cause some issues for you as the API query will time out.

The main challenge here is that the cloud fact would help more effectively doesnt support anything but Linux right now. 
This is issue is tracked in JIRA: 
* [FACT-1441 - Add "cloud" fact that identifies Azure](https://tickets.puppetlabs.com/browse/FACT-1441)

### API version pinned to 2017-04-02
Version 0.1.0 is currently using API version 2017-04-02, I'll update this as new versions become available and bump the module version accordingly.

## Development
Happy to accept pull requests, I'd expect this to end up in Facter Core at some time in the future, then this can be deprecated.
Please do vote for this JIRA for its addition: 
* [FACT-1383 - Azure Instance Metadata ](https://tickets.puppetlabs.com/browse/FACT-1383)


