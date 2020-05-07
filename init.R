# Script for the heroku build process to install necessary packages

source("install_pacakges.R")

install_packages(heroku_build = TRUE)
