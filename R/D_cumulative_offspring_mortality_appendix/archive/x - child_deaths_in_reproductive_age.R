
# Questions ----

# For the 20-44 measure, do you count child deaths that happened when the mother was 15-19 yo?



# Estimate the cumulative number of child deaths (CCD)
# experienced for women finishing their reproductive life.
# ESG uses the agr groups 20-44 and 45-49

# This means that CD is the mean value of the cumulative number 
# of child death for all mothers currently aged, for example, 45-49 I.e. the sum 
# of all child deaths experienced in the 15-49 period for all 
# women currently aged 45-49
# 	For time frame: 2010-2019

# We can use our data to estimate this directly using the mean value 
# of CD_{c, 20-44} and CD_{c, 45-49}



# Eventually we need to transform these measure from cohort to period
# but I am not sure if I should get the mean values first and the convert
# or the other way around

# 0. Parameters ----

width <- 20
height <- 14

# 1. Cohort to Period ----

# We approximate period values from cohort estimates
# by taking values on the diagonal

# First, reduce size of data, then get period values

years <- 2010:2019
breaks <- c(20, 45, 50)

cd_p <- s1 %>% 
  select(country, cohort, age, child_death) %>% 
  mutate(year = cohort + age) %>% 
  select(country, year, age, child_death) %>% 
  arrange(country, year, age)
  
# 2. Get mean CD value for age gr ----

cm <- cd_p %>% 
  filter(year %in% years) %>% 
  filter(between(age, min(breaks), max(breaks))) %>% 
  # create age groups
  mutate(
    agegr = cut(age, breaks, right = F)
  ) %>% 
  filter(!is.na(agegr)) %>% 
  group_by(country, year, agegr) %>% 
  summarise(
    mean = mean(child_death)
    , sd = sd(child_death)
    , low = mean - 1*sd
    , high = mean + 1*sd
    , median = median(child_death)
  ) %>% 
  ungroup
  
# 3. Export df ----

write.csv(cm, "../../Output/cumulative_child_death.csv", row.names = F)

# 4. Plot for selected countries ----

width <- 20
height <- 14

country_keep <- c("mali", "niger", "cameroon", "zimbabwe")

(
  cm_p <- cm %>% 
  filter(country %in% country_keep) %>% 
  ggplot(aes(x = year, y = mean, colour = country, shape = agegr)) +
  geom_point(
    size = 2.5
    # position=position_jitter(h=0.15,w=0.15)
  ) +
    geom_line() +
  # geom_errorbar(aes(ymin = low, ymax = high), width = 0.2, position=position_jitter(h=0.15,w=0.15) ) +
  scale_x_continuous("Period year", breaks = min(years):max(years)) +
  scale_y_continuous("Cumulative child death (mean)") +
  scale_shape_discrete("Women aged") +
  # facet_grid(.~agegr) +
  theme_bw()
)

ggsave(paste0("../../Output/cumulative_child_death.pdf"), cm_p, width = width, height = height, units = "cm")
