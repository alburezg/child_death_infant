# ! For papaer: by region ====================


# I've been muddling over this temporal question, and love the graph you created to 
# overlay the PNAS estimates with the Kin-Cohort ones. How easy would it be to create 
# similar graphs, but place all countries in the same plot, and generate for separate 
# indicators? So, this would be five graphs total (two age groups mIM, two age groups 
# mU5M, and mOM). If you could graph country estimates over whatever time span you 
# think appropriate (1950-2100?), and also include a line marker for the cross-sectional 
# estimates we present in the figures and appendix, this would allow us to not only offer 
# the snapshot of what things look like now, but what they looked like, and how long it is 
# estimated to take them to look far different than they look today. 
# I don't think we would want country labels on these lines--perhaps you could color the lines 
# according to region so the visual would show which regions were helping drive high levels of 
# between-country differences 70 yrs ago, today, and 50 yrs from now. 

measure_keep <- "mim20"

surv_df <- 
  surv %>% 
  filter(measure == "mothers") %>% 
  select(region, iso, year, mim20:mrom45) %>% 
  pivot_longer(-c(iso, region, year), names_to = "measure", values_to = "survey")  



model_df <- bind_rows(
  mOM %>% 
    mutate(
      age = recode(agegr,'[20,45)' = "20", '[45,50)' = "45")
      , measure = paste0("mom", age)
    ) %>% 
    select(iso, year, measure, value = bereaved_women)
  ,  mIM %>% 
    mutate(
      age = recode(agegr,'[20,45)' = "20", '[45,50)' = "45")
      , measure = paste0("mim", age)
    ) %>% 
    select(iso, year, measure, value = bereaved_women)
  , mU5M  %>% 
    mutate(
      age = recode(agegr,'[20,45)' = "20", '[45,50)' = "45")
      , measure = paste0("mum", age)
    ) %>% 
    select(iso, year, measure, value = bereaved_women)
) %>% 
  # left_join(regions %>% select(iso, region), by = "iso") %>% 
  rename(model = value)

# There's a strange wave-y country in Oceania..

# model_df %>% 
#   filter(measure %in% measure_keep) %>% 
#   left_join(regions %>% select(iso, region), by = "iso") %>% 
#   filter()
#   group_by(iso)
#   mutate(cum = cumsum(model)) %>% 
#   ungroup()

both <- 
  model_df %>% 
  left_join(surv_df %>% select(-region), by = c("iso", "year", "measure")) %>% 
  left_join(regions %>% select(iso, region), by = "iso") %>% 
  filter(!is.na(region)) %>% 
  filter(!grepl("COUNTRIES EXCLUDED", region))


# One measure =============

# p_pnas <-
# Get regions
both %>% 
  filter(measure %in% measure_keep) %>% 
  ggplot(aes(x = year, colour = region, group = iso)) + 
  geom_line(aes(y = model)) +
  geom_point(aes(y = survey)) +
  # facet_wrap( . ~ region, scales = "free")+
  scale_y_continuous(measure_keep) +
  theme_bw() +
  theme(legend.position = "bottom") +
  ggtitle("")


ggsave(
  "../../Output/trajectories_mim20.pdf"
  , width = 10
  , height = 6
)

# All measures in facet =============


  both %>% 
    # For plotting in grid
    mutate(
      age = gsub("[a-z]", "", measure)
      , age = paste0(age, "-", ifelse(age == 20, 44, 49), " yr-old mothers")
      , mes = gsub("[0-9]", "", measure)
      , mes = recode(mes, mim = "mIM", mum = "mU5M", mom = "mOM")
    ) %>% 
  ggplot(aes(x = year, colour = region, group = iso)) + 
  geom_line(aes(y = model), alpha = 0.7, size = 0.3) +
  geom_point(aes(y = survey)) +
  # facet_grid( age ~ mes, scales = "free")+
  facet_grid(age ~ mes) +
  scale_y_continuous("") +
  theme_bw() +
  theme(legend.position = "bottom") +
  ggtitle("")
  
ggsave(
  "../../Output/trajectories_all.pdf"
  , width = 10
  , height = 6
)
