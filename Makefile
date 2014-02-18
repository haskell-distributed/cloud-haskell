# CI build

GIT_BASE ?= git://github.com/haskell-distributed

# unlike standalone repos, we want our dependencies checked
# out into the current directory, not a ./build subdirectory
BUILD_DIR := $(shell pwd)

include build.mk

reset: dist-clean
	rm -rf $(REPO_NAMES)
	rm -rf $(REPOS)

install:
	$(info not installing cloud-haskell.cabal by default)
	$(info run force-install to override)

force-install:
	$(CABAL) install

define subcmd
	- $(MAKE) -C $(1) BUILD_DIR=${PWD} BASE_DIR=${PWD} LOCAL=true BRANCH=${BRANCH} $(2)
endef

tests: $(REPOS)
# yes, recursive make is ugly, and this even more so (to keep the output sane...)
	$(call subcmd,distributed-process-tests install-deps)
	$(call subcmd,network-transport-tcp install-deps)
	$(call subcmd,distributed-process-platform install-deps)
	$(call subcmd,distributed-process-tests test)
	$(call subcmd,network-transport-tcp test)
	$(call subcmd,distributed-process-platform test)

