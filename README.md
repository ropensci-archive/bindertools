# bindertools
[![Travis build status](https://travis-ci.org/ropenscilabs/bindertools.svg?branch=master)](https://travis-ci.org/ropenscilabs/bindertools)



The goal of bindertools is to make creating a reproducible research project easier.

`bindertools` is a little R helper for [binder](https://mybinder.org/), a tool that:

1. builds a Docker image for your Github repo, and
2. host a live environment on [JupyterHub](https://jupyterhub.readthedocs.io/en/latest/) server, accessible via a reusable link.

The binder live repository allows anyone to replicate your research with the same computing environment and package versions as you used when you built it. This should allow greater ease for computational reproducibility of your work. As an alternative to using docker itself, the benefit of binder is that it requires only an internet connection to use. 

`bindertools` makes binder even easier to use by allowing you to create the necessary files and launch binder from within R. `bindertools` has two key functions:

- `build_binder()` builds a runtime.txt file and an install.R file that contains code to install all required CRAN and Github packages mentioned in any .R and .Rmd file.
- `launch_binder()` launches your live repository at mybinder.org in an RStudio session.

## Installation

You can install it with:

``` r
devtools::install_github("ropenscilabs/bindertools")
```

## Example

Our project is contained in a local directory called `~/toy_project` that we reproduce in a live session on binder.

In just three steps, we can easily do so with `bindertools`:

1. run `build_binder(directory = "~/toy_project")`, which will create our runtime.txt and install.R files.
2. `git push` to push the two added files to your Github repo.
3. run the following to launch:
```r 
launch_binder(github_username = 'my_username', 
              repo_name = 'toy_project', 
              branch_name = 'master')
```

Then in the browser you should see a live RStudio session populated with data same as `~/toy_project`.

Access it here:
[![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/smwindecker/toy_project/master?urlpath=rstudio)

# More examples
- https://github.com/cboettig/noise-phenomena
