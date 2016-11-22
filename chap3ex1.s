	#
	# Do an exit system call
	#

	.section .data

	.section .text
	.globl _start

_start:
	movl $1, %eax 	# 1 is the code for the exit system call
	
	movl $0, %ebx	# 0 is the return code

	int $0x80	# control transfer from user space to kernel
			# by interrupt 0x80
	
