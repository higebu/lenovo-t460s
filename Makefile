#!/usr/bin/make -f

PREFIX		?= .
TMPDIR		= $(PREFIX)/tmp

all: build

build:
	@echo Building cd...
	build-simple-cdd --conf profiles/t460s.conf --dist jessie --force-root

clean:
	@echo Cleaning up files...
	rm -rf $(TMPDIR)
	@echo done.
