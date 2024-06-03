print_flags.o: print_flags.asm
	nasm -felf64 $^ -o print_flags.o
	ld print_flags.o -o print_flags

clean:
	rm *.o print_flags

