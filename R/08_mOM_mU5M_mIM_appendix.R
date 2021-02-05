
# This is the same as the preious script, but produces 
# estimates for 5-year age groups instead of the 
# larger age groups presented in the main text

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Data requirements: 
# Data created in previous script can be loaded as:
# abs_df <- readRDS("Data/estimates/abs_df_all.RDS")

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 0. Unchanging paramenters ----

years <- 2000:2020
breaks <- seq(15, 50, 5)
reprod_age <- c(15,50)

# method <- "mid-interval"
method <- "mean"

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
  , method = method
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
  , method = method
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
  , method = method
)

# 4. Export ====

write.csv(mOM_5y, "Data/estimates/mOM_5y.csv", row.names = F)
write.csv(mU5M_5y, "Data/estimates/mU5M_5y.csv", row.names = F)
write.csv(mIM_5y, "Data/estimates/mIM_5y.csv", row.names = F)

print("7 - mOM, mU5M, and mIM saved as csv files!")
