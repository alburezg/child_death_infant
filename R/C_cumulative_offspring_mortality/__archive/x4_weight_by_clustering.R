
# Status 20200221
# - the weighted model estimates are not better
# than the unweighted ones. 




# Attempt to improve model estimates by accounting for heterogeneity of
# child death.
# Reasons why our estimates may be higher than Emily’s
# -	Given heterogeneity, a small number of women might experience more child death, 
# ie if you experience the death of a child, you are also more likely to experience 
# the death of another child
# -	Our models assume no heterogeneity in the experience of child death. Our mean 
# measure assigns deaths to women that are (in the real world) less likely to actually 
# experience child death
# Correcting over-estimation
# -	For countries for which we have surveys, the basic idea is to run a regression to 
# correct for the bias using some sort of indicator from the ‘real world’
# -	One alternative is to use a measure of clustering of child death from the surveys
# o	One option is sort of gini coefficient
# o	Another would be to look at #child_deaths/#children_ever_born and from this, 
# compute the gini, SD, or the coefficient of variation (ratio of the standard deviation to the mean)

# -	Regression would be 
# o	diff(model, survey) ~ B*clustering, where there is a value for each country/age-group combination; or alternatively
# o	diff(model, survey) ~ B*clustering + B*age_gr, where age_gr is a dummy variable for age

# provisionally, we have 'mrom45' - the % of women/mothesr aged 45-50 who ever experienced more
# than one offspring death 

# 0. Parameters ====

# agr_keep <- "45-49"
agr_keep <- c("20-44","45-49")
year_for_missing_countries <- 2016

# 1. Get df to compare ====

# With model and survey side-by-side and a column for
# clustering of deaths, proxied by share of women/mothers
# have experienced more than 2 child deaths

diff_w <- 
  compare_measures_bulk(
    measure = "women"
    , export = F
  ) %>% 
  select(iso, year, region, ages, survey, model, level, measure, ages) %>% 
  mutate(denominator = "women")

diff_m <- 
  compare_measures_bulk(
    measure = "mothers"
    , export = F
  ) %>% 
  select(iso, year, region, ages, survey, model, level, measure, ages) %>% 
  mutate(denominator = "mothers")
  
# 1.1. get clustering values ====

diff_df <- merge(
  bind_rows(diff_m, diff_w) %>% filter(ages %in% agr_keep)
  , surv %>% select(iso, denominator = measure, mrom45) 
  , by = c("iso", "denominator")
) %>% mutate(
  mrom45 = mrom45
  # , diff = model - survey
  , diff = survey - model
  , diff_abs = abs(survey - model)
  ) 

# 1.2. Get TFR and e0 ====

# For all country and year combinations, get correspondent period rates

# Since I'm taking this from the WPP data, they are groupd by 5-year perdios
# Easiest thing is to get the UN estimate that falls within the period for eACH SURVEY

comparison <- 
  merge(
    diff_df %>% 
      # See in which UN WPP period the survey years would fit:
      mutate(period = cut(year, breaks = seq(1950, 2100, 5), labels = unique(rates$period), right = F))
    , rates
    , by = c("iso", "period")
  ) %>% 
  select(-period)


# 2. Regression ====

# Provisionally, we only have clustering values for 45-50, so
# the analysis will pertain to the estimates for these ages only

# Since these are DHS data (where there is data onclustering), the mdoel should be:
# diff(model, survey) ~ B*clustering, where there is a value for each country/age-group combination; or alternatively

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Summary:
# It seems like Africa benefits more from the correction, especially for
# mu5m and mom, but not for mim!
# Estimates of mim are generally quite accurate
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Question ----
# Option 1: four incremental models:
# model ~ mrom45
# model ~ mrom45 + region
# model ~ mrom45 + region + level
# model ~ mrom45 + region + level + measure

# Option 2: and the same but with diff as the regressor, like:
# diff ~ mrom45 + region

# I think option 1 makes more sense since it doesn't rely on 
# the estimated value of child loss from the surveys, but instead
# corrects for clustering only (using mrom 45 but not the survey estimate)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# All four incremental model of option 1 together
# using the entire database. 
# After some consideration, maybe mothers and women should be modelled separately
# since they have differnt denominators


# 2.1. Women and mothers ====

l <- split(comparison, list(comparison$denominator, comparison$level, comparison$region))

estimates <- data.frame(do.call(rbind, 
                                lapply(l, function(d) {
                                  d %>% 
                                    mutate(
                                      mod1 = predict(lm(model ~ mrom45, data = .))
                                      , mod2 = predict(lm(diff ~ mrom45, data = .))
                                      , mod2 = model - mod2
                                      # , mod3 = predict(lm(model ~ mrom45 + region + level, data = .))
                                      , diff1 =  survey - mod1
                                      # , diff2 =  survey - mod2
                                      # , diff3 =  survey - mod3
                                      , improved1 = abs(diff1) < abs(diff)
                                      # , improved2 = abs(diff2) < abs(diff)
                                      # , improved3 = abs(diff3) < abs(diff)
                                    ) %>% 
                                    select(iso, denominator, measure, ages, level, region, model, survey, starts_with("mod"), starts_with("diff"), starts_with("improved"))
                                })
))


# Evaluate improvement in fit
# Share of countries where fit improved by model type

estimates %>% 
  # group_by(region, denominator) %>% 
  group_by(region, level) %>% 
  summarise(
    imp1 = sum(improved1) / n() * 100
    # , imp2 = sum(improved2) / n() * 100
    # , imp3 = sum(improved3) / n() * 100
  ) %>% 
  data.frame


estimates %>% 
  # group_by(region, denominator) %>% 
  group_by(region, level) %>% 
  summarise(
    diff_original = mean(abs(diff))
    , diff1 = mean(abs(diff1))
    # , diff2 = mean(abs(diff2))
    # , diff3 = mean(abs(diff3))
  ) 



# 3. Save as df ====

# Save as df for comparisson

weighted <- estimates %>% 
  select(iso, denominator, measure, ages, level, model_weighted = mod1)

# Archive ====

# # DEPRECATED

# # 2.1. Women and mothers
# 
# l <- split(comparison, list(comparison$denominator))
# 
# estimates <- data.frame(do.call(rbind,
#                                 lapply(l, function(d) {
#                                   d %>%
#                                     mutate(
#                                       mod1 = predict(lm(model ~ mrom45, data = .))
#                                       , mod2 = predict(lm(model ~ mrom45 + region, data = .))
#                                       , mod3 = predict(lm(model ~ mrom45 + region + level, data = .))
#                                       , diff1 =  survey - mod1
#                                       , diff2 =  survey - mod2
#                                       , diff3 =  survey - mod3
#                                       , improved1 = abs(diff1) < abs(diff)
#                                       , improved2 = abs(diff2) < abs(diff)
#                                       , improved3 = abs(diff3) < abs(diff)
#                                     ) %>%
#                                     select(iso, denominator, measure, ages, level, region, model, survey, starts_with("mod"), starts_with("diff"), starts_with("improved"))
#                                 })
# ))
# 
# 
# # Evaluate improvement in fit
# # Share of countries where fit improved by model type
# 
# estimates %>% 
#   # group_by(region, denominator) %>% 
#   group_by(region, level) %>% 
#   summarise(
#     imp1 = sum(improved1) / n() * 100
#     , imp2 = sum(improved2) / n() * 100
#     , imp3 = sum(improved3) / n() * 100
#   ) 
# 
# # Mean aboslute difference by model type
# 
# estimates %>% 
#   # group_by(region, denominator) %>% 
#   group_by(region, level) %>% 
#   summarise(
#     diff_original = mean(abs(diff))
#     , diff1 = mean(abs(diff1))
#     , diff2 = mean(abs(diff2))
#     , diff3 = mean(abs(diff3))
#   ) 
