#Vagrant-Builder

<!--
Makefile for building Vagrant base image "boxes" for vagrant-libvirt
Copyright (C) 2010-2013+ James Shubin
Written by James Shubin <james@shubin.ca>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
-->

##Vagrant-Builder by [James](https://ttboj.wordpress.com/)
####Available from:
####[https://github.com/purpleidea/vagrant-builder/](https://github.com/purpleidea/vagrant-builder/)

####This documentation is available in: [Markdown](https://github.com/purpleidea/vagrant-builder/blob/master/DOCUMENTATION.md) or [PDF](https://pdfdoc-purpleidea.rhcloud.com/pdf/https://github.com/purpleidea/vagrant-builder/blob/master/DOCUMENTATION.md) format.

####Table of Contents

1. [Overview](#overview)
2. [Project description - What the project does](#project-description)
3. [Setup - Getting started with Vagrant Builder](#setup)
	* [Installation](#installation)
	* [Simple usage](#simple-usage)
	* [Complex usage](#complex-usage)
4. [Usage/FAQ - Notes on usage and frequently asked questions](#usage-and-frequently-asked-questions)
5. [Reference - Detailed reference](#reference)
	* [Variables](#variables)
	* [Targets](#targets)
6. [Examples - Example configurations](#examples)
7. [Limitations -  Vagrant versions, OS compatibility, etc...](#limitations)
8. [Development - Background on module development and reporting bugs](#development)
9. [Author - Author and contact information](#author)

##Overview

The Vagrant Builder project provides an elegant Makefile approach to building
Vagrant base image "boxes" for vagrant-libvirt.

##Project Description

The Vagrant Builder project tracks the multiple steps in the image generation
process, and only rebuilds missing parts that are out of date. It utilizes the
power of GNU make to do so, and as a result comes in at a few hundred lines of
code.

The base images are provided by the virt-builder project, although your own
base images can be used provided you provide an _ISO_ starting point.

For more information, start by reading and working through the introductory
[blog post](https://ttboj.wordpress.com/2014/01/20/building-base-images-for-vagrant-with-a-makefile).

For information on how to use vagrant-builder to build RHEL base images, read:
[https://ttboj.wordpress.com/2015/02/23/building-rhel-vagrant-boxes-with-vagrant-builder/](https://ttboj.wordpress.com/2015/02/23/building-rhel-vagrant-boxes-with-vagrant-builder/).

##Setup

###Installation

Start by cloning the project, and entering the _v_ directory of your choice:

```bash
$ git clone --recursive https://github.com/purpleidea/vagrant-builder
$ cd vagrant-builder/v7/
```

You'll need to have the virt-builder software installed. It is available in
most distro repositories.

That's it!

###Simple usage

The _v_ directory represents the different _similarities_ of OS images that
we're going to build. For example, the _v7/_ directory represents _CentOS 7.x_,
_RHEL 7.x_, _Fedora 20_, and _Fedora 21_. These are similar enough to be able
to be represented by almost the same code.

To decide what type of image to build, you must edit a file in the _versions/_
directory. Once you have set the parameters you so desire, you run it from the
parent directory:

```bash
./versions/fedora-21.sh
```

To run a specific target, you can pass that in. For example, to run the upload
target, you can run:

```bash
./versions/fedora-21.sh upload
```

The Makefile will now get to work building your images! They usually appear in:
_~/tmp/builder/_.

###Complex usage

A slightly more complex variant is possible if you'd like to build a base image
using an _ISO_ as the initial starting point. In this scenario, start by
downloading the ISO of your choice, and putting in the _iso/_ directory, which
should be next to the _versions/_ directory. Example:

```bash
$ pwd
/home/james/code/vagrant-builder/v7
$ tree -L 1
.
|-- files
|-- iso
|-- keys
|-- Makefile
|-- repos
|-- scripts
|-- Vagrantfile
`-- versions
```

After the _ISO_ is in place, set the _ISO_ path and any other necessary
variables in the correct versions file. The remaining steps are the same as in
the simple usage.

##Usage and frequently asked questions
(Send your questions as a patch to this FAQ! I'll review it, merge it, and
respond by commit with the answer.)

###Why did you start this project?

I needed Vagrant images for vagrant-libvirt, and very few were available, and
there were even no working tools that would generate them! As a result, this
project was born. I'm still maintaining it because it's still useful to me, and
because others are using it too!

###Awesome work, but it's missing support for a feature and/or platform!

Since this is an Open Source / Free Software project that I also give away for
free (as in beer, free as in gratis, free as in libre), I'm unable to provide
unlimited support. Please consider donating funds, hardware, virtual machines,
and other resources. For specific needs, you could perhaps sponsor a feature!

###You didn't answer my question, or I have a question!

Contact me through my [technical blog](https://ttboj.wordpress.com/contact/)
and I'll do my best to help. If you have a good question, please remind me to
add my answer to this documentation!

##Reference
Please note that there are a number of undocumented options. For more
information on these options, please view the source at:
[https://github.com/purpleidea/vagrant-builder/](https://github.com/purpleidea/vagrant-builder/).
If you feel that a well used option needs documenting here, please contact me.

###Overview of reference
* [Variables](#variables): Variables used in the versions/ files
* [Targets](#targets): Special named Makefile targets

###Variables
These are the variables that can be used in _versions/_ files.

####VERSION
This is the name for the image. In general it should match the names used in
the output of _virt-builder -l_.

###Targets
These are the special Makefile targets used in the project.

####All
Currently undocumented.

####Upload
Currently undocumented.

##Examples
For example configurations, please consult the [examples/](https://github.com/purpleidea/vagrant-builder/tree/master/examples) directory in the git
source repository. It is available from:

[https://github.com/purpleidea/vagrant-builder/tree/master/examples](https://github.com/purpleidea/vagrant-builder/tree/master/examples)

##Limitations
This project will work with virt-builder version 1.28.6 and greater. It may
work with certain older versions, but they are no longer tested. Hopefully new
versions of virt-builder don't introduce any regressions that break this
project.

This project is routinely tested on:

* Fedora 21+

It will probably work without incident or without major modification on:

* Fedora 20
* CentOS 5.x/6.x/7.x
* RHEL 5.x/6.x/7.x

It has not been tested by the author (but should work) on:

* Ubuntu 12.04+
* Debian 7+

It will most likely work on other GNU/Linux platforms, but testing on those
platforms has been minimal due to lack of time and resources.

Testing is community supported! Please report any issues as there are a lot of
features, and in particular, support for additional distros isn't well tested.

##Development

This is my personal project that I work on in my free time.
Donations of funding, hardware, virtual machines, and other resources are
appreciated. Please contact me if you'd like to sponsor a feature, invite me to
talk/teach or for consulting.

You can follow along [on my technical blog](https://ttboj.wordpress.com/).

To report any bugs, please file a ticket at: [https://github.com/purpleidea/vagrant-builder/issues](https://github.com/purpleidea/vagrant-builder/issues).

##Author

Copyright (C) 2012-2013+ James Shubin

* [github](https://github.com/purpleidea/)
* [&#64;purpleidea](https://twitter.com/#!/purpleidea)
* [https://ttboj.wordpress.com/](https://ttboj.wordpress.com/)

