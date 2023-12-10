# AssemblyX86Projects
Este é um repositório onde eu coloco meus pequenos códigos feitos em assembly x86_64 para solucionar determinados problemas.

Para compilar qualquer arquivo asm use o seguinte comando

nasm -felf64 <nome_do_arquivo.asm> -o <nome_do_arquivo.o> && ld -o <nome_do_arquivo> <nome_do_arquivo.o>

Exemplo:

nasm -felf64 cpuid.asm -o cpuid.o && ld -o cpuid cpuid.o
