
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PENDING ----

# 20200130
# Estimates for mothers are sometimes  higher than estimates for women
# which does not make sense since it should always be the 
# other way around!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Theory:
# From ESG:

# Here what we're doing is just treating bereavement 
# as a once ever outcome. So, we want the proportion 
# of women (which we'll express per 1,000 in the pop) 
# who have ever lost one or more children UNDER 5. And we want 
# these as period measures as you've done for all mothers 
# of peak reproductive age, and those who are (or nearing) 
# completion of reproduction. Does this make sense? So, our 
# estimate for all offspring loss (so, any age chlid died--not
# restricted to infants or under-five year olds) for the 
# selected countries are: 

# Cameroon (2011): 514 mothers age 45-49 have ever lost child (per 1,000 mothers in age group)  
# Niger (2012): 780 mothers age 45-49 have ever lost child (per 1,000 mothers in age group) 
# Zimbabwe (2015):: 247 mothers age 45-49 have ever lost child (per 1,000 mothers in age group) 
# Mali (2012): 368 mothers age 45-49 have ever lost child (per 1,000 mothers in age group)

# ESG uses the agr groups 20-44 and 45-49
# 	For time frame: 2010-2019

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

# 0. Parameters ----

width <- 20
height <- 14

# For cohort-period conversion
# First, reduce size of data, then get period values
years <- 2010:2019
breaks <- c(20, 45, 50)

# 1. From women to mothers  ----

# Theory:

# Now, if we knew the fraction of women aged 44-49 who are mothers, 
# then we could rescale. Say that 90% of women 44-49 have had at 
# least a child. Then each *mother* has lost X/90 children.

# If we do not have the fraction of women aged 44-49 who are mothers, 
# we could calculate it from age specific fertility rates. We can 
# consider the fertility rates as “hazard rates” and evaluate how many 
# women have “survived” having children by the time they are 44-49 if 
# the go through the given age specific fertility rates at each age. 
# 1-(fraction of survivors) would be the fraction of “ever been mothers”.

# Implementation: 

# This measure considers child death irrespective of the
# child's age, so get that data

abs_df_temp <- 
  abs_df_all %>% 
  filter(level == "0_1") %>% 
  filter(between(age, 15, 50))

# Creates fertility tables assuming that
# ASFR is the hazard rate or nqx column

share_of_women_are_mothers <- 
  ASFRC %>% 
  filter(between(Cohort, 1950, 2000)) %>% 
  mutate(asfr = ASFR/1000) %>% 
  select(cohort = Cohort, country, age = Age, asfr) %>% 
  group_by(cohort, country) %>% 
  mutate(
    lx =  qx2lx(asfr, radix = 1)
    , share_of_women_are_mothers = 1 - lx
  ) %>% 
  ungroup %>% 
  select(-lx, - asfr)

cd_mothers <- merge(
  abs_df_temp, 
  share_of_women_are_mothers
  , by = c("country", "cohort", "age")
) %>% 
  select(- absolute)

# 2. Child death table ----

# Create life tables where qx is the first difference of 
# child death, so that lx gives the share of women or mothers who have 
# experienced the death of a child by age a

cd_table <- 
  cd_mothers %>% 
  group_by(cohort, country) %>% 
  mutate(
    # Create lx with radix 1 for year 15
    # Note: sould this be 
    lx_scaled = lx / first(lx)
    # This pertains to women who have lost one child or more
    # Note that the estimate is weighted by the share of women 
    # survivng to that age group and then by 1000 since ESG
    # estimates require it
    , bereaved_women =  (1 - qx2lx(nqx = diff, radix = 1)) * lx_scaled * 1000
    # A quick and dirty way of accounting for mothers only would be to 
    # weight by the share of women in a given age group who are mothers
    , bereaved_mothers =  bereaved_women * share_of_women_are_mothers
  ) %>% 
  ungroup

# 3. Cohort to Period ----

# We approximate period values from cohort estimates
# by taking values on the diagonal

cd_p <- 
  cd_table %>% 
  # Get cumulative number of child deaths up to age a
  mutate(year = cohort + age) %>% 
  select(country, year, age, bereaved_women, bereaved_mothers) %>%
  filter(year %in% years) %>% 
  filter(between(age, min(breaks), max(breaks))) %>% 
  arrange(country, year, age) 

# 3. Average CD per age gr ----

# We can say that a group of, say 100 women aged 44-49, 
# have lost X number of children throughout their life. 
# Or on average, each woman has lost X/100 children.

mIM <- 
  cd_p %>% 
  mutate( agegr = cut(age, breaks, right = F)  ) %>% 
  filter(!is.na(agegr)) %>% 
  group_by(country, year, agegr) %>% 
  summarise(
    # Option 1, take mean
    # bereaved_women = mean(bereaved_women)
    # , bereaved_mothers = mean(bereaved_mothers)
    # Option 2, take mid-interval value
    bereaved_women = nth(bereaved_women, n = floor(n()/2))
    , bereaved_mothers = nth(bereaved_mothers, n = floor(n()/2))
  ) %>% 
  ungroup 

# 4. Export df ----

write.csv(mIM, "../../Output/mIM.csv", row.names = F)

