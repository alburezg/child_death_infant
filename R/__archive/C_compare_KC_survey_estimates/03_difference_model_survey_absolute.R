
# Compare to Emily's estimates from MICS and DHS
# Produce plot comparing estimates for all countries grouped by region
# including those with and without survey data

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

# 1. Compare for Women ----

prev_women <- 
  compare_measures_bulk(
    measure = "women"
    , export = T
    , regions = regions
    , add_indirect_estimates = add_indirect_estimates
    , surv_df = surv
  )

# merge with weighted estimates

# prev_women <- merge(
#   prev_women 
#   , weighted %>% 
#     filter(denominator == "women") %>% 
#     select(iso, level, model_weighted)
#   , by = c("iso", "level")
#   , all.x = T
# )

# 1.1. Plot women ====

prev_list <- split(prev_women, prev_women$level)

# This saves graphs as pdfs
plots <- lapply(prev_list, plot_comparison, export = T, export_name = "women") 

# 2. Compare for Mothers ----

prev_mothers <- 
  compare_measures_bulk(
    measure = "mothers"
    , export = T
    , regions = regions
    , surv_df = surv
  )

# merge with weighted estimates
# 
# prev_mothers <- merge(
#   prev_mothers 
#   , weighted %>% 
#     filter(denominator == "mothers") %>% 
#     select(iso, level, model_weighted)
#   , by = c("iso", "level")
#   , all.x = T
# )

# 2.1. Plot mothers ====

prev_list <- split(prev_mothers, prev_mothers$level)

# This saves graphs as pdfs
plots <- lapply(
  prev_list
  , FUN = plot_comparison
  , export = T
  , export_name = "mothers"
  , NorthAmerica = F
  # , add_indirect_estimates = add_indirect_estimates
) 

# 3. Plot error rate ----

# Easy way to do this, have a line plot showing the mean difference by measure 
# for women and mothers separately

levs <- c("mOM_45-49",  "mU5M_20-44", "mU5M_45-49", "mIM_20-44",  "mIM_45-49")

prevalence <- bind_rows(
  prev_women %>% mutate(denominator = "women")
  , prev_mothers %>% mutate(denominator = "mothers")
)

# DEPRECATED ====
# # 3.1. Plot absolute error 
# 
# (
#   p_error <- 
#     prevalence %>% 
#     # Since there is no survey observatios for NA
#     filter(!region %in% "North America") %>% 
#     # mutate(level = factor(level, levels = levs)) %>% 
#     group_by(region, measure, ages, denominator) %>%
#     dplyr::summarise(
#       abs = median(model - survey, na.rm = T)
#       , share = abs/median(survey)
#     ) %>%
#     ungroup %>%  
#     ggplot(aes(x = denominator, y = abs)) +
#     geom_col(aes(fill = region), position = position_dodge(), colour = "black") +
#     facet_grid(ages ~ measure) +
#     scale_y_continuous("Median difference between model and survey estimates") +
#     scale_x_discrete("Denominator") +
#     coord_cartesian(ylim = c(-75, 100)) +
#     # geom_hline(yintercept = 1) +
#     theme_bw()
# )
# 
# ggsave("../../Output/measures_error.pdf", p_error, width = 12, height = 10)
