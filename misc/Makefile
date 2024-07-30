# Makefile for compiling the attack program

# Compiler
CC = gcc

# Compiler flags
CFLAGS = -Wall -Wextra -O2

# Linker flags
LDFLAGS = -lpthread

# Target executable
TARGET = http_req_overload

# Source files
SRCS = http_req_overload.c

# Object files
OBJS = $(SRCS:.c=.o)

# Default target
all: $(TARGET)

# Link the object files to create the executable
$(TARGET): $(OBJS)
	$(CC) -o $@ $(OBJS) $(LDFLAGS)

# Compile source files to object files
%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

# Clean up build files
clean:
	rm -f $(TARGET) $(OBJS)
