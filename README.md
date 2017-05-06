Ada Linux Kernel Module Toolkit
===============================

This is work in progress.

This toolkit allows writing Linux kernel modules using the Ada programming langauge.

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

### GPLv3 License

See _COPYING3_ file for details.
