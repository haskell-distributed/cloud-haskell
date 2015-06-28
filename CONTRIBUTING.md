# Cloud Haskell contributor guidelines

The Cloud Haskell project is made up of a number of independent
repositories. The cloud-haskell repository includes all other
repositories as submodules, for convenience. If you want to hack on
any Cloud Haskell package and contribute changes upstream, don't
checkout each individual repository in its own directory. Instead,

```
$ hub clone --recursive haskell-distributed/cloud-haskell
```

which clones all Cloud Haskell repositories as submodules inside the
`cloud-haskell` directory. You can then hack on each submodule as
usual, committing as usual.

## Contributing changes upstream

To contribute a change, you first need a fork:

```
$ cd <submodule-dir>
$ hub fork
```

Then publish branches and submit pull requests as usual:

```
$ git push --set-upstream <username> <branch-name>
$ hub pull-request
```
