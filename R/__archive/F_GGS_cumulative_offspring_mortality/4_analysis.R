
# Data created in this script can be loaded as:
# om_survey <- read.csv("../../Data/GGS/ggs_estimates.csv", stringsAsFactors = F)

# 1. Format data --------------

# 1.0 Formato country names ==============

# Only use gss country data
country_labels <- attr(gss$COUNTRY, "labels")

ggs_countries <- country_labels[grepl("GGS", names(country_labels))]
# ggs_countries <- names(country_labels)[grepl("GGS", names(country_labels))]

gss_countries_small <- trimws( gsub("GGS wave1|GGS wave 1", "", names(ggs_countries)) )

# Get df of countries
country_df <- data.frame(
  old_num = ggs_countries
  , old_lab = names(ggs_countries)
  , new = countrycode(gss_countries_small, origin = "country.name", destination = "iso3c")
)

# Filter data to keep only coutries with GGS data

small <- 
  gss %>% 
  filter(COUNTRY %in% country_df$old_num)
  
# recode country labels
small$country <- country_df$new[match(small$COUNTRY, country_df$old_num)]

# Get survey years
# Assume that year with most observations is te survey years

survey_years <- 
  small %>% 
  count(country, year = YEAR_S) %>% 
  group_by(country) %>% 
  arrange(n) %>% 
  slice(1) %>% 
  ungroup() %>% 
  select(-n) %>% 
  mutate(year = as.numeric(year))

country_df <- 
  country_df %>% 
  left_join(survey_years, by = c("new" = "country"))

# 1.1. Filter data ============
# Keep only relevant columns

small_df <- 
  small %>% 
  select(
    country, survey_y = YEAR_S, survey_m = MONTH_S, sex = SEX, ego_yob = BORN_Y, ego_mob = BORN_M
    , starts_with("KID"), starts_with("IKID"), PERSWGT
    ) %>% 
  mutate(
    # Convert to DHS century month code
    ego_birth_cmc = get_cmc(ego_yob, ego_mob)
    , survey_cmc = get_cmc(survey_y, survey_m)
    , ego_age_months = survey_cmc - ego_birth_cmc
    , ego_age_years = floor(ego_age_months/12)
    # , ego_age_years = 
  ) %>% 
  # keep only women/mothers
  filter(sex == 2) %>% 
  # Keep only women younger than 49 to make comparable with DHS estimates
  filter(ego_age_years <= max(age_range)) %>% 
  # Keep only mothers
  # According to the documentation, KID_[1-9]+ is an
#   indicator of child order 
# (provides info if child was 
#   born, even if birth date 
#   unknown) 
  # 0: no child of order $ 
  # 1: child of order $ 
  # .a: unknown 
  filter(KID_1 == 1) %>% 
  # Temporary: filter countries without person years
  filter(!is.na(PERSWGT))

# 1.2. Explore sample sizes ============
  
# Before filtering

small %>% 
  count(country)

# Bulgaria, Hungary, Poland, and Russia have large samples

# After filtering

small_df %>% 
  count(country)

# 1.3. Process child data ============

# Create CMC codes for child variables

kids_birth_cmc <- mapply(
  get_cmc
  , y = small_df %>% select(starts_with("KID_Y"))
  # IKID uses inpute values
  , m = small_df %>% select(starts_with("IKID_M"))
  ) %>% 
  data.frame()

names(kids_birth_cmc) <- paste0("kid_birth_cmc", seq_along(kids_birth_cmc))

kids_death_cmc <- mapply(
  get_cmc
  , y = small_df %>% select(starts_with("KID_DY"))
  , m = small_df %>% select(starts_with("IKID_DM"))
) %>% 
  data.frame()

names(kids_death_cmc) <- paste0("kid_death_cmc", seq_along(kids_death_cmc))

# Kid's age at death

kids_age_death_months <- kids_death_cmc -  kids_birth_cmc
names(kids_age_death_months) <- paste0("kid_age_death_months", seq_along(kids_age_death_months))

# 2. Get bereavement estimates ---------------

# To estimate the mU5M, we make the same calculation, but sum mothers who have ever 
# had a child die before reaching age 5. 
# The mOM indexes the prevalence of mothers who have experienced a child death, 
# regardless of that child’s age.  
# Due to censoring, we calculate the mOM for 45- to 49-year-old mothers only

# 2.1. Count deaths by type of berevaement ==========

# To estimate the mIM, we tabulate the prevalence of mothers who have ever experienced 
# the death of at least one infant. 
# We sum the number of mothers who had a child die before age 1 among those who ever 
# had a live birth and express this per 1,000 mothers. 

# First, create a vecotr with each element indicating whether a given woman-row
# was bereaved or not according to the various definitions used
mim <- was_mother_bereaved_GGS(kids_age_death_months, max_child_age_months = 1*12)
mu5m <- was_mother_bereaved_GGS(kids_age_death_months, max_child_age_months = 5*12)
mom <- was_mother_bereaved_GGS(kids_age_death_months, max_child_age_months = 100*12)

# 2.2. Create consolidated df

# Don;t keep child sex as it's irrelevant
cd <- 
  small_df %>% 
  select(
    country, ego_age_years, PERSWGT
    # , ego_birth_cmc
    # , ego_age_months
    # , survey_cmc
    # Whether KID has died:
    # Labels:
    # value                 label
    # 0   No death of child 1
    # 1      Death of child 1
    # NA(a)               Unknown
    # NA(b)        Does not apply
    # NA(c) Unavailable in survey
    # , starts_with("KID_D")
    ) %>% 
  mutate(
    mim = mim
    , mu5m = mu5m
    , mom = mom
    , ego_age_years = as.numeric(ego_age_years)
    , country = as.character(country)
    # try to fix austria
    , PERSWGT = ifelse(country == "AUT", PERSWGT/1000, PERSWGT)
  ) 

# 2.2. Filter unwanted cuntries ============

# Survey weights are not the same across surveys!!

cd %>% 
  group_by(country) %>% 
  summarise(
    min = min(PERSWGT)
    , max = max(PERSWGT)
    )
  

# ? TODO Austria has weird weights ############
# Excluded for now, but figure up what's up

# small %>% 
#   dplyr::count(country, KID_D1) %>% 
#   data.frame()

print("Removing NOR")


cd <- 
  cd %>% 
  # Austria has weird weights
  # filter(country != "AUT") %>% 
  # Norway does not report child deaths
  filter(country != "NOR")

# 3. Get country-level estimates -----------

# 3.0 Exploratory ==============

sample <-
  cd %>%
  dplyr::count(country, name = "sample (mothers)")


exposure <-
  cd %>%
  dplyr::count(country, wt = PERSWGT,  name = "exposure")

enu <-
  cd %>%
  group_by(country) %>%
  summarise(
    mim = sum(mim)
    , mum = sum(mu5m)
    , mom = sum(mom)
  ) %>%
  ungroup()

library(knitr)

kable(left_join(sample, enu) )


# 3.1. Get mean and CI -----------

om_survey <- 
  get_ci_by_country_GGS(cd, level = 0.95) %>%
  # get survey yeares
  left_join(
    country_df %>% 
      select(country = new, year) %>% 
      mutate(country = as.character(country)) 
  ) %>% 
  select(country, year, variable, everything()) %>% 
  arrange(country, variable) 

# om_survey99ci

# DEPCREACATED --------

# ~~~~~~~~~~~~~~~~~
# WORKING CODE
# ~~~~~~~~~~~~~

# get weighted means without survey package

# 3.1  mim 

# mim20 <- 
#   cd %>% 
#   filter(between(ego_age_years, 20,44)) %>% 
#   group_by(country) %>% 
#   summarize(
#     value = weighted.mean(mim, w = PERSWGT)
#   ) %>% 
#   mutate(
#     value = value * 1000
#     , variable = "mim20"
#   )
# 
# mim45 <- 
#   cd %>% 
#   filter(between(ego_age_years, 45,49)) %>% 
#   group_by(country) %>% 
#   summarize(
#     value = weighted.mean(mim, w = PERSWGT)
#   ) %>% 
#   mutate(
#     value = value * 1000
#     , variable = "mim45"
#   )
# 
# # 3.2  mu5m 
# 
# mum20 <- 
#   cd %>% 
#   filter(between(ego_age_years, 20,44)) %>% 
#   group_by(country) %>% 
#   summarize(
#     value = weighted.mean(mu5m, w = PERSWGT)
#   ) %>% 
#   mutate(
#     value = value * 1000
#     , variable = "mum20"
#   )
# 
# mum45 <- 
#   cd %>% 
#   filter(between(ego_age_years, 45,49)) %>% 
#   group_by(country) %>% 
#   summarize(
#     value = weighted.mean(mu5m, w = PERSWGT)
#   ) %>% 
#   mutate(
#     value = value * 1000
#     , variable = "mum45"
#   )
# 
# # 3.3  mom 
# 
# mom45 <- 
#   cd %>% 
#   filter(between(ego_age_years, 45,49)) %>% 
#   group_by(country) %>% 
#   summarize(
#     value = weighted.mean(mom, w = PERSWGT)
#   ) %>% 
#   mutate(
#     value = value * 1000
#     , variable = "mom45"
#   )
# 
# # 3.4. Consolidate 
# 
# om_survey <- 
#   bind_rows(mim20, mim45, mum20, mum45, mom45) %>% 
#   select(country, variable, value, everything()) %>% 
#   arrange(country, variable) %>% 
#   left_join(
#     country_df %>% select(country = new, year)
#   ) 
