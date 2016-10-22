obj-m += hello.o
hello-y := main.o lib/libadakernelmodule.a 

all:
	gprbuild -Prts/gnat.gpr --create-missing-dirs
	gprbuild -Pkernel_module_lib.gpr --create-missing-dirs --RTS=rts
	
	make  -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules V=0
clean:
	gnatclean -Pkernel_module_lib.gpr
	gnatclean -Prts/gnat.gpr
	make  -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean V=0
	
 
