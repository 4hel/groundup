#!/bin/bash

as alloc.s -o alloc.o
as test.s -o test.o
ld alloc.o test.o -o test
./test
