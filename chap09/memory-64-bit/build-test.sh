#!/bin/bash
as test.s -o test.o
ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -L . -lalloc test.o -o test
