SHELL      = /bin/bash
CC         = stack ghc
CARGS      = --make -i./src
BRISK_ARGS = -fplugin Brisk.Plugin $(BINDER)

MODULES = Mapper Queue Master MapReduce

.PHONY: all clean

all: Master

$(MODULES): %: src/%.hs
	$(CC) -- $(CARGS) $(BRISK_ARGS) \
		-fplugin-opt Brisk.Plugin:$(shell tr '[:upper:]' '[:lower:]' <<< $@) \
		$<

clean:
	rm -f src/*.{dyn_,}{hi,o}
