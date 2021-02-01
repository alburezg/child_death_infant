
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Data requirements: 
# Data created in previous script can be loaded as:
# abs_df <- readRDS("../../Data/estimates/abs_df_all.RDS")

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Theory:
# From ESG:

# Here what we're doing is just treating bereavement 
# as a once ever outcome. So, we want the proportion 
# of women (which we'll express per 1,000 in the pop) 
# who have ever lost one or more children. And we want 
# these as period measures as you've done for all mothers 
# of peak reproductive age, and those who are (or nearing) 
# completion of reproduction.


# Implementation:

# Now, going back to the measure of prevalence, I tried a similar procedure to 
# estimate the proportion of mothers (per 1,000 mothers) who have ever lost one 
# or more children. For this, I created cohort ‘life tables’ for women, where 
# nqx was the First Difference of Child Death (ΔCD in our paper, Emilio). Emily, 
# this is basically the number of child deaths experienced by a woman at each age. 
# The resulting lx column can be interpreted as the share of women who have 
# experienced child death at age x. I then re-scaled this by multiplying it both 
# by the share of women surviving to age x (the ‘regular’ lx column in the mortality 
# life tables) and by the share of women aged x who are mothers. 

# 0. Unchanging paramenters ----

# For cohort-period conversion
# First, reduce size of data, then get period values

# ESG uses the agr groups 20-44 and 45-49
# 	For time frame: 2010-2019

# years <- 2010:2019
# Not sure about longest possible time-frame, but function won't
# break if years are unavaillable, only will return
# NA for those years. THis seems to work, although 1970 is unavailable
# for some meausres:
years <- 2000:2020
# breaks <- c(20, 45, 50)
breaks <- seq(15, 50, 5)
reprod_age <- c(15,50)

# 1. mOM ~~~~ ----

mOM_5y <- offspring_death_prevalence(
  k_value = "0_100" # age ranges for child death
  # , file_name = "mOM" # For exporting, file_name = NA # For exporting
  , file_name = NA # For exporting
  , years = years
  , breaks = breaks
  , reprod_age = reprod_age
  , abs_df_all = abs_df
  , ASFRC
  , LTCF 
)

# 2 mU5M ~~~~ ----

mU5M_5y <- offspring_death_prevalence(
  k_value = "0_5" # age ranges for child death
  # , file_name = "mU5M" # For exporting
  , file_name = NA # For exporting
  , years = years
  , breaks = breaks
  , reprod_age = reprod_age
  , abs_df_all = abs_df
  , ASFRC
  , LTCF 
)

# 3. mIM ~~~~ ----

mIM_5y <- offspring_death_prevalence(
  k_value = "0_1" # age ranges for child death
  # , file_name = "mIM" # For exporting
  , file_name = NA # For exporting
  , years = years
  , breaks = breaks
  , reprod_age = reprod_age
  , abs_df_all = abs_df
  , ASFRC
  , LTCF 
)

# 4. Export ====

write.csv(mOM_5y, "../../Data/estimates/mOM_5y.csv", row.names = F)
write.csv(mU5M_5y, "../../Data/estimates/mU5M_5y.csv", row.names = F)
write.csv(mIM_5y, "../../Data/estimates/mIM_5y.csv", row.names = F)

print("7 - mOM, mU5M, and mIM saved as csv files!")

# 5. Export for Emily ------------

  # regions <- read.csv("../../Data/emily/regions.csv", stringsAsFactors = F) 
  # 
  # # Get survey data
  # surv_df <- 
  #   bind_rows(
  #     read.csv("../../Data/emily/20200214_women.csv", stringsAsFactors = F) %>% 
  #       mutate(measure = "women")
  #     , read.csv("../../Data/emily/20200214_mothers.csv", stringsAsFactors = F) %>% 
  #       mutate(measure = "mothers")
  #     # If indirect estimates showuld be included, unomment this line
  #     , read.csv("../../Data/emily/20200214_mothers_indirect.csv", stringsAsFactors = F) %>% 
  #       mutate(measure = "mothers_indirect")
  #   ) %>% 
  #   get_regions_iso(., regions) %>% 
  #   arrange(measure, country) %>% 
  #   filter(!is.na(year)) %>% 
  #   filter(!grepl("-", year)) %>% 
  #   # select(iso, year) %>% 
  #   data.frame()
  # 
  # 
  # 
  # model_df <- 
  #   bind_rows(
  #     mOM_5y %>%
  #       select(iso, country, year, agegr, value = bereaved_mothers) %>% 
  #       mutate(type = "mom")
  #     , mU5M_5y %>%
  #       select(iso, country, year, agegr, value = bereaved_mothers) %>% 
  #       mutate(type = "mum")
  #     , mIM_5y %>%
  #     select(iso, country, year, agegr, value = bereaved_mothers) %>% 
  #     mutate(type = "mim")
  # ) %>% 
  #   # left_join(
  #   #   surv_df, by = c("iso", "year")
  #   # ) %>% 
  #   mutate(
  #     age_low = gsub(",[0-9]+)$","", gsub("\\[", "", agegr))
  #     , var = paste0(type, age_low, "kc")
  #   ) 
  # 
  # # Merge with survey data -----------
  # 
  # year_for_missing_countries <- 2016
  # 
  # # add_indirect_estimates <- T
  # 
  # mOM4549 <- compare_measures(
  #   year_for_missing_countries = 2016
  #   , surv_measure_keep = c("mom45")
  #   , model_agegr_keep = c("[45,50)")
  #   , measure = "women"
  #   , model_df = mOM_5y
  #   , surv_df = surv_df
  #   , regions = regions
  #   , add_indirect_estimates = T
  # )
  # 
  # 
