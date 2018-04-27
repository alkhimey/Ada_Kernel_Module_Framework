
# Path to the root of the Ada runtime directory
ADA_RTS_PATH := rts


obj-m += hello.o
hello-y := $(ADA_RTS_PATH)/adainclude/linux-wrappers.o $(ADA_RTS_PATH)/adalib/libgnat.a lib/libadakernelmodule.a main.o

all:
	gprbuild -P$(ADA_RTS_PATH)/gnat.gpr --create-missing-dirs
	gprbuild -Pkernel_module_lib.gpr --create-missing-dirs

	make  -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules V=0

clean:

	make  -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean V=0

	gnatclean -Pkernel_module_lib.gpr
	gnatclean -P$(ADA_RTS_PATH)/gnat.gpr



