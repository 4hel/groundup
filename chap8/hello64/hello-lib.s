	# using 64-bit assembly because ld: cannot find -lc
	#
	.section .data
helloworld:
	.ascii "hello world\n\0"

	.section .text
	.globl _start
_start:
	pushq $helloworld
	call printf

	pushq $0
	call exit
