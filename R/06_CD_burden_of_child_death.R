print(paste0("Running script: ", "7 - CD_asbolute_by_ex"))

# Estimate the total number of child deaths experienced by all women in a region 
# and birth cohort at each age $a$.
# We obtain this by multiplying $\Delta CD$ (the first difference of child death) 
# by the absolute number of women expected 
# to survive to each age, considering the original size of each female birth cohort 
# and the mortality rates prevalent in their countries of origin.
# This measure removes the assumption of female survival by accounting for the size 
# and age structure of the population.

# In practice, for each country/cohort combination, we need:
#  - First difference of cumulative child loss 
#   This was estimated in previous script
#  - Number of woman surviving to age a 
#   This is estimated in this script. 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Data requirements:
# First difference of child death:
l_diff <- readRDS("Data/estimates/l_diff.RDS")
# Objects created in this script: 
# lx_df is a df with the number of women surviving up to age 100 for specific
# birth cohort-country cobminations
# This takes a long time to run, so it's easier just to load
# it from the start. However, you can still estimate again below
if(file.exists("Data/estimates/lx_df.csv")){
  lx_df <- read.csv("Data/estimates/lx_df.csv", stringsAsFactors = F)
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 1. Absolute child loss by age ----

# 1.1. Radix by birth cohort (denominator) ====

# This cannot be obtained from the WPP, which only has period 
# poulations estimates
# Therefore, I need to apply the specific female cohort life table for the
# respective population of women by birth cohort and country/region

# Since these are empirical numbers, I need to get the size of the female 
# birth cohorts by country and year
# This can be obtained from the WPP estimates of the yearly number of births

# The function below applies (pssuedo) cohort life tables to real-life populatinos
# with the intention of gettin the lx column
# where radices are the initial size of birth cohorts 
# of women using wpp data

# lx_df is a df with the number of women surviving up to age 100 for specific
# birth cohort-country cobminations
# Put differently, it is the number of woman at risk of losing a child
# ie the denominator for the absolute measure of child loss

# This takes around 10min to run parallelised on 10 cores

if(!exists("lx_df")) {
  
  numCores <- ifelse(detectCores() > 8, 25, detectCores() - 1)
  
  lx_df <- apply_lt(
    female_births = female_births
    , LTCF = LTCF
    , numCores = numCores 
  ) 
  
  write.csv(lx_df, "Data/estimates/lx_df.csv", row.names = F)
  
}

# 1.2. Total yearly child deaths ====

# First, merge all dfs into a single one

# Get country-level data
l_diff_country <- lapply(l_diff, '[[', "df_cl_diff")

rows <- unlist(lapply(l_diff_country, nrow))

df_cl_diff <- data.frame(do.call(rbind, l_diff_country), stringsAsFactors = F)

df_cl_diff$level <- c(rep(age_codes, rows))

# Merge the two dfs to get the wanted measure
# I merge before multipltyig to make sure that the values that
# I will multiply are the actual corret country-cohort-age combinatinos
# as the dfs might be ordered strangely after moving them around so much

abs_df <- merge(
  df_cl_diff
  , lx_df
  , by = c('country', 'cohort', 'age')
  , all.x = T
) %>% 
  filter(dplyr::between(age, 15, 100)) %>% 
  filter(dplyr::between(cohort, 1950, 2000)) %>%
  filter(type == 'country') %>% 
  mutate(
    absolute = lx * diff
  ) %>% 
  select(level, region, type, country, cohort, cohort2, age, diff, lx, absolute) %>% 
  arrange(level, country, cohort, age)

# 1.3. Stat summary by group ====

# Now it is possible to group the data and get summary
# statistics if this is wanted
# Note that for this measure, we do not estimate percentiles, as 
# it is ultimately the sum of the estimates from a deterministic model
# We do, however, keep the lx column as this will be used later on, in the results section
# to visualise the heterogeneity within each region.

sum_abs <-
  abs_df %>%
  group_by(level, region, age, cohort) %>%
  summarise(
    value = sum(absolute)
    , lx = sum(lx)
  ) %>%
  ungroup %>% 
  arrange(level, region, cohort, age) 

# 1.4 Export ====

saveRDS(sum_abs, file = "Data/estimates/sum_abs_all.RDS")
saveRDS(abs_df, file = "Data/estimates/abs_df_all.RDS")
