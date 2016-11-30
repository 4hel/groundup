	# PURPOSE: convert input file to output file making all letters uppercase
	#
	.code32

	#
	# DATA
	#
	.section .data
	
	# system calls
	.equ SYS_OPEN, 5
	.equ SYS_WRITE, 4
	.equ SYS_READ, 3
	.equ SYS_CLOSE, 6
	.equ SYS_EXIT, 1
	.equ LINUX_SYSCALL, 0x80

	# options for open from /usr/include/asm-generic/fcntl.h
	.equ O_RDONLY, 0
	.equ O_CREAT_WRONLY_TRUNC, 03101

	# standard file descriptors
	.equ STDIN, 0
	.equ STDOUT, 1
	.equ STDERR, 2

	# misc
	.equ END_OF_FILE, 0		# retval of read?
	.equ NUMBER_ARGUMENTS, 2

	#
	# BUFFER 
	#
	.section .bss
	.equ BUFFER_SIZE, 500
	.lcomm BUFFER_DATA, BUFFER_SIZE
	
	#
	# PROGRAM
	#
	.section .text

	# stack postions
	.equ ST_SIZE_RESERVE, 8
	.equ ST_FD_IN, -4
	.equ ST_FD_OUT, -8
	.equ ST_ARGC, 0			# number of arguments
	.equ ST_ARGV_0, 4		# name of program
	.equ ST_ARGV_1, 8		# input file name
	.equ ST_ARGV_2, 12		# output file name
	
	.globl _start
_start:
	movl %esp, %ebp			# save the stack pointer
	subl $ST_SIZE_RESERVE, %esp

	### read from STDIN
	movl $SYS_READ, %eax
	movl $STDIN, %ebx
	movl $BUFFER_DATA, %ecx
	movl $BUFFER_SIZE, %edx
	int $LINUX_SYSCALL

	pushl $BUFFER_DATA
	pushl $BUFFER_SIZE
	call to_upper

	### write to STDOUT
	movl $SYS_WRITE, %eax
	movl $STDOUT, %ebx
	movl $BUFFER_DATA, %ecx
	movl $BUFFER_SIZE, %edx
	int $LINUX_SYSCALL
	
exit_prog:
	movl $1, %eax			# exit system call
	int $0x80
	
	#
	# this function converts buffer to upper case asci
	#
	# variables:
	#           %eax - beginning of buffer
	#           %ebx - length of buffer
	#           %edi - current offset in buffer
	#           %cl  - current byte
	#
	.equ LOWERCASE_A, 'a'
	.equ LOWERCASE_Z, 'z'
	.equ UPPER_CONVERSION, 'A' - 'a'
	.equ ST_BUFFER_LEN, 8
	.equ ST_BUFFER, 12
to_upper:				# BEGIN FUNCTION
	pushl %ebp			# 1. save old base pointer
	movl %esp, %ebp			# 2. make stack pointer the base pointer

	movl ST_BUFFER(%ebp), %eax
	movl ST_BUFFER_LEN(%ebp), %ebx
	movl $0, %edi			# i = 0

	# if buffer empty, just leave
	cmpl $0, %ebx
	je to_upper_end

loop:
	movb (%eax,%edi,1), %cl		# %cl = BUFFER[i]

	# unless char between 'a' and 'z' goto next byte
	cmpb $LOWERCASE_A, %cl
	jl next_byte
	cmpb $LOWERCASE_Z, %cl
	jg next_byte

	# otherwise convert byte to uppercase
	addb $UPPER_CONVERSION, %cl
	# and store it back
	movb %cl, (%eax,%edi,1)

next_byte:
	incl %edi			# i++
	cmpl %edi, %ebx			# is end?
	jne loop
	
to_upper_end:
					# no return value
	movl %ebp, %esp			# restore stack pointer
	popl %ebp			# restore base pointer
	ret				# return control	
