Ada Linux Kernel Module Toolkit
===============================

This toolkit allow writing Linux kernel modules suing the Ada programming langauge.

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

```make```

### Running

A file called ```hello.ko``` will be generated.

It is possible to insert and remove it using the ```insmod``` and ```rmmod``` commands in ```sudo``` mode.

Use ```dmesg | tail``` to see the output log. 

## GNUv3 License

See _COPYING3_ file for details.
