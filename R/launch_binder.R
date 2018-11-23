#' Launch binder for project at mybinder.org
#'
#' @description launches binder
#' 
#' @param github_username For project repo
#' @param repo_name Repository name
#' @param branch_name Branch name, eg. 'master'
#'
#' @return opens URL for binder
#' @export
#'

launch_binder <- function (github_username, repo_name, branch_name) {

  # set up URL for mybinder.org
  URL <- paste0("http://beta.mybinder.org/v2/gh/", 
                github_username, 
                "/", 
                repo_name, 
                "/", 
                branch_name, 
                "?urlpath=rstudio")  
  
  # launch binder and open URL
  browseURL(url = URL)
  
  cat(URL)
}
