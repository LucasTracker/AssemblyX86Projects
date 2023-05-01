; Program em asm x86_64 que pede um número no input e imprime
BITS 64
section .data
section .text
global _start
_start:
	mov rbp, rsp							; Move o topo da pilha para o registrador rbp
	sub rsp, 0x10							; Aloca 16 bytes na pilha
.read:
	mov rax,0							; Copia o valor da syscall read
	mov rdi,0							; Indica a entrada padrão para Input
	lea rsi,[rbp]							; Carrega o endereço alocado em rsi
	mov rdx,0x10							; Indica a quantidade de bytes a serem lidos
	syscall								; Chama a Syscall

.print:
	mov rdx, rax							; Coloca a quantidade de bytes lidos em rax
	mov rax, 1							; Copia o valor da syscall write em rax
	mov rsi, rbp							; Copia o endereço que foi alocado na memória da pilha para rsi		
	mov rdi, 1							; Copia o valor de stdout
	syscall								; Chama a Syscall Write ;-)

.exit:
	add rsp, 0x10							; Devolve o espaço da memória alocada a pilha
	mov rax,60							; Coloca o valor da syscall Exit em rax
	xor rdi, rdi							; Zera o rdi
	syscall								; Chama a Syscall Exit ;-)
