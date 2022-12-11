.PHONY := all

all: build run

build: main.asm
	nasm -felf32 -o main.o main.asm
	ld -melf_i386 -o main main.o
	rm main.o

run: main
	./main