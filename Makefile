CC         = stack ghc
CARGS      = --make -i./src
BINDER     = master
BRISK_ARGS = -fplugin Brisk.Plugin -fplugin-opt Brisk.Plugin:$(BINDER)
FILE       = src/Master.hs

.PHONY: all clean

all:
	$(CC) -- $(CARGS) $(BRISK_ARGS) $(FILE)

clean:
	rm -f src/*.{dyn_,}{hi,o}
