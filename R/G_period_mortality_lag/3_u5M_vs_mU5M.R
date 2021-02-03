
lagme <- 50
# lagme <- 30

# WPP DATA

wpp <- 
  wpp_period_med %>% 
  filter(!is.na(country)) %>% 
  select(iso = country, year = MidPeriod,mIM = IMR, mu5M = Q5) %>% 
  pivot_longer(-c(iso, year), names_to = "Measure", values_to = "value") %>% 
  filter(year <= 2050) %>%
  mutate(source = paste0("wpp")) 
  

# Mege with KC estimates

kc <- 
  pnas_comp %>% 
  mutate(source = paste0("KC")) %>% 
  select(-Source) %>% 
  bind_rows(wpp) %>% 
  mutate(lagged = "not lagged")

kc_lag <- 
  pnas_comp %>% 
  mutate(year = year - lagme) %>% 
  mutate(source = paste0("KC")) %>% 
  select(-Source) %>% 
  bind_rows(wpp) %>% 
  mutate(lagged = paste0("KC lagged ", lagme, " years")) 

both <-
  bind_rows(kc_lag, kc) %>% 
  mutate(lagged = factor(lagged, levels = c("not lagged", paste0("KC lagged ", lagme, " years"))))

# Plot lag 

# country_keep <- unique(wpp_kc$iso)[5:8]
# country_keep <- sample(unique(wpp_kc$iso), 3)
# country_keep <- c("SWE","USA", "GTM", "ZAF")
country_keep <- c("KOR","JPN")

both %>% 
  filter(iso %in% country_keep) %>% 
  filter(Measure %in% c("mIM")) %>% 
  mutate(
    source =  recode(
      source
      , "KC" = "mIM"
      , "wpp" = "IMR"
      # , "mIM" = "mIM or IMR"
      # , "mu5M" = "mu5M or U5MR"
      )
      ) %>%
  ggplot(aes(x = year, y = value, colour = iso, linetype = source)) +
  geom_line() +
  scale_y_continuous("") +
  facet_wrap(~lagged) +
  theme_bw()

ggsave(paste0("../../Output/lagged_mort_", lagme, ".pdf"))  
