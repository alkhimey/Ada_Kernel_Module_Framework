
# Path to the root of the Ada runtime directory
# The runtime should already be compiled
ADA_RTS_PATH := ../../rts


obj-m += hello.o
hello-y := main.o $(ADA_RTS_PATH)/adainclude/linux-wrappers.o lib/libadakernelmodule.a  $(ADA_RTS_PATH)/adalib/libgnat.a

all:
	gprbuild -Pkernel_module_lib.gpr --create-missing-dirs --RTS:ada=$(ADA_RTS_PATH)
	make  -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules V=0

clean:
	make  -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean V=0
	gnatclean -Pkernel_module_lib.gpr --RTS:ada=$(ADA_RTS_PATH)



