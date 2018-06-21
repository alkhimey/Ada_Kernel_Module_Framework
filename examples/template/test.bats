#!/usr/bin/env bats

load ../../testing-utils/enviroment


#setup() {
#r="(ls xxx)"
#if [ r != "xxx" ]; then
#
#   fail ""
#fi
#}


MODULE_NAME='hello'
MODULE_FILE=$MODULE_NAME'.ko'

ls_check() {
   ls | grep "$1"
}

lsmod_check() {
   lsmod | grep "$1"
}

@test "verify there is no hello module already loaded" {
   run lsmod_check $MODULE_NAME
   assert_failure
}

@test "build module" {
   make
   assert_success
}

@test "verify creation of loadable module with the correct name" {
   run ls_check $MODULE_FILE
   assert_success 
}

@test "insert module" {
    sudo insmod hello.ko
}

@test "check module init and entry into the ada part" {
   result="$(sudo dmesg -t | tail -17 | head -1)"
   assert_equal 'Init module.' "$result"

   result="$(sudo dmesg -t | tail -16 | head -1)"
   assert_equal 'Hello Ada.' "$result"
}

@test "remove module" {
    sudo rmmod hello.ko
}

@test "clean files" {
   make clean
}
