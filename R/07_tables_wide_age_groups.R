
# Compare to Emily's estimates from MICS and DHS
# Produce plot comparing estimates for all countries grouped by region
# including those with and without survey data

# Data requirements ~~~~~~~~~~~~~~~~~~~~~~~~~~
# Estimates in previous scripts 
# These have wide age groups (only 2)
mOM <- read.csv("Data/estimates/mOM.csv", stringsAsFactors = F) %>% 
  filter(country != "channel islands")
mU5M <- read.csv("Data/estimates/mU5m.csv", stringsAsFactors = F) %>% 
  filter(country != "channel islands")
mIM <- read.csv("Data/estimates/mIM.csv", stringsAsFactors = F) %>% 
  filter(country != "channel islands")
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 0. Parameters ----

# For plotting

base_size <- 15
point_size <- 4

# reg_exclude <- "COUNTRIES EXCLUDED (islands/very small territories/populations)"
reg_exclude <- ""

# In casses where no specific year is indicated in Emily's data
# and for indirect estimations
# use 2016, the 'newest' information.
year_for_missing_countries <- 2016

# Should I also include indirect estimates 
# provided by Emily using her other method
# in the output tables?
# only available for mothers and for mim45 and mum45
add_indirect_estimates <- T

# Compare for Mothers ----

prev_mothers <- 
  compare_measures_bulk(
    measure = "mothers"
    , export = T
    , regions = regions
    , surv_df = surv
  )
