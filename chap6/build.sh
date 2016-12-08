mkdir target
as --32 write-records.s -o ./target/write-records.o
as --32 write-record.s -o  ./target/write-record.o
as --32 read-record.s -o   ./target/read-record.o
as --32 count-chars.s -o   ./target/count-chars.o
as --32 write-newline.s -o ./target/write-newline.o
as --32 read-records.s -o  ./target/read-records.o
as --32 add-year.s -o      ./target/add-year.o

ld -m elf_i386 ./target/write-record.o ./target/write-records.o -o ./target/write-records
ld -m elf_i386 ./target/read-record.o ./target/count-chars.o ./target/write-newline.o ./target/read-records.o -o ./target/read-records
ld -m elf_i386 ./target/write-record.o ./target/read-record.o ./target/add-year.o -o ./target/add-year
