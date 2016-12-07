	# PURPOSE: read records from test.dat and prit first names
	#
	.include "linux.s"
	.include "record-def.s"

	.section .data
file_name:
	.ascii "test.dat\0"

	.section .bss
	.lcomm record_buffer, RECORD_SIZE


	.section .text
	.globl _start
_start:
	.equ ST_INPUT_DESCRIPTOR, -4
	.equ ST_OUTPUT_DESCRIPTOR, -8

	movl %esp, %ebp				# copy stack pointer to %ebp
	subl $8, %esp				# allocate space on the stack

	# open the file
	movl $SYS_OPEN, %eax
	movl $file_name, %ebx
	movl $0, %ecx				# open read-only
	movl $0666, %edx
	int $LINUX_SYSCALL

	# save the returned file descriptor
	movl %eax, ST_INPUT_DESCRIPTOR(%ebp)
	# use variable for stdout instead of hardcode
	movl $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)

record_read_loop:
	# read record from file
	pushl ST_INPUT_DESCRIPTOR(%ebp)
	pushl $record_buffer
	call read_record
	addl $8, %esp

	# check the returned nr of bytes read is ok
	cmpl $RECORD_SIZE, %eax
	jne finished_reading

	# find out size of first name
	pushl $RECORD_FIRSTNAME + record_buffer
	call count_chars
	addl $4, %esp

	# print first name
	movl %eax, %edx
	movl $SYS_WRITE, %eax
	movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
	movl $RECORD_FIRSTNAME + record_buffer, %ecx
	int $LINUX_SYSCALL

	# print newline
	pushl ST_OUTPUT_DESCRIPTOR(%ebp)
	call write_newline
	addl $4, %esp

	jmp record_read_loop

finished_reading:
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
	
