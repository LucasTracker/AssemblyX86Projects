eflags.o: eflags.asm
	nasm -felf64 eflags.asm -o eflags.o
	ld eflags.o -o print_eflags

clean:
	rm *.o print_eflags

