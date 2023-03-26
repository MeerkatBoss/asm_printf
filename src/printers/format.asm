default		rel

global		print_format:function

extern		int_to_hex_str
extern		int_to_oct_str
extern		int_to_bin_str
extern		int_to_dec_str
extern		put_char_buffered
extern		put_str_buffered

section		.text

;====================================================================================================
; Print arguments based on format specifiers
;====================================================================================================
; Entry:	[RSP+8]		- start of parameter list
; Exit:		EAX		- number of characters printed
; Destroys:	RCX, RSI, RDI
;====================================================================================================
print_format:	push			rbp
		mov			rbp,			rsp

		mov QWORD		rsi,			[rbp+16]	; string address in rsi
		lea			rdi,			[rbp+24]	; start of parameter list
		xor			rcx,			rcx

.print_loop:	mov BYTE		al,			[rsi]
		inc			rsi					; Next character

		test			al,			al		; is NUL-terminator?
		jz			.success				; TRUE: print finished

		cmp			al,			'%'
		jne			.print_char

		push			rcx					; Save RCX on stack
		call			print_special
		pop			rcx					; Restore RCX from stack

		cmp			eax,			0
		jl			.fail					; Print failed

		add			ecx,			eax
		jmp			.print_loop

.print_char:	push			rsi					; Save RSI on stack
		push			rdi					; Save RDI on stack
		push			rcx					; Save RCX on stack

		mov			dil,			al		; character in DIL
		call			put_char_buffered

		pop			rcx					; Restore RCX from stack
		pop			rdi					; Restore RDI from stack
		pop			rsi					; Restore RSI from stack

		test			eax,			eax
		jnz			.fail					; Print failed

		inc			ecx					; Increment character counter
		jmp			.print_loop
		
.success:	pop			rbp
		mov			eax,			ecx
		ret

.fail:		mov			rsp,			rbp		; Free stack space
		pop			rbp
		ret								; RAX already -1
;====================================================================================================

;====================================================================================================
; Print entry based on format specifier
;====================================================================================================
; Entry:	RSI		address of specifier start
;		RDI		address of parameter list
; Exit:		EAX		number of characters printed or -1 upon error
;		RSI		address of first unused character
;		RDI		address of first unused parameter
; Destroys:	RCX, RDX
;====================================================================================================
print_special:	xor			rax,			rax
		mov BYTE		al,			[rsi]
		inc			rsi					; next character
		mov			rcx,			rax		; Save RAX in RCX
		sub			al,			'b'
		jl			.spec_literal				; Not in table

		cmp			al,			TABLE_BD_LEN
		jge			.select_table_2				; In second table

		lea			rdx,			[TableB_D]
		jmp			[rdx+8*rax]

.select_table_2:
		sub			al,			'o'-'b'
		jl			.spec_literal				; Not in table

		cmp			al,			TABLE_OX_LEN
		jge			.spec_literal				; Not in table

		lea			rdx,			[TableO_X]
		jmp			[rdx+8*rax]

;CASE 'b'
.spec_binary:	push			rsi					; Save RSI on stack
		push			rdi					; Save RDI on stack

		mov			rdi,			[rdi]
		lea			rsi,			[NumberBuf]
		mov			rdx,			BUFFER_LEN+1
		call			int_to_bin_str				; No error can happen here

		lea			rdi,			[NumberBuf]
		call			put_str_buffered
		
		pop			rdi					; Restore RDI from stack
		pop			rsi					; Restore RSI from stack
		add			rdi,			8		; Next argument

		jmp			.end					; eax already set correctly

;CASE 'c'
.spec_char:	push			rsi					; Save RSI on stack
		push			rdi					; Save RDI on stack

		mov			rdi,			[rdi]
		call			put_char_buffered

		pop			rdi					; Restore RDI from stack
		pop			rsi					; Restore RSI from stack
		add			rdi,			8		; Next argument

		jmp			.end					; eax already set correctly

;CASE 'd'
.spec_decimal:	push			rsi					; Save RSI on stack
		push			rdi					; Save RDI on stack

		mov			rdi,			[rdi]
		lea			rsi,			[NumberBuf]
		mov			rdx,			BUFFER_LEN+1
		call			int_to_dec_str				; No error can happen here

		lea			rdi,			[NumberBuf]
		call			put_str_buffered
		
		pop			rdi					; Restore RDI from stack
		pop			rsi					; Restore RSI from stack
		add			rdi,			8		; Next argument

		jmp			.end					; eax already set correctly

;CASE 'o'
.spec_octal:	push			rsi					; Save RSI on stack
		push			rdi					; Save RDI on stack

		mov			rdi,			[rdi]
		lea			rsi,			[NumberBuf]
		mov			rdx,			BUFFER_LEN+1
		call			int_to_dec_str				; No error can happen here

		lea			rdi,			[NumberBuf]
		call			put_str_buffered
		
		pop			rdi					; Restore RDI from stack
		pop			rsi					; Restore RSI from stack
		add			rdi,			8		; Next argument

		jmp			.end					; eax already set correctly

;CASE 's'
.spec_string:	push			rsi					; Save RSI on stack
		push			rdi					; Save RDI on stack

		mov			rdi,			[rdi]
		call			put_str_buffered
		
		pop			rdi					; Restore RDI from stack
		pop			rsi					; Restore RSI from stack
		add			rdi,			8		; Next argument

		jmp			.end					; eax already set correctly


;CASE 'x'
.spec_hex: 	push			rsi					; Save RSI on stack
		push			rdi					; Save RDI on stack

		mov			rdi,			[rdi]
		lea			rsi,			[NumberBuf]
		mov			rdx,			BUFFER_LEN+1
		call			int_to_hex_str				; No error can happen here

		lea			rdi,			[NumberBuf]
		call			put_str_buffered
		
		pop			rdi					; Restore RDI from stack
		pop			rsi					; Restore RSI from stack
		add			rdi,			8		; Next argument

		jmp			.end					; eax already set correctly

; DEFAULT
.spec_literal:	push			rdi					; Save RDI on stack
		push			rsi					; Save RSI on stack
		mov			dil,			cl		; character in DIL
		call			put_char_buffered
		pop			rsi					; Restore RSI from stack
		pop			rdi					; Restore RDI from stack

		test			eax,			eax
		jnz			.end					; Failed print, end with same eax

		xor			rax,			rax
		inc			rax					; RAX = 1

.end:		ret
;====================================================================================================
		


section		.rodata
TableB_D:	dq	print_special.spec_binary		; 'b'
		dq	print_special.spec_char			; 'c'
		dq	print_special.spec_decimal		; 'd'

TABLE_BD_LEN	equ	($ - TableB_D)/8

TableO_X	dq	print_special.spec_octal		; 'o'
		dq	print_special.spec_literal		; 'p'
		dq	print_special.spec_literal		; 'q'
		dq	print_special.spec_literal		; 'r'
		dq	print_special.spec_string		; 's'
		dq	print_special.spec_literal		; 't'
		dq	print_special.spec_literal		; 'u'
		dq	print_special.spec_literal		; 'v'
		dq	print_special.spec_literal		; 'w'
		dq	print_special.spec_hex			; 'x'

TABLE_OX_LEN	equ	($ - TableO_X)/8

section		.bss
BUFFER_LEN	equ	32
NumberBuf:	resb	BUFFER_LEN+1 ; Reserve space for NUL-terminator
		
