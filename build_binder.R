build_binder <- function (directory = '.') {
  
  binder_dockerfile()
  cat("Dockerfile created.\n")
  binder_installR(directory)
  cat("install.R created.\nNext step: Commit and push to github!")
  
}

