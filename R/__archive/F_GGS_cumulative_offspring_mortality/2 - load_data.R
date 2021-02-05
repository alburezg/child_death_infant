
# Data downloaded from https://www.ggp-i.org/form/
# on 20200901by Diego Alburez
gss <- haven::read_dta("../../Data/GGS/HARMONIZED-HISTORIES_ALL_GGSaccess.dta")

# 6. Model estimates from previous scripts 

mOM <- read.csv("../../Data/estimates/mOM.csv", stringsAsFactors = F)

mU5M <- read.csv("../../Data/estimates/mU5m.csv", stringsAsFactors = F)

mIM <- read.csv("../../Data/estimates/mIM.csv", stringsAsFactors = F)

