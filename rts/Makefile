# Path to the root of the Ada runtime directory
ADA_RTS_PATH := .

all:
	gprbuild -P$(ADA_RTS_PATH)/gnat.gpr --create-missing-dirs

clean:
	gnatclean -P$(ADA_RTS_PATH)/gnat.gpr

.PHONY: all clean


