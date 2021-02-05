

# *~^**~^**~^**~^**~^**~^**~^*#
# Code by                     #
# Diego Alburez-Gutierrez     #
# gatemonte@gmail.com         #
# @d_alburez                  #
# unless stated otherwise.    #
# Last edited 20210210        #
# GNU GENERAL PUBLIC LICENSE  #
# Version 3, 29 June 2007     #
# *~^**~^**~^**~^**~^**~^**~^*#


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Code to produce estimates of the prevalence of offspring death
# by children age at death (mOM, mIM, mU5M) for the paper
# The Global Burden of Maternal Bereavement:
# Indicators of the Cumulative Prevalence of Child Loss
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(files <- list.files(pattern = ".R$", path = "R")[-1])

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

# 7. Get estimates for mOM, mU5M, mIM ==== 

source(files[7])

# 8. Get estimates for mOM, mU5M, mIM by 5-year age groups ==== 

source(files[8])

# 9. Compare to survey data and export table ===========
# First, using only 2 super wide age-groups 
# This is the one reported in the main text

source(files[9])

# 10. Compare to survey data and export table ===========
# using 5-year age groups (appendix)

source(files[10])

print("A'qaroq! Estimates complete.")
