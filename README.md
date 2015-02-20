# *Vagrant-Builder*: This is: Vagrant Builder

[![Build Status](https://secure.travis-ci.org/purpleidea/vagrant-builder.png)](http://travis-ci.org/purpleidea/vagrant-builder)

## Documentation:
Please see: [DOCUMENTATION.md](DOCUMENTATION.md) or [PDF](https://pdfdoc-purpleidea.rhcloud.com/pdf/https://github.com/purpleidea/vagrant-builder/blob/master/DOCUMENTATION.md).

## Installation:
Please read the [INSTALL](INSTALL) file for instructions on getting this installed.

## Examples:
Please look in the [examples/](examples/) folder for usage. If none exist, please contribute one!

## Module specific notes:

* This is the builder/ project that used to live inside puppet-gluster.
* This is an elegant method for making base images for vagrant-libvirt.
* The Makefile builds vagrant base image ("boxes") for vagrant-libvirt.
* A short article describing the original process can be found here:
** [https://ttboj.wordpress.com/2014/01/20/building-base-images-for-vagrant-with-a-makefile](https://ttboj.wordpress.com/2014/01/20/building-base-images-for-vagrant-with-a-makefile)
* This was built for Puppet-Gluster+Vagrant, but it can be used anywhere.
** [https://ttboj.wordpress.com/2014/01/08/automatically-deploying-glusterfs-with-puppet-gluster-vagrant/](https://ttboj.wordpress.com/2014/01/08/automatically-deploying-glusterfs-with-puppet-gluster-vagrant/)

## Dependencies:
* [http://libguestfs.org/virt-builder.1.html](virt-builder)
* pandoc (for building a pdf of the documentation)

## Patches:
This code may be a work in progress. The interfaces may change without notice.
Patches are welcome, but please be patient. They are best received by email.
Please ping me if you have big changes in mind, before you write a giant patch.

##

Happy hacking!

