#' Creates install.R file
#'
#' @param directory To build files in. Defaults to current directory. 
#'

binder_installR <- function (directory = '.') {
  
  R_files <- dir(directory, 
                 full.names = TRUE,
                 pattern = "\\.(rmd|r)$" , 
                 recursive = TRUE, 
                 ignore.case = TRUE)
 #  if (length(R_files == 0)) stop('No R files found.')
  
  lib_list <-
    purrr::map(R_files, readLines) %>%
    purrr::map(find_doc_libs) %>%
    unlist() %>%
    unique()
  
  CRAN_packages <- purrr::map_dfr(lib_list, CRAN_package) %>%
    Filter(Negate(is.null), .) 
  
  github_packages <- purrr::map(lib_list, github_package) %>%
    Filter(Negate(is.null), .) %>%
    as.character()
  
  x_CRAN <- paste0("purrr::walk2(.x = ", 
                   deparse(CRAN_packages$package), 
                   ", .y = ", 
                   deparse(CRAN_packages$version), 
                   ", ~devtools::install_version(package = .x, version = .y))")
  
  x_github <- paste0("devtools::install_github(c(", 
                     paste0("\"", github_packages, "\"", collapse = ", "), "))")
  
  # add to install.R file  
  writeLines(paste0(x_CRAN, '\n', x_github), 'install.R')

}

#' Find out if package is on CRAN and get version
#'
#' @param package_name name of package to test
#'
#'
CRAN_package <- function (package_name) {
  
  pd <- packageDescription(package_name)

  if (is.null(pd$Repository)) {
    return (NULL)
  }
  
  if (!is.null(pd$Repository)) {
    return(list(package = package_name, 
                version = pd$Version))
  }

}

#' Find out if package is on github and get repo and commit SHA
#'
#' @param package_name name of package to test
#'
#'
github_package <- function (package_name) {
  
  pd <- packageDescription(package_name)
  
  if (is.null(pd$Repository)) {
    return(paste0(pd$RemoteUsername, '/', pd$GithubRepo, '@', pd$RemoteSha))
  }
  
  if (!is.null(pd$Repository)) {
    return(NULL)
  }
  
}

#' Scan text to find packages
#'
#' @param doc text of file to scan
#' @note from milesmcbain/deplearning
#' 
find_doc_libs <- function (doc) {
  
  # filter comments
  comments <- "^\\s*#"
  comment_lines <- grepl(pattern = comments, x = doc)
  doc <- doc[!comment_lines]
  
  # find dependencies
  patterns <- list(
    library = "(?<=library\\()\"*[a-zA-Z0-9.]+\"*(?=\\))",
    require   = "(?<=require\\()\"*[a-zA-Z0-9.]+\"*(?=\\))",
    p_load = "(?<=p_load\\()\"*[a-zA-Z0-9.]+\"*[\\s*\\,\\s*\"*[a-zA-Z0-9.]+\"*]*(?=\\))",
    `::` = "[a-zA-Z0-9.]+(?=::)"
  )
  
  match_pos <- purrr::map(patterns, ~regexec(., doc, perl = TRUE))
  lib_matches <- purrr::map(match_pos, ~regmatches(doc, .)) %>%
    lapply(unlist)
  
  # post processing cleanup of matches
  final_matches <-
    lib_matches %>%
    purrr::map(~gsub(x = ., pattern = "\"", replacement ="")) %>%
    purrr::map(~strsplit(x = . , split = ",\\s*" )) %>%
    unlist() %>%
    unique()
  
  final_matches
}

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
