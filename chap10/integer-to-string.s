	# PURPOSE: Convert an integer number to a
	#          decimal string for display
	#
	# INPUT:   - A Buffer large enough for the
	#            biggest number's string
	#          - the number to convert
	#
	# OUTPUT:  The buffer will be overwritten
	#          with the decimal string
	#
	# Variables:
	#
	# %ecx will hold the count of characters processed
	# %eax will hold the current value
	# %edi will hold the base (10)
	#
	.equ ST_VALUE, 8
	.equ ST_BUFFER, 12

	.globl integer2string
	.type integer2string, @function
integer2string:
	pushl %ebp
	movl  %esp, %ebp		# start stack frame

	movl  $0, %ecx			# current count is 0

	movl  ST_VALUE(%ebp), %eax	# move value into position

	movl  $10, %edi			# devide by 10 later

conversion_loop:	
	movl  $0, %edx			# divl takes combined %edx:%eax

	# devide (%edx:%eax) by %edi (10)
	divl  %edi
	# as result the quotient is in %eax
	# and the remainder in %edx (a number beween 0 and 9)

	# add the ascii code for '0' to the remainder
	addl  $'0', %edx
	# now %edx contains the ascii code for the remainder digit

	# push the ascii digit to stack, so we can pop later
	# for reverse order
	# only the byte  %dl is needed, but we push the whole word
	pushl %edx

	# increment digit count
	incl  %ecx

	# finished loop? check if the quotient is already 0
	cmpl  $0, %eax
	je    end_conversion_loop

	# %eax already has its new value
	jmp   conversion_loop


end_conversion_loop:
	# the string is now on the stack
	# get the pointer to buffer in %edx
	movl  ST_BUFFER(%ebp), %edx


copy_reversing_loop:
	# we did push a whole register but need only one byte
	# so we pop a word but move only one byte to the buffer
	popl  %eax
	movb  %al,  (%edx)

	# decrease %ecx so we know when finished
	decl  %ecx

	# increase %edx to point to next byte in buffer
	incl %edx

	# check if we are finished
	cmpl  $0, %ecx
	je end_copy_reversing_loop

	# else repeat loop
	jmp copy_reversing_loop


end_copy_reversing_loop:
	# done copying. now write a null byte and return
	movb $0, (%edx)


	movl %ebp, %esp
	popl %ebp
	ret
