/*
Written by Emily Smith-Greenaway (emilysmithgreenaway.org; smithgre@usc.edu) 
This do-file generates maternal infant mortality estimates 
reported in S5 of:
Smith-Greenaway, E. and J. Trinitapoli. 2020. Maternal Cumulative Prevalence Measures 
of Child Mortality Show Heavy Burden in Sub-Saharan Africa. Proceedings of the National Academy of Sciences
*/
********************************
********************************
********************************
********************************MOM region-level estimates 
********************************
********************************
********************************
clear 
cd ""
use "Smith-GreenawayTrinitapoliPNAS2020data.dta"

drop if country>=21 & country<=36
drop if momcurrentage<=44

sort countryname v007
egen regionyear=concat(region v007)
destring regionyear, replace
egen nvals=group(regionyear)

keep countryname regionyear momcurrentage nvals everdie v007

forv i=1/577 {
gen anydeath4549_`i'=. 
replace anydeath4549_`i'=0 if momcurrentage>=45 &  nvals==`i'
replace anydeath4549_`i'=1 if everdie==1 & momcurrentage>=45 & nvals==`i'
egen anysummary4549_`i'=mean(anydeath4549_`i') if nvals==`i'
replace anysummary4549_`i'=anysummary4549_`i'*1000
}

gen offspring4549=. 
forv i=1/577 {
replace offspring4549=anysummary4549_`i' if nvals==`i'
}

duplicates drop regionyear, force 
sort countryname v007
browse countryname v007 regionyear offspring4549 
