#' Build binder files
#' 
#' @description Builds the binder dockerfile and the install.R script.
#'
#' @param directory To build files in. Defaults to current directory. 
#'
#' @return message confirming files created and suggesting next steps
#' @export
#'
#' @examples build_binder()

build_binder <- function (directory = '.') {
  
  # build dockerfile
  binder_dockerfile()
  cat("Dockerfile created.\n")
  
  # build install.R file
  binder_installR(directory)
  cat("install.R created.\nNext step: Commit and push to github!")
  
}

