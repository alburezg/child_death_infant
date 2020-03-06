/*
Written by Emily Smith-Greenaway (emilysmithgreenaway.org; smithgre@usc.edu) 
This do-file generates mIM (maternal infant mortality) estimates reported in 
Figure 1, S1, and S3 of:
Smith-Greenaway, E. and J. Trinitapoli. 2020. Maternal Cumulative Prevalence Measures 
of Child Mortality Show Heavy Burden in Sub-Saharan Africa. Proceedings of the National Academy of Sciences
*/

********************************
********************************
********************************
********************************mIM (maternal infant mortality) estimates for 20-44, 25-29, 30-34, 35-39, 40-44, and 45-49 year old mothers 
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
gen infantdeath2044_`i'=. 
replace infantdeath2044_`i'=0 if momcurrentage>=20 & momcurrentage<=44 & id_==`i'
replace infantdeath2044_`i'=1 if everinfantdie==1 & momcurrentage>=20 & momcurrentage<=44 & id_==`i'
egen infantsummary2044_`i'=mean(infantdeath2044_`i') if id_==`i'
replace infantsummary2044_`i'=infantsummary2044_`i'*1000

gen infantdeath2024_`i'=. 
replace infantdeath2024_`i'=0 if momcurrentage>=20 & momcurrentage<=24 & id_==`i'
replace infantdeath2024_`i'=1 if everinfantdie==1 & momcurrentage>=20 & momcurrentage<=24 & id_==`i'
egen infantsummary2024_`i'=mean(infantdeath2024_`i') if id_==`i'
replace infantsummary2024_`i'=infantsummary2024_`i'*1000

gen infantdeath2529_`i'=. 
replace infantdeath2529_`i'=0 if momcurrentage>=25 & momcurrentage<=29 & id_==`i'
replace infantdeath2529_`i'=1 if everinfantdie==1 & momcurrentage>=25 & momcurrentage<=29 & id_==`i'
egen infantsummary2529_`i'=mean(infantdeath2529_`i') if id_==`i'
replace infantsummary2529_`i'=infantsummary2529_`i'*1000

gen infantdeath3034_`i'=. 
replace infantdeath3034_`i'=0 if momcurrentage>=30 & momcurrentage<=34 & id_==`i'
replace infantdeath3034_`i'=1 if everinfantdie==1 & momcurrentage>=30 & momcurrentage<=34 & id_==`i'
egen infantsummary3034_`i'=mean(infantdeath3034_`i') if id_==`i'
replace infantsummary3034_`i'=infantsummary3034_`i'*1000

gen infantdeath3539_`i'=. 
replace infantdeath3539_`i'=0 if momcurrentage>=35 & momcurrentage<=39 & id_==`i'
replace infantdeath3539_`i'=1 if everinfantdie==1 & momcurrentage>=35 & momcurrentage<=39 & id_==`i'
egen infantsummary3539_`i'=mean(infantdeath3539_`i') if id_==`i'
replace infantsummary3539_`i'=infantsummary3539_`i'*1000

gen infantdeath4044_`i'=. 
replace infantdeath4044_`i'=0 if momcurrentage>=40 & momcurrentage<=44 & id_==`i'
replace infantdeath4044_`i'=1 if everinfantdie==1 & momcurrentage>=40 & momcurrentage<=44 & id_==`i'
egen infantsummary4044_`i'=mean(infantdeath4044_`i') if id_==`i'
replace infantsummary4044_`i'=infantsummary4044_`i'*1000

gen infantdeath4549_`i'=. 
replace infantdeath4549_`i'=0 if momcurrentage>=45 & id_==`i'
replace infantdeath4549_`i'=1 if everinfantdie==1 & momcurrentage>=45 & id_==`i'
egen infantsummary4549_`i'=mean(infantdeath4549_`i') if id_==`i'
replace infantsummary4549_`i'=infantsummary4549_`i'*1000
}
gen mim2044=. 
gen mim2024=. 
gen mim2529=. 
gen mim3034=.
gen mim3539=.
gen mim4044=. 
gen mim4549=. 
forv i=1/6 {
replace mim2044=infantsummary2044_`i' if id_==`i'
replace mim2024=infantsummary2024_`i' if id_==`i'
replace mim2529=infantsummary2529_`i' if id_==`i'
replace mim3034=infantsummary3034_`i' if id_==`i'
replace mim3539=infantsummary3539_`i' if id_==`i'
replace mim4044=infantsummary4044_`i' if id_==`i'
replace mim4549=infantsummary4549_`i' if id_==`i'
}
duplicates drop id_, force 
sort countryname v007
browse countryname v007 mim2044 mim2024 mim2529 mim3034 mim3539 mim4044 mim4549

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

gen reproage=1    if momcurrentage>=20 & momcurrentage<=44
gen groupone=1    if momcurrentage>=20 & momcurrentage<=24
gen grouptwo=1    if momcurrentage>=25 & momcurrentage<=29
gen groupthree=1  if momcurrentage>=30 & momcurrentage<=34
gen groupfour=1   if momcurrentage>=35 & momcurrentage<=39
gen groupfive=1   if momcurrentage>=40 & momcurrentage<=44
gen olderage=1    if momcurrentage>=45

svy, subpop(reproage): mean everinfantdie, over(id_) 
matrix define reproageIM = e(b)
matlist reproageIM
svmat reproageIM
forv i=1/101 {
gen infant2044_`i'=reproageIM`i'*1000
}
svy, subpop(groupone): mean everinfantdie, over(id_) 
matrix define grouponeIM = e(b)
matlist grouponeIM
svmat grouponeIM
forv i=1/101 {
gen infant2024_`i'=grouponeIM`i'*1000
}
svy, subpop(grouptwo): mean everinfantdie, over(id_) 
matrix define grouptwoIM = e(b)
matlist grouptwoIM
svmat grouptwoIM
forv i=1/101 {
gen infant2529_`i'=grouptwoIM`i'*1000
}
svy, subpop(groupthree): mean everinfantdie, over(id_) 
matrix define groupthreeIM = e(b)
matlist groupthreeIM
svmat groupthreeIM
forv i=1/101 {
gen infant3034_`i'=groupthreeIM`i'*1000
}
svy, subpop(groupfour): mean everinfantdie, over(id_) 
matrix define groupfourIM = e(b)
matlist groupfourIM
svmat groupfourIM
forv i=1/101 {
gen infant3539_`i'=groupfourIM`i'*1000
}
svy, subpop(groupfive): mean everinfantdie, over(id_) 
matrix define groupfiveIM = e(b)
matlist groupfiveIM
svmat groupfiveIM
forv i=1/101 {
gen infant4044_`i'=groupfiveIM`i'*1000
}
svy, subpop(olderage): mean everinfantdie, over(id_) 
matrix define olderageIM = e(b)
matlist olderageIM
svmat olderageIM
forv i=1/101 {
gen infant4549_`i'=olderageIM`i'*1000
}

gen mim2044w=.
forv i=1/101 {
egen val`i'=max(infant2044_`i')
replace mim2044w=val`i' if `i'==id_
}
drop val*

gen mim2024w=.
forv i=1/101 {
egen val`i'=max(infant2024_`i')
replace mim2024w=val`i' if `i'==id_
}
drop val*

gen mim2529w=.
forv i=1/101 {
egen val`i'=max(infant2529_`i')
replace mim2529w=val`i' if `i'==id_
}
drop val*

gen mim3034w=.
forv i=1/101 {
egen val`i'=max(infant3034_`i')
replace mim3034w=val`i' if `i'==id_
}
drop val*

gen mim3539w=.
forv i=1/101 {
egen val`i'=max(infant3539_`i')
replace mim3539w=val`i' if `i'==id_
}
drop val*

gen mim4044w=.
forv i=1/101 {
egen val`i'=max(infant4044_`i')
replace mim4044w=val`i' if `i'==id_
}
drop val*

gen mim4549w=.
forv i=1/101 {
egen val_`i'=max(infant4549_`i')
replace mim4549w=val_`i' if `i'==id_
}

duplicates drop id_, force 
sort countryname v007
browse countryname v007 mim2044w mim2024w mim2529w mim3034w mim3539w mim4044w mim4549w  
