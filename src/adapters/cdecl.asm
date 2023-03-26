default		rel

global		call_cdecl_function:function

section		.text

;====================================================================================================
; Call function at specified address using parameter list
;====================================================================================================
; Entry:	RDI			- function address
;		RSI, RDX, RCX, R8, R9	- call arguments
; Exit:		RAX			- function return value
; Destroys:	RDI, RSI, RDX, RCX, R8, R9, R10, R11
;====================================================================================================
call_cdecl_function:
		pop			r10					; Remove return address from stack
		mov QWORD		[ReturnAddr],			r10	; Save return address for later

		push			r9
		push			r8
		push			rcx
		push			rdx
		push			rsi

		call			rdi					; Call function by address

		pop			rsi
		pop			rdx
		pop			rcx
		pop			r8
		pop			r9

		mov QWORD		r10,				[ReturnAddr]
		push			r10					; Restore correct return address
		
		ret
;====================================================================================================
		
section		.bss
ReturnAddr:	resq 1
