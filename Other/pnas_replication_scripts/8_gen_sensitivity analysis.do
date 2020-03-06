/*
Written by Emily Smith-Greenaway (emilysmithgreenaway.org; smithgre@usc.edu) 
This do-file offers template for calculating country-specific estimates using Kaplan-Meier as discussed 
in the Materials and Methods section of: 

Smith-Greenaway, E. and J. Trinitapoli. 2020. Maternal Cumulative Prevalence Measures 
of Child Mortality Show Heavy Burden in Sub-Saharan Africa. Proceedings of the National Academy of Sciences

In this do-file, we use Angola 2015-16 as our example. Please note that you must run "1_append and generate data file" in order to generate the dataset that we use here. 
Also note that each section of code produces a single indicator for a particular age group of women. 
*/

/* Here I'm using Angola 2015-16 as an example */





*******************
*******************
*******************
*******************
*******************Kaplan-Meier approach to calculating the maternal burden of infant mortality for 20-44 year olds 
*******************
*******************
*******************
*******************

clear 
cd "" 
use Smith-GreenawayTrinitapoliPNAS2020data.dta

keep if countryname=="Angola" & v007==2015
drop if momcurrentage>=45
egen newmom = rowmin(cbirth_1-cbirth_20) 
gen id=_n

gen timefirstinfantdeath = firstinfantdeath-newmom
gen timefirstdeath = firstdeath-newmom 
gen obperiod = survey-newmom 
drop if obperiod==0
replace obperiod = timefirstinfantdeath if timefirstdeath!=. 
gen obperiod_ = obperiod 
replace obperiod_ = timefirstinfantdeath if timefirstdeath!=. 
replace obperiod_ = obperiod_/12 
gen obperiod__ = ceil(obperiod_)
drop if obperiod__==. 
drop if obperiod__==0 
gen timefirstinfantdeath_ = timefirstinfantdeath 
replace timefirstinfantdeath_ = timefirstinfantdeath_/12
gen timefirstinfantdeath__ = ceil(timefirstinfantdeath_)
stset obperiod__, failure(timefirstinfantdeath__) id(id) 
stsplit time, every(1) 
gen cd=timefirstinfantdeath__
recode cd .=0
replace cd=1 if cd!=0

stset obperiod__, failure(cd) id(id)

sts list /* 1-0.7290 = 0.271 (mIM of 271, expressed per 1,000) -- per claim, this estimate is high relative to estimate in S1 of mIM=168 */





*******************
*******************
*******************
*******************
*******************Kaplan-Meier approach to calculating the maternal burden of infant mortality for 45-49 year olds 
*******************
*******************
*******************
*******************
clear 
cd "" 
use Smith-GreenawayTrinitapoliPNAS2020data.dta

keep if countryname=="Angola" & v007==2015
drop if momcurrentage<=44
egen newmom = rowmin(cbirth_1-cbirth_20) 
gen id=_n

gen timefirstinfantdeath = firstinfantdeath-newmom
gen timefirstdeath = firstdeath-newmom 
gen obperiod = survey-newmom 
drop if obperiod==. 
drop if obperiod==0
replace obperiod = timefirstinfantdeath if timefirstdeath!=. 
gen obperiod_ = obperiod 
replace obperiod_ = timefirstinfantdeath if timefirstdeath!=. 
replace obperiod_ = obperiod_/12 
gen obperiod__ = ceil(obperiod_)
drop if obperiod__==. 
drop if obperiod__==0 
gen timefirstinfantdeath_ = timefirstinfantdeath 
replace timefirstinfantdeath_ = timefirstinfantdeath_/12
gen timefirstinfantdeath__ = ceil(timefirstinfantdeath_)

stset obperiod__, failure(timefirstinfantdeath__) id(id) 

stsplit time, every(1) 

gen cd=timefirstinfantdeath__
recode cd .=0
replace cd=1 if cd!=0

stset obperiod__, failure(cd) id(id)

sts list /* 1-0.6552 = 0.3448 (mIM of 345, expressed per 1,000) -- per claim, this estimate is comparable to estimate in S1 of mIM=310 */




*******************
*******************
*******************
*******************
*******************Kaplan-Meier approach to calculating the maternal burden of under-five mortality for 20-44 year olds 
*******************
*******************
*******************
*******************
clear 
cd "" 
use Smith-GreenawayTrinitapoliPNAS2020data.dta

keep if countryname=="Angola" & v007==2015
drop if momcurrentage>=45
egen newmom = rowmin(cbirth_1-cbirth_20) 
gen id=_n

gen timefirstunderfivedeath = firstunderfivedeath-newmom
gen timefirstdeath = firstdeath-newmom 
gen obperiod = survey-newmom 
drop if obperiod==. 
drop if obperiod==0
replace obperiod = timefirstunderfivedeath if timefirstdeath!=. 
gen obperiod_ = obperiod 
replace obperiod_ = timefirstunderfivedeath if timefirstdeath!=. 
replace obperiod_ = obperiod_/12 
gen obperiod__ = ceil(obperiod_)
drop if obperiod__==. 
drop if obperiod__==0 
gen timefirstunderfivedeath_ = timefirstunderfivedeath 
replace timefirstunderfivedeath_ = timefirstunderfivedeath_/12
gen timefirstunderfivedeath__ = ceil(timefirstunderfivedeath_)
stset obperiod__, failure(timefirstunderfivedeath__) id(id) 
stsplit time, every(1) 
gen cd=timefirstunderfivedeath__
recode cd .=0
replace cd=1 if cd!=0

stset obperiod__, failure(cd) id(id)

sts list /* 1-0.6779 = 0.3221 (mU5M of 322, expressed per 1,000) -- per claim, this estimate is high relative to estimate in S1 of mU5M=225 */





*******************
*******************
*******************
*******************
*******************Kaplan-Meier approach to calculating the maternal burden of under-five mortality for 45-49 year olds 
*******************
*******************
*******************
*******************
clear 
cd "" 
use Smith-GreenawayTrinitapoliPNAS2020data.dta

keep if countryname=="Angola" & v007==2015
drop if momcurrentage<=44
egen newmom = rowmin(cbirth_1-cbirth_20) 
gen id=_n

forv i=1/20 {
gen anydeath_`i'= cdeath_`i'
}

gen timefirstunderfivedeath = firstunderfivedeath-newmom
gen timefirstdeath = firstdeath-newmom 
gen obperiod = survey-newmom 
drop if obperiod==. 
drop if obperiod==0
replace obperiod = timefirstunderfivedeath if timefirstdeath!=. 
gen obperiod_ = obperiod 
replace obperiod_ = timefirstunderfivedeath if timefirstdeath!=. 
replace obperiod_ = obperiod_/12 
gen obperiod__ = ceil(obperiod_)
drop if obperiod__==. 
drop if obperiod__==0 
gen timefirstunderfivedeath_ = timefirstunderfivedeath 
replace timefirstunderfivedeath_ = timefirstunderfivedeath_/12
gen timefirstunderfivedeath__ = ceil(timefirstunderfivedeath_)
stset obperiod__, failure(timefirstunderfivedeath__) id(id) 
stsplit time, every(1) 
gen cd=timefirstunderfivedeath__
recode cd .=0
replace cd=1 if cd!=0

stset obperiod__, failure(cd) id(id)

sts list /* 1-0.5733 = 0.4267 (mU5M of 427, expressed per 1,000) -- per claim, this estimate is comparable to estimate in S1 of mU5M=442 */





*******************
*******************
*******************
*******************
*******************Kaplan-Meier approach to calculating the maternal burden of offspring mortality for 45-49 year olds 
*******************
*******************
*******************
*******************
clear 
cd "" 
use Smith-GreenawayTrinitapoliPNAS2020data.dta

keep if countryname=="Angola" & v007==2015
drop if momcurrentage<=44
egen newmom = rowmin(cbirth_1-cbirth_20) 
gen id=_n

gen timefirstdeath = firstdeath-newmom 
gen obperiod = survey-newmom 
drop if obperiod==. 
drop if obperiod==0
replace obperiod = timefirstdeath if timefirstdeath!=. 
gen obperiod_ = obperiod 
replace obperiod_ = timefirstdeath if timefirstdeath!=. 
replace obperiod_ = obperiod_/12 
gen obperiod__ = ceil(obperiod_)
drop if obperiod__==. 
drop if obperiod__==0 
gen timefirstdeath_ = timefirstdeath 
replace timefirstdeath_ = timefirstdeath_/12
gen timefirstdeath__ = ceil(timefirstdeath_)
stset obperiod__, failure(timefirstdeath__) id(id) 
stsplit time, every(1) 
gen cd=timefirstdeath__
recode cd .=0
replace cd=1 if cd!=0

stset obperiod__, failure(cd) id(id)

sts list /* 1-0.5152 = 0.4848 (mU5M of 485, expressed per 1,000) -- per claim, this estimate is comparable to estimate in S1 of mOM=484 */
