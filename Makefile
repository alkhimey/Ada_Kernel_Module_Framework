obj-m += hello.o
hello-y := main.o ada_foo.o

all:
	gnatmake -c ada_foo.adb
	gnatbind -n ada_foo.ali
	make  -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules V=0
clean:
	rm -f ada_foo.ali  b~ada_foo.ads  b~ada_foo.adb ada_foo.o
	make  -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean V=0
	

