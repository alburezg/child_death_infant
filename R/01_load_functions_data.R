
source("R/functions.R")

# Data wrangling
wrangling <- c("tidyverse", "data.table","reshape2", 'parallel', 'countrycode')

library2(wrangling)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Files needed (these should be in Data/):

# - Files in Data/wpp_data/ are the original WPP data without 
# any previous formatting they were all downloaded from 
# https://population.un.org/wpp/Download/Standard/CSV/

# - Files in /derived/ come from a previously published paper:
# Alburez-Gutierrez, D., M. Kolk, and E. Zagheni. (Forthcoming) Women's experience of child death: a global demographic perspective. 
# Demography. DOI:10.31235/osf.io/s69fz
# Estimation is outlined in that paper's supplementary material: https://osf.io/jdvhw/

# These three files are too large for GitHub, but they are can be downloaded from the Harvard dataverse:
# Data/derived/ASFRC.csv
# Data/derived/LTCF.csv
# Data/derived/LTCB.csv

# Files in Data/emily were provided by Emily Smith-Greenaway and are, mainly
# survey-based estimates of the prevalence of maternal bereavement

# Full list of datasets needed for the anlaysis:

data_needs <- c(
  "Data/wpp_data/WPP2019_Period_Indicators_Medium.csv"
  , "Data/wpp_data/WPP2019_TotalPopulationBySex.csv"
  , "Data/wpp_data/WPP2019_PopulationByAgeSex_Medium.csv"
  , "Data/wpp_data/un_regions.csv"
  , "Data/derived/ASFRC.csv"
  , "Data/derived/LTCF.csv"
  , "Data/derived/LTCB.csv"
  , "Data/derived/wpp_female_births_1_1.csv"
  , "Data/derived/wpp_all_births_1_1.csv"
  , "Data/emily/regions.csv"
  , "Data/emily/20200214_women.csv"
  , "Data/emily/20200214_women.csv"
  , "Data/emily/20200214_mothers_indirect.csv"
)
missing <- !file.exists(data_needs)
# The full list of all lx.kids.arr_{country} combinations should also be 
# in the Data/derived folder. They are sourced by the get_lx_array() function
# later on
# This is a lot of data, sorry!

lx_files <- length(list.files('data/derived', pattern = "lx.kids.arr"))

# Check if they all exist: 

if(any(missing)) {
  stop(paste0(
    "These datasets are missing: "
    , paste(data_needs[missing], collapse = "; ")
    , ". See instructions in script for link to download them by hand. "
    , "make sure that they are saved in the Data/ directory!"
    ) )
} else{
  if(lx_files < 209) {
    stop(paste0("I was expecting 209 lx.kids.arr_ files, but only found ", lx_files))
  } else {
    print("All datasets I need are available, well done! I'll start loading them now...")  
  }
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 0. Read wpp data 

# csv version. including with different indicators for the medium scenario

wpp_period_med <- read.csv(
  file = "Data/wpp_data/WPP2019_Period_Indicators_Medium.csv"
  , stringsAsFactors = F
) %>% 
  mutate(
    region = tolower(Location)
    , region = fix_un_countries(region)
  ) %>% 
  select(-Location)

# 1. Fertility data ----

# Note that these are the ungrouped version of the UN data, which is
# groups in 5-age groups for every 5 calendar-year interva
# I did the ungrouping with the scripts in foled WPP_ungroup_data

# Period fertility data ====
# UN fertility projections

fert_wpp_per <- wpp_period_med %>% 
  select(
    region
    , period = Time
    , TFR
    , CBR
    , births = Births
  )

# Cohort ASFR ====

# , derived from WPP data in previous script

ASFRC <- read.csv(file = "Data/derived/ASFRC.csv", stringsAsFactors = F)

# Mean age at childbirth (MAC)

mac_wpp_per <- wpp_period_med %>% 
  select(
    region
    , period = Time
    , value = MAC
  )

# 2. Mortality data ----

# Cohort life tables ====

# Female
LTCF <- data.table::fread(file = "Data/derived/LTCF.csv", stringsAsFactors = F) %>% 
  data.frame
# Both sex
LTCB <- data.table::fread(file = "Data/derived/LTCB.csv", stringsAsFactors = F) %>% 
  data.frame

# 3. Birth cohort size ----

# 3.1. Female birth cohorts ====

female_births <- read.csv(
  file = "Data/derived/wpp_female_births_1_1.csv"
  , stringsAsFactors = F
)

all_births <- read.csv(
  file = "Data/derived/wpp_all_births_1_1.csv"
  , stringsAsFactors = F
)

# 4. Total population ====

# UN WPP medium scenario
# https://population.un.org/wpp/Download/Standard/CSV/

# Total popualtion by sex

world_pop <- 
  read.csv("Data/wpp_data/WPP2019_TotalPopulationBySex.csv", stringsAsFactors = F) %>% 
  filter(Variant == "Medium") %>% 
  select(
    region = Location
    , year = Time
    , pop_m = PopMale
    , pop_f = PopFemale
    , pop_all = PopTotal
  ) %>% 
  mutate_at(c('pop_m', 'pop_f', "pop_all"), function(col) col*1000) %>% 
  mutate(
    region = tolower(region)
    , region = fix_un_countries(region)
  )

# World populatio by sex and age group

world_pop_age <- 
  read.csv("Data/wpp_data/WPP2019_PopulationByAgeSex_Medium.csv", stringsAsFactors = F) %>% 
  select(
    country = Location
    , year = Time
    , agegr = AgeGrp
    , agegr_start = AgeGrpStart
    , pop_m = PopMale
    , pop_f = PopFemale
    , pop_all = PopTotal
  ) %>% 
  mutate_at(c('pop_m', 'pop_f', "pop_all"), function(col) col*1000) %>% 
  mutate(
    country = tolower(country)
    , country = fix_un_countries(country)
  )

# 5. UN regions ====

# This one was downloaded from the WPP website and edited by hand for ease of use:
# wpp_data/un_regions.csv 
un_regions <- read.csv(file = "Data/wpp_data/un_regions.csv", stringsAsFactors = F)
regions <- read.csv(file = "Data/emily/regions.csv", stringsAsFactors = F)

# Decide how countries will be groupped in the analysis
# On 20191010, we had decided to group all countries by UN SDG region 

un_reg <- un_regions %>% 
  # fix text formatting
  mutate_all(.funs = fix_un_countries) %>% 
  # Chose which regions should be used as default
  # Very important as this will shape the final analysis
  # [PREFERRED 20190814]: Use UN SDG regions but remove UAS/NZ and Ocenia (other)
  mutate(default_region = un_sdg_groups)

# Define labels for using in plots later on

regions_long <- c(
  "sub-saharan africa"
  , "northern africa and western asia"
  , "central and southern asia"
  , "eastern and south-eastern asia"
  , "latin america and the caribbean"
  , "australia_new zealand"
  , "oceania (excluding australia and new zealand)"
  , "europe and northern america"
)

regions_short <- c(
  # "SS Africa"
  "Sub-Sah Africa"
  , "N Africa & W Asia"
  , "C & S Asia"
  , "E & SE Asia"
  , "LATAM & Caribbean"
  , "AUS & NZ"
  , "Oceania (other)"
  , "Europe & N America"
)

# 6. Survey estimates ----

# 20200214_women.csv and 20200214_mothers.csv are csv-versions derived from the original
# 20200214_updated DHS estimates.xlsx file sent by Emily.
# They do NOT include MICS estimates, only DHS
# this includes a 'mrom45' column that gives the % of women/mothesr aged 45-50 who ever 
# experienced more than one offspring death 

surv <- 
  bind_rows(
    read.csv("Data/emily/20200214_women.csv", stringsAsFactors = F) %>% 
      mutate(measure = "women")
    , read.csv("Data/emily/20200214_women.csv", stringsAsFactors = F) %>% 
      mutate(measure = "mothers")
    # If indirect estimates showuld be included, unomment this line
    , read.csv("Data/emily/20200214_mothers_indirect.csv", stringsAsFactors = F) %>% 
      mutate(measure = "mothers_indirect")
  ) %>% 
  get_regions_iso(., regions) %>% 
  arrange(measure, country) %>% 
  data.frame()


print("All data loaded!")
print(Sys.time())
#*********************************
