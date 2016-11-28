	# PURPOSE: recursively compute the factorial of the number 4 (4*3*2*1)
	#
	.code32
	.section .data	
	.section .text
	.globl _start

_start:
	
	pushl $4			# function parameter
	call factorial
	addl $4, %esp			# remove param from stack
	movl %eax, %ebx			# funcion reval -> prog retval
exit_prog:
	movl $1, %eax			# exit system call
	int $0x80
	
	.type factorial, @function
factorial:				# BEGIN FUNCTION
	pushl %ebp			# 1. save old base pointer
	movl %esp, %ebp			# 2. make stack pointer the base pointer
	movl 8(%ebp), %eax		# move parameter to %eax
	cmpl $1, %eax			# n == 1 ? -> base case
	je factorial_end		# then return withour new recursion
	decl %eax			# n = n -1
	pushl %eax
	call factorial
	movl 8(%ebp), %ebx
	imul %ebx, %eax
factorial_end:	
	movl %ebp, %esp			# restore stack pointer
	popl %ebp			# restore base pointer
	ret				# return control	
