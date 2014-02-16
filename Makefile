# CI build

GIT_BASE := git://github.com/haskell-distributed
BUILD_DIR := $(shell pwd)
include build.mk

reset: dist-clean
	rm -rf $(REPO_NAMES)

