


countries_final <- unique(om$country)

# Prepare survey data ------------

mim20_surv <- 
  mIM %>% 
  filter(iso %in% countries_final) %>% 
  filter(agegr %in% c("[20,45)")) %>% 
  select(country = iso, year, mim20s = bereaved_mothers)

mim45_surv <- 
  mIM %>% 
  filter(iso %in% countries_final) %>% 
  filter(agegr %in% c("[45,50)")) %>% 
  select(country = iso, year, mim45s = bereaved_mothers)


mum20_surv <- 
  mU5M %>% 
  filter(iso %in% countries_final) %>% 
  filter(agegr %in% c("[20,45)")) %>% 
  select(country = iso, year, mum20s = bereaved_mothers)

mum45_surv <- 
  mU5M %>% 
  filter(iso %in% countries_final) %>% 
  filter(agegr %in% c("[45,50)")) %>% 
  select(country = iso, year, mum45s = bereaved_mothers)

mom45_surv <- 
  mOM %>% 
  filter(iso %in% countries_final) %>% 
  filter(agegr %in% c("[45,50)")) %>% 
  select(country = iso, year, mom45s = bereaved_mothers)

# Merge

om_model <- 
  mim20_surv %>% 
  left_join(mim45_surv, by = c("country", "year")) %>% 
  left_join(mum20_surv, by = c("country", "year")) %>% 
  left_join(mum45_surv, by = c("country", "year")) %>% 
  left_join(mom45_surv, by = c("country", "year")) 
  # pivot_longer(-c(country, year), names_to = "variable", values_to = ) 

om_both <- 
  left_join(
    om_survey %>% pivot_wider(names_from = variable)
    , om_model, by = c("country", "year")
  ) %>% 
  pivot_longer(-c(country, year), names_to = "variable") %>% 
  mutate(
    source = ifelse(grepl("s", variable), "survey", "model")
    , variable = gsub("s", "", variable)
  ) 

# Plot ==============

base_size = 15
point_size = 4

om_both %>% 
  rename(iso = country) %>% 
  pivot_wider(names_from = "source") %>% 
  mutate(colour = ifelse(is.na(survey), "1", "2")) %>% 
  ggplot(aes(y = iso)) +
  # Segment: model - survey
  geom_segment(aes(x = `survey`, xend = `model`, yend = iso)) +
  # Survey = circle
  geom_point(aes(x = `survey`), shape = 16, size = point_size) +
  # Model = triangle
  geom_point(aes(x = `model`, colour = colour), shape = 17, size = point_size) +
  facet_wrap(~variable, scales = "free_y") +
  scale_x_continuous("Circle = survey") +
  # Legend by hand
  # geom_text(aes(x = x, y = y, label = label), size = 4, data = leg) +
  # annotate("text", x = 40 + x_adj, y = 7.9 + y_adj, label = "Birth cohort of women",
  #          , hjust = .5, color = "grey20") +
  # geom_point(aes(x = x, y = y, shape = shape), size = point_size, data = po) +
  scale_shape_discrete(guide = F) +
  scale_colour_manual("", breaks = c("1", "2"), values = c("red", "black"), guide = F) +
  coord_cartesian(xlim = c(0, 500)) +
  theme_bw()

ggsave("../../Output/ggs_comparative.pdf")
