default		rel

global		put_char_buffered:function
global		put_str_buffered:function
global		flush_buffer:function

BUFFER_CAPACITY	equ	4096

section		.text

;====================================================================================================
; Prints character to stdout. '\n' forces buffer flush.
;====================================================================================================
; Entry:	DIL		ASCII character to print
; Exit:		EAX		0 upon success, -1 otherwise
; Destroys:	RCX, RDX, RSI, RDI
;====================================================================================================
put_char_buffered:
		xor			rdx,			rdx
		mov WORD		dx,			[BufferSize]	; Buffer size in dx

		lea			rsi,			[OutputBuffer]
		add			rsi,			rdx		; rsi points to first free char
		mov BYTE		[rsi],			dil		; store char in buffer

		inc			dx
		mov WORD		[BufferSize],		dx		; update buffer size
		cmp			dx,			BUFFER_CAPACITY
		jz			.need_flush
		cmp			dil,			0x0A		; '\n'
		jz			.need_flush

		xor			eax,			eax
		ret

.need_flush:	call			flush_buffer
		ret								; eax set by flush_buffer
;====================================================================================================

;====================================================================================================
; Prints NUL-terminated string of characters to stdout
;====================================================================================================
; Entry:		RDI		- string address
; Exit:			EAX		- number of characters printed
; Destroys:		RCX, RDX, RSI, RDI
;====================================================================================================
put_str_buffered:
		xor			rcx,			rcx
.print_loop:	mov BYTE		al,			[rdi]
		test			al,			al		; is NUL-terminator?
		jz			.success				; TRUE: print finished

		push			rdi					; Save RDI on stack
		push			rcx					; Save RCX on stack

		mov			dil,			al		; character in DIL
		call			put_char_buffered

		pop			rcx					; Restore RCX from stack
		pop			rdi					; Restore RDI from stack

		test			rax,			rax
		jnz			.fail					; Print failed

		inc			ecx					; Increment character counter
		inc			rdi					; Next character
		jmp			.print_loop
		
.success: 	mov			eax,			ecx
		ret

.fail:		ret								; RAX already -1
;====================================================================================================
		
		
;====================================================================================================
; Empties output buffer and outputs its contents to `stdout`
; 
;====================================================================================================
; Entry:	None
; Exit:		EAX		0 upon success, -1 otherwise
; Destroys:	RCX, RDX, RSI, RDI
;====================================================================================================
flush_buffer:	xor			rdx,			rdx
		mov WORD		dx,			[BufferSize]	; length in dx
		test			dx,			dx
		jz			.skip

		lea			rcx,			[OutputBuffer]
		jmp			.write_loop

.loop_update:	sub			rdx,			rax
		jz			.success			; rdx = 0 - all written
		add			rcx,			rax	; next not printed character

.write_loop:	xor			rdi,			rdi
		inc			rdi				; rdi = 1 (STDOUT)
		mov			rsi,			rcx	; rsi = buffer start
		xor			rax,			rax
		inc			rax				; rax = 1 (write)

		push			rdx		; Save RDX on stack	(caller saved)
		push			rcx		; Save RCX on stack	(caller saved)
		syscall
		pop			rcx		; Restore RCX from stack
		pop			rdx		; Restore RDX from stack
		
		cmp			rax,			0	; check for errors
		jge			.loop_update
		ret							; write failed, eax = -1

.success:	xor			eax,			eax
		mov WORD		[BufferSize],		ax	; BufferSize = 0 after flush
		ret

.skip:		xor			eax,			eax
		ret
;====================================================================================================
		
section		.bss

OutputBuffer:	resb	BUFFER_CAPACITY
BufferSize:	resw	1

