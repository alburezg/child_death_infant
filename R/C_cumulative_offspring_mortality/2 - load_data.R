
# 1. Output from analysis for paper "Child death over a woman's life course"

# abs_df <- readRDS("../../Data/estimates/abs_df.RDS")
# FOr all measures
abs_df_all <- readRDS("../../Data/estimates/abs_df_all.RDS")

# ASFRC
ASFRC <- read.csv(file = paste0("../../Data/derived/","ASFRC.csv"), stringsAsFactors = F)

# LTCB (Women only)
LTCF <- data.table::fread(file = paste0("../../Data/derived/","LTCF.csv"), stringsAsFactors = F) %>%
  data.frame

# Survey estimates

# surv <- read.csv("../../Data/emily/mOM_20200130.csv", stringsAsFactors = F)

# surv1 <- read.csv("../../Data/emily/survey_data_20200130.csv", stringsAsFactors = F) 

regions <- read.csv("../../Data/emily/regions.csv", stringsAsFactors = F)

countries_order <- read.csv("../../Data/emily/global indicator data_20200206.csv", stringsAsFactors = F) %>% 
  pull(country)
  

# 2. Survey estimates ----

# 20200214_women.csv and 20200214_mothers.csv are csv-versions derived from the original
# 20200214_updated DHS estimates.xlsx file sent by Emily.
# They do NOT include MICS estimates, only DHS

surv <- 
  bind_rows(
    read.csv("../../Data/emily/20200214_women.csv", stringsAsFactors = F) %>% 
      mutate(measure = "women")
    , read.csv("../../Data/emily/20200214_mothers.csv", stringsAsFactors = F) %>% 
      mutate(measure = "mothers")
  ) %>% 
  get_regions_iso(., regions) %>% 
  arrange(measure, country) %>% 
  data.frame()


# global indicator data_20200206.csv includes all estimates for all countries but 
# only refers to mothers!
# The functions were written originally for this data

# surv <- read.csv("../../Data/emily/global indicator data_20200206.csv", stringsAsFactors = F) %>% 
#   get_regions_iso(., regions)
