GHC ?= $(shell which ghc)
CABAL ?= $(shell which cabal)
CABAL_DEV ?= $(shell which cabal-dev)
PWD = $(shell pwd)
SANDBOX ?= $(PWD)/cabal-dev
BRANCH=$(subst * ,,$(shell git branch | grep '*'))
GIT_BASE ?= git://github.com/haskell-distributed
NO_LOCAL_UMBRELLA ?= FALSE
TEST_SUITE ?=
REPO_NAMES=$(shell cat REPOS | sed '/^$$/d')
REPOS=$(patsubst %,$(PWD)/build/%.repo,$(REPO_NAMES))
CONF=./dist/setup-config
CABAL=distributed-process-platform.cabal
BUILD_DEPENDS=$(CONF) $(CABAL)


.PHONY: all
all: install

.PHONY: test
test: $(REPOS)
	$(CABAL_DEV) test $(TEST_SUITE) --show-details=always

.PHONY: push
push:
	$(shell git push origin $(BRANCH))

.PHONY: info
info:
	$(info branch = ${BRANCH})
	$(info ghc = ${GHC})

.PHONY: clean
clean:
	rm -rf ./build ./dist ./cabal-dev

.PHONY: build
compile: configure
	$(CABAL_DEV) build

.PHONY: configure
configure: $(BUILD_DEPENDS)

$(BUILD_DEPENDS):
	$(CABAL_DEV) configure --enable-tests

.PHONY: dev-install
ifneq (,$(CABAL_DEV))
install: $(REPOS)
	$(CABAL_DEV) install --enable-tests
else
install:
	$(error install cabal-dev to proceed)
endif

ifneq (,$(NO_LOCAL_UMBRELLA))
define clone
	git clone $(GIT_BASE)/$1.git ./build/$1
endef
else
define clone
    git clone $(GIT_BASE)/$1 ./build/$1
endef
endif

%.repo:
	$(call clone,$(*F))
	git --git-dir=$(@D)/$(*F)/.git \
		--work-tree=$(@D)/$(*F) \
		checkout $(BRANCH)
	cd $(@D)/$(*F) && $(CABAL_DEV) install --sandbox=$(SANDBOX)
	touch $@

./build:
	mkdir -p build
