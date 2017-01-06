	.include "record-def.s"
	.include "linux.s"

	.equ ST_READ_BUFFER, 8
	.equ ST_FILEDES, 12

	.section .text
	.globl read_record
	.type read_record, @function
read_record:
	pushl %ebp
	movl %esp, %ebp

	pushl %ebx			# why are we saving this ?
	movl $SYS_READ, %eax
	movl ST_FILEDES(%ebp), %ebx
	movl ST_READ_BUFFER(%ebp), %ecx
	movl $RECORD_SIZE, %edx
	int $LINUX_SYSCALL
	# %eax now has our return value
	popl %ebx			# what was in %ebx ?

	movl %ebp, %esp
	popl %ebp
	ret
