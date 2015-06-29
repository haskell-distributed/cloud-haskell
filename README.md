# Cloud Haskell meta-project

[![Build Status](https://travis-ci.org/haskell-distributed/cloud-haskell.svg?branch=master)](https://travis-ci.org/haskell-distributed/cloud-haskell)

[Cloud Haskell][cloud-haskell] is a set of libraries that bring
Erlang-style concurrency and distribution to Haskell programs.

This repository includes references to all other official Cloud
Haskell packages for conveniently building them all from a single
location. Use this repository as a starting point for hacking on Cloud
Haskell packages (see [CONTRIBUTING](CONTRIBUTING.md)).

Those users that do not use package snapshots (such as
[Stackage][stackage]) can use the `.cabal` file in this repository to
install a consistent set of versions of all Cloud Haskell packages.
Snapshot users don't normally need this `.cabal` file, and should
add Cloud Haskell packages directly as dependencies.

[cloud-haskell]: http://haskell-distributed.github.io/
[stackage]: http://www.stackage.org/

## Usage

### Installation from Hackage

```
$ cabal install cloud-haskell
```

### Building from source

Clone this repository locally using `git` or [`hub`][hub]:

```
$ hub clone --recursive haskell-distributed/cloud-haskell
```

Then,

```
$ cd cloud-haskell
$ stack build
```

You will need [stack][stack] installed and reachable from your
`$PATH`.

[hub]: https://hub.github.com/
[stack]: https://github.com/commercialhaskell/stack

### Updating the source

To hack on the latest versions of all packages,

```
$ git submodule update --remote
```

## Contributing to Cloud Haskell

See [CONTRIBUTING](CONTRIBUTING.md).
