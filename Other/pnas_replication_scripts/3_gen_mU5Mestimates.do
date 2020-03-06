/*
Written by Emily Smith-Greenaway (emilysmithgreenaway.org; smithgre@usc.edu) 
smithgre@usc.edu 
This do-file generates maternal under-five mortality estimates 
reported in Figure 2, S1, and S4 of:
Smith-Greenaway, E. and J. Trinitapoli. 2020. Maternal Cumulative Prevalence Measures 
of Child Mortality Show Heavy Burden in Sub-Saharan Africa. Proceedings of the National Academy of Sciences

*/

********************************
********************************
********************************
********************************mU5M (maternal under-five mortality) estimates for 20-44, 25-29, 30-34, 35-39, 40-44, and 45-49 year old mothers
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
gen u5mdeath2044_`i'=. 
replace u5mdeath2044_`i'=0 if momcurrentage>=20 & momcurrentage<=44 & id_==`i'
replace u5mdeath2044_`i'=1 if everunderfive==1 & momcurrentage>=20 & momcurrentage<=44 & id_==`i'
egen u5msummary2044_`i'=mean(u5mdeath2044_`i') if id_==`i'
replace u5msummary2044_`i'=u5msummary2044_`i'*1000

gen u5mdeath2024_`i'=. 
replace u5mdeath2024_`i'=0 if momcurrentage>=20 & momcurrentage<=24 & id_==`i'
replace u5mdeath2024_`i'=1 if everunderfive==1 & momcurrentage>=20 & momcurrentage<=24 & id_==`i'
egen u5msummary2024_`i'=mean(u5mdeath2024_`i') if id_==`i'
replace u5msummary2024_`i'=u5msummary2024_`i'*1000

gen u5mdeath2529_`i'=. 
replace u5mdeath2529_`i'=0 if momcurrentage>=25 & momcurrentage<=29 & id_==`i'
replace u5mdeath2529_`i'=1 if everunderfive==1 & momcurrentage>=25 & momcurrentage<=29 & id_==`i'
egen u5msummary2529_`i'=mean(u5mdeath2529_`i') if id_==`i'
replace u5msummary2529_`i'=u5msummary2529_`i'*1000

gen u5mdeath3034_`i'=. 
replace u5mdeath3034_`i'=0 if momcurrentage>=30 & momcurrentage<=34 & id_==`i'
replace u5mdeath3034_`i'=1 if everunderfive==1 & momcurrentage>=30 & momcurrentage<=34 & id_==`i'
egen u5msummary3034_`i'=mean(u5mdeath3034_`i') if id_==`i'
replace u5msummary3034_`i'=u5msummary3034_`i'*1000

gen u5mdeath3539_`i'=. 
replace u5mdeath3539_`i'=0 if momcurrentage>=35 & momcurrentage<=39 & id_==`i'
replace u5mdeath3539_`i'=1 if everunderfive==1 & momcurrentage>=35 & momcurrentage<=39 & id_==`i'
egen u5msummary3539_`i'=mean(u5mdeath3539_`i') if id_==`i'
replace u5msummary3539_`i'=u5msummary3539_`i'*1000

gen u5mdeath4044_`i'=. 
replace u5mdeath4044_`i'=0 if momcurrentage>=40 & momcurrentage<=44 & id_==`i'
replace u5mdeath4044_`i'=1 if everunderfive==1 & momcurrentage>=40 & momcurrentage<=44 & id_==`i'
egen u5msummary4044_`i'=mean(u5mdeath4044_`i') if id_==`i'
replace u5msummary4044_`i'=u5msummary4044_`i'*1000

gen u5mdeath4549_`i'=. 
replace u5mdeath4549_`i'=0 if momcurrentage>=45 & id_==`i'
replace u5mdeath4549_`i'=1 if everunderfive==1 & momcurrentage>=45 & id_==`i'
egen u5msummary4549_`i'=mean(u5mdeath4549_`i') if id_==`i'
replace u5msummary4549_`i'=u5msummary4549_`i'*1000
}
gen mu5m2044=. 
gen mu5m2024=. 
gen mu5m2529=. 
gen mu5m3034=.
gen mu5m3539=.
gen mu5m4044=. 
gen mu5m4549=. 
forv i=1/6 {
replace mu5m2044=u5msummary2044_`i' if id_==`i'
replace mu5m2024=u5msummary2024_`i' if id_==`i'
replace mu5m2529=u5msummary2529_`i' if id_==`i'
replace mu5m3034=u5msummary3034_`i' if id_==`i'
replace mu5m3539=u5msummary3539_`i' if id_==`i'
replace mu5m4044=u5msummary4044_`i' if id_==`i'
replace mu5m4549=u5msummary4549_`i' if id_==`i'
}
duplicates drop id_, force 
sort countryname
browse countryname v007 mu5m2044 mu5m2024 mu5m2529 mu5m3034 mu5m3539 mu5m4044 mu5m4549 

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

svy, subpop(reproage): mean everunderfive, over(id_) 
matrix define reproageU5M = e(b)
matlist reproageU5M
svmat reproageU5M
forv i=1/101 {
gen uf2044_`i'=reproageU5M`i'*1000
}
svy, subpop(groupone): mean everunderfive, over(id_) 
matrix define grouponeU5M = e(b)
matlist grouponeU5M
svmat grouponeU5M
forv i=1/101 {
gen uf2024_`i'=grouponeU5M`i'*1000
}
svy, subpop(grouptwo): mean everunderfive, over(id_) 
matrix define grouptwoU5M = e(b)
matlist grouptwoU5M
svmat grouptwoU5M
forv i=1/101 {
gen uf2529_`i'=grouptwoU5M`i'*1000
}
svy, subpop(groupthree): mean everunderfive, over(id_) 
matrix define groupthreeU5M = e(b)
matlist groupthreeU5M
svmat groupthreeU5M
forv i=1/101 {
gen uf3034_`i'=groupthreeU5M`i'*1000
}
svy, subpop(groupfour): mean everunderfive, over(id_) 
matrix define groupfourU5M = e(b)
matlist groupfourU5M
svmat groupfourU5M
forv i=1/101 {
gen uf3539_`i'=groupfourU5M`i'*1000
}
svy, subpop(groupfive): mean everunderfive, over(id_) 
matrix define groupfiveU5M = e(b)
matlist groupfiveU5M
svmat groupfiveU5M
forv i=1/101 {
gen uf4044_`i'=groupfiveU5M`i'*1000
}
svy, subpop(olderage): mean everunderfive, over(id_) 
matrix define olderageU5M = e(b)
matlist olderageU5M
svmat olderageU5M
forv i=1/101 {
gen uf4549_`i'=olderageU5M`i'*1000
}

gen mu5m2044w=.
forv i=1/101 {
egen val`i'=max(uf2044_`i')
replace mu5m2044w=val`i' if `i'==id_
}
drop val*

gen mu5m2024w=.
forv i=1/101 {
egen val`i'=max(uf2024_`i')
replace mu5m2024w=val`i' if `i'==id_
}
drop val*

gen mu5m2529w=.
forv i=1/101 {
egen val`i'=max(uf2529_`i')
replace mu5m2529w=val`i' if `i'==id_
}
drop val*

gen mu5m3034w=.
forv i=1/101 {
egen val`i'=max(uf3034_`i')
replace mu5m3034w=val`i' if `i'==id_
}
drop val*

gen mu5m3539w=.
forv i=1/101 {
egen val`i'=max(uf3539_`i')
replace mu5m3539w=val`i' if `i'==id_
}
drop val*

gen mu5m4044w=.
forv i=1/101 {
egen val`i'=max(uf4044_`i')
replace mu5m4044w=val`i' if `i'==id_
}
drop val*

gen mu5m4549w=.
forv i=1/101 {
egen val_`i'=max(uf4549_`i')
replace mu5m4549w=val_`i' if `i'==id_
}

duplicates drop id_, force 
sort countryname v007
browse countryname v007 mu5m2044w mu5m2024w mu5m2529w mu5m3034w mu5m3539w mu5m4044w mu5m4549w  

/* To */
