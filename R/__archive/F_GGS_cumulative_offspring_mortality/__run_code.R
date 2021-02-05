

# *~^**~^**~^**~^**~^**~^**~^*#
# Code by                     #
# Diego Alburez-Gutierrez     #
# gatemonte@gmail.com         #
# @d_alburez                  #
# unless stated otherwise.    #
# Last edited 20200110        #
# GNU GENERAL PUBLIC LICENSE  #
# Version 3, 29 June 2007     #
# *~^**~^**~^**~^**~^**~^**~^*#
#        \   ^__^ 
#        \  (oo)\ ________ 
#           (__)\         )\ /\ 
#                ||------w|
#                ||      ||




if(!require("stringr")) {
  install.packages("stringr")
  library(stringr)
} 

files <- list.files(pattern = ".R$")[-1]
( files <- stringr::str_sort(files, numeric = TRUE) )

# 1. Load the functions and packages needed in the scripts ====

source(files[1])

# 2. Load the data needed for the analysis ====

source(files[2])

# 3 - parameteres ====

source(files[3])

# 4.  difference_model_survey_absolute 2016 for all ====

source(files[4])

# 5 - difference_model_survey_percent ====

source(files[5])

# 6. Check childlesness ====

source(files[6])

# 7. Correlations plots ====

source(files[7])
