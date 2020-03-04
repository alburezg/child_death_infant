

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

# To Do! 20200302
# - csv output for Emily
# - Comparisson graphs with ALL countries
# - Greenland is not in the WPP data
# As it is not a UN member state


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

# 3. Get estimates for mOM, mU5M, mIM ==== 

source(files[3])

# 4. Comparisons ====

source(files[4])

