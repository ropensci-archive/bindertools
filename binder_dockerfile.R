##' Create the binder dockerfile
##'
##' Writes the binder dockerfile to the user's disk current working directory.
##'
##' Checks the user's local R version and compares it with a list of R versions
##' taken from the makefile for the roocker-org/binder repo.
##'
##' @title  binder_dockerfile
##' @param directory the directory to write the binder docker file.
##' @return nothing, writes a file.
binder_dockerfile <- function (directory) {

  ## Finding available R versions
  binder_make <- readLines(curl::curl('https://raw.githubusercontent.com/rocker-org/binder/master/Makefile'))

  version_positions <- regexpr("[0-9]\\.[0-9]\\.[0-9](?=/Dockerfile)", binder_make, perl = TRUE)

  available_versions <- regmatches(binder_make, version_positions)

  ## Find local R version
  local_version <- paste(version$major, version$minor, sep = ".")

  if (!(version %in% local_version)){
    stop(sprintf("Your R version (%s) is not suppored by binder tools. Supported versions are: %s",
                 local_version,
                 paste(available_versions, collapse = ", ")))
  }

  
  x <- sprintf('FROM rocker/binder:%s
    
## Copies your repo files into the Docker Container
USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}
    
## Become normal user again
USER ${NB_USER}
    
## Run an install.R script, if it exists.
RUN if [ -f install.R ]; then R --quiet -f install.R; fi', local_version)
  
  writeLines(x, 'Dockerfile')
  
}
