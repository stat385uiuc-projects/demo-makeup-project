# Install and load required packages
pkg_list = c("tm", "slam")
mia_pkgs = pkg_list[!(pkg_list %in% installed.packages()[, "Package"])]
if (length(mia_pkgs) > 0)
    install.packages(mia_pkgs)
loaded_pkgs = lapply(pkg_list, require, character.only = TRUE)

# Use clean data
load("data/cleaned-makeup.rda")

# Save file names
clean_filenames = function(filename, replace = "_") {
    filename = gsub("[/\\?<>\\:*|\":-]", replace, filename)
    filename = gsub("[[:cntrl:]]", replace, filename)
    filename = gsub("[[:space:]]", replace, filename)
    filename
}


# Compute the word frequencies
for (subcategory_name in unique(makeup$SubCategory)) {
    sample = makeup$ChemicalName[makeup$SubCategory == subcategory_name]
    myCorpus = Corpus(VectorSource(sample))
    myCorpus = tm_map(myCorpus, content_transformer(tolower))
    myCorpus = tm_map(myCorpus, removePunctuation)
    myCorpus = tm_map(myCorpus, removeNumbers)
    myDTM = TermDocumentMatrix(myCorpus, control = list(weighting = weightTfIdf))
    tdm.spar = removeSparseTerms(myDTM, sparse = 0.9)
    v = sort(slam::row_sums(myDTM), decreasing = TRUE)
    frequencies = data.frame(word = names(v), freq = v)

    saveRDS(frequencies,
            file = file.path("data",
                             clean_filenames(
                                 paste0("frequencies_", subcategory_name, ".rds")
                             )))

}
