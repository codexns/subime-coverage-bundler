# Sublime coverage Bundler

This is a simple bash script that takes the output of
https://github.com/codexns/coverage-build and moves the resulting files into a
repo set up for use as a dependency in Sublime Text.

## Instructions

After compiling coverage on the various environments using `coverage-build`
and creating a new release with all of the output files, check out the following
repo:

```bash
git clone git@github.com:codexns/sublime-coverage-bundler.git
git clone git@github.com:codexns/sublime-coverage.git
```

Then execute the `update.sh` by providing the tag name from `coverage-build`.
For example:

```bash
cd sublime-coverage-bundler
./update.sh coverage-4.0b2
```

Finally you'll need to commit the changes to the `sublime-coverage` repo, tag it
and push the changes up to GitHub.
