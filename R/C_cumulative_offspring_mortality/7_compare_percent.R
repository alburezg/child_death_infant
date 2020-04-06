
# 1. mOM45-49 ----

# For PDR paper, within which % of the survey results are the model results
# at the only age where they are comparable (45-49)?

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

pnas <- 
  prev_women %>% 
  filter(level == "mOM_45-49") %>% 
  select(iso, model, survey) %>% 
  na.omit() %>% 
  mutate(
    diff = (survey - model) / survey * 100
    , abs = abs(diff)
  )

# 2. Median difference as share of survey estimates:

pnas  %>%   
  filter(iso %in% iso_keep) %>% 
  summarise(median(abs))

# 3. Plot for PNAS regioncountries

pnas %>% 
  filter(iso %in% iso_keep) %>%
  arrange(desc(diff)) %>% 
  mutate(iso = factor(iso, levels = iso)) %>% 
  ggplot(aes(x = iso, y = diff)) + 
  geom_col() +
  # facet_grid(~region) +
  theme_bw()

ggsave(
  "../../Output/pnas_percent_difference.pdf"
  , width = 9
  , height = 7
)

# 4. Plot_for all countries

  merge(
    pnas
    , regions %>% select(iso, region)
    , by = "iso"
    , all.x = T
    , all.y = F
  ) %>% 
  arrange(desc(diff)) %>% 
  mutate(iso = factor(iso, levels = iso)) %>% 
  ggplot(aes(x = iso, y = diff)) + 
  geom_col() +
  facet_wrap(~region) +
  theme_bw()

# ggsave(
#   "../../Output/pnas_percent_difference_all.pdf"
#   , width = 9
#   , height = 7
# )