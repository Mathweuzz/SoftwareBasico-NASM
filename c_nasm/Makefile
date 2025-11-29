CC      = gcc
AS      = nasm
CFLAGS  = -Wall -Wextra -no-pie
ASFLAGS = -f elf64
TARGET  = prog_c_nasm
OBJS    = main.o funcoes.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET)

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

funcoes.o: funcoes.asm
	$(AS) $(ASFLAGS) funcoes.asm -o funcoes.o

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET) $(OBJS)
