
CC = gcc
CFLAGS = -Wall -Iinclude
TARGET = gpio_monitor
SRCS = src/main.c src/gpio_monitor.c
OBJS = $(SRCS:.c=.o)

PREFIX = /opt/YamadaDobby/yamada-gpio-logger
BINDIR = /usr/local/bin
LOGDIR = /var/log/YamadaDobby
SERVICEDIR = /etc/systemd/system
SERVICEFILE = service/yamada-gpio-monitor.service
UISH = ui/dialog_ui.sh

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

install:
	@echo "Installing Yamada GPIO Logger..."
	mkdir -p $(PREFIX)
	mkdir -p $(LOGDIR)
	mkdir -p $(SERVICEDIR)
	mkdir -p $(BINDIR)
	mkdir -p $(PREFIX)/ui

	cp $(TARGET) $(PREFIX)/
	cp $(UISH) $(PREFIX)/ui/
	cp $(SERVICEFILE) $(SERVICEDIR)/

	ln -sf $(PREFIX)/$(TARGET) $(BINDIR)/yamada-monitor
	ln -sf $(PREFIX)/ui/dialog_ui.sh $(BINDIR)/yamada-ui

	systemctl daemon-reexec
	systemctl enable yamada-gpio-monitor

uninstall:
	@echo "Uninstalling Yamada GPIO Logger..."
	systemctl disable yamada-gpio-monitor || true
	rm -f $(BINDIR)/yamada-monitor
	rm -f $(BINDIR)/yamada-ui
	rm -f $(SERVICEDIR)/yamada-gpio-monitor.service
	rm -rf $(PREFIX)
	rm -rf $(LOGDIR)
	systemctl daemon-reexec

clean:
	rm -f $(OBJS) $(TARGET)
