bits 64
default rel

section .data

msg: db 'Physical-address width supported by the processor -> '
msglen: equ $-msg
msg2: db 'Logical-address width supported by the processor  -> '
msg2len: equ $-msg2

section .text
global _start
_start:
	push rbx
	mov eax, 0x80000008
	cpuid
	lea rsi,[rsp - 4] 
	push rsi
	mov ebx,eax
	mov r12, 0x1
.printMsg1:
	mov eax, 0x1
	mov edi, 0x1
	mov rsi, msg
	mov edx, msglen
	syscall
	pop rsi
.buffer:
	movzx eax,bl
	mov r11d, 0xa
	mov byte [rsi], 0xa
	dec rsi
.convertToAscii:
	xor rdx,rdx
	div r11
	add rdx, 0x30
	mov byte [rsi], dl
	dec rsi
	test eax,eax
	jnz .convertToAscii
	inc rsi
.printNumber:
	mov eax, 0x1
	mov edi, 0x1
	lea rdx, [rsp - 3]
	sub rdx, rsi
	syscall
	lea rsi, [rsp - 4]
	cmp r12, 0x2
	je .exit
.printMsg2:
	push rsi
	mov eax, 0x1
	mov edi, 0x1
	mov rsi, msg2
	mov edx, msg2len
	syscall

	pop rsi
	mov bl,bh
	inc r12
	jmp .buffer
.exit:
	pop rbx
	mov eax, 60
	xor rdi, rdi
	syscall	
	
