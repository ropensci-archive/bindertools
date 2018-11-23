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

#' Create binder dockerfile
#'

binder_dockerfile <- function () {
  
  x <- 'FROM rocker/binder:3.4.3
    
## Copies your repo files into the Docker Container
USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}
    
## Become normal user again
USER ${NB_USER}
    
## Run an install.R script, if it exists.
RUN if [ -f install.R ]; then R --quiet -f install.R; fi'
  
  writeLines(x, 'Dockerfile')
  
}