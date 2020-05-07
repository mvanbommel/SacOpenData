# Script for the heroku build process to install necessary packages

source("/app/install_cran_pacakges.R")

install_packages(heroku_build = TRUE)
