/*
Written by Emily Smith-Greenaway (emilysmithgreenaway.org; smithgre@usc.edu) 
This do-file generates mIM (maternal infant mortality) estimates reported in S2 of:
Smith-Greenaway, E. and J. Trinitapoli. 2020. Maternal Cumulative Prevalence Measures 
of Child Mortality Show Heavy Burden in Sub-Saharan Africa. Proceedings of the National Academy of Sciences
*/
********************************
********************************
********************************
********************************mIM (maternal infant mortality) estimates for 15-19 year old mothers
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
gen infantdeath1519_`i'=. 
replace infantdeath1519_`i'=0 if momcurrentage>=15 & momcurrentage<=19 & id_==`i'
replace infantdeath1519_`i'=1 if everinfantdie==1 & momcurrentage>=15 & momcurrentage<=19 & id_==`i'
egen infantsummary1519_`i'=mean(infantdeath1519_`i') if id_==`i'
replace infantsummary1519_`i'=infantsummary1519_`i'*1000
}
gen mim1519=. 
forv i=1/6 {
replace mim1519=infantsummary1519_`i' if id_==`i'
}
duplicates drop id_, force 
sort countryname v007
browse countryname v007 mim1519

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

drop if country>=21 & country<=36
drop if countryname=="Kenya"   & v007==1988
drop if countryname=="Liberia" & v007==1986
drop if countryname=="Mali"    & v007==1987
drop if countryname=="Senegal" & v007==1986
drop if countryname=="Togo"    & v007==1988
drop if countryname=="Uganda"  & v007==1988
egen countryyear_=concat(country v007)
egen id_=group(countryyear_)
sort id_

gen teen=1 if momcurrentage>=15 & momcurrentage<=19
svy, subpop(teen): mean everinfantdie, over(id_) 
matrix define teenIM = e(b)
matlist teenIM
svmat teenIM
forv i=1/85 {
gen infant1519_`i'=teenIM`i'*1000
}
gen mim1519w=.
forv i=1/85 {
egen val`i'=max(infant1519_`i')
replace mim1519w=val`i' if `i'==id_
}
duplicates drop id_, force 
sort countryname v007
browse countryname v007 mim1519w
