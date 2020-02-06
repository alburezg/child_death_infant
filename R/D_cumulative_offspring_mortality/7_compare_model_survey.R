
# Compare to Emily's estimates from MICS and DHS
# Currently, only implemented for mOM4549

# Questions ----

# - GNQ and GNB don;t have a year assinged in the survy estimates
# Cuentries without estimates lack a year in your Excel sheet. 
# I just took the value for 2018 for those cases, hope it's ok!

# 0. Parameters ----

# For plotting

base_size <- 15
point_size <- 4

reg_exclude <- "COUNTRIES EXCLUDED (islands/very small territories/populations)"

# Datasets for functions below
# create iso codes

surv_df <- surv %>% 
  mutate(
    iso = countrycode(country, origin = "country.name", "iso3c", warn = F)
    , region = trimws(region) 
  )

old <- unique(mOM$country)
new <- countrycode(old, origin = "country.name", "iso3c", warn = F)

# NOn-changing parameters for the functinos

# In casses where no specific year is indicated in Emily's data
# use 2018, the 'newest' information.
year_for_missing_countries <- 2018

# 1. mOM ~~~~ ----

model_df <- mOM %>% 
  mutate(iso = plyr::mapvalues(country, from =  old, to = new))

# 1.1. mOM2044 ----

# Measure to keep from the survey estimates
surv_measure_keep <- c("mU5M2044")
# Age group for model data
model_agegr_keep <- c("[20,45)")

mOM2044 <- compare_measures(
  year_for_missing_countries
  , surv_measure_keep
  , model_agegr_keep
  , model_df
  , surv_df
)

# 1.2. mOM4549 ----

# Measure to keep from the survey estimates
surv_measure_keep <- c("mOM4549")
# Age group for model data
model_agegr_keep <- c("[45,50)")

mOM4549 <- compare_measures(
  year_for_missing_countries
  , surv_measure_keep
  , model_agegr_keep
  , model_df
  , surv_df
)

# 2. mU5M ~~~~ ----

model_df <- mU5M %>% 
  mutate(iso = plyr::mapvalues(country, from =  old, to = new))

# 2.1 mU5M2044 ====

# Measure to keep from the survey estimates
surv_measure_keep <- c("mU5M2044")
# Age group for model data
model_agegr_keep <- c("[20,45)")

mU5M2044 <- compare_measures(
  year_for_missing_countries
  , surv_measure_keep
  , model_agegr_keep
  , model_df
  , surv_df
)

# 2.2 mU5M4549 ====

# Measure to keep from the survey estimates
surv_measure_keep <- c("mU5M4549")
# Age group for model data
model_agegr_keep <- c("[45,50)")

mu5M4550 <- compare_measures(
  year_for_missing_countries
  , surv_measure_keep
  , model_agegr_keep
  , model_df
  , surv_df
)

# 3. mIM ~~~~ ----

model_df <- mIM %>% 
  mutate(iso = plyr::mapvalues(country, from =  old, to = new))

# 2.1 mU5M2044 ====

# Measure to keep from the survey estimates
surv_measure_keep <- c("mIM2044")
# Age group for model data
model_agegr_keep <- c("[20,45)")

mIM2044 <- compare_measures(
  year_for_missing_countries
  , surv_measure_keep
  , model_agegr_keep
  , model_df
  , surv_df
)

# 2.2 mIM4549 ====

# Measure to keep from the survey estimates
surv_measure_keep <- c("mIM4549")
# Age group for model data
model_agegr_keep <- c("[45,50)")

mIM4550 <- compare_measures(
  year_for_missing_countries
  , surv_measure_keep
  , model_agegr_keep
  , model_df
  , surv_df
)

# 4. Consolidate ----

prevalence <- bind_rows(
  mOM2044 %>% mutate(
      measure = "mOM"
      , ages = "20-44"
    )
  , mOM4549 %>% mutate(
    measure = "mOM"
    , ages = "45-49"
  )
  , mU5M2044 %>% mutate(
    measure = "mU5M"
    , ages = "20-44"
  )
  , mu5M4550 %>% mutate(
    measure = "mU5M"
    , ages = "45-49"
  )
  , mIM2044 %>% mutate(
    measure = "mIM"
    , ages = "20-44"
  )
  , mIM4550 %>% mutate(
    measure = "mIM"
    , ages = "45-49"
  )
) %>% 
  mutate(level = paste0(measure, "_", ages))

# 5. Export ----

write.csv(prevalence %>% select(-level), "../../Output/all_combined.csv", row.names = F)

# 6. Plot ----

prev_list <- split(prevalence, prevalence$level)

# This saves graphs as pdfs
plots <- lapply(prev_list, plot_comparison, export = T) 
