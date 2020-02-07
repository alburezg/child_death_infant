
# Compare to Emily's estimates from MICS and DHS
# Currently, only implemented for mOM4549

# 0. Parameters ----

# For plotting

base_size <- 15
point_size <- 4

reg_exclude <- "COUNTRIES EXCLUDED (islands/very small territories/populations)"

# In casses where no specific year is indicated in Emily's data
# and for indirect estimations
# use 2016, the 'newest' information.
year_for_missing_countries <- 2016

# I estimated bereaved women and mothers, which is suppsed to be better
# but is giving worse estimates
model_measure_keep <- "bereaved_women"

# 1. mOM ~~~~ ----

# 1.1. mOM4549 ----

# Measure to keep from the survey estimates
surv_measure_keep <- c("mom45")
# Age group for model data
model_agegr_keep <- c("[45,50)")

mOM4549 <- compare_measures(
  year_for_missing_countries
  , surv_measure_keep
  , model_agegr_keep
  , model_measure_keep
  , model_df = mOM
  , surv_df = surv
)

# 2. mU5M ~~~~ ----

# 2.1 mU5M2044 ====

# Measure to keep from the survey estimates
surv_measure_keep <- c("mum20")
# Age group for model data
model_agegr_keep <- c("[20,45)")

mU5M2044 <- compare_measures(
  year_for_missing_countries
  , surv_measure_keep
  , model_agegr_keep
  , model_measure_keep
  , model_df = mU5M
  , surv_df = surv
)

# 2.2 mU5M4549 ====

# Measure to keep from the survey estimates
surv_measure_keep <- c("mum45")
# Age group for model data
model_agegr_keep <- c("[45,50)")

mu5M4550 <- compare_measures(
  year_for_missing_countries
  , surv_measure_keep
  , model_agegr_keep
  , model_measure_keep
  , model_df = mU5M
  , surv_df = surv
)

# 3. mIM ~~~~ ----

# 2.1 mU5M2044 ====

# Measure to keep from the survey estimates
surv_measure_keep <- c("mim20")
# Age group for model data
model_agegr_keep <- c("[20,45)")

mIM2044 <- compare_measures(
  year_for_missing_countries
  , surv_measure_keep
  , model_agegr_keep
  , model_measure_keep
  , model_df = mIM
  , surv_df = surv
)

# 2.2 mIM4549 ====

# Measure to keep from the survey estimates
surv_measure_keep <- c("mim45")
# Age group for model data
model_agegr_keep <- c("[45,50)")

mIM4550 <- compare_measures(
  year_for_missing_countries
  , surv_measure_keep
  , model_agegr_keep
  , model_measure_keep
  , model_df = mIM
  , surv_df = surv
)

# 4. Consolidate ----

prevalence <- bind_rows(
   mOM4549 %>% mutate(
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

# 4. Export for Emily ----

rownames(prevalence) <- 1:nrow(prevalence)

old <- unique(prevalence$level)
new <- paste0(c("mom45", "mum20", "mum45", "mim20", "mim45"), "ic")

prev_wide <- 
  prevalence %>% 
  select(iso, level, model) %>% 
  mutate(level = plyr::mapvalues(level, old, new)) %>% 
  pivot_wider(names_from = level, values_from = model, values_fn = list(model = mean)) %>% 
  merge(
  .
  , surv %>% select(iso, country = country)
  , by = c("iso")
) %>% 
  select(-iso) %>% 
  select(country, everything()) 

# Order accoring to original excel
prev_wide <- prev_wide[match(countries_order, prev_wide$country), ]

write.csv(prev_wide, "../../Output/all_combined.csv", row.names = F)

# 6. Plot ----

prev_list <- split(prevalence, prevalence$level)

# This saves graphs as pdfs
plots <- lapply(prev_list, plot_comparison, export = T) 
