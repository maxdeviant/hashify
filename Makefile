BIN_DIR=$(shell pwd)/bin/
PREFIX?=/usr/local
INSTALL_BIN=$(PREFIX)/bin/

all:
	crystal run src/hashify.cr

build:
	@mkdir -p $(BIN_DIR)
	crystal build -o $(BIN_DIR)hashify src/hashify.cr

install: build
	@cp $(BIN_DIR)hashify $(INSTALL_BIN)hashify
