SHELL      = /bin/bash
CC         = stack ghc
CARGS      = --make -i./src
BRISK_ARGS = -fplugin Brisk.Plugin

MODULES = Mapper Queue Master MapReduce
PROLOGS = $(patsubst %,%-pl,$(MODULES))

.PHONY: all clean $(MODULES) $(PROLOGS)

all: Master

$(PROLOGS): %-pl: src/%.hs
	$(CC) -- $(CARGS) $(BRISK_ARGS) \
		-fplugin-opt Brisk.Plugin:$(shell tr '[:upper:]' '[:lower:]' <<< $*) \
		$<

$(MODULES): %: src/%.hs
	stack exec -- brisk $< $@ $(shell tr '[:upper:]' '[:lower:]' <<< $@)

clean:
	rm -f src/*.{dyn_,}{hi,o}
