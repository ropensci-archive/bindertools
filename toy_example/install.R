purrr::walk2(.x = c("purrr", "devtools", "ggplot2", "knitr", "checkmate"), .y = c("0.2.5", "2.0.1", "3.1.0", "1.20", "1.8.5"), ~devtools::install_version(package = .x, version = .y))
devtools::install_github(c(""))
