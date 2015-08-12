all:
	crystal run src/hashify.cr

build:
	crystal build -o bin/hashify src/hashify.cr
