print(paste0("Running script: ", "4 - CD_create_df"))

# This script takes cohort age-specific fertility rates (ASFRC) 
# and matrices of survival probabilities (lx.kids.arr) to estimate
# the cumulative number of child deaths for a woman surviving 
# to different ages for all countries and birth cohorts separately. 

# The output is a data frame containing the expected CD value by woman's age.

# The outcomes estimated in this script are

# 1. Offspring Death (0-100)
# 2. Infant Deaths (0-4)
# 3. Adult Deaths (20-100)

# 0. Parameters ----

reference_years <- 1950:2000
countries <- unique(ASFRC$country)

# To determine which rows are regions and which countries
#   when merging
allowed_types <- c("country", "un_sdg-groups")

# Parameters for the function
cos <- c(1950:2100) # cohorts
xs <- c(15:50) # reproductive ages

# 1. Offspring Death (0-100) ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

mas <- c(15:100) # woman ages

od <- child_loss(
  countries = countries
  , reference_years = reference_years
  , path = "Data/derived"
  , ASFRC = ASFRC
  , LTCB = LTCB
  , ages_keep = 15:100
  # If you want infant deaths only instead of all-age child deaths
  , max_child_age = NA
)

# Get regions

od_m <- 
  get_regions(od, un_reg, regions_long) %>% 
  mutate(value = value /1000)

saveRDS(od_m, 'Data/estimates/CD_0_100.RDS')


# 2. Infant Death (0-1) ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# woman ages
# Need to add +1 so that the loop way down in the function 
# doesn't crash. 
mas <- c(15:51) 

id <- child_loss(
  countries = countries
  , reference_years = reference_years
  , path = "Data/derived"
  , ASFRC = ASFRC
  , LTCB = LTCB
  , ages_keep = 15:100
  # If you want infant deaths only instead of all-age child deaths
  , max_child_age = 1
) 

# Get regions

id_m <- get_regions(id, un_reg, regions_long) %>% 
  mutate(value = value /1000)

saveRDS(id_m, 'Data/estimates/CD_0_1.RDS')

# 3. Child Death (0-5) ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

mas <- c(15:55) # woman ages

cd <- child_loss(
  countries = countries
  , reference_years = reference_years
  , path = "Data/derived"
  , ASFRC = ASFRC
  , LTCB = LTCB
  , ages_keep = 15:100
  # If you want infant deaths only instead of all-age child deaths
  , max_child_age = 5
) 

# Get regions

cd_m <- get_regions(cd, un_reg, regions_long) %>% 
  mutate(value = value /1000)

saveRDS(cd_m, 'Data/estimates/CD_0_5.RDS')

# 4. Merge ----

od_cd <- merge(
  od %>% rename(od = value)
  , cd %>% select(country, variable, age, cd = value)
  , by = c("country", "variable", "age")
  , all.x = T
  , sort = T
)

od_cd_id <- merge(
  od_cd
  , id %>% select(country, variable, age, id = value)
  , by = c("country", "variable", "age")
  , all.x = T
  , sort = T
) %>%
  rename(cohort = variable) %>% 
  # take last observed value for ages over 54
  fill(id)

saveRDS(od_cd_id, 'Data/estimates/CD_01_05_0100.RDS')