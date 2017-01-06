#!/bin/bash
as --32 hello-lib.s -o hello-lib.o
ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -o hello hello-lib.o -lc
