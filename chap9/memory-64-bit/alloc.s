# PURPOSE: functions to manage memory
#          - allocate
#          - deallocate
#
# NOTES:   one allocated memory chunk looks like this:
#          | Available_marker | Size_of_chunk | Actual_location_returned

	.section .data
	
##### GLOBAL VARIABLES #####

trace_string:
	.ascii "syscall brk made"
	
# beginning of the memory we are managing
heap_begin:
	.quad 0

# one location past the memory we are managing
current_break:
	.quad 0
	

	##### STRUCTURE INFORMATION #####

	.equ HEADER_SIZE, 16
	.equ HDR_AVAIL_OFFSET, 0
	.equ HDR_SIZE_OFFSET, 8


	##### CONSTANTS #####

	.equ UNAVAILABLE, 0
	.equ AVAILABLE, 1
	.equ SYS_BRK, 45
	.equ SYS_WRITE, 4
	.equ SYS_EXIT, 1
	.equ STDOUT, 1
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
	pushq %rbp			# start stack frame
	movq %rsp, %rbp			#

	# find out where the break is (call with 0)
	# heap size still 0
	movq $SYS_BRK, %rax
	movq $0, %rbx
	int $LINUX_SYSCALL

	incq %rax			# location after last valid addr
	movq %rax, current_break	# currently the break, heap size=0
	movq %rax, heap_begin		# first addr of heap

	movq %rbp, %rsp			# exit function
	popq %rbp
	ret

	# allocate:   grab a section of memory
        #             first iterate blocks to find one available
	#             if not found one, then move up system break
	#
	# parameters: 1. size of requested memory block
	#
	# ret value:  %rax -> address of the allocated memory
	#
	# variables used:
	#
	#             %rcx - size of requested memory block
	#             %rax - currently examined memory block
	#             %rbx - current break position
	#             %rdx - size of current memory region
	.globl malloc
	.type malloc, @function
malloc:
	pushq %rbp			# start stack frame
	movq %rsp, %rbp

	# check if already initialized
	# if not call allocate_init
	movq current_break, %rax
	cmpq $0, %rax
	jne setup_variables
	callq allocate_init

setup_variables:	
	movq %rdi, %rcx			# size param -> %rcx register
	movq heap_begin, %rax
	movq current_break, %rbx

alloc_loop_begin:
	cmpq %rbx, %rax			# if( heap_begin / current block  == current_break )
	je move_break			# then goto move_break

	movq HDR_SIZE_OFFSET(%rax), %rdx	# grab the size of curren block
	cmpq $UNAVAILABLE, HDR_AVAIL_OFFSET	# if unavailable
	je next_location			# then goto next_location

double_check_cmp:	
	cmpq %rdx, %rcx			# if ( %rcx <= %rdx )
	jle allocate_here		# then goto allocate_here

next_location:
	addq $HEADER_SIZE, %rax		# %rax += HEADER_SIZE
	addq %rdx, %rax			# %rax += size of block
	jmp alloc_loop_begin

allocate_here:
	movq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax)	# mark unavailable
	addq $HEADER_SIZE, %rax				# move %rax past header for return

	movq %rbp, %rsp			# exit function
	popq %rbp
	ret

move_break:
	addq $HEADER_SIZE, %rbx		# add header size to current break
	addq %rcx, %rbx			# add requested size to current break

	pushq %rax			# save registers
	pushq %rcx
	pushq %rbx

	#
	# print trace
	#
	movq $SYS_WRITE, %rax
	movq $STDOUT, %rbx
	movq $trace_string, %rcx
	movq $16, %rdx
	int $LINUX_SYSCALL

	popq %rbx
	pushq %rbx
	
	movq $SYS_BRK, %rax		# %rbx holds new break
	int $LINUX_SYSCALL

	cmpq $0, %rax			# check for error
	je error

	popq %rbx			# restore registers
	popq %rcx
	popq %rax

	# write header fields
	movq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax)
	movq %rcx, HDR_SIZE_OFFSET(%rax)

	addq $HEADER_SIZE, %rax		# move %rax to start of usable memory
					# %rax is now retval

	movq %rbx, current_break	# save new break

	movq %rbp, %rsp			# exit function
	popq %rbp
	ret

error:
	movq $0, %rax
	movq %rbp, %rsp			# exit function
	popq %rbp
	ret
####### END OF FUNCTION #######


	# deallocate:	make a block of memory available again
	#
	# parameters:	1. address of memory block
	#
	# return value: none
	.globl free
	.type free, @function
free:
	movq %rdi, %rax			# param passed via %rdi
	subq $HEADER_SIZE, %rax
	movq $AVAILABLE, HDR_AVAIL_OFFSET(%rax)
	ret
	
