bits 64
default rel

section .rodata

msg: db 'Physical-address width supported by the processor -> '
msglen equ $-msg
msg2: db 'Logical-address width supported by the processor  -> '
msg2len equ $-msg2

section .text
global _start
_start:
	mov eax, 0x80000008
	cpuid
	lea rsi,[rsp - 4] 
	push rsi
	mov ebx,eax
	xor ebp,ebp
.printMsg1:
	mov eax, 0x1
	mov edi, eax 
	lea rsi, [msg]
	mov edx, msglen
	syscall
	pop rsi
.buffer:
	movzx eax,bl
	mov ecx, 0xa
	mov byte [rsi], cl
	dec rsi
.convertToAscii:
	xor edx,edx
	div rcx
	add edx, 0x30
	mov byte [rsi], dl
	dec rsi
	test eax,eax
	jnz .convertToAscii
	inc rsi
.printNumber:
	mov eax, 0x1
	mov edi, eax
	lea rdx, [rsp - 3]
	sub rdx, rsi
	syscall
	test ebp, ebp
	jnz .exit
	lea rsi, [rsp - 4]
.printMsg2:
	push rsi
	mov eax, 0x1
	mov edi, eax
	lea rsi, [msg2]
	mov edx, msg2len
	syscall

	pop rsi
	mov bl,bh
	inc ebp
	jmp _start.buffer
.exit:
	mov eax, 60
	xor edi, edi
	syscall	
	
