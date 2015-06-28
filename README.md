# Cloud Haskell meta-project

[![Build Status](https://travis-ci.org/haskell-distributed/cloud-haskell.svg?branch=master)](https://travis-ci.org/haskell-distributed/cloud-haskell)

This repository includes references to all other official Cloud
Haskell packages for conveniently building them all from a single
location. Use this repository as a starting point for hacking on Cloud
Haskell packages (see [CONTRIBUTING.md](CONTRIBUTING.md)).

## Usage

### Installation from Hackage

```
$ cabal install cloud-haskell
```

### Building from source

Clone this repository locally using `git` or [`hub`][hub]. Then,

```
$ git submodule update --init
$ stack build
```

You will need [Stack][stack] installed and reachable from your
`$PATH`.

[hub]: https://hub.github.com/
[stack]: https://github.com/commercialhaskell/stack

### Updating the source

To hack on the latest versions of all packages,

```
$ git submodule update --remote
```

## Contributing to Cloud Haskell

See [CONTRIBUTING.md](CONTRIBUTING.md).
