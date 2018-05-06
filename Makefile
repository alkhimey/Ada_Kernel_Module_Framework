# Path to the root of the Ada runtime directory
ADA_RTS_PATH := rts

runtime:
	gprbuild -P$(ADA_RTS_PATH)/gnat.gpr --create-missing-dirs

clean-runtime:
	gnatclean -P$(ADA_RTS_PATH)/gnat.gpr

all: runtime


