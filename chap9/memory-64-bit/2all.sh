#!/bin/bash

as alloc.s -o alloc.o
ld alloc.o -o test
./test
