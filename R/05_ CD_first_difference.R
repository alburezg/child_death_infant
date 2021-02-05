print(paste0("Running script: 6 - CD_first_difference"))

# Obtain country-level estimates of the first difference of Child Death. 
# This is the number of child deaths experienced by a woman at each age 'a'.
# See the SI Appendix for a formal description.

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Data requirements (created in previous script): 
CD_0_100 <- readRDS('Data/estimates/CD_0_100.RDS') 
CD_0_5 <- readRDS('Data/estimates/CD_0_5.RDS') 
CD_0_1 <- readRDS('Data/estimates/CD_0_1.RDS') 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# The following scripts save the RDS files automatically
# to the disk and return them as a list

# To identify whether all-age child deaths, child, or infant
age_codes <- c("0_100", "0_5", "0_1")

# 1. All offspring ----

l_all <- get_difference(
  child_death_df = CD_0_100
  , name_to_save = age_codes[1]
)


# 2. Under 5 ----

l_u5 <- get_difference(
  child_death_df = CD_0_5
  , name_to_save = age_codes[2]
)

# 3. Infants ----

l_infant <- get_difference(
  child_death_df = CD_0_1
  , name_to_save = age_codes[3]
)

# 4. Consolidate all country-level dfs ----

l_diff <- list(l_all, l_u5, l_infant)

# l_diff_country <- lapply(l_diff, '[[', "df_cl_diff")

# 4. Export

saveRDS(l_diff, file = "Data/estimates/l_diff.RDS")
