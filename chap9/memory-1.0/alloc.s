# PURPOSE: functions to manage memory
#          - allocate
#          - deallocate
#
# NOTES:   one allocated memory chunk looks like this:
#          | Available_marker | Size_of_chunk | Actual_location_returned

	.section .data
	
##### GLOBAL VARIABLES #####

# beginning of the memory we are managing
heap_begin:
	.long 0

# one location past the memory we are managing
current_break:
	.long 0
	

	##### STRUCTURE INFORMATION #####

	.equ HEADER_SIZE, 8
	.equ HDR_AVAIL_OFFSET, 0
	.equ HDR_SIZE_OFFSET, 4


	##### CONSTANTS #####

	.equ UNAVAILABLE, 0
	.equ AVAILABLE, 1
	.equ SYS_BRK, 45
	.equ LINUX_SYSCALL, 0x80


	.section .text

	##### FUNCTIONS #####

	# allocate_init: call this first
	#                it initializes: heap_begin
	#                                current_break
	#
	# parameters:    none
	#
	.globl allocate_init
	.type allocate_init, @function
allocate_init:
	pushl %ebp			# start stack frame
	movl %esp, %ebp			#

	# find out where the break is (call with 0)
	# heap size still 0
	movl $SYS_BRK, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL

	incl %eax			# location after last valid addr
	movl %eax, current_break	# currently the break, heap size=0
	movl %eax, heap_begin		# first addr of heap

	movl %ebp, %esp			# exit function
	popl %ebp
	ret

	# allocate:   grab a section of memory
        #             first iterate blocks to find one available
	#             if not found one, then move up system break
	#
	# parameters: 1. size of requested memory block
	#
	# ret value:  %eax -> address of the allocated memory
	#
	# variables used:
	#
	#             %ecx - size of requested memory block
	#             %eax - currently examined memory block
	#             %ebx - current break position
	#             %edx - size of current memory region
	.globl allocate
	.type allocate, @function
	.equ ST_MEM_SIZE, 8		# param position on stack
allocate:
	pushl %ebp			# start stack frame
	movl %esp, %ebp

	movl ST_MEM_SIZE(%ebp), %ecx	# size param -> register
	movl heap_begin, %eax
	movl current_break, %ebx

alloc_loop_begin:
	cmpl %ebx, %eax			# if( heap_begin / current block  == current_break )
	je move_break			# then goto move_break

	movl HDR_SIZE_OFFSET(%eax), %edx	# grab the size of curren block
	cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET	# if unavailable
	je next_location			# then goto next_location

double_check_cmp:	
	cmpl %edx, %ecx			# if ( %ecx <= %edx )
	jle allocate_here		# then goto allocate_here

next_location:
	addl $HEADER_SIZE, %eax		# %eax += HEADER_SIZE
	addl %edx, %eax			# %eax += size of block
	jmp alloc_loop_begin

allocate_here:
	movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)	# mark unavailable
	addl $HEADER_SIZE, %eax				# move %eax past header for return

	movl %ebp, %esp			# exit function
	popl %ebp
	ret

move_break:
	addl $HEADER_SIZE, %ebx		# add header size to current break
	addl %ecx, %ebx			# add requested size to current break

	pushl %eax			# save registers
	pushl %ecx
	pushl %ebx

	movl $SYS_BRK, %eax		# %ebx holds new break
	int $LINUX_SYSCALL

	cmpl $0, %eax			# check for error
	je error

	popl %ebx			# restore registers
	popl %ecx
	popl %eax

	# write header fields
	movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
	movl %ecx, HDR_SIZE_OFFSET(%eax)

	addl $HEADER_SIZE, %eax		# move %eax to start of usable memory
					# %eax is now retval

	movl %ebx, current_break	# save new break

	movl %ebp, %esp			# exit function
	popl %ebp
	ret

error:
	movl $0, %eax
	movl %ebp, %esp			# exit function
	popl %ebp
	ret
####### END OF FUNCTION #######


	# deallocate:	make a block of memory available again
	#
	# parameters:	1. address of memory block
	#
	# return value: none
	.globl deallocate
	.type deallocate, @function
	.equ ST_MEMORY_SEG, 4
deallocate:
	movl ST_MEMORY_SEG(%esp), %eax
	subl $HEADER_SIZE, %eax
	movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)
	ret
	
