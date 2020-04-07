

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


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Code to produce estimates of Child Death, Child Survival, and derived measures
# described in the main text and in the SI Appendix.
# Make sure that all scripts in the directory `A_Data_formatting` have been run before
# attempting to run these scripts - otherwise they won't work.
# The scripts in this directory carry out the analysis of the data but do not produce
# any of the tables or figures included in the paper. 
# These are produced by a separate set of scripts in the directory `C_Results`.
# Scripts in this directory do the following: 
# 
#    1. Load the functions and packages needed in the scripts 
#    2. Load the data needed for the analysis 
#    3. Load data about country grouping and format them for the analysis  
# A. Child Death
#    4. Estimate the cumulative number of child deaths for a woman reaching age a (CD) 
#    5. Regional estimates of CD  
#    6. First difference of Child Death (Delta CD) 
#    7. Burden of child death 
#    8. Sum of burden of child death 
#    9. Expected value of Child Death E[CD] 
#    10. Children expected to outlive a woman as a fraction of her cohort's TFR 
# B. Child survival 
#    11.  Child Survival (CS) 
#    12. Regional estimates of CS  
#    13. Expected value of Child Survival E[CS] 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


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

# 3. Load data about country grouping and format them for the analysis ==== 

source(files[3])

# A. Child Death ----

# 4. Estimate the cumulative number of child deaths for a woman reaching age a (CD) ====

# This script takes cohort age-specific fertility rates (ASFRC) 
# and matrices of survival probabilities (lx.kids.arr) to implement 
# equation 1 in the main text for all countries and birth cohorts separately. 
# It produces estimates of the cumulative number of child deaths for a woman 
# surviving to different ages. 

source(files[4])

# 5. Regional estimates of CD  ====

# Use the country-level estimates produced by the previous script to estimate
# the levels of child death at a regional level. Regions are UN SDG regions.
# Median and different percentiles are estimated.

source(files[5])

# 6. First difference of Child Death (Delta CD) ====

# Obtain country-level estimates of the first difference of Child Death. 
# This is the number of child deaths experienced by a woman at each age 'a'.
# See the main text (Fig.3) and the SI Appendix for a formal description.

source(files[6])

# 7. Burden of child death ====

# Estimate the total number of child deaths experienced by all women in a region 
# and birth cohort at each age $a$.
# We obtain this by multiplying $\Delta CD$ by the absolute number of women expected 
# to survive to each age, considering the original size of each female birth cohort 
# and the mortality rates prevalent in their countries of origin.
# This measure removes the assumption of female survival by accounting for the size 
# and age structure of the population.

# In practice, for each country/cohort combination, we need:
#  - First difference of cumulative child loss (ECLC)
#   This was estimated in previous script
#  - Number of woman surviving to age a 
#   This is estimated in this script. 

# More details in script and in the main text (Fig. 3).

source(files[7])

# B. Child survival ----

# 8.  Child Survival (CS) ====

# Total number of children surviving (CS) for a woman reaching age $a$. 
# Values in the vertical axis represent the total number of children `currently alive' - 
# those surviving exposure to the life table mortality function corresponding to their 
# birth cohorts. 
# See Eq. 1 and Fig. 2 (C-D) in the main text for more details.  

source(files[8])

# 9. Regional estimates of CS  ====

# Use the country-level estimates produced by the previous script to estimate
# the levels of child survival at a regional level. Regions are UN SDG regions.
# Median and different percentiles are estimated.

source(files[9])
