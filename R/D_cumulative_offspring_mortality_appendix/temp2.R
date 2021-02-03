
compare_measures_5y <- function(year_for_missing_countries = 2016, surv_measure_keep = c("mOM4549"), model_agegr_keep = c("[45,50)"), measure, model_df, surv_df, regions) {
  # browser()
  model_measure_keep <- paste0("bereaved_", measure)
  
  # For adding indirect estimates later if needed
  surv_copy <- surv_df
  # 1. Format country names data 
  
  surv_df <- surv_df[surv_df$measure == measure, ]
  
  matches <- match(surv_measure_keep, names(surv_df))
  
  if(is.na(matches)){
    surv_df$survey <- NA
  } else {
    surv_df$survey <- surv_df[ , matches]
  }
  
  surv_df[surv_df == ""] <- NA
  
  model_df$model <- unlist(model_df[, match(model_measure_keep, names(model_df))])
  
  model_df <- 
    model_df  %>% 
    filter(agegr %in% model_agegr_keep) %>% 
    select(iso, year, model)
  
  # 2. Merge single-year estimates 
  
  joint_single <- merge(
    model_df
    , surv_df %>% 
      filter(!is.na(year)) %>% 
      filter(!grepl("-", year)) %>% 
      select(iso, region, year, survey)
    , by = c("iso", "year")
    , all.x = F
  ) %>% 
    mutate(year = as.numeric(year))
  
  # 3. Get values for NA 
  
  surv_na <- surv_df %>% 
    filter(is.na(year)) %>% 
    filter(is.na(survey)) %>% 
    mutate(
      year = year_for_missing_countries
    ) %>% 
    select(iso, year, region, survey)
  
  # Merge
  
  joint_na <- merge(
    model_df
    , surv_na 
    , by = c("iso", "year")
    , all.x = F
  )
  
  # 4. Get averages for compund years 
  
  # Determine which estimates in the survey data are not for
  # single years but for year intervals
  
  surv_int <- 
    surv_df %>% 
    filter(grepl("-", year)) %>% 
    mutate(
      year_low = as.numeric(gsub("-[0-9]{2}$", "", year))
      , year_high = as.numeric(paste0(20, gsub("^[0-9]{4}-", "", year)))
    ) %>% 
    arrange(iso, year)
  
  ids <- 
    surv_int %>% 
    select(iso, year_low, year_high) %>% 
    reshape2::melt(id = "iso") %>% 
    arrange(iso) %>% 
    mutate(id = paste0(iso, value)) %>% 
    pull(id)
  
  model_df_int_means <- 
    model_df %>% 
    mutate(id = paste0(iso, year)) %>% 
    filter(id %in% ids) %>% 
    select(-id) %>% 
    # get interval mean
    group_by(iso) %>% 
    summarise(model = mean(model)) %>% 
    ungroup %>% 
    arrange(iso) %>% 
    mutate(
      year = surv_int$year
    )
  
  # Merge
  
  joint_int <- merge(
    model_df_int_means
    , surv_int %>% select(iso, year, region, survey)
    , by = c("iso", "year")
    , all.x = F
  ) %>% 
    mutate(
      year_real = year
      , year = surv_int$year_low
    )
  
  joint_survey_model <- bind_rows(
    joint_single, joint_na, joint_int
  ) %>% 
    arrange(iso, year)
  
  # 5. Add countries missing from survey estimates
  # but present in model estimates
  
  # Keep rlevant countries
  reg <- regions 
  # filter(!grepl('COUNTRIES EXCLUDED', region) ) 
  
  missing_iso <- reg$iso[! reg$iso %in% joint_survey_model$iso]
  
  new_rows <- model_df %>% 
    filter(year == year_for_missing_countries) %>% 
    filter(iso %in% missing_iso) %>% 
    mutate(
      survey = NA
      , year_real = NA
    ) %>% 
    merge(., reg, by = "iso", all.x = F, all.y = F) %>% 
    select(iso, year, model, region, survey, year_real) 
  
  # 6. For plot
  
  joint_survey_out <- bind_rows(
    joint_survey_model, new_rows
  ) %>% 
    arrange(iso, year)
  
  return(joint_survey_out)
  
}
