CC = stack ghc
CARGS = --make -fplugin Brisk.Plugin -isrc

.PHONY: all

all:
	$(CC) -- $(CARGS) -fplugin-opt Brisk.Plugin:master Master.hs
