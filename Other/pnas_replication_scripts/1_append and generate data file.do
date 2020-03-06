/*
Written by Emily Smith-Greenaway (emilysmithgreenaway.org; smithgre@usc.edu) 
This do-file appends publicly available DHS data to enable calculation of 
mIM (maternal infant mortality), mU5M (maternal underfive mortality), and mOM (maternal offspring mortality) estimates 
published in:
Smith-Greenaway, E. and J. Trinitapoli. 2020. Maternal Cumulative Prevalence Measures 
of Child Mortality Show Heavy Burden in Sub-Saharan Africa. Proceedings of the National Academy of Sciences

To access Demographic and Health Survey data, visit: https://dhsprogram.com/Data/
*/

clear
clear matrix
clear mata 
set max_memory 10g, perm 
set maxvar 10000

cd ""
 
*appending datasets for BENIN: 1996; 2001; 2006; 2011
use BJIR31FL.dta 
rename v024 v024_ben96
keep caseid v005 v001 v022 v201 v011 v005 v001 v022 v201 v011 v024_ben96 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

append using BJIR41FL.dta
rename v024 v024_ben01
keep caseid v005 v001 v022 v201 v011 v024_ben96 v024_ben01 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

append using BJIR51FL 
rename v024 v024_ben06
keep caseid v005 v001 v022 v201 v011 v024_ben96 v024_ben01 v024_ben06 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

append using BJIR61FL
rename v024 v024_ben11
keep caseid v005 v001 v022 v201 v011 v024_ben96 v024_ben01 v024_ben06 v024_ben11 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

gen v024_ben=. 
replace v024_ben=1 if v024_ben96==1|v024_ben01==1|v024_ben06==2|v024_ben06==7|v024_ben11==2|v024_ben11==7
replace v024_ben=2 if v024_ben96==2|v024_ben01==2|v024_ben06==3|v024_ben06==8|v024_ben11==3|v024_ben11==8
replace v024_ben=3 if v024_ben96==3|v024_ben01==3|v024_ben06==1|v024_ben06==4|v024_ben11==1|v024_ben11==4
replace v024_ben=4 if v024_ben96==4|v024_ben01==4 |v024_ben06==6|v024_ben06==9|v024_ben11==6|v024_ben11==9
replace v024_ben=5 if v024_ben96==5|v024_ben01==5|v024_ben06==10|v024_ben06==11|v024_ben11==10|v024_ben11==11
replace v024_ben=6 if v024_ben96==6|v024_ben01==6|v024_ben06==12|v024_ben06==5|v024_ben11==12|v024_ben11==5

label define v024_ben 1 "atacora/donga" 2 "atlantique/littoral" 3 "borgou/alibori" 4 "mono/couffo" 5 "oueme/plateau"  6 "zou/collines"
label values v024_ben v024_ben

*appending datasets for CAMEROON: 1991; 1998; 2004; 2011
append using CMIR22DT.dta 
rename v024 v024_cam91
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam91 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

append using CMIR31DT.dta 
rename v024 v024_cam98
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam91 v024_cam98 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

append using CMIR44dt.dta 
rename v024 v024_cam04
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam91 v024_cam98 v024_cam04 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

append using CMIR61DT.dta 
rename v024 v024_cam11
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam91 v024_cam98 v024_cam04 v024_cam11 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

gen v024_cam=.
replace v024_cam=1 if v024_cam91==1|v024_cam04==3|v024_cam04==12|v024_cam11==12|v024_cam11==3
replace v024_cam=2 if v024_cam91==2|v024_cam98==1|v024_cam04==1|v024_cam04==7|v024_cam04==5|v024_cam11==1|v024_cam11==7|v024_cam11==5
replace v024_cam=3 if v024_cam91==3|v024_cam98==2|v024_cam04==2|v024_cam04==10|v024_cam04==4|v024_cam11==2|v024_cam11==10|v024_cam11==4
replace v024_cam=4 if v024_cam91==4|v024_cam98==3|v024_cam04==9|v024_cam04==6|v024_cam04==11|v024_cam11==9|v024_cam11==6
replace v024_cam=5 if v024_cam91==5|v024_cam98==4|v024_cam04==8|v024_cam04==5|v024_cam11==8|v024_cam11==11
label define v024_cam 1 "yaoundŽ/douala" 2 "adam/nord/ext-nord" 3 "centre/sud/est" 4 "ouest/littoral" 5 "nord-ouest/sud-ouest" 
label values v024_cam v024_cam
 
*appending datasets for KENYA: 1989; 1993; 1998; 2003; 2008; 2014
append using KEIR30DT.dta 
rename v101 v024_ken89
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken89 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

append using KEIR33DT.dta 
rename v024 v024_ken93
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken89 v024_ken93 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

append using KEIR3ADT.dta 
rename v024 v024_ken98
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken89 v024_ken93 v024_ken98 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

append using KEIR42DT.dta 
rename v024 v024_ken03
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken89 v024_ken93 v024_ken98 v024_ken03 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

append using KEIR52DT.dta 
rename v024 v024_ken08
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken89 v024_ken93 v024_ken98 v024_ken03 v024_ken08 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

append using KEIR72DT.dta 
rename v024 v024_ken14
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken89 v024_ken93 v024_ken98 v024_ken03 v024_ken08 v024_ken14 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

gen v024_ken=.
replace v024_ken=1 if v024_ken89==1|v024_ken93==1|v024_ken98==1|v024_ken03==1|v024_ken08==1|v024_ken14==9
replace v024_ken=2 if v024_ken89==2|v024_ken93==2|v024_ken98==2|v024_ken03==2|v024_ken08==2|v024_ken14==4
replace v024_ken=3 if v024_ken89==3|v024_ken93==3|v024_ken98==3|v024_ken03==3|v024_ken08==3|v024_ken14==1
replace v024_ken=4 if v024_ken89==4|v024_ken93==4|v024_ken98==4|v024_ken03==4|v024_ken08==4|v024_ken14==3
replace v024_ken=5 if v024_ken89==5|v024_ken93==5|v024_ken98==5|v024_ken03==5|v024_ken08==5|v024_ken14==8
replace v024_ken=6 if v024_ken89==6|v024_ken93==6|v024_ken98==6|v024_ken03==6|v024_ken08==6|v024_ken14==5
replace v024_ken=7 if v024_ken89==7|v024_ken93==7|v024_ken98==7|v024_ken03==7|v024_ken08==7|v024_ken14==7
replace v024_ken=8 if v024_ken03==8|v024_ken08==8|v024_ken14==2
label define v024_ken 1 "nairobi" 2 "central" 3 "coast" 4 "eastern" 5 "nyanza" 6 "rift valley" 7 "western" 8 "north eastern"
label values v024_ken v024_ken

*appending datasets for MALAWI: 1992; 2000; 2004; 2010; 2015
append using MWIR22DT.dta 
rename v024 v024_mal92
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal92 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

append using MWIR41DT.dta 
rename v024 v024_mal00
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken  v024_mal92 v024_mal00 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 

append using MWIR4EDT.dta 
rename v024 v024_mal04
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal92 v024_mal00 v024_mal04 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using MWIR61DT.dta 
rename v024 v024_mal10
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal92 v024_mal00 v024_mal04 v024_mal10 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190 

append using MWIR7ADT.dta 
rename v024 v024_mal15
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal92 v024_mal00 v024_mal04 v024_mal10 v024_mal15 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190 

gen v024_mal=.
replace v024_mal=1 if v024_mal92==1|v024_mal00==1|v024_mal04==1|v024_mal10==1|v024_mal15==1
replace v024_mal=2 if v024_mal92==2|v024_mal00==2|v024_mal04==2|v024_mal10==2|v024_mal15==2
replace v024_mal=3 if v024_mal92==3|v024_mal00==3|v024_mal04==3|v024_mal10==3|v024_mal15==3
label define v024_mal 1 "northern region" 2 "central region" 3 "southern region"
label values v024_mal v024_mal

*appending datasets for MALI: 1987; 1995; 2001; 2006; 2012
append using MLIR01DT.dta 
rename v101 v024_mali87
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali87 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using MLIR32DT.dta 
rename v024 v024_mali95
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali87 v024_mali95 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using MLIR41DT.dta 
rename v024 v024_mali01
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali87 v024_mali95 v024_mali01 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using MLIR53DT.dta 
rename v024 v024_mali06
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali87 v024_mali95 v024_mali01 v024_mali06 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using MLIR6ADT.dta 
rename v024 v024_mali12
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali87 v024_mali95 v024_mali01 v024_mali06 v024_mali12 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_mali=.
replace v024_mali=1 if v024_mali87==1|v024_mali95==1|v024_mali95==2|v024_mali01==1|v024_mali01==2|v024_mali06==1|v024_mali06==2|v024_mali12==1|v024_mali12==2
replace v024_mali=2 if v024_mali87==2|v024_mali95==3|v024_mali95==4|v024_mali01==3|v024_mali01==4|v024_mali06==3|v024_mali06==4|v024_mali12==3|v024_mali12==4
replace v024_mali=3 if v024_mali87==3|v024_mali95==5|v024_mali95==7|v024_mali95==6|v024_mali01==5|v024_mali01==7|v024_mali01==6|v024_mali06==5|v024_mali06==7|v024_mali06==6|v024_mali06==8|v024_mali12==5
replace v024_mali=4 if v024_mali87==4|v024_mali95==8|v024_mali01==8|v024_mali06==9|v024_mali12==9|v024_mali01==9
label define v024_mali 1 "kayes/koulikoro" 2 "sikasso/segou" 3 "mopti/gao/tomboucto" 4 "bamako"
label values v024_mali v024_mali

*appending datasets for NIGER: 1992; 1998; 2006; 2012
append using NIIR22DT.dta 
rename v024 v024_niger92
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger92 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using  NIIR31DT.dta 
rename v024 v024_niger98
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger92 v024_niger98 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using NIIR51dt.dta 
rename v024 v024_niger06
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger92 v024_niger98 v024_niger06 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using NIIR61DT.dta 
rename v024 v024_niger12
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali  v024_niger92 v024_niger98 v024_niger06 v024_niger12 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_niger=.
replace v024_niger=1 if v024_niger98==1|v024_niger92==1|v024_niger06==8|v024_niger12==8
replace v024_niger=2 if v024_niger98==2|v024_niger92==4|v024_niger06==3|v024_niger12==3
replace v024_niger=3 if v024_niger98==3|v024_niger92==5|v024_niger06==4|v024_niger12==1|v024_niger12==4
replace v024_niger=4 if v024_niger98==4|v024_niger92==6|v024_niger92==2|v024_niger06==1|v024_niger06==5|v024_niger12==5
replace v024_niger=5 if v024_niger98==5|v024_niger92==7|v024_niger06==6|v024_niger12==6
replace v024_niger=6 if v024_niger98==6|v024_niger92==3|v024_niger92==8|v024_niger06==2|v024_niger06==7|v024_niger12==2|v024_niger12==7
label define v024_niger 1 "niamey" 2 "dosso" 3 "maradi" 4 "tahoua/agadez" 5 "tillaberi" 6 "zinda/diffa"
label values v024_niger v024_niger

*appending datasets for NIGERIA: 1990; 2003; 2008; 2013
append using NGIR21DT.dta 
rename sstate v024_nigeria90
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria90 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using NGIR4BDT.dta 
rename v024 v024_nigeria03
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria90 v024_nigeria03 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using NGIR53DT 
rename v024 v024_nigeria08
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria90 v024_nigeria03 v024_nigeria08 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using NGIR6ADT.dta 
rename v024 v024_nigeria13
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria90 v024_nigeria03 v024_nigeria08 v024_nigeria13 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_nigeria=.
replace v024_nigeria=1 if v024_nigeria03==1|v024_nigeria08==1|v024_nigeria13==1|v024_nigeria90==6|v024_nigeria90==14|v024_nigeria90==16|v024_nigeria90==20|v024_nigeria90==1
replace v024_nigeria=2 if v024_nigeria03==2|v024_nigeria08==2|v024_nigeria13==2|v024_nigeria90==4|v024_nigeria90==7
replace v024_nigeria=3 if v024_nigeria03==3|v024_nigeria08==3|v024_nigeria13==3|v024_nigeria90==11|v024_nigeria90==12|v024_nigeria90==13|v024_nigeria90==22|v024_nigeria90==9
replace v024_nigeria=4 if v024_nigeria03==4|v024_nigeria08==4|v024_nigeria13==4|v024_nigeria90==3|v024_nigeria90==10
replace v024_nigeria=5 if v024_nigeria03==5|v024_nigeria08==5|v024_nigeria13==5|v024_nigeria90==2|v024_nigeria90==8|v024_nigeria90==21|v024_nigeria90==5
replace v024_nigeria=6 if v024_nigeria03==6|v024_nigeria08==6|v024_nigeria13==6|v024_nigeria90==17|v024_nigeria90==18|v024_nigeria90==19|v024_nigeria90==15

label define v024_nigeria 1 "north central" 2 "north east" 3 "north west" 4 "south east" 5 "south south" 6 "south west" 
label values v024_nigeria v024_nigeria

*appending datasets for TOGO: 1988; 1998; 2013
append using TGIR01DT.dta 
rename v101 v024_tog88
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog88 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using TGIR31DT.dta 
rename v024 v024_tog98
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog88 v024_tog98 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using TGIR61DT.dta 
rename v024 v024_tog13
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog88 v024_tog98 v024_tog13 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_tog=.
replace v024_tog=1 if v024_tog88==1|v024_tog98==1|v024_tog98==2|v024_tog13==1|v024_tog13==2
replace v024_tog=2 if v024_tog88==2|v024_tog98==3|v024_tog13==3
replace v024_tog=3 if v024_tog88==3|v024_tog98==4|v024_tog13==4
replace v024_tog=4 if v024_tog88==4|v024_tog98==5|v024_tog13==5
replace v024_tog=5 if v024_tog88==5|v024_tog98==6|v024_tog13==6
label define v024_tog 1 "maritime/LomŽ" 2 "plateaux" 3 "centrale"  4 "Kara" 5 "Savanes" 
label values v024_tog v024_tog

*appending datasets for ZAMBIA: 1992; 1996; 2001; 2007; 2013
append using ZMIR21DT.dta 
rename v024 v024_zam92
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam92 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using ZMIR31DT.dta 
rename v024 v024_zam96
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam92 v024_zam96 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using ZMIR42DT.dta 
rename v024 v024_zam01
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam92 v024_zam96 v024_zam01 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using ZMIR51DT.dta 
rename v024 v024_zam07
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam92 v024_zam96 v024_zam01 v024_zam07 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using ZMIR61DT.dta 
rename v024 v024_zam13
keep caseid v005 v001 v022 v025 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam92 v024_zam96  v024_zam01 v024_zam07  v024_zam13 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_zam=.
replace v024_zam=1 if v024_zam92==1|v024_zam96==1|v024_zam01==1|v024_zam07==1|v024_zam13==1
replace v024_zam=2 if v024_zam92==2|v024_zam96==2|v024_zam01==2|v024_zam07==2|v024_zam13==2
replace v024_zam=3 if v024_zam92==3|v024_zam96==3|v024_zam01==3|v024_zam07==3|v024_zam13==3
replace v024_zam=4 if v024_zam92==4|v024_zam96==4|v024_zam01==4|v024_zam07==4|v024_zam13==4
replace v024_zam=5 if v024_zam92==5|v024_zam96==5|v024_zam01==5|v024_zam07==5|v024_zam13==5
replace v024_zam=6 if v024_zam92==6|v024_zam96==6|v024_zam01==6|v024_zam07==6|v024_zam13==7|v024_zam13==6
replace v024_zam=7 if v024_zam92==7|v024_zam96==7|v024_zam01==7|v024_zam07==7|v024_zam13==8
replace v024_zam=8 if v024_zam92==8|v024_zam96==8|v024_zam01==8|v024_zam07==8|v024_zam13==9
replace v024_zam=9 if v024_zam92==9|v024_zam96==9|v024_zam01==9|v024_zam07==9|v024_zam13==10
label define v024_zam 1 "central" 2 "copperbelt" 3 "eastern" 4 "luapula" 5 "lusaka" 6 "northern" 7 "north-western" 8 "southern" 9 "western"
label values v024_zam v024_zam

*appending datasets for ZIMBABWE: 1988; 1994; 1999; 2005; 2010; 2015
append using ZWIR01DT.dta 
rename v101 v024_zim88
keep caseid v005 v001 v022 v025 sstrata v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim88 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using ZWIR31DT.dta 
rename v024 v024_zim94 
keep caseid v005 v001 v022 v025 sstrata v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim88 v024_zim94 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using ZWIR42DT.dta 
rename v024 v024_zim99
keep caseid v005 v001 v022 v025 sstrata v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim88 v024_zim94 v024_zim99 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using ZWIR52DT.dta 
rename v024 v024_zim05
keep caseid v005 v001 v022 v025 sstrata v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim88 v024_zim94 v024_zim99 v024_zim05 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using ZWIR62DT.dta 
rename v024 v024_zim10
keep caseid v005 v001 v022 v025 sstrata v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim88 v024_zim94 v024_zim99 v024_zim05 v024_zim10 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using ZWIR72DT.dta 
rename v024 v024_zim15
keep caseid v005 v001 v022 v025 sstrata v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim88  v024_zim94 v024_zim99 v024_zim05 v024_zim10 v024_zim15 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_zim=.
replace v024_zim=1 if v024_zim88==0|v024_zim94==1|v024_zim99==1|v024_zim05==1|v024_zim10==1|v024_zim15==1
replace v024_zim=2 if v024_zim88==1|v024_zim94==2|v024_zim99==2|v024_zim05==2|v024_zim10==2|v024_zim15==2
replace v024_zim=3 if v024_zim88==2|v024_zim94==3|v024_zim99==3|v024_zim05==3|v024_zim10==3|v024_zim15==3
replace v024_zim=4 if v024_zim88==3|v024_zim94==4|v024_zim99==4|v024_zim05==4|v024_zim10==4|v024_zim15==4
replace v024_zim=5 if v024_zim88==4|v024_zim94==5|v024_zim99==5|v024_zim05==5|v024_zim10==5|v024_zim15==5
replace v024_zim=6 if v024_zim88==5|v024_zim94==6|v024_zim99==6|v024_zim05==6|v024_zim10==6|v024_zim15==6
replace v024_zim=7 if v024_zim88==6|v024_zim94==7|v024_zim99==7|v024_zim05==7|v024_zim10==7|v024_zim15==7
replace v024_zim=8 if v024_zim88==7|v024_zim94==8|v024_zim99==8|v024_zim05==8|v024_zim10==8|v024_zim15==8
replace v024_zim=9 if v024_zim88==8|v024_zim94==9|v024_zim99==9|v024_zim05==9|v024_zim10==9|v024_zim15==9
replace v024_zim=10 if v024_zim88==9|v024_zim94==10|v024_zim99==10|v024_zim05==10|v024_zim10==10|v024_zim15==10
label define v024_zim 1 "manicaland" 2 "mashonaland central" 3 "mashonaland east" 4 "mashonaland west" 5 "matabeleland north" 6 "matabeleland south" 7 "midlands" 8 "masvingo" 9 "harare/chitungwiza" 10 "bulawayo"
label values v024_zim v024_zim 

*appending datasets for UGANDA: 1988; 1995; 2000; 2006; 2011 
append using UGIR01DT.dta 
rename v101 v024_uga88
keep caseid v005 v001 v022 v025 sstrata v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga88 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using UGIR33DT.dta 
rename v024 v024_uga95
keep caseid v005 v001 v022 v025 sstrata v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga88 v024_uga95 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using UGIR41DT.dta 
rename v024 v024_uga00
keep caseid v005 v001 v022 v025 sstrata v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga88 v024_uga95  v024_uga00 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using UGIR52DT.dta 
rename v024 v024_uga06
keep caseid v005 v001 v022 v025 sstrata v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga88 v024_uga95  v024_uga00 v024_uga06 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using UGIR60DT.dta 
rename v024 v024_uga11
keep caseid v005 v001 v022 v021 v025 sstrata v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga88 v024_uga95  v024_uga00 v024_uga06 v024_uga11 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_uga=.
replace v024_uga=1 if v024_uga95==1|v024_uga00==1|v024_uga06==1|v024_uga06==2|v024_uga06==3|v024_uga11==1|v024_uga11==2|v024_uga11==3|v024_uga88==6|v024_uga88==3
replace v024_uga=2 if v024_uga95==2|v024_uga00==2|v024_uga06==4|v024_uga06==5|v024_uga11==4|v024_uga11==5|v024_uga88==2
replace v024_uga=3 if v024_uga95==3|v024_uga00==3|v024_uga06==6|v024_uga06==7|v024_uga11==6|v024_uga11==7|v024_uga11==8|v024_uga88==1
replace v024_uga=4 if v024_uga95==4|v024_uga00==4|v024_uga06==8|v024_uga06==9|v024_uga11==9|v024_uga11==10|v024_uga88==5|v024_uga88==4

label define v024_uga 1 "central" 2 "eastern" 3 "northern" 4 "western" 
label values v024_uga v024_uga

*appending datasets for GHANA: 1988; 1993; 1998; 2003; 2008; 2014 
append using GHIR02DT.dta 
rename v101 v024_gha88
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha88 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using GHIR31DT.dta 
rename v024 v024_gha93
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha88 v024_gha93 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using GHIR41DT.dta 
rename v024 v024_gha98
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha88 v024_gha93 v024_gha98 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using GHIR4BDT.dta 
rename v024 v024_gha03
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha88 v024_gha93 v024_gha98 v024_gha03 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using GHIR5ADT.dta 
rename v024 v024_gha08
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha88 v024_gha93 v024_gha98 v024_gha03 v024_gha08 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using GHIR72DT.dta 
rename v024 v024_gha14
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha88 v024_gha93 v024_gha98 v024_gha03 v024_gha08 v024_gha14 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_gha=.
replace v024_gha=1 if v024_gha88==1|v024_gha93==1|v024_gha98==1|v024_gha03==1|v024_gha08==1|v024_gha14==1
replace v024_gha=2 if v024_gha88==2|v024_gha93==2|v024_gha98==2|v024_gha03==2|v024_gha08==2|v024_gha14==2
replace v024_gha=3 if v024_gha88==3|v024_gha93==3|v024_gha98==3|v024_gha03==3|v024_gha08==3|v024_gha14==3
replace v024_gha=4 if v024_gha88==4|v024_gha93==5|v024_gha98==5|v024_gha03==5|v024_gha08==5|v024_gha14==5
replace v024_gha=5 if v024_gha88==5|v024_gha93==4|v024_gha98==4|v024_gha03==4|v024_gha08==4|v024_gha14==4
replace v024_gha=6 if v024_gha88==6|v024_gha93==6|v024_gha98==6|v024_gha03==6|v024_gha08==6|v024_gha14==6
replace v024_gha=7 if v024_gha88==7|v024_gha93==7|v024_gha98==7|v024_gha03==7|v024_gha08==7|v024_gha14==7
replace v024_gha=8 if v024_gha88==8|v024_gha93==8|v024_gha93==9|v024_gha93==10|v024_gha98==8|v024_gha98==9|v024_gha98==10|v024_gha03==8|v024_gha03==9|v024_gha03==10|v024_gha08==8|v024_gha08==9|v024_gha08==10|v024_gha14==8|v024_gha14==9|v024_gha14==10

label define v024_gha 1 "western" 2 "central" 3 "greater accra" 4 "eastern" 5 "volta" 6 "ashanti" 7 "brong ahafo" 8 "upper w/e/north"
label values v024_gha v024_gha

*appending datasets for MADAGASCAR: 1992; 1997; 2003; 2008 
append using MDIR21DT.dta 
rename v024 v024_mad92
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad92 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using MDIR31DT.dta 
rename v024 v024_mad97
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad92 v024_mad97 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using MDIR42DT.dta 
rename v024 v024_mad03
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad92 v024_mad97 v024_mad03 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using MDIR51DT.dta 
rename v024 v024_mad08
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad92 v024_mad97 v024_mad03 v024_mad08 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_mad=.
replace v024_mad=1 if v024_mad92==1|v024_mad97==1|v024_mad03==1|v024_mad08==13|v024_mad08==11|v024_mad08==12|v024_mad08==14
replace v024_mad=2 if v024_mad92==2|v024_mad97==2|v024_mad03==2|v024_mad08==21|v024_mad08==22|v024_mad08==23|v024_mad08==24|v024_mad08==25
replace v024_mad=3 if v024_mad92==3|v024_mad97==3|v024_mad03==3|v024_mad08==31|v024_mad08==32|v024_mad08==33
replace v024_mad=4 if v024_mad92==4|v024_mad97==4|v024_mad03==4|v024_mad08==41|v024_mad08==42|v024_mad08==43|v024_mad08==44
replace v024_mad=5 if v024_mad92==5|v024_mad97==5|v024_mad03==5|v024_mad08==51|v024_mad08==52|v024_mad08==53|v024_mad08==54
replace v024_mad=6 if v024_mad92==6|v024_mad97==6|v024_mad03==7|v024_mad08==71|v024_mad08==72

label define v024_mad 1 "antananarivo" 2 "fianarantsoa" 3 "toamasina" 4 "mahajanga" 5 "toliary" 6 "antsiranana" 
label values v024_mad v024_mad

*appending datasets for TANZANIA: 1991; 1996; 1999; 2004; 2010; 2015
append using TZIR21DT.dta 
rename v024 v024_tan91
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan91 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using TZIR3ADT.dta 
rename v024 v024_tan96
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan91 v024_tan96 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using TZIR41DT.dta 
rename v024 v024_tan99
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan91 v024_tan96 v024_tan99 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using TZIR4IDT.dta 
rename v024 v024_tan04
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan91 v024_tan96 v024_tan99 v024_tan04 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using TZIR63DT.dta 
rename v024 v024_tan10
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan91 v024_tan96 v024_tan99 v024_tan04  v024_tan10 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using TZIR7BDT.dta 
rename v024 v024_tan15
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan91 v024_tan96 v024_tan99 v024_tan04 v024_tan10 v024_tan15 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_tan=.
replace v024_tan=1 if v024_tan91==1|v024_tan96==7|v024_tan96==4|v024_tan96==5|v024_tan96==6|v024_tan96==22|v024_tan96==21|v024_tan99==7|v024_tan99==4|v024_tan99==5|v024_tan99==6|v024_tan99==22|v024_tan99==21|v024_tan04==4|v024_tan04==5|v024_tan04==6|v024_tan04==7|v024_tan04==51|v024_tan04==52|v024_tan04==53|v024_tan04==54|v024_tan04==55|v024_tan10==4|v024_tan10==5|v024_tan10==6|v024_tan10==7|v024_tan10==51|v024_tan10==52|v024_tan10==53|v024_tan10==54|v024_tan10==55|v024_tan15==4|v024_tan15==5|v024_tan15==6|v024_tan15==7|v024_tan15==51|v024_tan15==52|v024_tan15==53|v024_tan15==54|v024_tan15==55
replace v024_tan=2 if v024_tan91==2|v024_tan96==2|v024_tan96==3|v024_tan99==2|v024_tan99==3|v024_tan04==2|v024_tan04==3|v024_tan04==21|v024_tan10==2|v024_tan10==3|v024_tan10==21|v024_tan15==2|v024_tan15==3|v024_tan15==21
replace v024_tan=3 if v024_tan91==3|v024_tan96==18|v024_tan96==19|v024_tan96==20|v024_tan96==17|v024_tan96==14|v024_tan96==16|v024_tan99==18|v024_tan99==19|v024_tan99==20|v024_tan99==17|v024_tan99==14|v024_tan99==16|v024_tan04==14|v024_tan04==17|v024_tan04==16|v024_tan04==18|v024_tan04==19|v024_tan04==20|v024_tan10==14|v024_tan10==17|v024_tan10==16|v024_tan10==18|v024_tan10==19|v024_tan10==20|v024_tan15==14|v024_tan15==17|v024_tan15==16|v024_tan15==18|v024_tan15==19|v024_tan15==20|v024_tan15==24|v024_tan15==25
replace v024_tan=4 if v024_tan91==4|v024_tan96==1|v024_tan96==13|v024_tan99==1|v024_tan99==13|v024_tan04==1|v024_tan04==13|v024_tan10==1|v024_tan10==13|v024_tan15==1|v024_tan15==13
replace v024_tan=5 if v024_tan91==5|v024_tan96==11|v024_tan96==12|v024_tan96==15|v024_tan99==11|v024_tan99==12|v024_tan99==15|v024_tan04==11|v024_tan04==12|v024_tan04==15|v024_tan10==11|v024_tan10==12|v024_tan10==15|v024_tan15==11|v024_tan15==12|v024_tan15==15|v024_tan15==22|v024_tan15==23
replace v024_tan=6 if v024_tan91==6|v024_tan96==8|v024_tan96==9|v024_tan96==10|v024_tan99==8|v024_tan99==9|v024_tan99==10|v024_tan04==8|v024_tan04==9|v024_tan04==10|v024_tan10==8|v024_tan10==9|v024_tan10==10|v024_tan15==8|v024_tan15==9|v024_tan15==10

label define v024_tan 1 "coastal" 2 "northern highlands" 3 "lake" 4 "central" 5 "southern highlands" 6 "south"
label values v024_tan v024_tan

*appending datasets for NAMIBIA: 1992; 2000; 2006; 2013
append using NMIR21DT.dta 
rename v024 v024_nam92
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam92 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using NMIR41DT.dta 
rename v024 v024_nam00
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam92 v024_nam00 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using NMIR51DT.dta 
rename v024 v024_nam06
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam92 v024_nam00 v024_nam06 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using NMIR61DT.dta 
rename v024 v024_nam13
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad  v024_tan v024_nam92 v024_nam00 v024_nam06 v024_nam13 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_nam=.
replace v024_nam=1 if v024_nam92==1|v024_nam00==10|v024_nam00==11|v024_nam00==7|v024_nam00==12|v024_nam06==10|v024_nam06==11|v024_nam06==8|v024_nam06==12|v024_nam13==10|v024_nam13==11|v024_nam13==8|v024_nam13==12
replace v024_nam=2 if v024_nam92==2|v024_nam00==1|v024_nam00==8|v024_nam06==1|v024_nam06==5|v024_nam13==1|v024_nam13==5
replace v024_nam=3 if v024_nam92==3|v024_nam00==6|v024_nam00==13|v024_nam00==2|v024_nam00==9|v024_nam06==7|v024_nam06==13|v024_nam06==2|v024_nam06==9|v024_nam13==7|v024_nam13==13|v024_nam13==2|v024_nam13==9
replace v024_nam=4 if v024_nam92==4|v024_nam00==4|v024_nam00==3|v024_nam00==5|v024_nam06==4|v024_nam06==3|v024_nam06==6|v024_nam13==4|v024_nam13==3|v024_nam13==6

label define v024_nam 1 "northwest" 2 "northeast" 3 "central" 4 "south"
label values v024_nam v024_nam

*appending datasets for COTE D'IVOIRE: 1994; 1998; 2011
append using CIIR35DT.dta 
rename v024 v024_cot94
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot94 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using CIIR3ADT.dta 
rename sdept v024_cot98
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot94 v024_cot98 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using CIIR62DT.dta 
rename v024 v024_cot11
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot94 v024_cot98 v024_cot11 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_cot=.
replace v024_cot=1 if v024_cot94==1|v024_cot98==11|v024_cot98==19|v024_cot98==20|v024_cot98==33|v024_cot98==47|v024_cot98==49|v024_cot98==57|v024_cot11==1
replace v024_cot=2 if v024_cot94==2|v024_cot98==8|v024_cot98==13|v024_cot98==28|v024_cot98==36|v024_cot11==3
replace v024_cot=3 if v024_cot94==3|v024_cot98==10|v024_cot98==14|v024_cot98==43|v024_cot11==6
replace v024_cot=4 if v024_cot94==4|v024_cot98==1|v024_cot98==16|v024_cot11==2
replace v024_cot=5 if v024_cot94==5|v024_cot98==2|v024_cot98==3|v024_cot98==4|v024_cot98==5|v024_cot98==21|v024_cot98==24|v024_cot98==30|v024_cot98==35|v024_cot98==45|v024_cot98==52|v024_cot98==54|v024_cot98==55|v024_cot98==56|v024_cot11==9|v024_cot11==11
replace v024_cot=6 if v024_cot94==6|v024_cot98==37|v024_cot98==41|v024_cot11==10
replace v024_cot=7 if v024_cot94==7|v024_cot98==12|v024_cot98==17|v024_cot98==27|v024_cot98==40|v024_cot98==48|v024_cot11==4
replace v024_cot=8 if v024_cot94==8|v024_cot98==9|v024_cot98==18|v024_cot98==22|v024_cot98==26|v024_cot98==31|v024_cot11==8
replace v024_cot=9 if v024_cot94==9|v024_cot98==32|v024_cot98==34|v024_cot98==39|v024_cot98==46|v024_cot11==7
replace v024_cot=10 if v024_cot94==10|v024_cot98==23|v024_cot98==29|v024_cot98==44|v024_cot11==5

label define v024_cot 1 "center" 2 "center north" 3 "north east" 4 "center east" 5 "south" 6 "south west" 7 "center west" 8 "west" 9 "north west" 10 "north"
label values v024_cot v024_cot

*appending datasets for LIBERIA: 1986; 2007; 2013
append using LBIR01DT.DTA 
rename scounty v024_lib86
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib86 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using LBIR51DT.dta 
rename v024 v024_lib07
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib07 v024_lib86 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using LBIR6ADT.dta 
rename v024 v024_lib13
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib07 v024_lib86 v024_lib13 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_lib=.
replace v024_lib=1 if v024_lib13==1|v024_lib86==1|v024_lib86==4|v024_lib86==7|v024_lib07==2
replace v024_lib=2 if v024_lib13==2|v024_lib86==3|v024_lib86==8|v024_lib86==10|v024_lib07==1|v024_lib07==3
replace v024_lib=3 if v024_lib13==3|v024_lib86==5|v024_lib86==12|v024_lib86==14|v024_lib07==4
replace v024_lib=4 if v024_lib13==4|v024_lib86==6|v024_lib86==9|v024_lib07==5
replace v024_lib=5 if v024_lib13==5|v024_lib86==2|v024_lib86==11|v024_lib07==6
label define v024_lib 1 "north western" 2 "south central" 3 "south eastern A" 4 "south eastern B" 5 "north central"
label values v024_lib v024_lib

*appending datasets for RWANDA: 1992; 2000; 2005; 2010; 2014
append using RWIR21DT.dta 
rename spref v024_rwa92
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa92 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using RWIR41DT.dta 
rename v024 v024_rwa00
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa92 v024_rwa00 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using RWIR53DT.dta 
rename v024 v024_rwa05
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa92 v024_rwa00 v024_rwa05 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using RWIR61DT.dta 
rename v024 v024_rwa10
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa92 v024_rwa00 v024_rwa05 v024_rwa10 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using RWIR70DT.dta 
rename v024 v024_rwa14
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa92 v024_rwa00 v024_rwa05 v024_rwa10 v024_rwa14 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_rwa=.
replace v024_rwa=1 if v024_rwa10==1|v024_rwa14==1|v024_rwa05==1|v024_rwa00==9|v024_rwa92==10
replace v024_rwa=2 if v024_rwa10==2|v024_rwa14==2|v024_rwa05==3|v024_rwa05==4|v024_rwa05==5|v024_rwa00==1|v024_rwa00==4|v024_rwa00==6|v024_rwa92==1|v024_rwa92==4|v024_rwa92==6
replace v024_rwa=3 if v024_rwa10==3|v024_rwa14==3|v024_rwa05==6|v024_rwa05==7|v024_rwa05==8|v024_rwa00==3|v024_rwa00==5|v024_rwa00==8|v024_rwa92==3|v024_rwa92==5|v024_rwa92==8
replace v024_rwa=4 if v024_rwa10==4|v024_rwa14==4|v024_rwa05==9|v024_rwa05==10|v024_rwa00==2|v024_rwa00==11|v024_rwa92==2|v024_rwa92==11
replace v024_rwa=5 if v024_rwa10==5|v024_rwa14==5|v024_rwa05==2|v024_rwa05==11|v024_rwa05==12|v024_rwa00==7|v024_rwa00==12|v024_rwa00==10|v024_rwa92==7|v024_rwa92==9
label define v024_rwa 1 "Kigali city" 2 "south" 3 "west" 4 "north" 5 "east"
label values v024_rwa v024_rwa

*appending datasets for SENEGAL: 1986; 1992; 1997; 2005; 2010
append using SNIR02DT.dta 
rename v101 v024_sen86
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen86 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using SNIR21DT.dta 
rename v024 v024_sen92
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen86 v024_sen92 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using SNIR32DT.dta 
rename v024 v024_sen97
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen86 v024_sen92 v024_sen97 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using SNIR4ADT.dta 
rename v024 v024_sen05
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen86 v024_sen92 v024_sen97 v024_sen05 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using SNIR61DT.dta 
rename v024 v024_sen10
keep caseid v005 v001 v022 v021 v025 sstrata s001 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen86 v024_sen92 v024_sen97 v024_sen05 v024_sen10 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_sen=.
replace v024_sen=1 if v024_sen92==1|v024_sen97==1|v024_sen86==1|v024_sen05==1|v024_sen05==10|v024_sen10==1|v024_sen10==7
replace v024_sen=2 if v024_sen92==2|v024_sen97==2|v024_sen86==2|v024_sen05==2|v024_sen05==3|v024_sen05==4|v024_sen10==3|v024_sen10==6|v024_sen10==8|v024_sen10==9|v024_sen10==12|v024_sen05==6
replace v024_sen=3 if v024_sen92==3|v024_sen97==3|v024_sen86==4|v024_sen05==5|v024_sen05==11|v024_sen10==2|v024_sen10==10|v024_sen10==14
replace v024_sen=4 if v024_sen92==4|v024_sen97==4|v024_sen86==3 |v024_sen05==7|v024_sen05==8|v024_sen10==4|v024_sen10==5|v024_sen10==11|v024_sen10==13|v024_sen05==9
label define v024_sen 1 "West" 2 "central" 3 "south" 4 "north east"
label values v024_sen v024_sen

*appending datasets for BURKINA FASO: 1993; 1998; 2003; 2010 
append using BFIR21DT.dta 
rename sprov v024_bfa93
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bfa93 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using BFIR31DT.dta 
rename sprov v024_bfa98
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bfa93 v024_bfa98 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using BFIR43DT.dta 
rename v024 v024_bfa03
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bfa93 v024_bfa98 v024_bfa03 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using BFIR62DT.dta 
rename v024 v024_bfa10
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bfa93 v024_bfa98 v024_bfa03 v024_bfa10 v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

gen v024_bf=.
replace v024_bf=1 if v024_bfa10==1|v024_bfa03==2|v024_bfa98==13|v024_bfa98==15|v024_bfa98==27|v024_bfa98==31|v024_bfa98==32|v024_bfa98==40|v024_bfa93==13|v024_bfa93==15|v024_bfa93==27
replace v024_bf=2 if v024_bfa10==2|v024_bfa03==11|v024_bfa98==6|v024_bfa93==6
replace v024_bf=3 if v024_bfa10==3|v024_bfa03==1|v024_bfa03==3|v024_bfa98==11|v024_bfa93==11
replace v024_bf=4 if v024_bfa10==4|v024_bfa03==6|v024_bfa98==4|v024_bfa98==14|v024_bfa98==36|v024_bfa93==4|v024_bfa93==14
replace v024_bf=5 if v024_bfa10==5|v024_bfa03==7|v024_bfa98==1|v024_bfa98==17|v024_bfa98==23|v024_bfa93==1|v024_bfa93==17|v024_bfa93==23
replace v024_bf=6 if v024_bfa10==6|v024_bfa03==8|v024_bfa98==5|v024_bfa98==25|v024_bfa98==44|v024_bfa98==22|v024_bfa93==5|v024_bfa93==22|v024_bfa93==25
replace v024_bf=7 if v024_bfa10==7|v024_bfa03==4|v024_bfa98==2|v024_bfa98==16|v024_bfa98==30|v024_bfa93==2|v024_bfa93==16|v024_bfa93==30
replace v024_bf=8 if v024_bfa10==8|v024_bfa03==9|v024_bfa98==8|v024_bfa98==9|v024_bfa98==28|v024_bfa93==8|v024_bfa93==9|v024_bfa93==28
replace v024_bf=9 if v024_bfa10==9|v024_bfa03==12|v024_bfa98==10|v024_bfa98==12|v024_bfa93==10|v024_bfa93==12
replace v024_bf=10 if v024_bfa10==10|v024_bfa03==10|v024_bfa98==20|v024_bfa98==29|v024_bfa98==39|v024_bfa98==45|v024_bfa93==20|v024_bfa93==29
replace v024_bf=11 if v024_bfa10==11|v024_bfa03==5|v024_bfa98==7|v024_bfa98==18|v024_bfa98==37|v024_bfa93==7|v024_bfa93==18
replace v024_bf=12 if v024_bfa10==12|v024_bfa03==13|v024_bfa98==19|v024_bfa98==24|v024_bfa98==26|v024_bfa98==43|v024_bfa93==19|v024_bfa93==24|v024_bfa93==26
replace v024_bf=13 if v024_bfa10==13|v024_bfa03==14|v024_bfa98==21|v024_bfa98==33|v024_bfa93==3|v024_bfa93==21
tab1 v000 v024_bf
label define v024_bf 1 "boucle de mouhon" 2 "cascades" 3 "centre" 4 "centre-est" 5 "centre-nord" 6 "centre-ouest" 7 "centre-sud" 8 "est" 9 "hauts basins" 10 "nord" 11 "plateau central" 12 "sahel" 13 "sud-ouest"  
label values v024_bf v024_bf

**Appending additional countries in S1 
append using AOIR71FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using BUIR70FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using TDIR71FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using KMIR61FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using CGIR60FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using CDIR61FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using szir51fl.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using ETIR70FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using GAIR60FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using GMIR60FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using GNIR62FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using LSIR71FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using MZIR62FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using STIR50FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using SLIR61FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

append using ZAIR71FL.dta
keep caseid v005 v001 v022 v021 v025 sstrata s001 v021 v201 v011 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf v000 v007 v006 v012 b1_01-b1_20 b2_01-b2_20 b7_01-b7_20 b8_01-b8_20 v190

tab1 v024_ben v024_cam v024_ken v024_mal v024_mali v024_niger v024_nigeria v024_tog v024_zam v024_zim v024_uga v024_gha v024_mad v024_tan v024_nam v024_cot v024_lib v024_rwa v024_sen v024_bf

/* Numbering regions to allow for generation of region-year indicator to plot mIM, mU5M, and mOM by country, region, and year */
gen region=0
**Benin
replace region=101 if v024_ben==1
replace region=102 if v024_ben==2
replace region=103 if v024_ben==3
replace region=104 if v024_ben==4
replace region=105 if v024_ben==5
replace region=106 if v024_ben==6
***Cameroon 
replace region=107 if v024_cam==1
replace region=108 if v024_cam==2
replace region=109 if v024_cam==3
replace region=110 if v024_cam==4
replace region=111 if v024_cam==5
***Kenya 
replace region=112 if v024_ken==1
replace region=113 if v024_ken==2
replace region=114 if v024_ken==3
replace region=115 if v024_ken==4
replace region=116 if v024_ken==5
replace region=117 if v024_ken==6
replace region=118 if v024_ken==7
replace region=119 if v024_ken==8
***Malawi 
replace region=120 if v024_mal==1
replace region=121 if v024_mal==2
replace region=122 if v024_mal==3
***Mali
replace region=123 if v024_mali==1
replace region=124 if v024_mali==2
replace region=125 if v024_mali==3
replace region=126 if v024_mali==4
**Niger 
replace region=127 if v024_niger==1
replace region=128 if v024_niger==2
replace region=129 if v024_niger==3
replace region=130 if v024_niger==4
replace region=131 if v024_niger==5
replace region=132 if v024_niger==6
***Nigeria 
replace region=133 if v024_nigeria==1
replace region=134 if v024_nigeria==2
replace region=135 if v024_nigeria==3
replace region=136 if v024_nigeria==4
replace region=137 if v024_nigeria==5
replace region=138 if v024_nigeria==6
**Togo
replace region=139 if v024_tog==1
replace region=140 if v024_tog==2
replace region=141 if v024_tog==3
replace region=142 if v024_tog==4
replace region=143 if v024_tog==5
**Zambia 
replace region=144 if v024_zam==1
replace region=145 if v024_zam==2
replace region=146 if v024_zam==3
replace region=147 if v024_zam==4
replace region=148 if v024_zam==5
replace region=149 if v024_zam==6
replace region=150 if v024_zam==7
replace region=151 if v024_zam==8
replace region=152 if v024_zam==9
**Zimbabwe 
replace region=153 if v024_zim==1
replace region=154 if v024_zim==2
replace region=155 if v024_zim==3
replace region=156 if v024_zim==4
replace region=157 if v024_zim==5
replace region=158 if v024_zim==6
replace region=159 if v024_zim==7
replace region=160 if v024_zim==8
replace region=161 if v024_zim==9
replace region=162 if v024_zim==10
**Uganda
replace region=163 if v024_uga==1
replace region=164 if v024_uga==2
replace region=165 if v024_uga==3
replace region=166 if v024_uga==4
***Ghana 
replace region=167 if v024_gha==1
replace region=168 if v024_gha==2
replace region=169 if v024_gha==3
replace region=170 if v024_gha==4
replace region=171 if v024_gha==5
replace region=172 if v024_gha==6
replace region=173 if v024_gha==7
replace region=174 if v024_gha==8
**Madagascar 
replace region=175 if v024_mad==1
replace region=176 if v024_mad==2
replace region=177 if v024_mad==3
replace region=178 if v024_mad==4
replace region=179 if v024_mad==5
replace region=180 if v024_mad==6
**Tanzania 
replace region=181 if v024_tan==1
replace region=182 if v024_tan==2
replace region=183 if v024_tan==3
replace region=184 if v024_tan==4
replace region=185 if v024_tan==5
replace region=186 if v024_tan==6
***Namibia 
replace region=187 if v024_nam==1
replace region=188 if v024_nam==2
replace region=189 if v024_nam==3
replace region=190 if v024_nam==4
**Cote d'Ivoire
replace region=191 if v024_cot==1
replace region=192 if v024_cot==2
replace region=193 if v024_cot==3
replace region=194 if v024_cot==4
replace region=195 if v024_cot==5
replace region=196 if v024_cot==6
replace region=197 if v024_cot==7
replace region=198 if v024_cot==8
replace region=199 if v024_cot==9
replace region=200 if v024_cot==10
**Liberia 
replace region=201 if v024_lib==1
replace region=202 if v024_lib==2
replace region=203 if v024_lib==3
replace region=204 if v024_lib==4
replace region=205 if v024_lib==5
***Rwanda
replace region=206 if v024_rwa==1
replace region=207 if v024_rwa==2
replace region=208 if v024_rwa==3
replace region=209 if v024_rwa==4
replace region=210 if v024_rwa==5
**Senegal 
replace region=211 if v024_sen==1
replace region=212 if v024_sen==2
replace region=213 if v024_sen==3
replace region=214 if v024_sen==4
***Burkina Faso
replace region=215 if v024_bf==1
replace region=216 if v024_bf==2
replace region=217 if v024_bf==3
replace region=218 if v024_bf==4
replace region=219 if v024_bf==5
replace region=220 if v024_bf==6
replace region=221 if v024_bf==7
replace region=222 if v024_bf==8
replace region=223 if v024_bf==9
replace region=224 if v024_bf==10
replace region=225 if v024_bf==11
replace region=226 if v024_bf==12
replace region=227 if v024_bf==13

/* Generating numerical ID for countries */
gen country=. 
replace country=1  if v000=="BF2"|v000=="BF3"|v000=="BF4"|v000=="BF6"
replace country=2  if v000=="BJ3"|v000=="BJ4"|v000=="BJ5"|v000=="BJ6"
replace country=3  if v000=="CI3"|v000=="CI6"
replace country=4  if v000=="CM2"|v000=="CM3"|v000=="CM4"|v000=="CM6"
replace country=5 if v000=="GH"|v000=="GH2"|v000=="GH3"|v000=="GH4"|v000=="GH5"|v000=="GH6"
replace country=6 if v000=="KE"|v000=="KE2"|v000=="KE3"|v000=="KE4"|v000=="KE5"|v000=="KE6"
replace country=7 if v000=="LB"|v000=="LB5"|v000=="LB6"
replace country=8 if v000=="MD2"|v000=="MD3"|v000=="MD4"|v000=="MD5"
replace country=9 if v000=="ML"|v000=="ML3"|v000=="ML4"|v000=="ML5"|v000=="ML6"
replace country=10 if v000=="MW2"|v000=="MW4"|v000=="MW5"|v000=="MW7"
replace country=11 if v000=="NG2"|v000=="NG4"|v000=="NG5"|v000=="NG6"
replace country=12 if v000=="NI2"|v000=="NI3"|v000=="NI5"|v000=="NI6"
replace country=13 if v000=="NM2"|v000=="NM4"|v000=="NM5"|v000=="NM6"
replace country=14 if v000=="RW2"|v000=="RW4"|v000=="RW6"
replace country=15 if v000=="SN"| v000=="SN2"|v000=="SN4"|v000=="SN6"
replace country=16 if v000=="TG"|v000=="TG3"|v000=="TG6"
replace country=17 if v000=="TZ2"|v000=="TZ3"|v000=="TZ4"|v000=="TZ5"|v000=="TZ7"
replace country=18 if v000=="UG"|v000=="UG3"|v000=="UG4"|v000=="UG5"|v000=="UG6"
replace country=19 if v000=="ZM2"|v000=="ZM3"|v000=="ZM4"|v000=="ZM5"|v000=="ZM6"
replace country=20 if v000=="ZW"|v000=="ZW3"|v000=="ZW4"|v000=="ZW5"|v000=="ZW6"|v000=="ZW7"
replace country=21 if v000=="AO7"
replace country=22 if v000=="BU7" 
replace country=23 if v000=="CD6"
replace country=24 if v000=="CG6"
replace country=25 if v000=="ET7"
replace country=26 if v000=="GA6"
replace country=27 if v000=="GM6"
replace country=28 if v000=="GN6"
replace country=29 if v000=="KM6"
replace country=30 if v000=="LS6"
replace country=31 if v000=="MZ6"
replace country=32 if v000=="SL6"
replace country=33 if v000=="ST5"
replace country=34 if v000=="SZ5"
replace country=35 if v000=="TD6"
replace country=36 if v000=="ZA7"

/* Generating country names for each country */
gen countryname=""
replace countryname="Burkina Faso"  if v000=="BF2"|v000=="BF3"|v000=="BF4"|v000=="BF6"
replace countryname="Benin" if v000=="BJ3"|v000=="BJ4"|v000=="BJ5"|v000=="BJ6"
replace countryname="Cote d'Ivoire" if v000=="CI3"|v000=="CI6"
replace countryname="Cameroon" if v000=="CM2"|v000=="CM3"|v000=="CM4"|v000=="CM6"
replace countryname="Ghana" if v000=="GH"|v000=="GH2"|v000=="GH3"|v000=="GH4"|v000=="GH5"|v000=="GH6"
replace countryname="Kenya" if v000=="KE"|v000=="KE2"|v000=="KE3"|v000=="KE4"|v000=="KE5"|v000=="KE6"
replace countryname="Liberia" if v000=="LB"|v000=="LB5"|v000=="LB6"
replace countryname="Madagascar" if v000=="MD2"|v000=="MD3"|v000=="MD4"|v000=="MD5"
replace countryname="Mali" if v000=="ML"|v000=="ML3"|v000=="ML4"|v000=="ML5"|v000=="ML6"
replace countryname="Malawi" if v000=="MW2"|v000=="MW4"|v000=="MW5"|v000=="MW7"
replace countryname="Nigeria" if v000=="NG2"|v000=="NG4"|v000=="NG5"|v000=="NG6"
replace countryname="Niger" if v000=="NI2"|v000=="NI3"|v000=="NI5"|v000=="NI6"
replace countryname="Namibia" if v000=="NM2"|v000=="NM4"|v000=="NM5"|v000=="NM6"
replace countryname="Rwanda" if v000=="RW2"|v000=="RW4"|v000=="RW6"
replace countryname="Senegal" if v000=="SN"| v000=="SN2"|v000=="SN4"|v000=="SN6"
replace countryname="Togo" if v000=="TG"|v000=="TG3"|v000=="TG6"
replace countryname="Tanzania" if v000=="TZ2"|v000=="TZ3"|v000=="TZ4"|v000=="TZ5"|v000=="TZ7"
replace countryname="Uganda" if v000=="UG"|v000=="UG3"|v000=="UG4"|v000=="UG5"|v000=="UG6"
replace countryname="Zambia" if v000=="ZM2"|v000=="ZM3"|v000=="ZM4"|v000=="ZM5"|v000=="ZM6"
replace countryname="Zimbabwe" if v000=="ZW"|v000=="ZW3"|v000=="ZW4"|v000=="ZW5"|v000=="ZW6"|v000=="ZW7"
replace countryname="Angola" if v000=="AO7"
replace countryname="Burundi" if v000=="BU7"
replace countryname="Congo Democratic Republic" if v000=="CD6"
replace countryname="Congo" if v000=="CG6"
replace countryname="Ethiopia" if v000=="ET7"
replace countryname="Gabon" if v000=="GA6"
replace countryname="Gambia" if v000=="GM6"
replace countryname="Guinea" if v000=="GN6"
replace countryname="Comoros" if v000=="KM6"
replace countryname="Lesotho" if v000=="LS6"
replace countryname="Mozambique" if v000=="MZ6"
replace countryname="Sierra Leone" if v000=="SL6"
replace countryname="Sao Tome Principe" if v000=="ST5"
replace countryname="Eswatini" if v000=="SZ5"
replace countryname="Chad" if v000=="TD6"
replace countryname="South Africa" if v000=="ZA7"

/* Generating four digit year indicators for the year the survey was conducted */
recode v007 99=1999 98=1998 97=1997 96=1996 95=1995 94=1994 93=1993 92=1992 91=1991 90=1990 ///
89=1989 88=1988 87=1987 86=1986 85=1985 84=1984 83=1983 82=1982 81=1981 80=1980 ///
79=1979 78=1978 77=1977 76=1976 75=1975 74=1974 73=1973 72=1972 71=1971 70=1979 ///
69=1969 68=1968 67=1967 66=1966 65=1965 64=1964 63=1963 62=1962 61=1961 60=1960 ///
59=1959 58=1958 57=1957 56=1956 55=1955 54=1954 53=1953 52=1952 51=1951 50=1950 ///
49=1949 48=1948 

/*Standardizing the year of the interview for countries where a single round of data collection occured over two separate years. 
this allows for creation of a "country year" indicator for each wave of data collection */
replace v007=1992 if countryname=="Burkina Faso" & v007==1993
replace v007=1998 if countryname=="Burkina Faso" & v007==1999
replace v007=2004 if countryname=="Malawi" & v007==2005
replace v007=2015 if countryname=="Malawi" & v007==2016
replace v007=2006 if countryname=="Namibia" & v007==2007
replace v007=2010 if countryname=="Rwanda" & v007==2011
replace v007=2014 if countryname=="Rwanda" & v007==2015
replace v007=1992 if countryname=="Senegal" & v007==1993
replace v007=2010 if countryname=="Senegal" & v007==2011
replace v007=2013 if countryname=="Togo" & v007==2014
replace v007=1991 if countryname=="Tanzania" & v007==1992
replace v007=2004 if countryname=="Tanzania" & v007==2005
replace v007=2009 if countryname=="Tanzania" & v007==2010
replace v007=2015 if countryname=="Tanzania" & v007==2016
replace v007=1988 if countryname=="Uganda" & v007==1989
replace v007=2000 if countryname=="Uganda" & v007==2001
replace v007=1996 if countryname=="Zambia" & v007==1997
replace v007=2001 if countryname=="Zambia" & v007==2002
replace v007=2013 if countryname=="Zambia" & v007==2014
replace v007=1988 if countryname=="Zimbabwe" & v007==1989
replace v007=2005 if countryname=="Zimbabwe" & v007==2006
replace v007=2010 if countryname=="Zimbabwe" & v007==2011
replace v007=2011 if countryname=="Benin" & v007==2012
replace v007=1998 if countryname=="Cote d'Ivoire" & v007==1999
replace v007=2011 if countryname=="Cote d'Ivoire" & v007==2012
replace v007=1993 if countryname=="Ghana" & v007==1994
replace v007=1998 if countryname=="Ghana" & v007==1999
replace v007=1988 if countryname=="Kenya" & v007==1989
replace v007=2008 if countryname=="Kenya" & v007==2009
replace v007=2003 if countryname=="Madagascar" & v007==2004
replace v007=2008 if countryname=="Madagascar" & v007==2009
replace v007=1995 if countryname=="Mali" & v007==1996
replace v007=2012 if countryname=="Mali" & v007==2013
replace v007=2006 if countryname=="Liberia" & v007==2007
replace v007=2015 if country==21 & v007==2016
replace v007=2016 if country==22 & v007==2017
replace v007=2013 if country==23 & v007==2014
replace v007=2011 if country==24 & v007==2012
replace v007=2008 if country==33 & v007==2009
replace v007=2006 if country==34 & v007==2007
replace v007=2014 if country==35 & v007==2015

/* Removing leading zeros to enable loops to run below */
rename b2_01 b2_1
rename b2_02 b2_2
rename b2_03 b2_3
rename b2_04 b2_4
rename b2_05 b2_5
rename b2_06 b2_6
rename b2_07 b2_7
rename b2_08 b2_8
rename b2_09 b2_9
*
rename b1_01 b1_1
rename b1_02 b1_2
rename b1_03 b1_3
rename b1_04 b1_4
rename b1_05 b1_5
rename b1_06 b1_6
rename b1_07 b1_7
rename b1_08 b1_8
rename b1_09 b1_9
*
rename b7_01 b7_1
rename b7_02 b7_2
rename b7_03 b7_3
rename b7_04 b7_4
rename b7_05 b7_5
rename b7_06 b7_6
rename b7_07 b7_7
rename b7_08 b7_8
rename b7_09 b7_9
*
rename b8_01 b8_1
rename b8_02 b8_2
rename b8_03 b8_3
rename b8_04 b8_4
rename b8_05 b8_5
rename b8_06 b8_6
rename b8_07 b8_7
rename b8_08 b8_8
rename b8_09 b8_9

/* Generating four digit year indicators for the year the child was born */
forv i=1/20 {
recode b2_`i' 99=1999 ///
98=1998 97=1997 96=1996 95=1995 94=1994 93=1993 92=1992 91=1991 90=1990 ///
89=1989 88=1988 87=1987 86=1986 85=1985 84=1984 83=1983 82=1982 81=1981 80=1980 ///
79=1979 78=1978 77=1977 76=1976 75=1975 74=1974 73=1973 72=1972 71=1971 70=1979 ///
69=1969 68=1968 67=1967 66=1966 65=1965 64=1964 63=1963 62=1962 61=1961 60=1960 ///
59=1959 58=1958 57=1957 56=1956 55=1955 54=1954 53=1953 52=1952 51=1951 50=1950 ///
49=1949 48=1948 
} 

/* Generating century month for child's date of birth */
forv i=1/20 {
gen cbirth_`i' = ym(b2_`i', b1_`i')
}
/* Creating century month indicator for child's date of death based on birth and age at time of death */
forv i=1/20 {
gen cdeath_`i' = cbirth_`i' + b7_`i'
}
/* Creating century month for date of survey */ 
gen survey = ym(v007, v006)

/* Recording century month of first death */
egen firstdeath = rowmin(cdeath_1-cdeath_20)

/* Creating an indicator for total number of child losses */
egen totaldeaths=rownonmiss(cdeath_1-cdeath_20)

/* Creating indicator that captures only under-five deaths */
forv i=1/20 {
gen ufdeath_`i'= cdeath_`i'
}
forv i=1/20 {
replace ufdeath_`i'=. if b7_`i'>=59
}

/* Creating indicator that captures only infant deaths */
forv i=1/20 {
gen imdeath_`i'= cdeath_`i'
}
forv i=1/20 {
replace imdeath_`i'=. if b7_`i'>=12
}

/* Creating an indicator for whether mother has ever had child die */
gen everdie = totaldeaths 
recode everdie 2/15=1

/* Creating an indicator for whether mother has ever had under-five year old child die */
egen firstunderfivedeath = rowmin(ufdeath_1-ufdeath_20)
gen everunderfivedie = firstunderfivedeath 
replace everunderfivedie = 1 if everunderfivedie!=. 
recode everunderfivedie .=0

/* Creating an indicator for whether mother has ever had infant die */
egen firstinfantdeath = rowmin(imdeath_1-imdeath_20)
gen everinfantdie = firstinfantdeath
replace everinfantdie = 1 if everinfantdie!=. 
recode everinfantdie .=0

/* Creating indicator for mother's age at the time of the survey, and excluding women out of study age range */
gen momcurrentage=v012
drop if momcurrentage<=14
drop if momcurrentage>=50 

/*Dropping all childless women given they are not included in analyses */
drop if v201==0

save Smith-GreenawayTrinitapoliPNAS2020data.dta , replace

