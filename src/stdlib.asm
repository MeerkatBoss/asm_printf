default		rel
global		_start

extern		main
extern		flush_buffer

section		.text

_start:		call			main

		push			rax					; Save RAX on stack
		call			flush_buffer
		pop			rax					; Restore RAX from stack

		mov			rdi,			rax
		mov			rax,			0x3C		; exit
		syscall
