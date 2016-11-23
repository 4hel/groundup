	# PURPOSE: finding the max value from a list
	#
	# VARIABLES:
	#
	#   register:
	#   %edi -> current position in the list
	#   %ebx -> current highest values
	#   %eax -> current element from the list
	#
	#   memory:
	#   data_items -> list of numbers, terminated by a 0
	

	.section .data
data_items:	
        .long 3,67,34,222,45,75,34,22,11,66,0
	
	.section .text
	.globl _start

_start:
	movl $0, %edi			# move 0 into index register
	movl data_items(,%edi,4), %eax	# load the first byte of data
	movl %eax, %ebx			# the first item is the highest so far

start_loop:
	cmpl $0, %eax			# end of list?
	je loop_exit
	incl %edi			# increment index
	movl data_items(,%edi,4), %eax	# load next value
	cmpl %ebx, %eax			# compare values
	jle start_loop			# if new value is less than current max
	movl %eax, %ebx			# move value as new largest to %ebx
	jmp start_loop
	
loop_exit:	
	movl $1, %eax			# exit system call
					# %ebx now has max val as return code
	int $0x80	
			
	
