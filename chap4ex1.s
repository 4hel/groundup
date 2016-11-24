	# PURPOSE: 
	#
	# VARIABLES:
	# 	
	.code32
	.section .data	
	.section .text
	.globl _start
	.globl power

_start:
	pushl $3			# 2. Parameter
	pushl $3			# 1. Parameter
	call power
exit_prog:	
	movl $1, %eax			# exit system call
	int $0x80
	
	.type power, @function
power:					# BEGIN FUNCTION
	pushl %ebx			# 1. save old base pointer
	movl %esp, %ebp			# 2. make stack pointer the base pointer
					
	movl 8(%ebp), %eax		# move 1. Parameter to %eax
	movl 12(%ebp), %ebx		# move 2. Parameter to %ebx
	addl %eax, %ebx			# add to get return value
					
	movl %ebp, %esp			# restore stack pointer
	popl %ebp			# restore base pointer
	ret				# return control	
			
	
