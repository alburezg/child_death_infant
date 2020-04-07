
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

years <- 2010:2019
breaks <- c(20, 45, 50)
reprod_age <- c(15,50)

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
)

# 4. Export ====

write.csv(mOM, "../../Data/estimates/mOM.csv", row.names = F)
write.csv(mU5M, "../../Data/estimates/mU5M.csv", row.names = F)
write.csv(mIM, "../../Data/estimates/mIM.csv", row.names = F)

# 5. Export for Emily 

# model_all <- bind_cols(
#   mim20ic = mIM %>% 
#     filter(agegr == "[20,45)") %>% 
#     select(iso, year, bereaved_mothers)
#   , mim45ic = mIM %>% 
#     filter(agegr == "[45,50)") %>% 
#     pull(bereaved_mothers)
#   , mum20ic = mU5M %>% 
#     filter(agegr == "[20,45)") %>% 
#     pull(bereaved_mothers)
#   , mum45ic = mU5M %>% 
#     filter(agegr == "[45,50)") %>% 
#     pull(bereaved_mothers)
#   , mom45ic = mOM %>% 
#     filter(agegr == "[45,50)") %>% 
#     pull(bereaved_mothers)
# )
