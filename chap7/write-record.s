	.include "record-def.s"
	.include "linux.s"
	.code32

	# PURPOSE: function for writing a record to disk
	#
	# INPUT: 1. buffer 2. file descriptor 
	#
	# OUTPUT: status code from write syscall
	#
	# STACK LOCAL VARIABLES:
	#
	.equ ST_WRITE_BUFFER, 8
	.equ ST_FILEDES, 12
	#
	# FUNCTION DEFINITION:
	#
	.section .text
	.globl write_record
	.type write_record, @function
write_record:	
	pushl %ebp
	movl %esp, %ebp
	
	pushl %ebx			# what is in ebx ??????
	movl $SYS_WRITE, %eax
	movl ST_FILEDES(%ebp), %ebx
	movl ST_WRITE_BUFFER(%ebp), %ecx
	movl $RECORD_SIZE, %edx
	int $LINUX_SYSCALL
	popl  %ebx			# restore mysterious ebx ?!?!

	# retval = eax
	movl %ebp, %esp			# restore stack pointer
	popl %ebp			# restore base pointer
	ret				# return control	
