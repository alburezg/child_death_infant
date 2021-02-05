# Overview

Code and data to produce the **Kin-Cohort** estimates included in the paper:

*The Global Burden of Maternal Bereavement: Indicators of the Cumulative Prevalence of Child Loss*.

The estimation procedures are described in the Appendix of the paper. 

**Prepared by Diego Alburez, Feb 2021**

## Replicating the analysis

I recommend that you save the entire content of this repository locally (extracting the files if needed). Please make sure to keep the folder structure after extracting! This is needed because the scripts use relative paths to locate data and save function outputs. 
Note that some empty directories have a `temp` file, which you can safely ignore. 

- All code is in the directory `R`
- All input data in the directory `Data`
- All output is saved in the directory `Output` 

## Software information

> sessionInfo()
R version 3.6.0 Patched (2019-06-11 r76697)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 7 x64 (build 7601) Service Pack 1

Matrix products: default

locale:
[1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252   
[3] LC_MONETARY=English_United States.1252 LC_NUMERIC=C                          
[5] LC_TIME=English_United States.1252    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] readxl_1.3.1      countrycode_1.1.1 forcats_0.5.0     stringr_1.4.0     dplyr_1.0.2      
 [6] purrr_0.3.3       readr_1.3.1       tidyr_1.0.2       tibble_3.0.4      ggplot2_3.3.0    
[11] tidyverse_1.3.0  

loaded via a namespace (and not attached):
 [1] Rcpp_1.0.6        plyr_1.8.6        cellranger_1.1.0  pillar_1.4.3      compiler_3.6.0   
 [6] dbplyr_1.4.2      tools_3.6.0       digest_0.6.25     packrat_0.5.0     lubridate_1.7.4  
[11] jsonlite_1.6.1    lifecycle_0.2.0   gtable_0.3.0      pkgconfig_2.0.3   rlang_0.4.7      
[16] reprex_0.3.0      cli_2.0.2         DBI_1.1.0         rstudioapi_0.11   haven_2.2.0      
[21] withr_2.1.2       xml2_1.2.5        httr_1.4.1        fs_1.3.2          generics_0.0.2   
[26] vctrs_0.3.5       hms_0.5.3         grid_3.6.0        tidyselect_1.1.0  data.table_1.12.8
[31] glue_1.3.2        R6_2.4.1          fansi_0.4.1       farver_2.0.3      reshape2_1.4.3   
[36] modelr_0.1.6      magrittr_1.5      backports_1.1.5   scales_1.1.0      ellipsis_0.3.0   
[41] rvest_0.3.5       assertthat_0.2.1  colorspace_1.4-1  labeling_0.3      stringi_1.4.6    
[46] munsell_0.5.0     broom_0.7.2       crayon_1.3.4     