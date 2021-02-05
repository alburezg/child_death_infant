# 5. Export for Emily ------------

regions <- read.csv("../../Data/emily/regions.csv", stringsAsFactors = F)

# Get survey data
surv_df <-
  bind_rows(
    read.csv("../../Data/emily/20200214_women.csv", stringsAsFactors = F) %>%
      mutate(measure = "women")
    , read.csv("../../Data/emily/20200214_mothers.csv", stringsAsFactors = F) %>%
      mutate(measure = "mothers")
    # If indirect estimates showuld be included, unomment this line
    , read.csv("../../Data/emily/20200214_mothers_indirect.csv", stringsAsFactors = F) %>%
      mutate(measure = "mothers_indirect")
  ) %>%
  get_regions_iso(., regions) %>%
  arrange(measure, country) %>%
  filter(!is.na(year)) %>%
  filter(!grepl("-", year)) %>%
  # select(iso, year) %>%
  data.frame()



model_df <-
  bind_rows(
    mOM_5y %>%
      select(iso, country, year, agegr, value = bereaved_mothers) %>%
      mutate(type = "mom")
    , mU5M_5y %>%
      select(iso, country, year, agegr, value = bereaved_mothers) %>%
      mutate(type = "mum")
    , mIM_5y %>%
    select(iso, country, year, agegr, value = bereaved_mothers) %>%
    mutate(type = "mim")
) %>%
  # left_join(
  #   surv_df, by = c("iso", "year")
  # ) %>%
  mutate(
    age_low = gsub(",[0-9]+)$","", gsub("\\[", "", agegr))
    , var = paste0(type, age_low, "kc")
  )

# Merge with survey data -----------

year_for_missing_countries <- 2016

# add_indirect_estimates <- T

mOM4549 <- compare_measures(
  year_for_missing_countries = 2016
  , surv_measure_keep = c("mom45")
  , model_agegr_keep = c("[45,50)")
  , measure = "women"
  , model_df = mOM_5y
  , surv_df = surv_df
  , regions = regions
  , add_indirect_estimates = T
)

