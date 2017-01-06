mkdir target
as --32 count-chars.s -o        ./target/count-chars.o
as --32 write-newline.s -o      ./target/write-newline.o
as --32 integer-to-string.s -o  ./target/integer-to-string.o
as --32 conversion-program.s -o ./target/conversion-program.o

cd target
ld -m elf_i386 count-chars.o write-newline.o integer-to-string.o conversion-program.o -o conversion-program

