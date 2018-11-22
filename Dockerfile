FROM rocker/binder:3.4.3

## Copies your repo files into the Docker Container
USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}

## Run an install.R script, if it exists.
RUN ["install2.r", "backports", "checkmate", "curl", "formatR", "futile.logger", "futile.options", "knitr", "lambda.r", "magrittr", "Rcpp", "remotes", "rjson", "semver", "stringi", "stringr", "yaml"]
RUN ["installGithub.r", "richfitz/stevedore@c9531428df052eaf8185d9235f2f8db5b2a6008a"]
