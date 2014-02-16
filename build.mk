GHC ?= $(shell which ghc)
CABAL ?= $(shell which cabal)
PWD = $(shell pwd)
BRANCH=$(subst * ,,$(shell git branch | grep '*'))

ifneq (,$(LOCAL))
BASE_DIR ?= $(shell dirname `pwd`)
GIT_BASE ?= $(BASE_DIR)
SANDBOX ?= $(GIT_BASE)/.cabal-sandbox
else
SANDBOX ?= $(PWD)/.cabal-sandbox
GIT_BASE ?= git://github.com/haskell-distributed
endif

SANDBOX_CONFIG=$(PWD)/cabal.sandbox.config
TEST_SUITE ?=
REPO_NAMES=$(shell cat REPOS | sed '/^$$/d')
REPOS=$(patsubst %,$(PWD)/build/%.repo,$(REPO_NAMES))
CONF=./dist/setup-config
BUILD_DEPENDS=ensure-dirs $(REPOS) $(SANDBOX) $(CONF)

.PHONY: all
all: install

.PHONY: push
push:
	$(shell git push origin $(BRANCH))

.PHONY: info
info:
	$(info git-base = ${GIT_BASE})
	$(info branch = ${BRANCH})
	$(info ghc = ${GHC})
	$(info cabal = ${CABAL})
	$(info depends = ${BUILD_DEPENDS})

.PHONY: clean
clean:
	$(CABAL) clean

.PHONY: dist-clean
dist-clean: clean
	rm -rf build
	$(shell ${CABAL} sandbox delete --sandbox=${SANDBOX})
	rm -rf $(SANDBOX)


.PHONY: build
compile: $(BUILD_DEPENDS)
	$(CABAL) build

.PHONY: test
test: $(BUILD_DEPENDS)
	$(CABAL) test $(TEST_SUITE) --show-details=always

$(CONF): ensure-dirs
	$(CABAL) configure --enable-tests

$(SANDBOX): $(SANDBOX_CONFIG) install

$(SANDBOX_CONFIG):
	$(CABAL) sandbox init --sandbox=$(SANDBOX)

install: ensure-dirs $(REPOS)
	$(CABAL) install --enable-tests

ifneq (,$(LOCAL))
%.repo: $(SANDBOX_CONFIG)
	git --git-dir=$(GIT_BASE)/$(*F)/.git \
		--work-tree=$(GIT_BASE)/$(*F) \
		checkout $(BRANCH)
	$(CABAL) sandbox add-source $(GIT_BASE)/$(*F)
	touch $@
else

define clone
	git clone $(GIT_BASE)/$1.git ./build/$1
endef

%.repo: $(SANDBOX_CONFIG)
	$(call clone,$(*F))
	git --git-dir=$(@D)/$(*F)/.git \
		--work-tree=$(@D)/$(*F) \
		checkout $(BRANCH)
	cd $(@D)/$(*F) && $(CABAL) sandbox add-source $(@D)/$(*F) --sandbox=$(SANDBOX)
	touch $@
endif

ensure-dirs:
	mkdir -p $(PWD)/build

