
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

# 2. Export with the 20-44 and 45-49 yr old results -------------

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

