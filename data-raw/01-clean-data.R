library("dplyr")

# Clean and load the data into R

cosmeticchemicals = read.csv("data-raw/cscpopendata.csv")

# Obtain chemical frequency counts
counts_chem = cosmeticchemicals %>%
    group_by(CDPHId) %>%
    distinct(ChemicalName) %>%
    summarise(nchem = n()) %>%
    arrange(nchem)

# Append counts to the dataset
updated_cosmetics = counts_chem %>%
    dplyr::inner_join(cosmeticchemicals, by = "CDPHId")

# Subset data
makeup1 = subset(updated_cosmetics,
                 PrimaryCategory == "Makeup Products (non-permanent)")
makeup = makeup1[, c(2, 3, 5, 7, 8, 10, 12, 16)]

# Find unique brand and subcategory names
UniqueBrand = unique(makeup$BrandName)

UniqueSubCategory = unique(makeup$SubCategory)

# Take a smaller set of makeup
set.seed(1999)
makeup_downsample = makeup[sample(nrow(makeup), size = 1000), ]

# Fit a model
model_fit = lm(nchem ~ factor(SubCategory) + factor(BrandName),
               data = makeup_downsample)

# Create data sets for each subcategory
lip_color = subset(makeup, SubCategory == "Lip Color - Lipsticks, Liners, and Pencils")
lip_gloss = subset(makeup, SubCategory == "Lip Gloss/Shine")
mascara = subset(makeup, SubCategory == "Mascara/Eyelash Products")
lip_balm = subset(makeup, SubCategory == "Lip Balm (making a cosmetic claim)")
rogue = subset(makeup, SubCategory == "Rouges")
other = subset(makeup, SubCategory == "Other Makeup Product")
paints = subset(makeup, SubCategory == "Paints (e.g. facial, body)")
eyeliner = subset(makeup, SubCategory == "Eyeliner/Eyebrow Pencils")
eye_shadow = subset(makeup, SubCategory == "Eye Shadow")
fountain = subset(makeup, SubCategory == "Foundations and Bases")
blushes = subset(makeup, SubCategory == "Blushes ")
powder = subset(makeup, SubCategory == "Face Powders")
fixatives = subset(makeup, SubCategory == "Makeup Fixatives")
preps = subset(makeup, SubCategory == "Makeup Preparations")

# Find averages
avg_lip_color = mean(lip_color$nchem)
avg_lip_gloss = mean(lip_gloss$nchem)
avg_mascara = mean(mascara$nchem)
avg_lip_balm = mean(lip_balm$nchem)
avg_rogue = mean(rogue$nchem)
avg_other = mean(other$nchem)
avg_paints = mean(paints$nchem)
avg_eyeline = mean(eyeliner$nchem)
avg_eye_shadow = mean(eye_shadow$nchem)
avg_fountain = mean(fountain$nchem)
avg_blushes = mean(blushes$nchem)
avg_powder = mean(powder$nchem)
avg_fixatives = mean(fixatives$nchem)
avg_preps = mean(preps$nchem)

# Combine Averages
avg_set = c(
    avg_lip_color,
    avg_lip_gloss,
    avg_mascara,
    avg_lip_balm,
    avg_rogue,
    avg_other,
    avg_paints,
    avg_eyeline,
    avg_eye_shadow,
    avg_fountain,
    avg_blushes,
    avg_powder,
    avg_fixatives,
    avg_preps
)

sub_names = c(
    "Lipsticks/Liners/Pencils",
    "Lip Gloss/Shine",
    "Mascara/Eyelash Products",
    "Lip Balm",
    "Rouges",
    "Others",
    "Paints (facial/body)",
    "Eyeliner/Eyebrow Pencils",
    "Eye Shadow",
    "Foundations and Bases",
    "Blushes",
    "Face Powders",
    "Makeup Fixatives",
    "Makeup Preparations"
)

# Create a data.frame with averages and appropriate names
df = data.frame(avg_set, sub_names)
colnames(df) = c("mean", "subcategory")

df$group = c(
    "Lip",
    "Lip",
    "Eye",
    "Lip",
    "Cheek",
    "Others",
    "Paints",
    "Eye",
    "Eye",
    "Face",
    "Cheek",
    "Face",
    "Face",
    "Face"
)

# Save cleaned data
save(df,
     model_fit,
     counts_chem,
     makeup_downsample,
     UniqueSubCategory,
     file = "data/shiny-app-data.rda")

save(makeup, file = "data/cleaned-makeup.rda")
