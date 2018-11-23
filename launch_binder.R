launch_binder <- function (github_username, repo_name, branch_name) {

  URL <- paste0("http://beta.mybinder.org/v2/gh/", 
                github_username, 
                "/", 
                repo_name, 
                "/", 
                branch_name, 
                "?urlpath=rstudio")  
  
  browseURL(url = URL)
}
