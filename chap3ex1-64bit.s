	#
	# Do an exit system call
	#

	.section .data

	.section .text
	.globl _start

_start:
	movq $1, %rax 	# 1 is the code for the exit system call
	
	movq $23, %rbx	# 23 is the return code

	int $0x80	# control transfer from user space to kernel
			# by interrupt 0x80
	
