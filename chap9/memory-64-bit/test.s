	
	.equ SYS_EXIT, 1
	.equ LINUX_SYSCALL, 0x80
	.globl _start
_start:	
	pushq $10
	call malloc
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
