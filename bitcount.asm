; Código que implementa a operação x &= (x-1) que deleta o bit 1 do x mais a direita
section .data
section .text
global _start

_start:
	mov rbp, rsp
	sub rsp, 0x20
	mov edi, 0x5
	mov eax, edi
	xor rcx,rcx
	mov rbx,1
.bitcount:
	sub eax, 0x1
	and eax, edi
	test eax,eax
	je .newline
	inc rcx
	jnz .bitcount

.newline:
	mov byte[rbp], 0xa
	dec rbp
	inc rbx
.converteParaAscii:
	mov rax, rcx
	mov rcx, 0x10
	div rcx
	add rdx, 0x30
	mov byte [rbp],dl
	inc rbx
	dec rbp
	test rax,rax
	jnz .converteParaAscii
.printResult:
	mov eax, 1
	mov edi, 1
	mov rsi, rbp
	mov rdx, rbx
	syscall
.exit:
	add rsp, 0x20
	mov eax, 60
	xor rdi,rdi
	syscall
