	
	.equ SYS_EXIT, 1
	.equ LINUX_SYSCALL, 0x80
	.section .text
	.globl _start
_start:
	movq %rsp, %rbp

	# allocate 8 byte
	movq $8, %rdi
	callq allocate

	# write 255 to allocated memory
	movq $255, (%rax)

	# deallocate
	movq %rax, %rdi
	call deallocate
	
	movq $SYS_EXIT, %rax
	movq $0, %rbx
	int $LINUX_SYSCALL
