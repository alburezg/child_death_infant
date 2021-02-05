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
# cos <- c(1950:2099) # cohorts
xs <- c(15:50) # reproductive ages

# DEPRECATED Child and teen deaths ----
# DEPRECATED 20200206
# 4. Child Deaths (4-12)
# 5. Teenage Deaths (13-19)
# IT DOES RUN BUT I HAVE TO CHECK THE MATH BEHIND IT

# with the understanding that 
# OD = ID + AD + CD + TD
# which allows us to estimate each of these quantitites


# 3. Adult Deaths (20-100)

# This can be estimated as OD - CD_{0-19}

mas <- c(15:100) # woman ages

cd_0_20 <- child_loss(
  countries = countries
  , reference_years = reference_years
  , path = "../../Data/derived"
  , ASFRC = ASFRC
  , LTCB = LTCB
  , ages_keep = 15:100
  # If you want infant deaths only instead of all-age child deaths
  , max_child_age = 20
)

# 3.1. Merge

od_id_ad <- merge(
  od_id
  , cd_0_20 %>%
    mutate(value = value /1000) %>%
    select(country, cohort = variable, age, cd_0_20 = value)
  , by = c("country", "cohort", "age")
  , all.x = T
) %>%
  arrange(country, cohort, age) %>%
  mutate(
    ad = od - cd_0_20
  )

# 4. Child Deaths (4-12)

# Defined as CD_{0-12} - ID_{0-5}

mas <- c(15:100) # woman ages

cd_0_13 <- child_loss(
  countries = countries
  , reference_years = reference_years
  , path = "../../Data/derived"
  , ASFRC = ASFRC
  , LTCB = LTCB
  , ages_keep = 15:100
  # If you want infant deaths only instead of all-age child deaths
  , max_child_age = 13
)

# 3.1. Merge

od_id_ad_cd <- merge(
  od_id_ad
  , cd_0_13 %>%
    mutate(value = value /1000) %>%
    select(country, cohort = variable, age, cd_0_13 = value)
  , by = c("country", "cohort", "age")
  , all.x = T
) %>%
  arrange(country, cohort, age) %>%
  mutate(
    cd = cd_0_13 - id
  )

# 5. Teenage Deaths (13-19)

# Defined as AD_{0-20} - CD{0-12}

cd_all <-
  od_id_ad_cd %>%
  mutate(td = cd_0_20 - cd_0_13) %>%
  select(country, cohort, age, od, id, ad, cd, td)

# Plot

# cons <- c("niger", "guatemala", "sweden", "malawi")

cd_all %>%
  select(country, cohort, age, od, id, ad) %>%
  group_by(country, cohort, age) %>%
  mutate(cd = cumsum(id + ad)) %>%
  melt(id = c("country", "cohort", "age")) %>%
  # filter(country %in% cons) %>%
  filter(cohort == 1950) %>%
  ggplot(aes(x = age, y = value, group = variable, colour = variable)) +
  geom_line() +
  facet_wrap(country ~ .) +
  theme_bw()

