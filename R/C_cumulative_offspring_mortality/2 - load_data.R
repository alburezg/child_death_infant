
# 1. Output from analysis for paper "Child death over a woman's life course"

# abs_df <- readRDS("../../Data/estimates/abs_df.RDS")
# FOr all measures
abs_df_all <- readRDS("../../Data/estimates/abs_df_all.RDS")

# ASFRC
ASFRC <- read.csv(file = paste0("../../Data/derived/","ASFRC.csv"), stringsAsFactors = F)

# LTCB (Women only)
LTCF <- data.table::fread(file = paste0("../../Data/derived/","LTCF.csv"), stringsAsFactors = F) %>%
  data.frame

# 2. Period measures from UN WPP ----

# Interpolated to be 1x1

# ASFR
rates <- read.csv("../../Data/wpp_data/WPP2019_Period_Indicators_Medium.csv", stringsAsFactors = F) %>% 
  mutate(iso = countrycode(Location, origin = "country.name", "iso3c", warn = F)) %>% 
  select(iso, period = Time, e0_f = LExFemale, e0_m = LExMale, TFR, IMR, U5MR = Q5)
  

# # Life tables for women and men
# e0_F <- data.table::fread("../../Data/wpp_data/lt_per_1_1_F.csv", stringsAsFactors = F) %>% 
#   filter(age == 0) %>% 
#   mutate(iso = countrycode(country, origin = "country.name", "iso3c", warn = F)) %>% 
#   select(iso, year, ex) %>% 
#   data.frame()

# Life tables for women and men
# e0_B <- data.table::fread("../../Data/wpp_data/lt_per_1_1_B.csv", stringsAsFactors = F) %>% 
#   filter(age == 0) %>% 
#   select(country, year, ex)

# Survey estimates

# surv <- read.csv("../../Data/emily/mOM_20200130.csv", stringsAsFactors = F)

# surv1 <- read.csv("../../Data/emily/survey_data_20200130.csv", stringsAsFactors = F) 

regions <- read.csv("../../Data/emily/regions.csv", stringsAsFactors = F) 
  # mutate(
  #   region = trimws(region)
  #   , iso = countrycode(country, origin = "country.name", "iso3c", warn = F)) %>% 
  # select(country, iso, region)

# write.csv(regions, "../../Data/emily/regions.csv")

countries_order <- read.csv("../../Data/emily/global indicator data_20200206.csv", stringsAsFactors = F) %>% 
  # For cote divore
  mutate(country = gsub("C\\?", "Co", country)) %>% 
  pull(country)
  
  

# 2. Survey estimates ----

# 20200214_women.csv and 20200214_mothers.csv are csv-versions derived from the original
# 20200214_updated DHS estimates.xlsx file sent by Emily.
# They do NOT include MICS estimates, only DHS
# this includes a 'mrom45' column that gives the % of women/mothesr aged 45-50 who ever 
# experienced more than one offspring death 

surv <- 
  bind_rows(
    read.csv("../../Data/emily/20200214_women.csv", stringsAsFactors = F) %>% 
      mutate(measure = "women")
    , read.csv("../../Data/emily/20200214_mothers.csv", stringsAsFactors = F) %>% 
      mutate(measure = "mothers")
    # If indirect estimates showuld be included, unomment this line
    , read.csv("../../Data/emily/20200214_mothers_indirect.csv", stringsAsFactors = F) %>% 
      mutate(measure = "mothers_indirect")
  ) %>% 
  get_regions_iso(., regions) %>% 
  arrange(measure, country) %>% 
  data.frame()


# global indicator data_20200206.csv includes all estimates for all countries but 
# only refers to mothers!
# The functions were written originally for this data

# surv <- read.csv("../../Data/emily/global indicator data_20200206.csv", stringsAsFactors = F) %>% 
#   get_regions_iso(., regions)
