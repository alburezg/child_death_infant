

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


files <- list.files(pattern = ".R$")[-1]

# 1. Load the functions and packages needed in the scripts ====

source(files[1])

# 2. Load the data needed for the analysis ====

source(files[2])

# 3 - difference_model_survey_absolute ====

source(files[3])

# 4.  difference_model_survey_absolute 2016 for all ====
# This fixes all the KC estimates to the values 
# observed in 2016.

# The scripts below are just used to compare the KC 
# to the survey estimates

source(files[4])

# 5 - difference_model_survey_percent ====

source(files[5])

# 6. Check childlesness ====

source(files[6])

# 7. Correlations plots ====

source(files[7])
