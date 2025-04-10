
CC = gcc
CFLAGS = -Wall -Iinclude
TARGET = gpio_monitor
SRCS = src/main.c src/gpio_monitor.c
OBJS = $(SRCS:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

clean:
	rm -f $(OBJS) $(TARGET)
