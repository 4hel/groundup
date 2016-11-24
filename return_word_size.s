	.code32
	.section .data	
	.section .text
	.globl _start

_start:
	movl %esp, %ebx
	pushl $1
	movl %esp, %eax
	subl %eax, %ebx
	
exit_prog:	
	movl $1, %eax			# exit system call
	int $0x80	
			
	
