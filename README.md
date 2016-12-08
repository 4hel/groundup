# Programming From The Ground Up

Exercises for the [book](https://4hel.github.io/book/groundup.html) on introduction to Programming using Linux Assembly Language.

This is 32-bit assembler. It is not state of the art, but does the purpose of teaching how the machine works.

## Table of Exercises

Program | Purpose
--- | ---
chap3ex1 | simply exit
chap3ex2 | find max value
chap4ex1 | function for power
chap4ex2 | recursive factorial function
chap5ex1 | toUpper function with file args
chap6    | reading and writing records

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

