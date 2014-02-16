# CI build

GIT_BASE := git://github.com/haskell-distributed
include build.mk

reset: dist-clean
	rm -rf $(REPO_NAMES)

