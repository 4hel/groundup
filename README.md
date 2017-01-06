# Programming From The Ground Up

This [book](https://4hel.github.io/book/groundup.html) teaches programming using Linux Assembly Language.

The Exercises are written in 32-bit x86 assembler. This is kind of obsolete but does the purpose of teaching how the machine works.

## Table of Exercises

Program              | Purpose
---                  | ---
chap3ex1             | exit system call
chap3ex2             | find max value
chap4ex1             | function for power
chap4ex2             | recursive factorial function
chap5ex1             | toUpper function with file args
chap06               | reading and writing records
chap07               | records with error handling for add-year
chap08/hello         | hello world linking libc.so
chap08/librecord     | creating a dynamic library
chap09/memory-1.0    | memory manager like malloc
chap09/memory-64-bit | 64-bit malloc and free
chap09/records       | read-records using memory manager
chap10               | converting numbers to strings


## Install 32 bit version libc

```bash
$ apt-get install libc6:i386 libc6-dev-i386
```

## Assemble the source to an object file

```bash
$ as --32 chap3ex1.s -o exit.o
```

## Link the object file to an executable
```bash
$ ld -m elf_i386 exit.o -o exit
```

## Do all and run
```bash
$ as --32 chap3ex1.s -o object.o && ld -m elf_i386 object.o -o prog && ./prog
```

