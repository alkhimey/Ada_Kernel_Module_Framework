Ada Linux Kernel Module Toolkit
===============================

_NOTICE: This is work in progress_

This toolkit provide the ability to program Linux kernel modules using the Ada programming langauge.

### Prerequirments

I used the following versions of the tools:

```
$ uname -rpio
4.4.0-43-generic x86_64 x86_64 GNU/Linux
$ gnat --version
GNAT GPL 2016 (20160515-49)
Copyright (C) 1996-2016, Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ gprbuild --version
GPRBUILD GPL 2016 (20160515) (x86_64-pc-linux-gnu)
Copyright (C) 2004-2016, AdaCore
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

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


* **rts** - The runtime system modified to be able to run in the kernel.

* **rts\kernel** - Bindings to linux kernel functions that are required by the RTS.

* **bindings** - Bindings to linux kernel functions that can be used from the modules code.

* **src** - The actual source of the kernel module.

* **main.c** - A C wrapper that is used to register ```init_module``` and ```cleanup_module```. This can not be done in pure Ada as there are Macros involved. 

### GPLv3 License

See _COPYING3_ file for details.
