
# 1. Output from analysis for paper "Child death over a woman's life course"

# Measures with year-age-country level

# s1 <- read.csv("../../Data/datasetS1.csv", stringsAsFactors = F)

# Measures with year-country level
# s2 <- read.csv("../../Data/datasetS1.csv", stringsAsFactors = F)

abs_df <- readRDS("../../Data/estimates/abs_df.RDS")

# ASFRC
ASFRC <- read.csv(file = paste0("../../Data/derived/","ASFRC.csv"), stringsAsFactors = F)

# LTCB (Women only)
# LTCF <- data.table::fread(file = paste0("../../Data/derived/","LTCF.csv"), stringsAsFactors = F) %>% 
#   data.frame

# Survey estimates

surv <- read.csv("../../Data/emily/mOM_20200130.csv", stringsAsFactors = F)

