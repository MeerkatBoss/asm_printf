default		rel

global		int_to_hex_str:function
global		int_to_bin_str:function
global		int_to_dec_str:function
global		int_to_oct_str:function

section 	.text

BUFFER_SIZE	equ	32

;====================================================================================================
; Copies bytes from source to destination
;====================================================================================================
; Entry:	RCX		number of bytes to copy
;		RDI		destination address
;		RSI		source address
; Exit:		RCX = 0
; Destroys:	RAX, RDI, RSI
;====================================================================================================
copy_bytes:	
.copy_loop:	mov BYTE		al,			[rsi]
		mov BYTE		[rdi],			al
										
		inc			rdi					; Increase both destination (rdi)
		inc			rsi					; 	and source (rsi) pointers

		loop			.copy_loop				; Continue copying

		ret
;====================================================================================================
		

;====================================================================================================
; Converts given integer value to hex representation and stores it in given buffer. If buffer size
; is not enough to contain hex representation, returns -1, otherwise returns 0
;====================================================================================================
; Entry:	EDI		input integer
;		RSI		buffer address
;		RDX		buffer size
; Exit:		EAX		-1 upon failure, 0 otherwise
; Destroys:	RCX, EDI, ESI, R8, R9
;====================================================================================================
int_to_hex_str:	xor			rcx,			rcx

		lea			r8,			[ConversionBuf+BUFFER_SIZE-1]	; End of buffer in r8
		lea			r9,			[HexDigits]	; HexDigits start in r9

.div_loop:	mov			eax,			edi
		and			eax,			0x0F		; Only last nibble
		mov BYTE		al,			[r9+rax]	; Get hexadecimal digit
		mov BYTE		[r8],			al

		inc			rcx					; Increase counter
		dec			r8					; Decrease address

		shr			edi,			4		; Divide by 16
		jnz			.div_loop

		inc			r8					; r8 points to first character

		mov			rax,			rcx
		inc			rax
		cmp			rdx,			rax		; rdx < rcx + 1 ?
		jae			.end

		mov			eax,			-1		; Buffer too small
		ret

.end:		mov			rdi,			rsi		; destination in rdi
		mov			rsi,			r8		; source in rsi
		mov			r8,			rcx		; save length
		add			r8,			rdi		; r8 points to last byte

		call			copy_bytes				; copy result to buffer

		mov BYTE		[r8],			0		; NUL-terminator
		
		xor			eax,			eax
		ret
;====================================================================================================

;====================================================================================================
; Converts given integer value to octal representation and stores it in given buffer. If buffer size
; is not enough to contain octal representation, returns -1, otherwise returns 0
;====================================================================================================
; Entry:	EDI		input integer
;		RSI		buffer address
;		RDX		buffer size
; Exit:		EAX		-1 upon failure, 0 otherwise
; Destroys:	RCX, EDI, ESI, R8, R9
;====================================================================================================
int_to_oct_str:	xor			rcx,			rcx
		lea			r8,			[ConversionBuf+BUFFER_SIZE-1]

.div_loop:	mov			eax,			edi
		and			eax,			07		; Get last three bits (octal digit)
		add			eax,			'0'		; Convert to character
		mov BYTE		[r8],			al		; Save in internal buffer

		dec			r8					; Decrease pointer
		inc			rcx					; Increase counter

		shr			edi,			3		; /8
		jnz			.div_loop

		inc			r8					; r8 points to first character

		mov			rax,			rcx
		inc			rax
		cmp			rdx,			rax		; rdx < rcx + 1 ?
		jae			.end

		mov			eax,			-1		; Buffer too small
		ret

.end:		mov			rdi,			rsi		; destination in rdi
		mov			rsi,			r8		; source in rsi
		mov			r8,			rcx		; save length
		add			r8,			rdi		; r8 points to last byte

		call			copy_bytes				; copy result to buffer

		mov BYTE		[r8],			0		; NUL-terminator
		
		xor			eax,			eax
		
		ret
;====================================================================================================

;====================================================================================================
; Converts given integer value to binary representation and stores it in given buffer. If buffer size
; is not enough to contain binary representation, returns -1, otherwise returns 0
;====================================================================================================
; Entry:	EDI		input integer
;		RSI		buffer address
;		RDX		buffer size
; Exit:		EAX		-1 upon failure, 0 otherwise
; Destroys:	RCX, EDI, ESI, R8, R9
;====================================================================================================
int_to_bin_str:	xor			rcx,			rcx
		lea			r8,			[ConversionBuf+BUFFER_SIZE-1]

.div_loop:	mov			eax,			edi
		and			eax,			1		; Get last bit
		add			eax,			'0'		; Convert to character
		mov BYTE		[r8],			al		; Save in internal buffer

		dec			r8					; Decrease pointer
		inc			rcx					; Increase counter

		shr			edi,			1		; /2
		jnz			.div_loop

		inc			r8					; r8 points to first character

		mov			rax,			rcx
		inc			rax
		cmp			rdx,			rax		; rdx < rcx + 1 ?
		jae			.end

		mov			eax,			-1		; Buffer too small
		ret

.end:		mov			rdi,			rsi		; destination in rdi
		mov			rsi,			r8		; source in rsi
		mov			r8,			rcx		; save length
		add			r8,			rdi		; r8 points to last byte

		call			copy_bytes				; copy result to buffer

		mov BYTE		[r8],			0		; NUL-terminator
		
		xor			eax,			eax
		
		ret
;====================================================================================================

;====================================================================================================
; Converts given integer value to decimal representation and stores it in given buffer. If buffer size
; is not enough to contain decimal representation, returns -1, otherwise returns 0
;====================================================================================================
; Entry:	EDI		input integer
;		RSI		buffer address
;		RDX		buffer size
; Exit:		EAX		-1 upon failure, 0 otherwise
; Destroys:	RCX, EDI, ESI, R8, R9, R10, R11
;====================================================================================================
int_to_dec_str:	xor			r9,			r9		; clear sign flag
		xor			r8,			r8
		inc			r8					; r8 = 1

		mov			eax,			edi
		neg			eax					; eax = -edi

		cmp			edi,			0
		cmovl			r9,			r8		; sign flag if < 0
		cmovl			edi,			eax		; edi = -edi if < 0

		lea			r8,			[ConversionBuf+BUFFER_SIZE-1]
		mov			r10,			10		; divisor
		mov			eax,			edi		; dividend
		mov			r11,			rdx		; save rdx due to its role in division
		xor			rcx,			rcx

.div_loop:	xor			rdx,			rdx		; rdx = 0 to avoid FPE
		idiv			r10d
		add			edx,			'0'		; get decimal digit
		mov BYTE		[r8],			dl		; digit to buffer
		
		inc			rcx
		dec			r8

		test			eax,			eax
		jnz			.div_loop

		mov			rax,			rcx
		inc			rax					; rax = rcx + 1
		mov			rdx,			r8
		inc			rdx					; rdx = r8 + 1

		mov BYTE		[r8],			'-'		; always put '-', maybe ignore later

		test			r9,			r9		; sign flag ?
		cmovnz			rcx,			rax		; rcx++ if sign flag
		cmovz			r8,			rdx		; r8++ if NOT sign flag

		; r8 now points to first character

		mov			rax,			rcx
		inc			rax
		cmp			r11,			rax		; r11 < rcx + 1 ?
		jae			.end

		mov			eax,			-1		; Buffer too small
		ret

.end:		mov			rdi,			rsi		; destination in rdi
		mov			rsi,			r8		; source in rsi
		mov			r8,			rcx		; save length
		add			r8,			rdi		; r8 points to last byte

		call			copy_bytes				; copy result to buffer

		mov BYTE		[r8],			0		; NUL-terminator
		
		xor			eax,			eax
		
		ret
;====================================================================================================
		
		
		
section		.rodata
HexDigits:	db '0123456789ABCDEF'

section		.bss
ConversionBuf:	resb	BUFFER_SIZE

