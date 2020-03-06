
# 0. Parameters ----

# Since this should follow Emily's PNAS paper, restrict to SSA countries she used in that
# analysis
# Also, comparisson should be done for women

# Countries considered by Emily:
iso_keep <- countrycode::countrycode(
  c("Benin", "Burkina Faso", "Cameroon", "Ivory Coast"
    , "Ghana", "Kenya", "Liberia", "Madagascar", "Malawi"
    , "Mali" , "Namibia", "Niger", "Nigeria", "Rwanda"
    , "Senegal", "Tanzania", "Togo", "Uganda", "Zambia", "Zimbabwe"
  ) , origin = "country.name", "iso3c")

# 1. mOM45-49 ----

# redo this, but with new year ranges

years <- 1950:2100
breaks <- c(20, 45, 50)
reprod_age <- c(15,50)

years_plot <- 1984:2020

# 1. mOM ~~~~ ----

mOM_pnas <- offspring_death_prevalence(
  k_value = "0_100" # age ranges for child death
  , file_name = NA # For exporting
  , years = years
  , breaks = breaks
  , reprod_age = reprod_age
  , abs_df_all
  , ASFRC
  , LTCF 
)

# 2 mU5M ~~~~ ----

mU5M_pnas <- offspring_death_prevalence(
  k_value = "0_5" # age ranges for child death
  # , file_name = "mU5M" # For exporting
  , file_name = NA # For exporting
  , years = years
  , breaks = breaks
  , reprod_age = reprod_age
  , abs_df_all
  , ASFRC
  , LTCF 
)

# 3. mIM ~~~~ ----

mIM_pnas <- offspring_death_prevalence(
  k_value = "0_1" # age ranges for child death
  # , file_name = "mIM" # For exporting
  , file_name = NA # For exporting
  , years = years
  , breaks = breaks
  , reprod_age = reprod_age
  , abs_df_all
  , ASFRC
  , LTCF 
)


pnas_comp <- 
  bind_rows(
    mOM_pnas %>% mutate(Measure = "mOM")
    , mU5M_pnas %>% mutate(Measure = "mu5M")
    , mIM_pnas %>% mutate(Measure = "mIM")
  ) %>% 
  filter(agegr == "[45,50)") %>% 
  select(iso, year, Measure, value = bereaved_mothers) %>% 
  mutate(Source = "KC model")

# Add survey data as points

surv_pnas <- 
  surv %>% 
  filter(measure == "mothers") %>% 
  select(iso, year, mOM = mom45, mIM = mim45, mu5M = mum45) %>% 
  reshape2::melt(id = c("iso", 'year')) %>% 
  rename(Measure = variable) %>% 
  mutate(Source = "Survey")

# 1. 3. Plot

p_pnas <-
  pnas_comp %>% 
  filter(year %in% years_plot) %>% 
  filter(iso %in% iso_keep) %>% 
  ggplot(aes(x = year, y = value, colour = Measure)) + 
  geom_line() +
  geom_point(aes(x = year, y = value, shape = Source), data = surv_pnas) +
  facet_wrap( . ~ iso)+
  theme_bw() +
  coord_cartesian(ylim = c(0, 1000)) +
  theme(legend.position = "bottom") +
  ggtitle("")

ggsave(
   "../../Output/pnas_comparative.pdf"
   , p_pnas
  , width = 18
  , height = 14
)

# 2. Plot for all periods ----

# 2.1. PNAS style


p_full <-
  pnas_comp %>% 
  ggplot(aes(x = year, y = value, colour = Measure)) + 
  geom_line() +
  geom_point(aes(x = year, y = value, shape = Source), data = surv_pnas) +
  facet_wrap( . ~ iso)+
  scale_x_continuous(breaks = c(2000, 2025, 2050)) +
  theme_bw() +
  coord_cartesian(ylim = c(0, 1000)) +
  theme(legend.position = "bottom")

ggsave(
  "../../Output/pnas_comparative_full.pdf"
  , p_full
  , width = 18
  , height = 14
)

# 2.2. All countries mashed together

(
  p_mashed <-
  merge(
    pnas_comp
    , regions %>% select(iso, region)
    , by = "iso"
    , all.x = T
    , all.y = F
  ) %>% 
  ggplot(aes(x = year, y = value, colour = Measure)) + 
  # geom_line(aes(group = Measure), alpha = 0.3) +
  geom_smooth(aes(group = Measure), se = F) +
  facet_wrap( . ~ region)+
  scale_x_continuous(breaks = c(2000, 2025, 2050)) +
  theme_bw() +
  coord_cartesian(ylim = c(0, 1000)) +
  theme(legend.position = "bottom")
)

ggsave(
  "../../Output/pnas_comparative_mashed.pdf"
  , p_mashed
  , width = 18
  , height = 14
)
