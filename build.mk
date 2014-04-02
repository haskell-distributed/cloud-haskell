GHC ?= $(shell which ghc)
CABAL ?= $(shell which cabal)
PWD = $(shell pwd)
BRANCH=$(subst * ,,$(shell git branch | grep '*'))

ifneq (,$(LOCAL))
BASE_DIR ?= $(shell dirname `pwd`)
GIT_BASE ?= $(BASE_DIR)
SANDBOX ?= $(GIT_BASE)/.cabal-sandbox
BUILD_DIR ?= $(GIT_BASE)
else
SANDBOX ?= $(PWD)/.cabal-sandbox
GIT_BASE ?= git://github.com/haskell-distributed
endif

BUILD_DIR ?= $(PWD)/build

SANDBOX_CONFIG=$(PWD)/cabal.sandbox.config
TEST_SUITE ?=
REPO_NAMES=$(shell cat REPOS | sed '/^$$/d')
REPOS=$(patsubst %,$(BUILD_DIR)/%/.git/,$(REPO_NAMES))
CONF=./dist/setup-config
BUILD_DEPENDS=$(REPOS) $(SANDBOX) $(CONF)
CABAL_EXTRA ?=
PACKAGE ?=

.PHONY: all
all: install

.PHONY: push
push:
	$(shell git push origin $(BRANCH))

.PHONY: info
info:
	$(info git-base = ${GIT_BASE})
	$(info branch   = ${BRANCH})
	$(info ghc      = ${GHC})
	$(info cabal    = ${CABAL})
	$(info depends  = ${BUILD_DEPENDS})

.PHONY: clean
clean:
	$(CABAL) clean

.PHONY: dist-clean
dist-clean: clean
	rm -rf build
	rm -rf $(SANDBOX)
	rm -rf cabal.sandbox.config

.PHONY: build
compile: $(BUILD_DEPENDS)
	$(CABAL) build

.PHONY: test
test: $(BUILD_DEPENDS)
	$(CABAL) test $(TEST_SUITE) --show-details=always

$(CONF):
	$(CABAL) configure --enable-tests $(CABAL_EXTRA)

$(SANDBOX): $(SANDBOX_CONFIG)

$(SANDBOX_CONFIG):
	$(CABAL) sandbox init --sandbox=$(SANDBOX)

install-deps: $(REPOS) $(SANDBOX)
	$(CABAL) install --enable-tests --only-dependencies $(CABAL_EXTRA)

install: $(REPOS) $(SANDBOX)
	$(CABAL) install $(CABAL_EXTRA)

unregister: $(SANDBOX)
	$(CABAL) sandbox hc-pkg unregister $(PACKAGE) --sandbox=$(SANDBOX)

define repo_name
	$(lastword $(subst /, ,$1))
endef

define clone
	git clone $(GIT_BASE)/$1.git $(BUILD_DIR)/$1
endef

ifneq (,$(LOCAL))
%.git: $(SANDBOX_CONFIG) $(BUILD_DIR)
	git --git-dir=$@ \
            --work-tree=$(BUILD_DIR)/$(strip $(call repo_name,$(@D))) \
            checkout $(BRANCH)
	$(CABAL) sandbox add-source $(GIT_BASE)/$(strip $(call repo_name,$(@D)))
else
%.git: $(SANDBOX_CONFIG) $(BUILD_DIR)
	$(call clone,$(strip $(call repo_name,$(@D))))
	git --git-dir=$@ --work-tree=$(@D) checkout $(BRANCH)
	$(CABAL) sandbox add-source $(@D) --sandbox=$(SANDBOX)
endif

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

