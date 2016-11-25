	# PURPOSE: compute 2^3 + 5^2
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
	pushl $2			# 1. Parameter
	call power
	addl $8, %esp			# move the stack pointer back
	pushl %eax			# store retval of 2^3
	pushl $2			# 2. Parameter
	pushl $5			# 1. Parameter
	call power
	addl $8, %esp			# move the stack pointer back
	popl %ebx			# get first retval from stack
	addl %eax, %ebx			# add both powers for return
exit_prog:
	movl $1, %eax			# exit system call
	int $0x80
	
	.type power, @function
power:					# BEGIN FUNCTION
	pushl %ebx			# 1. save old base pointer
	movl %esp, %ebp			# 2. make stack pointer the base pointer
					
	movl 8(%ebp), %ebx		# move 1. Parameter to %eax
	movl 12(%ebp), %ecx		# move 2. Parameter to %ebx
	pushl %ebx			# init local_var1 with base
power_loop:
	cmpl $1, %ecx			# while( power != 1)
	je power_end
	movl -4(%ebp), %eax		# local_var1 -> %eax
	imull %ebx, %eax		# base * local_var1 
	movl %eax, -4(%ebp)		# local_var1 := mul_result
	decl %ecx			# power--
	jmp power_loop
	
power_end:	
	movl %ebp, %esp			# restore stack pointer
	popl %ebp			# restore base pointer
	ret				# return control	
