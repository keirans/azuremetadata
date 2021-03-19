# azuremetadata 

## Deprecation Announcement  - Functionality now part of Facter and Puppet Enterprise

After over 20k module downloads from the Forge and much wider use on internal environments I am happy to announce that Facter 4.0.52 has now introduced the following enhancements that now makes this module obsolete for modern Puppet environments.

* Azure metadata fact. This release adds the az_metadata fact which provides information on Azure virtual machine instances. 

* Azure identification fact. This release adds the cloud.provider fact for Azure identification on Linux and Windows platforms. 

You can find more information about this from the following Facter PR's
* [(FACT-1847) Fix cloud fact implementation for Azure](https://github.com/puppetlabs/facter/pull/2302)
* [(FACT-1383) Add Azure instance metadata fact ](https://github.com/puppetlabs/facter/pull/2298)

As such, you should look to transition off this module and leverage the native functionality provided from Facter, and as a result, I'll be no longer actively developing this module. I'll continue to keep an eye on PR's to help those on legacy versions however this will be done at a best effort level only.

#### Table of Contents

1. [Description](#description)
2. [Setup](#setup)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Description

[Azure now has an instance metadata service that is GA globally !](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/instance-metadata-service)

To help with further automation, this modules exposes the Azure instance metadata as a structured fact for use in Puppet code.
If you would like to see this end up in Facter Core, please do vote for the JIRA below:
* [FACT-1383 - Azure Instance Metadata ](https://tickets.puppetlabs.com/browse/FACT-1383)

This has been tested with Puppet 6.17.0 RHEL8 , however it should work on any platform that has a modern Ruby with open-uri and JSON support.

This module was part of a larger part of Puppet and Azure work that I presented at Puppetconf 2017.

* [You can see the presentation video here.](https://www.youtube.com/watch?v=tbWeYvOHvJE)

## Setup

### What azuremetadata affects 
This module deploys a single Ruby file that queries and exposes the Azure metadata as a structured fact.

### Setup Requirements

Include the module in your Puppetfile and let pluginsync do the rest for you.

Puppetfile entries


    # Directly from Git
    mod 'azuremetadata',
        :git => 'https://github.com/keirans/azuremetadata.git',
        :tag => '0.2.0'

    
    # Directly from the forge
    mod 'keirans-azuremetadata', '0.2.0'


## Usage

Once the fact is in place, you can use Facter on your Windows and Linux nodes to access the values as follows:


Returning the full set of metadata from Facter on Windows
```
PS> facter az_metadata
{
  compute => {
    azEnvironment => "AzurePublicCloud",
    customData => "",
    isHostCompatibilityLayerVm => "false",
    location => "australiasoutheast",
    name => "puppetdev",
    offer => "RHEL",
    osType => "Linux",
    placementGroupId => "",
    plan => {
      name => "",
      product => "",
      publisher => ""
    },
    platformFaultDomain => "0",
    platformUpdateDomain => "0",
    provider => "Microsoft.Compute",
    publicKeys => [
      {
        keyData => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7OGhS/PGV7Ov6071BmaE2JnZs1J32zzdzkJD8Np6+1Uz/d7wFUHn4X76jbNlFJ78U5nr/i7WINmZ/rPkw+sLby/u95pwCeL28MiGvZWR7TKuRGb3QJTkWIoRUkJ6AH6IBMMoAbfwVlgEwP2nArJI4QS+euy7uHZONeYGXxUUsw37UYGtRHM+m62yURB8ZsNEzssMSu1/OLb5322RGubxFaT9QMOhaUcfvtCuO6MN3DmIuHCr9dlQV/c8HzztGW9YlMCd2Dcvbp9w+LcPYldGw/U8JVF+K2YHLKxBa5ZlB3+jC0KJG3HCnj+TJ2tc+MsLprdh5oCom/Mi3l/XOmpEr keiran@Keirans-MacBook-Pro.local",
        path => "/home/keiran/.ssh/authorized_keys"
      }
    ],
    publisher => "RedHat",
    resourceGroupName => "puppetdev_group",
    resourceId => "/subscriptions/0432b1d0-5e2e-4e2a-ad73-e33d0652e3f7/resourceGroups/puppetdev_group/providers/Microsoft.Compute/virtualMachines/puppetdev",
    securityProfile => {
      secureBootEnabled => "false",
      virtualTpmEnabled => "false"
    },
    sku => "82gen2",
    storageProfile => {
      dataDisks => [],
      imageReference => {
        id => "",
        offer => "RHEL",
        publisher => "RedHat",
        sku => "82gen2",
        version => "latest"
      },
      osDisk => {
        caching => "ReadWrite",
        createOption => "FromImage",
        diffDiskSettings => {
          option => ""
        },
        diskSizeGB => "64",
        encryptionSettings => {
          enabled => "false"
        },
        image => {
          uri => ""
        },
        managedDisk => {
          id => "/subscriptions/0432b1d0-5e2e-4e2a-ad73-e33d0652e3f7/resourceGroups/PUPPETDEV_GROUP/providers/Microsoft.Compute/disks/puppetdev_OsDisk_1_62a017170f4044adbcfea54cea6cc45d",
          storageAccountType => "Premium_LRS"
        },
        name => "puppetdev_OsDisk_1_62a017170f4044adbcfea54cea6cc45d",
        osType => "Linux",
        vhd => {
          uri => ""
        },
        writeAcceleratorEnabled => "false"
      }
    },
    subscriptionId => "0432b1d0-5e2e-4e2a-ad73-e33d0652e3f7",
    tags => "testtag1:thisisavalue1;testtag:2:thisisavalue2",
    tagsList => [
      {
        name => "testtag1",
        value => "thisisavalue1"
      },
      {
        name => "testtag:2",
        value => "thisisavalue2"
      }
    ],
    version => "8.2.2020050812",
    vmId => "976f831c-dc8d-446d-b62d-0598b77b5799",
    vmScaleSetName => "",
    vmSize => "Standard_D4s_v3",
    zone => ""
  },
  network => {
    interface => [
      {
        ipv4 => {
          ipAddress => [
            {
              privateIpAddress => "10.5.0.4",
              publicIpAddress => "52.189.236.160"
            }
          ],
          subnet => [
            {
              address => "10.5.0.0",
              prefix => "24"
            }
          ]
        },
        ipv6 => {
          ipAddress => []
        },
        macAddress => "00224814BABC"
      }
    ]
  }
}
```

Returning individual values of the metadata from Facter on Windows


    PS> facter  az_metadata.compute.location
    australiasoutheast
    PS>
    
You can then reference these values in your Puppet code using the facts hash such as:

    notice("The  Azure location for ${facts['networking']['fqdn']} is ${facts['az_metadata']['compute']['location']}")


## Limitations

### API version pinned to 2020-06-01
Version 0.2.0 is currently using API version 2020-06-01, I'll update this as new versions become available and bump the module version accordingly.

Please note that versions prior to 0.2.0 introduced a 'tags' key in the fact data, this now conflicts with a value in the metadata data itself from the Azure platform, as such it has been removed and you should use the tagsList value instead which is native functionaly. As a result, 0.2.0 is a breaking change for previous users.

This native approach also gracefully handles special characters in tag keys and values unlike previous versions of the module.


```
# facter  az_metadata.compute.tags
testtag1:thisisavalue1;testtag:2:thisisavalue2
# facter az_metadata.compute.tagsList
[
  {
    name => "testtag1",
    value => "thisisavalue1"
  },
  {
    name => "testtag:2",
    value => "thisisavalue2"
  }
]
#
```

## Development

Please see the Deprecation Announcement above.
