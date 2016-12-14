#!/bin/bash
as test.s -o test.o
ld alloc.o test.o -o test
