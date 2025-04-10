# Yamada GPIO Logger - Makefile
PREFIX=/opt/YamadaDobby/yamada-gpio-logger
BINDIR=/usr/local/bin
LOGDIR=/var/log/YamadaDobby
SERVICEDIR=/etc/systemd/system
CONFIGDIR=$(PREFIX)/config

CC=gcc
CFLAGS=-Wall -Iinclude
SRCS=src/main.c src/gpio_monitor.c
OBJS=$(SRCS:.c=.o)
TARGET=gpio_monitor

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

install:
	@echo "Installing Yamada GPIO Logger..."
	mkdir -p $(PREFIX)
	mkdir -p $(LOGDIR)
	mkdir -p $(BINDIR)
	cp -r ascii config images include src ui $(PREFIX)
	cp gpio_monitor $(PREFIX)/
	cp dialog_ui.sh $(PREFIX)/ui/
	cp commit-template.txt $(PREFIX)/
	cp LICENSE README.md $(PREFIX)/
	cp service/yamada-gpio-monitor.service $(SERVICEDIR)/
	ln -sf $(PREFIX)/gpio_monitor $(BINDIR)/yamada-monitor
	ln -sf $(PREFIX)/ui/dialog_ui.sh $(BINDIR)/yamada-ui
	systemctl daemon-reexec
	systemctl enable yamada-gpio-monitor

uninstall:
	@echo "Uninstalling Yamada GPIO Logger..."
	systemctl disable yamada-gpio-monitor || true
	rm -f $(BINDIR)/yamada-monitor
	rm -f $(BINDIR)/yamada-ui
	rm -rf $(PREFIX)
	rm -rf $(LOGDIR)
	rm -f $(SERVICEDIR)/yamada-gpio-monitor.service
	systemctl daemon-reexec

clean:
	rm -f $(OBJS) $(TARGET)

