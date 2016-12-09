#!/bin/bash

as --32 write-record.s  -o write-record.o
as --32 read-record.s   -o read-record.o
as --32 write-records.s -o write-records.o

ld -m elf_i386 -shared write-record.o read-record.o -o librecord.so

ld -m elf_i386 -L . -dynamic-linker /lib/ld-linux.so.2 -o write-records -lrecord write-records.o


