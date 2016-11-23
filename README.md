# Programming From The Ground Up

Exercises for the [book](https://4hel.github.io/book/groundup.html) on introduction to Programming using Linux Assembly Language.

This is 32-bit assembler. It is not state of the art, but does the purpose of teaching how the machine works.

## Assemble the source to an object file

```bash
$ as chap3ex1.s -o exit.o
```

## Link the object file to an executable
```bash
$ ld exit.o -o exit
```

## Do all and run
```bash
$ as chap3ex1.s -o object.o && ld object.o -o prog && ./prog
```

## List of general purpose registers

- %eax (accumulator register)
- %ebx (base register)
- %ecx (counter register)
- %edx (double word accumulator register)
- %edi (destination index register)
- %esi (source index register)

