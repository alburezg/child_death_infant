/*
Written by Emily Smith-Greenaway (emilysmithgreenaway.org; smithgre@usc.edu) 
The do-file generates maternal infant mortality estimates 
reported in S6 of: 
Smith-Greenaway, E. and J. Trinitapoli. 2020. Maternal Cumulative Prevalence Measures 
of Child Mortality Show Heavy Burden in Sub-Saharan Africa. Proceedings of the National Academy of Sciences
*/
********************************
********************************
********************************
********************************mOM (maternal offspring mortality) estimates by wealth 
********************************
********************************
********************************
clear 
cd ""
use "Smith-GreenawayTrinitapoliPNAS2020data.dta"
drop if v007<=2001

/* Restricting sample to 15 focal countries with relevant data */
gen focal=. 
replace focal=1 if countryname=="Burkina Faso" 
replace focal=1 if countryname=="Ghana" 
replace focal=1 if countryname=="Liberia" 
replace focal=1 if countryname=="Madagascar" 
replace focal=1 if countryname=="Malawi" 
replace focal=1 if countryname=="Mali" 
replace focal=1 if countryname=="Namibia" 
replace focal=1 if countryname=="Niger"  
replace focal=1 if countryname=="Nigeria" 
replace focal=1 if countryname=="Rwanda" 
replace focal=1 if countryname=="Senegal" 
replace focal=1 if countryname=="Tanzania"
replace focal=1 if countryname=="Uganda" 
replace focal=1 if countryname=="Zambia" 
replace focal=1 if countryname=="Zimbabwe" 
drop if focal!=1

gen svyweight = v005/1000000
gen strata = v022
replace strata=v021    if v000=="BF4" & strata==.
replace strata=v021    if v000=="UG6"
replace strata=sstrata if v000=="ZW" & v007==1988

svyset [pweight=svyweight], psu(v001) strata(strata) 

egen countryyear_=concat(country v007)
egen id_=group(countryyear_)
sort id_

gen wealth=v190 

forv i=1/36 {
gen anydeath1_`i'=. 
replace anydeath1_`i'=0 if momcurrentage>=45 & wealth==1 & id_==`i'
replace anydeath1_`i'=1 if everdie==1 & momcurrentage>=45 & wealth==1 & id_==`i'
egen anysummary1_`i'=mean(anydeath1_`i') if id_==`i' & wealth==1
replace anysummary1_`i'=anysummary1_`i'*1000
}
forv i=1/36 {
gen anydeath2_`i'=. 
replace anydeath2_`i'=0 if momcurrentage>=45 & wealth==2 & id_==`i'
replace anydeath2_`i'=1 if everdie==1 & momcurrentage>=45 & wealth==2 & id_==`i'
egen anysummary2_`i'=mean(anydeath2_`i') if id_==`i' & wealth==2
replace anysummary2_`i'=anysummary2_`i'*1000
}
forv i=1/36 {
gen anydeath3_`i'=. 
replace anydeath3_`i'=0 if momcurrentage>=45 & wealth==3 & id_==`i'
replace anydeath3_`i'=1 if everdie==1 & momcurrentage>=45 & wealth==3 & id_==`i'
egen anysummary3_`i'=mean(anydeath3_`i') if id_==`i' & wealth==3
replace anysummary3_`i'=anysummary3_`i'*1000
}
forv i=1/36 {
gen anydeath4_`i'=. 
replace anydeath4_`i'=0 if momcurrentage>=45 & wealth==4 & id_==`i'
replace anydeath4_`i'=1 if everdie==1 & momcurrentage>=45 & wealth==4 & id_==`i'
egen anysummary4_`i'=mean(anydeath4_`i') if id_==`i' & wealth==4
replace anysummary4_`i'=anysummary4_`i'*1000
}
forv i=1/36 {
gen anydeath5_`i'=. 
replace anydeath5_`i'=0 if momcurrentage>=45 & wealth==5 & id_==`i'
replace anydeath5_`i'=1 if everdie==1 & momcurrentage>=45 & wealth==5 & id_==`i'
egen anysummary5_`i'=mean(anydeath5_`i') if id_==`i' & wealth==5
replace anysummary5_`i'=anysummary5_`i'*1000
}
gen offspring1=. 
gen offspring2=. 
gen offspring3=. 
gen offspring4=. 
gen offspring5=. 
forv i=1/36 {
replace offspring1=anysummary1_`i' if id_==`i' 
}
forv i=1/36 {
replace offspring2=anysummary2_`i' if id_==`i' 
}
forv i=1/36 {
replace offspring3=anysummary3_`i' if id_==`i' 
}
forv i=1/36 {
replace offspring4=anysummary4_`i' if id_==`i' 
}
forv i=1/36 {
replace offspring5=anysummary5_`i' if id_==`i' 
}
xfill offspring1, i(id_)
xfill offspring2, i(id_)
xfill offspring3, i(id_)
xfill offspring4, i(id_)
xfill offspring5, i(id_)

duplicates drop id_, force 
sort countryname
browse countryname v007 offspring1-offspring5

