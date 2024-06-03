bits 64
default rel

section .rodata

msg: db 'LAHF/SAHF available in 64-bit mode?-> '
msg_len equ $-msg

cf: db ' CF -> '
pf: db ' PF -> '
af: db ' AF -> '
zf: db ' ZF -> '
sf: db ' SF -> '
tf: db ' TF -> '
if: db ' IF -> '
df: db ' DF -> '
of: db ' OF -> '
nt: db ' NT -> '
flagMsg_len equ $-nt

rflags_tag:
	db '**************** RFLAGS ****************', 0xa
rflags_tag_len equ $-rflags_tag

yesorno:
	dq no
	dq yes
	
yes:
	db 'Yes', 0xa

no:
	db 'No', 0xa

section .text
%macro write_msg 1
 mov eax, 1
 mov edi, eax
 mov edx, %1
 syscall
%endmacro

; Flag's Bit position
%define CF_POSITION 0
%define PF_POSITION 2
%define AF_POSITION 4
%define ZF_POSITION 6
%define SF_POSITION 7
%define TF_POSITION 8
%define IF_POSITION 9
%define DF_POSITION 10
%define OF_POSITION 11
%define IOPL_POSITION 12 ; 12-13
%define NT_POSITION 14

%macro load_flag 1
	mov ah,bh
	sar al, %1
	and al, 1
	add al, 0x30
	mov ah, 0xa	; Load the newline character into ah
	mov [rsp - 4], eax
	lea rsi, [rsp - 4]
%endmacro

global _start
_start:
	push rbx
	lea rsi, [msg]
	write_msg msg_len
	mov eax, 0x80000001
	cpuid
	and ecx, 0x1
	lea rsi, [msg]

	push rcx
	mov rsi, [yesorno + rcx*8]
	write_msg 4	
	pop rcx

	test ecx, 1
	jz .exit	; Quit the program (because the LAHF instruction isn't supported by 64-bit mode).

	lea rsi, [rflags_tag]
	write_msg rflags_tag_len

	lea rsi, [cf]	; Carry Flag
	write_msg flagMsg_len 

	lahf		; Load the (r)eflags into AH register
	mov bh,ah
	load_flag CF_POSITION
	write_msg 4		


	lea rsi,[pf]	; Parity Flag
	write_msg flagMsg_len

	load_flag PF_POSITION 
	write_msg 4

	lea rsi, [af]	; Auxiliary Flag
	write_msg flagMsg_len

	load_flag AF_POSITION
	write_msg 4

	lea rsi, [zf]	; Zero Flag
	write_msg flagMsg_len

	load_flag ZF_POSITION
	write_msg 4

	lea rsi, [sf]	; Sign Flag
	write_msg flagMsg_len

	load_flag SF_POSITION
	write_msg 4

	lea rsi, [tf]	; Trap Flag
	write_msg flagMsg_len

	load_flag TF_POSITION
	write_msg 4

	lea rsi, [if]	; Interrupt Enable Flag
	write_msg flagMsg_len

	load_flag IF_POSITION
	write_msg 4

	lea rsi, [df]	; Direction Flag
	write_msg flagMsg_len

	load_flag DF_POSITION
	write_msg 4

	lea rsi, [of]	; Overflow Flag
	write_msg flagMsg_len

	load_flag OF_POSITION
	write_msg 4

	;TODO -> Implement the function write_msg to flag IOPL here.

	lea rsi, [nt]	; Nested Task Flag
	write_msg flagMsg_len

	load_flag NT_POSITION
	write_msg 4


.exit:
	pop rbx
	mov eax, 60
	xor edi, edi
	syscall	

