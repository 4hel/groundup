	
	.equ SYS_EXIT, 1
	.equ LINUX_SYSCALL, 0x80
	.section .text
	.globl _start
_start:
	movq %rsp, %rbp
	movq $10, %rdi
	callq allocate
	movq $SYS_EXIT, %rax
	movq $0, %rbx
	int $LINUX_SYSCALL
