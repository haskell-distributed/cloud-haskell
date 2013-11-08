GHC ?= $(shell which ghc)
CABAL ?= $(shell which cabal)
CABAL_DEV ?= $(shell which cabal-dev)
PWD = $(shell pwd)
BRANCH=$(subst * ,,$(shell git branch | grep '*'))

ifneq (,$(LOCAL))
BASE_DIR ?= $(shell dirname `pwd`)
GIT_BASE ?= $(BASE_DIR)
SANDBOX ?= $(GIT_BASE)/cabal-dev
else
SANDBOX ?= $(PWD)/cabal-dev
GIT_BASE ?= git://github.com/haskell-distributed
endif

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
	$(info git-base = ${GIT_BASE})
	$(info branch = ${BRANCH})
	$(info ghc = ${GHC})

.PHONY: clean
clean:
	rm -rf ./build ./dist

.PHONY: dist-clean
dist-clean:
	rm -rf $(SANDBOX)

.PHONY: build
compile: $(REPOS) configure
	$(CABAL_DEV) build

.PHONY: configure
configure: $(BUILD_DEPENDS) ensure-dirs

$(BUILD_DEPENDS):
	$(CABAL_DEV) configure --enable-tests --sandbox=$(SANDBOX)

.PHONY: dev-install
ifneq (,$(CABAL_DEV))
install: ensure-dirs $(REPOS)
	$(CABAL_DEV) install --enable-tests --sandbox=$(SANDBOX)
else
install:
	$(error install cabal-dev to proceed)
endif

ifneq (,$(LOCAL))
ifneq (,$(SKIP_DEPS))
%.repo:
	git --git-dir=$(GIT_BASE)/$(*F)/.git \
		--work-tree=$(GIT_BASE)/$(*F) \
		checkout $(BRANCH)
	cd $(GIT_BASE)/$(*F) && $(CABAL_DEV) install --sandbox=$(SANDBOX)
	touch $@
else
%.repo:
	$(CABAL_DEV) add-source $(GIT_BASE)/$(*F)
	touch $@
endif
else
define clone
	git clone $(GIT_BASE)/$1.git ./build/$1
endef

%.repo:
	$(call clone,$(*F))
	git --git-dir=$(@D)/$(*F)/.git \
		--work-tree=$(@D)/$(*F) \
		checkout $(BRANCH)
	cd $(@D)/$(*F) && $(CABAL_DEV) install --sandbox=$(SANDBOX)
	touch $@
endif

ensure-dirs:
	mkdir -p $(PWD)/build
