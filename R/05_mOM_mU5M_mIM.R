
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Data requirements: 
# Data created in previous script can be loaded as:
# abs_df <- readRDS("Data/estimates/abs_df_all.RDS")

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Theory:
# Explanation of the logic of this analysis
# (from Emily SG):

# Here what we're doing is just treating bereavement 
# as a once ever outcome. So, we want the proportion 
# of women (which we'll express per 1,000 in the pop) 
# who have ever lost one or more children. And we want 
# these as period measures as you've done for all mothers 
# of peak reproductive age, and those who are (or nearing) 
# completion of reproduction.


# Implementation:

# I tried a similar procedure to 
# estimate the proportion of mothers (per 1,000 mothers) who have ever lost one 
# or more children. For this, I created cohort ‘life tables’ for women, where 
# nqx was the First Difference of Child Death. 
# This is basically the number of child deaths experienced by a woman at each age. 
# The resulting lx column can be interpreted as the share of women who have 
# experienced child death at age x. I then re-scaled this by multiplying it both 
# by the share of women surviving to age x (the ‘regular’ lx column in the mortality 
# life tables) and by the share of women aged x who are mothers. 

# 0. Unchanging paramenters ----

# Not sure about longest possible time-frame, but function won't
# break if years are unavaillable, only will return
# NA for those years. THis seems to work, although 1970 is unavailable
# for some meausres:
years <- 2000:2020
breaks <- c(20, 45, 50)
reprod_age <- c(15,50)

# The 'mean' method just gets the mean of all values in the
# age range
# initially, I took the "mid-interval" value but in Feb 2021
# we decided to change this to the mean
method <- "mean"

# 1. mOM ~~~~ ----

mOM <- offspring_death_prevalence(
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

mU5M <- offspring_death_prevalence(
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

mIM <- offspring_death_prevalence(
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

write.csv(mOM, "Data/estimates/mOM.csv", row.names = F)
write.csv(mU5M, "Data/estimates/mU5M.csv", row.names = F)
write.csv(mIM, "Data/estimates/mIM.csv", row.names = F)

print("7 - mOM, mU5M, and mIM saved as csv files!")
