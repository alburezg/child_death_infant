

# *~^**~^**~^**~^**~^**~^**~^*#
# Code by                     #
# Diego Alburez-Gutierrez     #
# gatemonte@gmail.com         #
# @d_alburez                  #
# unless stated otherwise.    #
# Last edited 20210210        #
# GNU GENERAL PUBLIC LICENSE  #
# *~^**~^**~^**~^**~^**~^**~^*#
#        \   ^__^ 
#        \  (oo)\ ________ 
#           (__)\         )\ /\ 
#                ||-------|
#                ||      ||

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Code to produce estimates of the prevalence of offspring death
# by children's age at death (mOM, mIM, mU5M) for the paper
# The Global Burden of Maternal Bereavement:
# Indicators of the Cumulative Prevalence of Child Loss
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(files <- list.files(pattern = ".R$", path = "R", full.names = T)[-1])

# 1. Load the functions and ata needed in the scripts ====

# This script makes sure that all data I need for the analysis 
# are available in the Data/ directory. If they are not, the larger
# files need to be downloaded manually. See insctruction in error message.

source(files[1])

# 2. Estimate the cumulative number of child deaths for a woman reaching age a (CD) ====

# This script takes cohort age-specific fertility rates (ASFRC) 
# and matrices of survival probabilities (lx.kids.arr) to 
# estimates the cumulative number of child deaths for a woman 
# surviving to different ages

source(files[2])

# 3. First difference of Child Death (Delta CD) ====

# Obtain country-level estimates of the first difference of Child Death. 
# This is the number of child deaths experienced by a woman at each age 'a'.

source(files[3])

# 4. Get the burden of child death ========

# This is the estimated number of child deaths (in thousands or equivalent)
# experienced by all women in a given country-cohort combination

source(files[4])

# 5. Get estimates for mOM, mU5M, mIM for wide age groups ==== 

source(files[5])

# 6. Get estimates for mOM, mU5M, mIM for 5-y age groups ==== 

source(files[6])

# 7. Get formated results for paper at the country level (wide age groups) ===========

source(files[7])

# 8. Get formated results for paper at the country level (5-y age groups) ===========

source(files[8])

print("Estimates complete.")
