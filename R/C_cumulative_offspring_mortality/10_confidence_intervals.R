
# Test for mim20

surv_ci %>% 
  select(country, starts_with("mim20"), ends_with("95_mim20")) %>%
  dplyr::rename(survey = mim20, model = mim20kc, low = lb95_mim20, high = ub95_mim20) %>%
  filter(!is.na(survey)) %>% 
  ggplot() +
  geom_point(aes(x = country, y = survey)) +
  geom_point(aes(x = country, y = model), colour = "red") +
  geom_errorbar(aes(x = country, ymin = low, ymax = high)) +
  theme_bw()


# Correlation plot =====

surv_ci %>% 
  select(country, starts_with("mim20")) %>%
  dplyr::rename(survey = mim20, model = mim20kc) %>%
  filter(!is.na(survey)) %>% 
  ggplot() +
  geom_point(aes(x = survey, y = model)) +
  geom_abline(intercept = 0) +
  theme_bw()

# 

m <-
  surv_ci %>% 
  select(country, ends_with("kc")) %>% 
  pivot_longer(-country, names_to = "variable", values_to = "model") %>% 
  mutate(
    variable = gsub("kc", "", variable)
    # , source = "model"
    )

vars <- unique(m$variable)
  
s <- 
  surv_ci[, c("country", vars)] %>% 
  pivot_longer(-c(country), names_to = "variable", values_to = "survey") 
  # mutate(source = "survey")

# clustering

cl_df <- 
  surv_ci %>% 
  mutate(clustering = ntile(mrom45, 10)) %>% 
  select(country, mrom45)
    
# COnsolidate 

corr_df1 <- merge(m, s, by = c("country", "variable"))

corr_df <- merge(corr_df1, cl_df, by = "country", all.x = T)

corr_df %>% 
  filter(!is.na(survey)) %>% 
  # Temporary as Colombia and Dominican Republic appear to have too 
  # large values for wim20 (seems like it’s just a rounding problem). 
  filter(survey < 1000) %>% 
  ggplot() +
  geom_point(aes(x = survey, y = model, colour = mrom45)) +
  geom_abline(intercept = 0) +
  facet_wrap( . ~ variable) +
  theme_bw()

ggsave("../../Output/correlations.pdf", width = 9, height = 7)
