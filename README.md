### Cloud Haskell Build Umbrella

This repository contains tools to assist with building and
developing Cloud Haskell itself.

### Status

Right now, there is a top-level Makefile that you can use to
obtain a copy of all the relevant git repositories and a build.mk
utility makefile that each project pulls in, which provides some
common build infrastructure (based on cabal sandboxes).

### Usage

To install from hackage, simply `cabal install cloud-haskell`.

To install from sources, first of all, check out this repository from
github, then cd into the newly created directory and run `make` to get
a download of all the repositories. To then work with them, cd into a
specific repo/directory and use one of the various make targets. Right
now, you'll have to look at build.mk yourself and figure out the gory
details - we hope to improve on that soon!
