
# Data downloaded from https://www.ggp-i.org/form/
# on 20200901by Diego Alburez
gss <- haven::read_dta("../../Data/GGS/HARMONIZED-HISTORIES_ALL_GGSaccess.dta")

# 6. Model estimates from previous scripts 

mOM <- read.csv("../../Data/estimates/mOM.csv", stringsAsFactors = F)

mU5M <- read.csv("../../Data/estimates/mU5m.csv", stringsAsFactors = F)

mIM <- read.csv("../../Data/estimates/mIM.csv", stringsAsFactors = F)

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
