
# Backgorund

# Strictly speaking, these estimates do not refer to mothers, 
# since the input UN WPP demographic rates do not report the
# fraction of women who are mothers. We rescale our estimates
# using a similar life table approach where we consider fertility 
# as a “hazard rate” to approximate the number of women that 
# “survive” having children (i.e. remain childless) after experiencing 
# a set of age-specific fertility rates. The fraction of women
# who have ever been mothers [FAM]_((a,c,p)) is approximated 
# as 1 minus the fraction of childless women. 

# The problem:
  
# It is unclear whether this rough estimate actually corresponds 
# to levels of childlessness since little data is avaiable. 

# The solution:

# A - Compare against cohort childlessness in HFD data
# https://www.humanfertility.org/cgi-bin/main.php

# B - check how different the values are for a few  countries
# in HFD where we have both standard age specific fertility 
# rates and ASFR for parity 0 only. 

# C - Check with estimates of never been mothers from Emily. 

# Need to double-check, but I assume  that '.' in the Excel sheet means NA and not 0
# as it is interpreted in R 
cch[cch == 0] <- NA

# A. HFD Cohort childessness ~~~~ ----


# 1. Hfd childlessness ====

# From documentation:
# Cohort childlessness is calculated at the highest age 
# for which data are available, but not lower than 44.

# Keep only relevant countries
cons <- countrycode(unique(names(cch)[-1]) , origin = "country.name", "iso3c", warn = F)

# Ignore sub-national estimates in UK:
#  "England and Wales" "Northern Ireland" "Scotland"

cons_full <- na.omit(cons)
cons_full <- cons_full[cons_full!="DEU"]

childless_hfd_w <- cch[ , c(T, !is.na(cons)) ]
# Ignore Germany
childless_hfd_w$`Germany West` <- childless_hfd_w$Germany <- NULL
names(childless_hfd_w) <- c("cohort", cons_full)

childless_hfd <- pivot_longer(childless_hfd_w, cols = AUT:USA) %>% 
  select(cohort, iso = name, hfd = value)

# 2. Model childlessness ====

age_to_observe_childlessness <- 45

old_model <- unique(ASFRC$country)
new_model <-  countrycode(old_model, origin = "country.name", "iso3c", warn = F)

women_are_mothers <- 
  ASFRC %>% 
  filter(between(Cohort, 1950, 2000)) %>% 
  mutate(
    asfr = ASFR/1000
    , iso = plyr::mapvalues(country, old_model, new_model)
    ) %>% 
  filter(iso %in% cons_full) %>% 
  select(cohort = Cohort, iso, age = Age, asfr) %>% 
  group_by(cohort, iso) %>% 
  mutate(
    # Create probability of exiting poulation of 
    # childless women asnqx = 1 - e^(-h*n)
    nqx = 1 - exp(-asfr)
    , lx =  qx2lx(nqx = nqx, radix = 1)
    , share_of_women_are_mothers = 1 - lx
  ) %>% 
  ungroup %>% 
  select(-lx)

childless_model <- 
  women_are_mothers %>% 
  mutate(model = (1 - share_of_women_are_mothers) * 100) %>% 
  filter(age == age_to_observe_childlessness) %>% 
  select(cohort, iso, model)

# Merge model and hfd data

model_hfd <- merge(
  childless_hfd
  , childless_model
  , by = c("cohort", "iso")
) %>% 
  na.omit()

# 3. Graphic comparisson ====

# Plot diferences

# Estonia is way off the carths for some reason
ignore <- c("EST", "LTU")
# keep <- c("SWE", "RUS")

diff_df <- 
  model_hfd %>% 
  filter(!iso %in% ignore) %>% 
  # filter(iso %in% keep) %>% 
  mutate(
    diff = hfd - model
    , diff_abs = abs(diff)
    # Estimate deviation as share of value
    , dev = diff/hfd
  )

# Determine which country is low or high
# error for plotting
low_high <- 
  diff_df %>% 
  group_by(iso) %>% 
  summarise(
    dev_gr = ifelse(mean(diff_abs) < 4, "low", "high")
    # , dev_gr = ifelse(max(diff_abs) < 6, "low", "high")
  ) %>% 
  ungroup
  
df_group <- merge(
  diff_df
  , low_high
  , by = "iso"
  ) 

(
  p_childless_times <- 
df_group %>% 
  ggplot(aes(x = cohort, y = dev, colour = iso)) +
  geom_line() +
  geom_hline(yintercept = 0) +
  facet_wrap(~dev_gr, scales = "free_y") +
  theme_bw(base_size = 24)
)

ggsave(
  paste0("../../Output/childless_times.pdf")
  , p_childless_times
  , width = 18
  , height = 14
)

# MSE error ====

# Terrible

model_hfd %>% 
  filter(!iso %in% ignore) %>% 
  group_by(cohort) %>% 
  summarise(
    mse = mean((hfd - model)^2)
  ) %>% 
  ggplot(aes(x = cohort, y = mse, group = 1)) +
  geom_line()
