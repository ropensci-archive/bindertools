# bindertools
[![Travis build status](https://travis-ci.org/ropenscilabs/bindertools.svg?branch=master)](https://travis-ci.org/ropenscilabs/bindertools)
The goal of bindertools is to make creating a reproducible research project easier.

`bindertools` is a little R helper for [binder](https://mybinder.org/), a tool that:

1. builds a Docker image for your Github repo, and
2. host a live environment on [JupyterHub](https://jupyterhub.readthedocs.io/en/latest/) server, accessible via a reusable link.

`bindertools` has two key functions:

- `build_binder()` recursively looks for required packages (in any .R and .Rmd) in the project directory, and writes two files needed - a Dockerfile for binder, and an install.R script that will install the exact version of any CRAN and/or Github packages.
- `launch_binder()` launches binder with an RStudio session.

## Installation

You can install it with:

``` r
devtools::install_github("ropenscilabs/bindertools")
```

## Example

This is a basic example which shows you how to solve a common problem:

Say we have a local directory called e.g. `~/toy_project` that we want to host on binder.
Then here are the steps needed:

1. run `build_binder(directory = "~/toy_project")`, which will create Dockerfile and install.r.
2. `git push` to push the two added files to your Github repo.
3. run `launch_binder()` to launch.

Then in the browser you should see a live RStudio session populated with data same as `~/toy_project`.

# More examples
- https://github.com/cboettig/noise-phenomena
