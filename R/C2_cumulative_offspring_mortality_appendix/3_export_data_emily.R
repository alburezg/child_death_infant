
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

add_indirect_estimates <- T

# 1. Compare for Women ----

prev_wide_women <- 
  compare_measures_bulk_5y(
    measure = "women"
    , name_export = "appendix_5y"
    , regions = regions
    , surv_df = surv
  )
