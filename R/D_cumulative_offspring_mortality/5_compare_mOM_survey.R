
# Compare to Emily's estimates from MICS and DHS

# Issues ----

# - GNQ and GNB don;t have a year assinged in the survy estimates

# 0. Parameters ----

year_for_missing_countries <- 2018

# 1. Format country names data ----

surv2 <- 
  surv %>% 
  mutate(
    iso = countrycode(country, origin = "country.name", "iso3c")
    , region = trimws(region) 
    ) %>% 
  rename(survey = mOM45_49)
  

surv2[surv2 == ""] <- NA

old <- unique(mOM$country)
new <- countrycode(old, origin = "country.name", "iso3c")

mOM2 <- 
  mOM %>% 
  mutate(iso = plyr::mapvalues(mOM$country, from = old, to = new)) %>% 
  filter(agegr == "[45,50)") %>% 
  select(iso, year, model = bereaved_mothers)

# 2. Merge single-year estimates ----

joint_single <- merge(
  surv2 %>% 
    filter(!is.na(year)) %>% 
    filter(!grepl("-", year)) %>% 
    select(iso, region, year, source, survey)
  , mOM2
  , by = c("iso", "year")
) %>% 
  mutate(year = as.numeric(year))

# 3. Get values for NA ----

surv_na <- surv2 %>% 
  filter(is.na(year)) %>% 
  filter(is.na(survey)) %>% 
  mutate(
    year = year_for_missing_countries
    # , source = "Model"
    ) %>% 
  select(iso, year, region, source, survey)

# Merge

joint_na <- merge(
  surv_na 
  , mOM2
  , by = c("iso", "year")
)

# 4. Get averages for compund years ----

# Determine which estimates in the survey data are not for
# single years but for year intervals

surv_int <- 
  surv2 %>% 
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

moM_int_means <- 
  mOM2 %>% 
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
  surv_int %>% select(iso, year, region, source, survey)
  , moM_int_means
  , by = c("iso", "year")
) %>% 
  mutate(
    year_real = year
    , year = surv_int$year_low
  )

# 5. Plot ----

joint_mOM <- bind_rows(
  joint_single, joint_na, joint_int
) %>% 
  arrange(iso, year)

base_size <- 15
point_size <- 4
point_inset <- 3

reg_exclude <- "COUNTRIES EXCLUDED (islands/very small territories/populations)"

leg <- data.frame(
  x = c(500, 500)
  , y = c(1,1.25)
  , label = c("Model", "Survey")
  , region = "North America"
)

po <- data.frame(
  x = 435
  , y = c(1,1.25)
  # , shape = c(17, 16)
  , shape = c("triangle", "circle")
  , region = "North America"
)

mOM_45_49_p <- 
joint_mOM %>% 
  # filter(!is.na(survey)) %>% 
  filter(!is.na(iso)) %>%
  filter(!region %in% reg_exclude) %>% 
  select(-year_real) %>% 
  ggplot(aes(y = iso)) +
  geom_segment(aes(x = `survey`, xend = `model`, yend = iso)) +
  # Survey = circle
  geom_point(aes(x = `survey`), shape = 16, size = point_size) +
  # Model = triangle
  geom_point(aes(x = `model`), shape = 17, size = point_size) +
  facet_wrap(~region, scales = "free_y") +
  scale_x_continuous("mOM 40-49") +
  # Legend by hand
  geom_text(aes(x = x, y = y, label = label), size = 4, data = leg) +
  # annotate("text", x = 40 + x_adj, y = 7.9 + y_adj, label = "Birth cohort of women",
  #          , hjust = .5, color = "grey20") +
  geom_point(aes(x = x, y = y, shape = shape), size = point_size, data = po) +
  scale_shape_discrete(guide = F) +
  theme_bw(base_size = base_size) 

mOM_45_49_p

ggsave(
  "../../Output/mOM_45_59_comparative.pdf"
  , mOM_45_49_p
  , width = 18
  , height = 14
  )
