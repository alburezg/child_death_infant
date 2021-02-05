
# rcode 5lkjgoi

# 1. Get estimates ----------

mOM_mid <- offspring_death_prevalence(
  k_value = "0_100" # age ranges for child death
  # , file_name = "mOM" # For exporting, file_name = NA # For exporting
  , file_name = NA # For exporting
  , years = years
  , breaks = breaks
  , reprod_age = reprod_age
  , abs_df_all = abs_df
  , ASFRC
  , LTCF 
  , method = "mid-interval"
)

mOM_mean <- offspring_death_prevalence(
  k_value = "0_100" # age ranges for child death
  # , file_name = "mOM" # For exporting, file_name = NA # For exporting
  , file_name = NA # For exporting
  , years = years
  , breaks = breaks
  , reprod_age = reprod_age
  , abs_df_all = abs_df
  , ASFRC
  , LTCF 
  , method = "mean"
)

mOM_median <- offspring_death_prevalence(
  k_value = "0_100" # age ranges for child death
  # , file_name = "mOM" # For exporting, file_name = NA # For exporting
  , file_name = NA # For exporting
  , years = years
  , breaks = breaks
  , reprod_age = reprod_age
  , abs_df_all = abs_df
  , ASFRC
  , LTCF 
  , method = "median"
)

# Compare -----------

mom_all <- 
  mOM_mid %>% 
  select(iso, year, agegr, mid = bereaved_mothers) %>% 
  left_join(
    mOM_mean %>% 
      select(iso, year, agegr, mean = bereaved_mothers)
    , by = c("iso", "year", "agegr")
  ) %>% 
  left_join(
    mOM_median %>% 
      select(iso, year, agegr, median = bereaved_mothers)
    , by = c("iso", "year", "agegr")
  ) %>% 
  left_join(regions, by = "iso") %>% 
  mutate(region = trimws(region)) %>% 
  select(iso, country, region, everything())


# Mean absolute difference ==========

library(knitr)

diff_df <- 
  mom_all %>% 
    filter(!grepl("EXCLUDED", region)) %>% 
    filter(!is.na(region)) %>% 
    group_by(region, agegr) %>% 
    # group_by(iso, region) %>% 
    summarise(
      mean_abs_diff = round(mean(abs(mean - mid)), 1)
      # mean_mid = round(mean(mean - mid), 1)
      # , mean_median = round(mean(mean - median), 1)
      # , median_mid = round(mean(median - mid), 1)
    ) %>% 
    ungroup() %>% 
  pivot_wider(names_from = agegr, values_from = mean_abs_diff)

diff_df %>% kable()
  
  
diff_df %>% 
    ggplot(aes(x = iso, y = median_mid)) + 
    geom_col() +
    facet_wrap(.~region)
  
  
#  Plot  ===========
    
    set.seed(42)
    country_keep <- sample(unique(mom_all$iso), 10)
    
    mom_all %>% 
      filter(iso %in% country_keep) %>% 
      pivot_longer(mid:mean) %>% 
      ggplot(aes(x = year, y = value, linetype = name, colour = iso)) +
      geom_line() +
      facet_wrap(.~agegr) +
      theme_bw()
    
    mom_all %>% 
      filter(iso %in% country_keep) %>% 
      pivot_longer(mid:mean) %>% 
      ggplot(aes(x = year, y = value, linetype = name, colour = agegr)) +
      geom_line() +
      facet_wrap(.~iso, scales = "free") +
      theme_bw()