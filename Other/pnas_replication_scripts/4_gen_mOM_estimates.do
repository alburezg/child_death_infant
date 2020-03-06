/*
Written by Emily Smith-Greenaway (emilysmithgreenaway.org; smithgre@usc.edu) 
This do-file generates maternal offspring mortality estimates 
reported in Figure 3, Figure 4, and S1 of:
Smith-Greenaway, E. and J. Trinitapoli. 2020. Maternal Cumulative Prevalence Measures 
of Child Mortality Show Heavy Burden in Sub-Saharan Africa. Proceedings of the National Academy of Sciences

*/

********************************
********************************
********************************
********************************mOM (maternal offspring mortality) & mROM (maternal repeat offspring mortality) estimates for mothers 45-49 years old  
********************************
********************************
********************************
*UNWEIGHTED ESTIMATES: Kenya 1989; Liberia 1986; Mali 1987; Senegal 1986; Togo 1988; Uganda 1988
clear 
cd ""
use "Smith-GreenawayTrinitapoliPNAS2020data.dta"

gen id_=.
replace id_=1 if countryname=="Kenya"   & v007==1988
replace id_=2 if countryname=="Liberia" & v007==1986
replace id_=3 if countryname=="Mali"    & v007==1987
replace id_=4 if countryname=="Senegal" & v007==1986
replace id_=5 if countryname=="Togo"    & v007==1988
replace id_=6 if countryname=="Uganda"  & v007==1988
drop if id_==.

forv i=1/6 {
gen anydeath4549_`i'=. 
replace anydeath4549_`i'=0 if momcurrentage>=45 &  id_==`i'
replace anydeath4549_`i'=1 if everdie==1 & momcurrentage>=45 & id_==`i'
egen anysummary4549_`i'=mean(anydeath4549_`i') if id_==`i'
replace anysummary4549_`i'=anysummary4549_`i'*1000
}
gen mom4549=. 
forv i=1/6 {
replace mom4549=anysummary4549_`i' if id_==`i'
}

forv i=1/6 {
gen multipledeath4549_`i'=. 
replace multipledeath4549_`i'=0 if momcurrentage>=45 & id_==`i'
replace multipledeath4549_`i'=1 if totaldeaths>=2 & totaldeaths<=15 & momcurrentage>=45 & id_==`i'
egen multiplesummary4549_`i'=mean(multipledeath4549_`i') if id_==`i'
replace multiplesummary4549_`i'=multiplesummary4549_`i'*1000
}
gen mrom4549=. 
forv i=1/6 {
replace mrom4549=multiplesummary4549_`i' if id_==`i'
}
duplicates drop id_, force 
sort countryname v007
browse countryname v007 mom4549 mrom4549

*WEIGHTED ESTIMATES FOR REMAINING COUNTRY-YEARS
clear 
cd "C:\Users\bpgre\Box\smith-greenaway trini shared\REPLICATION FILES\womendatasets"
use "Smith-GreenawayTrinitapoliPNAS2020data.dta"

gen svyweight = v005/1000000
gen strata = v022
replace strata=v021    if v000=="BF4" & strata==.
replace strata=s001    if v000=="GH" & v007==1988
replace strata=v021    if v000=="UG6"
replace strata=sstrata if v000=="ZW" & v007==1988

svyset [pweight=svyweight], psu(v001) strata(strata) 

drop if countryname=="Kenya"   & v007==1988
drop if countryname=="Liberia" & v007==1986
drop if countryname=="Mali"    & v007==1987
drop if countryname=="Senegal" & v007==1986
drop if countryname=="Togo"    & v007==1988
drop if countryname=="Uganda"  & v007==1988
egen countryyear_=concat(country v007)
egen id_=group(countryyear_)
sort id_

gen olderage=1 if momcurrentage>=45
svy, subpop(olderage): mean everdie, over(id_) 
matrix define olderageOM = e(b)
matlist olderageOM
svmat olderageOM
forv i=1/101 {
gen offspring4549_`i'=olderageOM`i'*1000
}
gen mom4549w=.
forv i=1/101 {
egen val_`i'=max(offspring4549_`i')
replace mom4549w=val_`i' if `i'==id_
}
drop val_*

gen morethanone=0
replace morethanone=1 if totaldeaths>=2 & totaldeaths<=15

svy, subpop(olderage): mean morethanone, over(id_) 
matrix define olderageROM = e(b)
matlist olderageROM
svmat olderageROM
forv i=1/101 {
gen multiple4549_`i'=olderageROM`i'*1000
}
gen mrom4549w=.
forv i=1/101 {
egen val_`i'=max(multiple4549_`i')
replace mrom4549w=val_`i' if `i'==id_
}

duplicates drop id_, force 
sort countryname v007
browse countryname v007 mom4549w mrom4549w
