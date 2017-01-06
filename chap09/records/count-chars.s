	# PURPOSE: count characters until null byte
	#
	# INPUT: address of the character string
	#
	# OUTPUT: returns the count in %eax
	#
	# PROCESS:
	#   Registers used:
	#     %ecx - character count
	#     %al  - current character
	#     %edx - current character address

	.type count_chars, @function
	.globl count_chars

	# stack position of the one parameter used
	.equ ST_STRING_START_ADDRESS, 8

count_chars:
	pushl %ebp
	movl %esp, %ebp

	movl $0, %ecx					# counter starts at 0
	movl ST_STRING_START_ADDRESS(%ebp), %edx	# %edx points to first char
count_loop_begin:
	movb (%edx), %al				# grab the current char
	cmpb $0, %al					# is it null?
	je count_loop_end				# if yes -> done
	incl %ecx					# else -> count++
	incl %edx					# char_pointer++
	jmp count_loop_begin				# goto beginning
count_loop_end:
	movl %ecx, %eax					# count retval -> %eax

	movl %ebp, %esp			# why is this left out in book?
	popl %ebp			# restore base pointer
	ret				# return control	
	
