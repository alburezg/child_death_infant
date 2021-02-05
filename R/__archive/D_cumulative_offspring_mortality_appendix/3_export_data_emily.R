
# Compare to Emily's estimates from MICS and DHS
# Produce plot comparing estimates for all countries grouped by region
# including those with and without survey data

# 0. Parameters ----

# For plotting

# reg_exclude <- "COUNTRIES EXCLUDED (islands/very small territories/populations)"
reg_exclude <- ""

# In casses where no specific year is indicated in Emily's data
# and for indirect estimations
# use 2016, the 'newest' information.
year_for_missing_countries <- 2016

# 1. Compare for mothers ----

prev_wide_mothers <- 
  compare_measures_bulk_5y(
    measure = "mothers"
    , name_export = "appendix_5y"
    , regions = regions
    , surv_df = surv
  )


# 3. Scan for errors -------

# 3.1. mom > mum > mim

prev_temp <- 
  prev_wide_mothers %>% 
  pivot_longer(-country) %>% 
  # filter(grepl("mom", name)) %>% 
  mutate(
    type = str_extract(name, "^[a-z]{3}")
    , age = str_extract(name, "[0-9]{2}-[0-9]{2}")
  ) %>% 
  select(-name) %>% 
  get_regions_iso(regions)

# This shows that for all cases mom > mum > mim
prev_temp %>% 
  pivot_wider(names_from = "type", values_from = "value") %>% 
  mutate(
    # mom_mum = mom >= mum
    # , mom_mim = mom >= mim
    # , mum_mim = mum >= mim
    test = mom >= mum & mum >= mim & mom >= mim
  ) %>% 
  count(test)

# 3.2. Find duplicated patterns

# South Korea and Sri Lanka estimates are identical?
# No evidence of this
prev_wide_mothers %>% 
  filter(grepl("Korea|Sri", country)) %>% 
  distinct() %>% 
  nrow() == 3

# Are there any duplicates in the estimates?
# No
prev_wide_mothers %>% 
  distinct() %>% 
  nrow() == nrow(prev_wide_mothers)

# 3.3. The under-five ones appear too low 
# (both relative to infant *and* relative to the 20-44 and 45-49 estimates).

set.seed(42)
country_keep <- sample(unique(prev_temp$country), 13)
age_labs <- unique(prev_temp$age)

# One way of checking is to plot
  prev_temp %>% 
  filter(country %in% country_keep) %>% 
  mutate(age = as.numeric(str_extract(age, "[0-9]{2}"))) %>% 
  ggplot(aes(x = age, y = value, colour = country, shape = type)) +
  geom_line(  ) +
  geom_point() +
  # scale_x_continuous(breaks = seq(15, 45, 10), labels = age_labs[c(1,3,5,7)]) +
  scale_x_continuous(breaks = seq(15, 45, 5), labels = age_labs) +
  scale_colour_discrete(guide = F) +
  facet_wrap(.~region, scales = "free") +
  theme_bw() +
  theme(
    legend.position = "bottom"
    , axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)
    )

ggsave("../../Output/appendix_mommummim_test.pdf")
  
# 3.	Sri Lanka that has a curious pattern, 
# but others appear as expected (comparing infant to under-five).

country_keep <- c("Sri Lanka", "Republic of Korea")
age_labs <- unique(prev_temp$age)

# One way of checking is to plot
prev_temp %>% 
  filter(country %in% country_keep) %>% 
  mutate(age = as.numeric(str_extract(age, "[0-9]{2}"))) %>% 
  ggplot(aes(x = age, y = value, colour = country, shape = type)) +
  geom_line(  ) +
  geom_point() +
  # scale_x_continuous(breaks = seq(15, 45, 10), labels = age_labs[c(1,3,5,7)]) +
  scale_x_continuous(breaks = seq(15, 45, 5), labels = age_labs) +
  # scale_colour_discrete(guide = F) +
  # facet_wrap(.~region, scales = "free") +
  theme_bw() +
  theme(
    legend.position = "bottom"
    , axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)
  )

ggsave("../../Output/appendix_srilanka.pdf")

# 4. Add the 20-44 and 45-49 yr old results -------------

prev_old <- 
  read.csv("../../Output/_kin_cohort_estimates_mothers.csv", stringsAsFactors = F) 


new_df <- 
  left_join(prev_wide_mothers, prev_old) %>% 
  rename(
    `mim20-44kc_old` = mim20kc 
    , `mim45-49kc_old` = mim45kc 
    , `mum20-44kc_old` = mum20kc 
    , `mum45-49kc_old` = mum45kc 
    , `mom45-49kc_old` = mom45kc 
  ) %>% 
  # ~~ Fixme! #########
  # Remove small countries. This should be done 
  # earlier but I don't remember where
filter(!is.na(`mim20-44kc_old`))

write.csv(new_df, "../../Output/_kin_cohort_estimates_mothers_appendix_all.csv")

# 4.1. For the 45-49 age, values should match

# 45-49

test1 <- 
  new_df %>% 
  select(country, contains("45-49"), contains("m45kc"))  %>% 
  pivot_longer(-country) %>% 
  # filter(grepl("mom", name)) %>% 
  mutate(
    type = str_extract(name, "^[a-z]{3}")
    , age = str_extract(name, "[0-9]{2}-[0-9]{2}")
    , iteration = ifelse(!grepl("-", name), "old", "new")
  ) %>% 
  select(-name, -age) %>%
  pivot_wider(names_from = iteration) %>% 
  mutate(test = new == old) 

  test1 %>% count(test)

  test1 %>% 
    filter(!test) %>% 
    data.frame()

  # ERROR? ---------
  # 30-35
  
  test2 <- 
    new_df %>% 
    select(country, contains("30-34"), contains("m20kc"))  %>% 
    pivot_longer(-country) %>% 
    # filter(grepl("mom", name)) %>% 
    mutate(
      type = str_extract(name, "^[a-z]{3}")
      , age = str_extract(name, "[0-9]{2}-[0-9]{2}")
      , iteration = ifelse(!grepl("-", name), "old", "new")
    ) %>% 
    filter(type != "mom") %>% 
    select(-name, -age) %>%
    pivot_wider(names_from = iteration) %>% 
    mutate(test = new == old) 
  
  test2 %>% count(test)
  
  test2 %>% 
    filter(!test) %>% 
    data.frame()
  
# The estimate for 30-34 is the same as the estimate for 20-44
# This should not happen, or??
# In any case, if there was a mistake it should be in the precious
# project-script, where these values are estimated.
# 
# Note: this is NOT an error, but the expected behaviour
# I first estiamted te single-age prevalence of maternal bereavemt for eahc meausre
# Afterward, I grouped it by age (eg 20-44 or 30-35). However, when I did this
# (see: rcode sldf44t)
# I chose the mid-interval value as representing the value for the whole interval.
# Therefore, the mIM value for the 20-44 ages was the value at age 20+(44-20)/2 = 32
# This is the same as the mIM value for the 30-34 age group: 30+(34-30)/2 = 32
# That's why they are the same
# An alternative approach, of course, would be to take the mean of all the values
# in the interval