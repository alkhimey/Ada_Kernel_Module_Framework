all:
	cd rts && make
	cd -
	cd examples/template && make


clean:
	cd rts && make clean
	cd -
	cd examples/template && make clean

test:
	cd examples/template && bats test.bats
   
