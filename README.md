Ada Linux Kernel Module Toolkit
===============================

_NOTICE: This is work in progress_

This toolkit provide the ability to program Linux kernel modules using the Ada programming langauge.

### Prerequirments

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

Additionaly, installing `build-essentials` might be required.

### Building

``` make ```

### Running

A file called ```hello.ko``` will be generated.

Insert the module into the kernel:

```sudo insmod hello.ko```

Remove the module from the kernel:

```sudo rmmod hello.ko ```

See message log:

```dmesg | tail```

### Directory structure


* **rts** - The runtime system that was modified to be able to run in the kernel.

* **rts\adainclude\linux-[package].adx** - These files contain bindings to Linux kernel functions which are required by the RTS or the module.

* **src** - The actual source of the kernel module.

* **main.c** - A C wrapper that is used to register ```init_module``` and ```cleanup_module```. This can not be done in pure Ada as there are C macros involved. 

* **linux-wrappers.c** - Some C functions require a wrapper. For example a function that is inline or a macro.

* **Vagrantfile** - Vagrant configuration file (see "Developing with VM" section.

* **vm_scripts** - Scripts used by Vagrant to setup the virtual machine (download and install gnat etc).

### Developing with VM

It is discouraged to develop and test kernel modules on the system you are using for everyday work.

A Much superior approach is to use a virtual machine.

The author of this module uses Vagrant as a VM manger. An automatic process will setup an `debian/stretch64` machine and install all the necessary tools.


1. Clone this repository using git.
1. Install [Vagrant](https://www.vagrantup.com/).
1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (or your favorite [supported](https://www.vagrantup.com/docs/providers/) VM provider). The author of this module uses VirtualBox.
1. If using VirtualBox, install the vagrant-vbguest plugin (`vagrant plugin install vagrant-vbguest`).
1. Run `vagrant up` where you cloned the repo (where `Vagrantfile` is) to create a shiny new VM with everything you need in it.
1. Run `vagrant ssh` to log into the machine.

The source code of this directory will be mounted on `/home/vagrant/project`. Proceed normaly from there.


### GPLv3 License

See _COPYING3_ file for details.
