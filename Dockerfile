FROM rocker/r-ver:3.5.1
LABEL maintainer="swindecker"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
  && apt-get install -y git-core \
	libcurl4-openssl-dev \
	libssl-dev \
	pandoc \
	pandoc-citeproc
RUN ["install2.r", "assertthat", "backports", "bindr", "bindrcpp", "colorspace", "crayon", "curl", "digest", "dplyr", "evaluate", "formatR", "futile.logger", "futile.options", "ggplot2", "glue", "gtable", "htmltools", "knitr", "labeling", "lambda.r", "lazyeval", "magrittr", "munsell", "pillar", "pkgconfig", "plyr", "purrr", "R6", "Rcpp", "remotes", "rjson", "rlang", "rmarkdown", "rprojroot", "rsconnect", "rstudioapi", "scales", "semver", "stringi", "stringr", "tibble", "tidyselect", "withr", "yaml"]
RUN ["installGithub.r", "richfitz/stevedore@c9531428df052eaf8185d9235f2f8db5b2a6008a"]
WORKDIR /payload/
CMD ["R"]
