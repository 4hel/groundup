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

	.equ HEADER_SIZE, 16
	.equ HDR_AVAIL_OFFSET, 0
	.equ HDR_SIZE_OFFSET, 8


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
	pushq %rbp			# start stack frame
	movq %rsp, %rbp			#

	# find out where the break is (call with 0)
	# heap size still 0
	movq $SYS_BRK, %rax
	movq $0, %rbx
	int $LINUX_SYSCALL

	incq %rax			# location after last valid addr

	#
	# the retval from SYS_BRK will be written position independently to
	# 1. current_break
	# 2. heap_begin
	#
	lea current_break(%rip), %rbx	# get pic addr of current_break into %rbx
	movq %rax, (%rbx)		# write value to current_break

	lea heap_begin(%rip), %rbx	# get pic addr of heap_begin into %rbx
	movq %rax, (%rbx)		# write value to heap_begin

	
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
	.globl allocate
	.type allocate, @function
	.equ ST_MEM_SIZE, 8		# param position on stack
allocate:
	pushq %rbp			# start stack frame
	movq %rsp, %rbp


	# load value of heap_begin into %rax position independently
	lea heap_begin(%rip), %rdx
	movq (%rdx), %rax
	
	# check if already initialized
	# if not call allocate_init
	cmpq $0, %rax
	jne setup_variables
	call allocate_init

setup_variables:	
	movq ST_MEM_SIZE(%rbp), %rcx	# size param -> register

	
	# load value of heap_begin into %rax position independently
	lea heap_begin(%rip), %rdx
	movq (%rdx), %rax

	# load value of current_break into %rbx position independently
	lea current_break(%rip), %rdx
	movq (%rdx), %rbx
	

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


	# save value of %rbx to current_break
	lea current_break(%rip), %rdx	# get pic addr of current_break into %rdx
	movq %rbx, (%rdx)		# write value to current_break



	

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
	.globl deallocate
	.type deallocate, @function
	.equ ST_MEMORY_SEG, 4
deallocate:
	movq ST_MEMORY_SEG(%rsp), %rax
	subq $HEADER_SIZE, %rax
	movq $AVAILABLE, HDR_AVAIL_OFFSET(%rax)
	ret
	
