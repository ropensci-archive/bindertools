#' Creates install.R file
#'
#' @param directory To build files in. Defaults to current directory.
#' @importFrom purrr map map_dfr
#'

binder_installR <- function (directory = '.') {
  
  R_files <- dir(directory, 
                 full.names = TRUE,
                 pattern = "\\.(rmd|r)$" , 
                 recursive = TRUE, 
                 ignore.case = TRUE)
 #  if (length(R_files == 0)) stop('No R files found.')

  ## If we have R markdown files, inject it as a dependency.
  lib_list <- list() 
  if (any(grepl(".[Rr][Mm][Dd]", R_files))){
    lib_list <- list("rmarkdown")
  }

  lib_list <-
    c(lib_list,
      purrr::map(R_files, readLines) %>%
      purrr::map(find_doc_libs) %>%
      unlist() %>%
      unique())
  
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
  
  if (is.null(pd$GithubRepo)) {
    return(NULL)
  }
  
  if (!is.null(pd$GithubRepo)) {
    return(paste0(pd$RemoteUsername, '/', pd$GithubRepo, '@', pd$RemoteSha))
  }
  
}

#' Scan text to find packages
#'
#' @param doc text of file to scan
#' @note from github.com/milesmcbain/deplearning
#' @importFrom purrr map
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

##' Create the binder runtime
##'
##' Writes the binder R runtime.txt to the user's disk current working directory.
##'
##' @title  binder_runtime
##' @param directory the directory to write the binder docker file.
##' @return nothing, writes a file.
binder_runtime <- function (directory) {

  runtime_date <-
    as.Date(Sys.time(), "UTC", format="%Y-%m-%d")

  x <- paste0("r-",runtime_date)

  writeLines(x, file.path(directory,'runtime.txt'))
}
