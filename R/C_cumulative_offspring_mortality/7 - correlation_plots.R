
# Correlation plot 

# 1. Reshape data ====

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

# clustering

cl_df <- 
  surv_ci %>% 
  mutate(clustering = ntile(mrom45, 10)) %>% 
  select(country, mrom45)
    
# COnsolidate 

corr_df1 <- merge(m, s, by = c("country", "variable"))

corr_df <- merge(corr_df1, cl_df, by = "country", all.x = T)

# 2. Plot  ----

# 2.1. All together ====

vars_keep <- c("mim20", "mim45", "mum20", "mum45", "mom45")

corr_df %>% 
  filter(!is.na(survey)) %>% 
  filter(variable %in% vars_keep) %>% 
  # Temporary as Colombia and Dominican Republic appear to have too 
  # large values for wim20 (seems like it’s just a rounding problem). 
  filter(survey < 1000) %>%
  # For plotting in grid
  mutate(
    age = gsub("[a-z]", "", variable)
    , age = paste0(age, "-", ifelse(age == 20, 44, 49), " yr-old mothers")
    , mes = gsub("[0-9]", "", variable)
    , mes = recode(mes, mim = "mIM", mum = "mU5M", mom = "mOM")
  ) %>% 
  ggplot() +
  # geom_point(aes(x = survey, y = model, colour = mrom45)) +
  geom_point(aes(x = survey, y = model)) +
  geom_abline(intercept = 0) +
  scale_colour_continuous(high = "#132B43", low = "#56B1F7") +
  # facet_wrap( . ~ variable) +
  facet_grid(age ~ mes) +
  theme_bw(base_size = 16)

ggsave("../../Output/correlations.pdf", width = 9, height = 7)
