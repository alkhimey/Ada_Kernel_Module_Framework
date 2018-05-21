#!/usr/bin/env bats

load ../../testing/enviroment


setup() {
r="(ls xxx)"
#if [ r != "xxx" ]; then

   #fail ""
#fi
}


@test "build module" {
   make
   assert_success
}

@test "verify creation of loadable module with the correct name" {
   result="$(ls *.ko)"
   assert_equal $result 'hello.ko' 'loadable module should be called hello.ko' 
}


@test "insert module" {
    sudo insmod hello.ko
}

@test "check for after ada string in log" {
   sudo dmesg | tail -1 | grep "After Ada" 
}

@test "remove module" {
    sudo rmmod hello.ko
}


@test "clean module" {
   make clean
}
