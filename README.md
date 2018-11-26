# bindertools
[![Travis build status](https://travis-ci.org/ropenscilabs/bindertools.svg?branch=master)](https://travis-ci.org/ropenscilabs/bindertools)

## Summary
Computational reproducibility is a critical component of modern open science. Methods such as docker exist to containerise analyses, ensuring that operating systems and package versions are recorded and can be recreated in order to rerun analyses. Setting up dockerfiles, however, is a nontrivial task on top of a growing technical barrier to reproducible research. 

[binder](https://mybinder.org/) is a handy alternative, that:
1. builds a Docker image for your Github repo, and
2. hosts a live environment on [JupyterHub](https://jupyterhub.readthedocs.io/en/latest/) server, accessible via a reusable link.

As an alternative to using docker itself, the benefit of binder is that it requires only an internet connection to use. The binder live repository allows anyone to replicate your research with the same computing environment and package versions as you used when you built it. Setting up binder, while straightforward, still requires researchers to search through their code to find package names, source, and versions used to create an install.R file that loads these into the virtual environment. 

`bindertools` is a little R helper that seeks to make the bridge to binder for analyses in R even simpler by setting up the install.R file with all packages and versions (both for CRAN and github packages) in one step. The online binder can also be launched right from R, without needing to manually input repository information into the mybinder.org interface. 

`bindertools` has two key functions:

- `build_binder()` builds a runtime.txt file and an install.R file that contains code to install all required CRAN and Github packages mentioned in any .R and .Rmd file.
- `launch_binder()` launches your live repository at mybinder.org in an RStudio session and also returns the html webpage that you can then send as is, or record in a github repo with a README button as follows: 

`[![Binder](http://mybinder.org/badge.svg)](COPY HTML LINK RETURNED BY launch_binder() HERE)`

## Installation

You can install `bindertools` as follows:

``` r
devtools::install_github("ropenscilabs/bindertools")
```

## Example

Let's say our project is contained in a local directory called `~/toy_project` that we want to reproduce in a live session on binder.

In just three steps, we can do so with `bindertools`:

1. `build_binder(directory = "~/toy_project")`, which will create our runtime.txt and install.R files.
2. `git push` in the terminal or using the Git pane in RStudio to push the two added files to your Github repo.
3. run the following to launch:
```r 
launch_binder(github_username = 'my_username', 
              repo_name = 'toy_project', 
              branch_name = 'master')
```

Then in the browser you should see a live RStudio session populated with data same as `~/toy_project`.

Access our toy project here:
[![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/smwindecker/toy_project/master?urlpath=rstudio)

## More examples
See also, the [github repo for binder](https://github.com/rocker-org/binder) and a [research compendium example](https://github.com/cboettig/noise-phenomena) using binder.

## Team members 
* `r emo::ji("cat")` [Saras Windecker](https://github.com/smwindecker) `r emo::ji("bird")`  [\@smwindecker](https://twitter.com/smwindecker)
* `r emo::ji("cat")` [Felix Leung](https://github.com/felixleungsc) `r emo::ji("bird")` [\@felixleungsc](https://twitter.com/felixleungsc)
* `r emo::ji("cat")` [Steve Kambouris](https://github.com/stevekambouris) `r emo::ji("bird")` [\@steve_kambouris](https://twitter.com/steve_kambouris)
* `r emo::ji("cat")` [Miles McBain](https://github.com/MilesMcBain) `r emo::ji("bird")` [\@MilesMcBain](https://twitter.com/MilesMcBain)