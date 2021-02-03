source("../functions.R")

# Data wrangling
wrangling <- c(
  "tidyverse"
  , "countrycode"
  # , "plyr"
  , 'survey'
  , 'srvyr'
)

library2(wrangling)

# Convert to DHS century month code
get_cmc <- function(y,m){
  ((y - 1900)*12) + m
}

# Proportion who had at least one deceased infant, under five yr old, 
# or child die (out of those who ever gave birth)
# using GGS harmonized df 
was_mother_bereaved_GGS <- function(kids_age_death_months, max_child_age_months){
  
  row_aut <- kids_age_death_months[ small_df$country == "AUT",]
  row_bereaved <- row_aut[!is.na(row_aut$kid_death_cmc1), ]
  row <- row_bereaved[3 , ]
  
  apply(kids_age_death_months, 1, function(row, max_child_age_months){
    
    r <- unlist(row)
    number_deaths <- sum(!is.na(r[r <= max_child_age_months]))
    return(number_deaths > 0)
  }, max_child_age_months)
  
}
