# Install and then load required packages
pkg_list = c("dplyr", "treemapify", "tm", "wordcloud", "ggplot2", "DT", "shiny")
mia_pkgs = pkg_list[!(pkg_list %in% installed.packages()[, "Package"])]
if (length(mia_pkgs) > 0)
    install.packages(mia_pkgs)
loaded_pkgs = lapply(pkg_list, require, character.only = TRUE)

# Load pre-calculated data
load("data/shiny-app-data.rda")
# Note to course staff, we were approved to use 1000 observations

# Clean file names
clean_filenames = function(filename, replace = "_") {
    filename = gsub("[/\\?<>\\:*|\":-]", replace, filename)
    filename = gsub("[[:cntrl:]]", replace, filename)
    filename = gsub("[[:space:]]", replace, filename)
    filename
}
