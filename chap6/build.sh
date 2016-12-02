mkdir target
as --32 write-records.s -o ./target/write-records.o
as --32 write-record.s -o  ./target/write-record.o
ld -m elf_i386 ./target/write-record.o ./target/write-records.o -o ./target/write-records
