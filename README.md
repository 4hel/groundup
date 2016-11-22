# Programming From The Ground Up

Exercises for the [book](https://4hel.github.io/book/groundup.html)

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

