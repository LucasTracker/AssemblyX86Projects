; Um pequeno código que soma o número 10 vindo da memória e retorna o valor 20
section .data
number01: dq 0xa
section .text
global _start
_start:
	mov rbp, rsp							; Move o topo da pilha para o registrador rbp
	sub rsp, 0x10							; Aloca 16 bytes na pilha
	mov rax, [number01]						; Copia o conteúdo da memória da label number01 para rax
	add rax, 0xa							; Soma 10 no rax
	mov rbx, 1							; Copia o valor rbx para contar a quantidade de bytes a serem lidos na memória

.newline:
	mov byte [rbp], 0xa						; Adiciona o caracter de nova linha
	dec rbp								; Avança a posição da memória alocada
	inc rbx								; Incrementa a quantidade de bytes inseridos na memória
.converteParaAscii:
	xor rdx,rdx							; Zera o rdx
	mov rcx, 0xa							; Copia o valor 10 no registrador rcx que será o divisor do inteiro a ser impresso
	div rcx								; Faz a divisão (rax -> quociente; rdx -> resto)

	add rdx, 0x30							; Soma o resto com o valor hexadecimal 0x30 que representa o número de 0 a 9
	mov byte [rbp], dl						; Move 1 byte para a memória alocada
	dec rbp								; Avança 1 posição da memória alocada para colocar os outros dígitos do número
	inc rbx								; Incrementa a quantidade de bytes colocada na memória
	test rax,rax							; Verifica se o rax teve resto zero (critério de parada)
	jnz .converteParaAscii						; Caso o rax for diferente de zero repete a sequência de .loop

.print:
	mov rax, 1							; Copia o valor da syscall write em rax
	mov rsi, rbp							; Copia o endereço que foi alocado na memória da pilha para rsi
	mov rdx, rbx							; Copia a quantidade de Bytes colocadas na memória
	mov rdi, 1							; Copia o valor de stdout
	syscall								; Chama a Syscall Write ;-)

.exit:
	add rsp, 0x10							; Devolve o espaço da memória alocada a pilha
	mov rax,60							; Coloca o valor da syscall Exit em rax
	xor rdi, rdi							; Zera o rdi
	syscall								; Chama a Syscall Exit ;-)
