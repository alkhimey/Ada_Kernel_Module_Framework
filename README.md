Ada Linux Kernel Module Framework
=================================

The goal of this project is do demonstrate that it is possible and is useful to use Ada programming language when developing Linux kernel modules.

This framework provides Ada bindings for Kernel functions as well as an Ada runtime modified to run in the kernel (statically linked into the kernel module).

Please note that this work is:

1. **Proof of concept** - There are no plans to provide an exhaustive set of bindings as well as to make this robust against Kernel changes.
1. **Work in progress** - Every commit might break existing modules.

### Directory structure


* **rts** - Ada _runtime system_ that was modified to be able to run in the kernel. It's is based on Gnat's runtime.

* **rts/Makefile** - A Makefile used to build the framework with a single `make` command.

* **rts/adainclude/linux-[package].adx** - These files contain bindings to Linux kernel functions which are required by the RTS or the module being developed.

* **rts/adainclude/linux-wrappers.c** - This file contains wrappers for C inline functions and pre-processor macros. This file will be compiled along with your kernel module.

* **Vagrantfile** - Vagrant configuration file. See the section that discusses developing with virtual machine.

* **vm_scripts** - Scripts used by Vagrant to setup the virtual machine and the tools.

* **examples** - This directory contains subdirectories with source code for example kernel modules. Some of these are also being used as regression tests.

* **examples/template** - A simple module that can be used as a starting point.


Each individual module directory is structured as following:

* **main.c** - A C wrapper that is used to register ```init_module``` and ```cleanup_module```. This currently can not be done in pure Ada as there are C macros involved. 

* **src** - The Ada source code of the kernel modules goes inside here.

* **Makefile** - A makefile that builds the module. You should edit it to specify the location of the RTS.

### Tools used

The following tools are used in the development of this module:

```
$ uname -rpio
4.9.0-4-amd64 unknown unknown GNU/Linux

$ gnat --version
GNAT GPL 2017 (20170515-63)
Copyright (C) 1996-2017, Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ gprbuild --version
GPRBUILD GPL 2017 (20170515) (x86_64-pc-linux-gnu)
Copyright (C) 2004-2017, AdaCore
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

```

It might be possible to use other tool versions, but it was not tested.

### Developing using a virtual machine

It is good practice to develop and test kernel modules using a virtual machine rather than your everyday system.

The author of this module uses Vagrant as a VM manger. 

An automatic process can setup a `debian/stretch64` machine and install all the necessary tools:


1. Clone this repository using git.
1. Install [Vagrant](https://www.vagrantup.com/).
1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (or your favorite [supported](https://www.vagrantup.com/docs/providers/) VM provider). The author of this module uses VirtualBox.
1. If using VirtualBox, install the vagrant-vbguest plugin (`vagrant plugin install vagrant-vbguest`).
1. Run `vagrant up` where you cloned the repo (where `Vagrantfile` is) to create a shiny new VM with everything you need in it.
1. Run `vagrant ssh` to log into the machine.

The source code of this directory will be mounted on `/home/vagrant/project`. Proceed normally from there.

Reference for the tools used by the author of this framework:

```
$ vagrant --version
Vagrant 2.0.0

$ virtualbox -h
Oracle VM VirtualBox Manager 5.1.34_Ubuntu
```

### Building

First you need to make the RTS (run this from the root directory):

```
$ make -C rts
```

After that, change dir to the desired module's directory and make it:

``` 
$ cd examples/template
$ make
 ```

### Running

A file called ```hello.ko``` will be generated.

Insert the module into the kernel:

```$ sudo insmod hello.ko```

Remove the module from the kernel:

```$ sudo rmmod hello.ko ```

See message log:

```$ dmesg | tail```

### GPLv3 License

See _COPYING3_ file for details.
