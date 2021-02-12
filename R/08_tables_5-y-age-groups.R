
# Compare to Emily's estimates from MICS and DHS
# Produce plot comparing estimates for all countries grouped by region
# including those with and without survey data

# Data requirements ~~~~~~~~~~~~~~~~~~~~~~~~~~
# Estimates in previous scripts 
# Estimates using 5-y age groups
mOM_5y <- read.csv("Data/estimates/mOM_5y.csv", stringsAsFactors = F) %>% 
  filter(country != "channel islands")
mU5M_5y <- read.csv("Data/estimates/mU5m_5y.csv", stringsAsFactors = F) %>% 
  filter(country != "channel islands")
mIM_5y <- read.csv("Data/estimates/mIM_5y.csv", stringsAsFactors = F) %>% 
  filter(country != "channel islands")

prev_old <- 
  read.csv("Output/_kin_cohort_estimates_mothers.csv", stringsAsFactors = F) 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 0. Parameters ----

# For plotting

# reg_exclude <- "COUNTRIES EXCLUDED (islands/very small territories/populations)"
reg_exclude <- ""

# In casses where no specific year is indicated in Emily's data
# and for indirect estimations
# use 2016, the 'newest' information.
year_for_missing_countries <- 2016

# 1. Compare for mothers ----

prev_wide_mothers_5y <- 
  compare_measures_bulk_5y(
    measure = "mothers"
    , name_export = "appendix_5y"
    , regions = regions
    , surv_df = surv
  )

# 2. Export with the 20-44 and 45-49 yr old results -------------

new_df <- 
  left_join(prev_wide_mothers_5y, prev_old, by = c("country")) %>% 
  rename(
    `mim20-44kc_old` = mim20kc 
    , `mim45-49kc_old` = mim45kc 
    , `mum20-44kc_old` = mum20kc 
    , `mum45-49kc_old` = mum45kc 
    , `mom45-49kc_old` = mom45kc 
  ) %>% 
filter(!is.na(`mim20-44kc_old`))

write.csv(new_df, "Output/_kin_cohort_estimates_mothers_appendix_all.csv", row.names = F)
