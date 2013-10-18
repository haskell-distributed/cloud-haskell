# CI build

GHC ?= $(shell which ghc)
CABAL ?= $(shell which cabal)

BASE_GIT := git://github.com/haskell-distributed
REPOS=$(shell cat REPOS | sed '/^$$/d')

.PHONY: all
all: $(REPOS)

.PHONY: clean
clean:
	rm -rf $(REPOS)

$(REPOS):
	git clone $(BASE_GIT)/$@.git

.PHONY: install
install: $(REPOS)

# TODO: add benchmarks &c to this build
