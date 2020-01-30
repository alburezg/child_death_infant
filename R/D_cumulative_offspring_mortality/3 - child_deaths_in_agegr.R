
# Questions ----

# For the 20-44 measure, do you count child deaths that happened when the mother was 15-19 yo?



# Estimate the cumulative number of child deaths (CCD)
# experienced for women finishing their reproductive life.
# ESG uses the agr groups 20-44 and 45-49

# This means that CD is the mean value of the cumulative number 
# of child death for all mothers currently aged, for example, 45-49 I.e. the sum 
# of all child deaths experienced in the 15-49 period for all 
# women currently aged 45-49
# 	For time frame: 2010-2019

# We can use our data to estimate this directly using the mean value 
# of CD_{c, 20-44} and CD_{c, 45-49}



# Eventually we need to transform these measure from cohort to period
# but I am not sure if I should get the mean values first and the convert
# or the other way around

# 0. Parameters ----

width <- 20
height <- 14

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
# Creates fertility tables assuming that
# ASFR is the hazard rate or nqx column

share_of_women_are_mothers <- ASFRC %>% 
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
  abs_df %>% filter(between(age, 15, 50)), 
  share_of_women_are_mothers
  , by = c("country", "cohort", "age")
)

# 1. Cohort to Period ----

# We approximate period values from cohort estimates
# by taking values on the diagonal

# First, reduce size of data, then get period values

years <- 2010:2019
breaks <- c(20, 45, 50)

cd_p <- 
  cd_mothers %>% 
  select(country, cohort, age, lx, absolute, share_of_women_are_mothers) %>%
  # Get cumulative number of child deaths up to age a
  group_by(country, cohort) %>%
  mutate(
    absolute_cum = cumsum(absolute)
    # , lx_cum = cumsum(lx)
    ) %>%
  ungroup %>%
  mutate(year = cohort + age) %>% 
  # select(country, year, age, child_death) %>% 
  select(country, year, age, lx, absolute_cum, share_of_women_are_mothers) %>% 
  filter(year %in% years) %>% 
  filter(between(age, min(breaks), max(breaks))) %>% 
  arrange(country, year, age) 


# 3. Average CD per age gr ----

# We can say that a group of, say 100 women aged 44-49, 
# have lost X number of children throughout their life. 
# Or on average, each woman has lost X/100 children.

cm <- 
  cd_p %>% 
  mutate( agegr = cut(age, breaks, right = F)  ) %>% 
  filter(!is.na(agegr)) %>% 
  group_by(country, year, agegr) %>% 
  summarise(
    # Enumerator: will always be the upper age limit
    # of the age group, since the value is cumulative, so
    # it doesn't really matter what the lower bound of the age group
    # is. 
    child_deaths_in_agr = last(absolute_cum)
    # Denominator: here both age bounds matter. This should be the 
    # number of women who were exposed to those child deaths in
    # the iven age groups. One alternative is to compute this as
    # the mean number of women who lived in this period:
    # , women_alive_in_interval = mean(lx)
    # Another alternative would be to take the mid-period population
    # as the denominator
    , women_mid_period = nth(lx, n = floor(n()/2))
    # Now, you can consider only mothers by multiplying by the 
    # share of women who were mother in the given agr group
    , share_of_women_are_mothers = nth(share_of_women_are_mothers, n = floor(n()/2))
    , mothers_mid_period = women_mid_period * share_of_women_are_mothers
  ) %>% 
  ungroup %>% 
  # Divide by the number of women alive in that interval
  mutate(
    cd_per_woman = child_deaths_in_agr / women_mid_period
    , cd_per_mother = child_deaths_in_agr / mothers_mid_period
    ) 
  
# 4.1. Export small ----

keep <- paste0(
  c("mali", "niger", "cameroon", "zimbabwe")
  , c(2012, 2012, 2011, 2015)
)

small <- cm %>% 
  mutate(id = paste0(country, year)) %>% 
  mutate_if(is.numeric, round, 3) %>% 
  filter(id %in% keep) %>% 
  select(-id)

write.csv(small, "../../Output/cumulative_child_death_small.csv", row.names = F)

# 4. Export df ----

write.csv(cm, "../../Output/cumulative_child_death.csv", row.names = F)
