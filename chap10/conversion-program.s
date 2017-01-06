	.include "linux.s"

	.section .data
tmp_buffer:
	.ascii "\0\0\0\0\0\0\0\0\0\0\0"

	.section .text
	.globl _start
_start:
	movl  %esp, %ebp
	# push params and call conversion function
	pushl $tmp_buffer
	pushl $824
	call integer2string
	addl $8, %esp

	# get character count for system call
	pushl $tmp_buffer
	call  count_chars
	addl  $4, %esp

	# the count goes in %edx for SYS_WRITE
	movl  %eax, %edx

	# make sys call
	movl $SYS_WRITE, %eax
	movl $STDOUT, %ebx
	movl $tmp_buffer, %ecx
	int  $LINUX_SYSCALL

	# write carriage return
	pushl $STDOUT
	call  write_newline

	#exit
	movl  $SYS_EXIT, %eax
	movl  $0, %ebx
	int   $LINUX_SYSCALL
	
	
	
