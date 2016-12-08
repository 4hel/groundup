#!/bin/bash
as hello-lib.s -o hello-lib.o
ld -dynamic-linker /lib/ld-linux.so.2 -o hello hello-lib.o -lc
