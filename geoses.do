clear all
set more off
/* 
•	Input: bene_geo_YYYY.dta, 02-13. zcta2010tozip.dta. acs_educ_65up.dta, ACS_Income.dta
•	Output: geoses_0613.dta, geoses_0713.dta, geoses_long0713.dta. geoses_0213.dta. geoses_long0213.dta
•	Merges geo files, makes geographic control variables, and merges in education and income at the zip5 level. 
*/
/*
////////////////////////////////////////////////////////////////////////////////
/////////////////	GEOGRAPHY WIDE 02-13   /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//import these in reverse order, to give priority to geographic readings from earlier in the panel
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2013.dta", clear
keep bene_id fips_state fips_county zip3 zip5
tempfile geo
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2012.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2011.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2010.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2009.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2008.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2007.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2006.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2005.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2004.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2003.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2002.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m

//census regions
//NE 1, MW 2, S 3, W 4, O 5
gen cen4 = .
replace cen4 = 3 if fips_state=="01"  	//AL
replace cen4 = 4 if fips_state=="02"  	//AK
										//AS
replace cen4 = 4 if fips_state=="04"  	//AZ
replace cen4 = 3 if fips_state=="05"  	//AR
replace cen4 = 4 if fips_state=="06"	//CA	
										//CZ
replace cen4 = 4 if fips_state=="08"	//CO
replace cen4 = 1 if fips_state=="09"	//CT
replace cen4 = 3 if fips_state=="10"	//DE
replace cen4 = 3 if fips_state=="11"	//DC
replace cen4 = 3 if fips_state=="12"	//FL
replace cen4 = 3 if fips_state=="13"	//GA
										//GU
replace cen4 = 4 if fips_state=="15"	//HI
replace cen4 = 4 if fips_state=="16"	//ID
replace cen4 = 2 if fips_state=="17"	//IL
replace cen4 = 2 if fips_state=="18"	//IN
replace cen4 = 2 if fips_state=="19"	//IA
replace cen4 = 2 if fips_state=="20"	//KS
replace cen4 = 3 if fips_state=="21"	//KY
replace cen4 = 3 if fips_state=="22"	//LA
replace cen4 = 1 if fips_state=="23"	//ME
replace cen4 = 3 if fips_state=="24"	//MD
replace cen4 = 1 if fips_state=="25"	//MA
replace cen4 = 2 if fips_state=="26"	//MI
replace cen4 = 2 if fips_state=="27"	//MN
replace cen4 = 3 if fips_state=="28"	//MS
replace cen4 = 2 if fips_state=="29"	//MO
replace cen4 = 4 if fips_state=="30"	//MT
replace cen4 = 2 if fips_state=="31"	//NE
replace cen4 = 4 if fips_state=="32"	//NV
replace cen4 = 1 if fips_state=="33"	//NH
replace cen4 = 1 if fips_state=="34"	//NJ
replace cen4 = 4 if fips_state=="35"	//NM
replace cen4 = 1 if fips_state=="36"	//NY
replace cen4 = 3 if fips_state=="37"	//NC
replace cen4 = 2 if fips_state=="38"	//ND
replace cen4 = 2 if fips_state=="39"	//OH
replace cen4 = 3 if fips_state=="40"	//OK
replace cen4 = 4 if fips_state=="41"	//OR
replace cen4 = 1 if fips_state=="42"	//PA
										//PR
replace cen4 = 1 if fips_state=="44"	//RI
replace cen4 = 3 if fips_state=="45"	//SC
replace cen4 = 2 if fips_state=="46"	//SD
replace cen4 = 3 if fips_state=="47"	//TN
replace cen4 = 3 if fips_state=="48"	//TX
replace cen4 = 4 if fips_state=="49"	//UT 
replace cen4 = 1 if fips_state=="50"	//VT
replace cen4 = 3 if fips_state=="51"	//VA
										//VI
replace cen4 = 4 if fips_state=="53"	//WA
replace cen4 = 3 if fips_state=="54"	//WV
replace cen4 = 2 if fips_state=="55"	//WI
replace cen4 = 4 if fips_state=="56"	//WY
replace cen4 = 5 if fips_state=="60"	//AS
replace cen4 = 5 if fips_state=="66"	//GU
replace cen4 = 5 if fips_state=="72"	//PR
replace cen4 = 5 if fips_state=="78"	//VI
replace cen4 = 5 if fips_state=="FC"	//UP, FC

save `geo', replace

////////////////////////////////////////////////////////////////////////////////
//////////////////		add education		////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Geography/Crosswalks/zip_to_2010ZCTA/MasterXwalk/zcta2010tozip.dta", replace
rename zip zip5
destring ZCTA5, gen(zcta5)
tempfile zip
save `zip', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Stata/ACS/acs_educ_65up.dta", replace
keep zcta5 pct_hsgrads
drop if pct_hsgrads==.

merge 1:m zcta5 using `zip'
keep if _m==3
drop _m

//prioritize 2003 value (the first), but otherwise take earliest
gen pct_hsg = pct_hsgrads if year==2003
egen zip5n = group(zip5)
xfill pct_hsg, i(zip5n)
replace pct_hsg = pct_hsgrads if pct_hsg==.

sort zip5 year
drop if zip5==zip5[_n-1]

merge 1:m zip5 using `geo'
keep if _m==2 | _m==3
drop _m

save `geo', replace

////////////////////////////////////////////////////////////////////////////////
//////////////////		add income			////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Stata/BackupData/ACS_Income.dta", replace
count
keep ZCTA5 B19013_001E
rename ZCTA5 zcta5
rename B19013_001E medinc
drop if medinc==.

merge 1:m zcta5 using `zip'
keep if _m==3
drop _m

sort zip5 year
drop if zip5==zip5[_n-1]

merge 1:m zip5 using `geo'
keep if _m==2 | _m==3
drop _m

///////  SAVE
keep bene_id fips_state fips_county zip3 zip5 cen4 zcta5 pct_hsg medinc
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/geoses_0213.dta", replace


////////////////////////////////////////////////////////////////////////////////
/////////////////	GEOGRAPHY WIDE 06-13   /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//import these in reverse order, to give priority to geographic readings from earlier in the panel
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2013.dta", clear
keep bene_id fips_state fips_county zip3 zip5
tempfile geo
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2012.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2011.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2010.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2009.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2008.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2007.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2006.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m

//census regions
//NE 1, MW 2, S 3, W 4, O 5
gen cen4 = .
replace cen4 = 3 if fips_state=="01"  	//AL
replace cen4 = 4 if fips_state=="02"  	//AK
										//AS
replace cen4 = 4 if fips_state=="04"  	//AZ
replace cen4 = 3 if fips_state=="05"  	//AR
replace cen4 = 4 if fips_state=="06"	//CA	
										//CZ
replace cen4 = 4 if fips_state=="08"	//CO
replace cen4 = 1 if fips_state=="09"	//CT
replace cen4 = 3 if fips_state=="10"	//DE
replace cen4 = 3 if fips_state=="11"	//DC
replace cen4 = 3 if fips_state=="12"	//FL
replace cen4 = 3 if fips_state=="13"	//GA
										//GU
replace cen4 = 4 if fips_state=="15"	//HI
replace cen4 = 4 if fips_state=="16"	//ID
replace cen4 = 2 if fips_state=="17"	//IL
replace cen4 = 2 if fips_state=="18"	//IN
replace cen4 = 2 if fips_state=="19"	//IA
replace cen4 = 2 if fips_state=="20"	//KS
replace cen4 = 3 if fips_state=="21"	//KY
replace cen4 = 3 if fips_state=="22"	//LA
replace cen4 = 1 if fips_state=="23"	//ME
replace cen4 = 3 if fips_state=="24"	//MD
replace cen4 = 1 if fips_state=="25"	//MA
replace cen4 = 2 if fips_state=="26"	//MI
replace cen4 = 2 if fips_state=="27"	//MN
replace cen4 = 3 if fips_state=="28"	//MS
replace cen4 = 2 if fips_state=="29"	//MO
replace cen4 = 4 if fips_state=="30"	//MT
replace cen4 = 2 if fips_state=="31"	//NE
replace cen4 = 4 if fips_state=="32"	//NV
replace cen4 = 1 if fips_state=="33"	//NH
replace cen4 = 1 if fips_state=="34"	//NJ
replace cen4 = 4 if fips_state=="35"	//NM
replace cen4 = 1 if fips_state=="36"	//NY
replace cen4 = 3 if fips_state=="37"	//NC
replace cen4 = 2 if fips_state=="38"	//ND
replace cen4 = 2 if fips_state=="39"	//OH
replace cen4 = 3 if fips_state=="40"	//OK
replace cen4 = 4 if fips_state=="41"	//OR
replace cen4 = 1 if fips_state=="42"	//PA
										//PR
replace cen4 = 1 if fips_state=="44"	//RI
replace cen4 = 3 if fips_state=="45"	//SC
replace cen4 = 2 if fips_state=="46"	//SD
replace cen4 = 3 if fips_state=="47"	//TN
replace cen4 = 3 if fips_state=="48"	//TX
replace cen4 = 4 if fips_state=="49"	//UT 
replace cen4 = 1 if fips_state=="50"	//VT
replace cen4 = 3 if fips_state=="51"	//VA
										//VI
replace cen4 = 4 if fips_state=="53"	//WA
replace cen4 = 3 if fips_state=="54"	//WV
replace cen4 = 2 if fips_state=="55"	//WI
replace cen4 = 4 if fips_state=="56"	//WY
replace cen4 = 5 if fips_state=="60"	//AS
replace cen4 = 5 if fips_state=="66"	//GU
replace cen4 = 5 if fips_state=="72"	//PR
replace cen4 = 5 if fips_state=="78"	//VI
replace cen4 = 5 if fips_state=="FC"	//UP, FC

save `geo', replace

////////////////////////////////////////////////////////////////////////////////
//////////////////		add education		////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Geography/Crosswalks/zip_to_2010ZCTA/MasterXwalk/zcta2010tozip.dta", replace
rename zip zip5
destring ZCTA5, gen(zcta5)
tempfile zip
save `zip', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Stata/ACS/acs_educ_65up.dta", replace
keep zcta5 pct_hsgrads
drop if pct_hsgrads==.

merge 1:m zcta5 using `zip'
keep if _m==3
drop _m

//prioritize 2006 value, but otherwise take earliest
gen pct_hsg = pct_hsgrads if year==2006
egen zip5n = group(zip5)
xfill pct_hsg, i(zip5n)
replace pct_hsg = pct_hsgrads if pct_hsg==.

sort zip5 year
drop if zip5==zip5[_n-1]

merge 1:m zip5 using `geo'
keep if _m==2 | _m==3
drop _m

save `geo', replace

////////////////////////////////////////////////////////////////////////////////
//////////////////		add income			////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Stata/BackupData/ACS_Income.dta", replace
count
keep ZCTA5 B19013_001E
rename ZCTA5 zcta5
rename B19013_001E medinc
drop if medinc==.

merge 1:m zcta5 using `zip'
keep if _m==3
drop _m

sort zip5 year
drop if zip5==zip5[_n-1]

merge 1:m zip5 using `geo'
keep if _m==2 | _m==3
drop _m

///////  SAVE
keep bene_id fips_state fips_county zip3 zip5 cen4 zcta5 pct_hsg medinc
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/geoses_0613.dta", replace
*/
////////////////////////////////////////////////////////////////////////////////
/////////////////	GEOGRAPHY WIDE 07-13   /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//import these in reverse order, to give priority to geographic readings from earlier in the panel
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2013.dta", clear
keep bene_id fips_state fips_county zip3 zip5
tempfile geo
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2012.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2011.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2010.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2009.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2008.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2007.dta", clear
keep bene_id fips_state fips_county zip3 zip5
merge 1:1 bene_id using `geo'
drop _m

//census regions
//NE 1, MW 2, S 3, W 4, O 5
gen cen4 = .
replace cen4 = 3 if fips_state=="01"  	//AL
replace cen4 = 4 if fips_state=="02"  	//AK
										//AS
replace cen4 = 4 if fips_state=="04"  	//AZ
replace cen4 = 3 if fips_state=="05"  	//AR
replace cen4 = 4 if fips_state=="06"	//CA	
										//CZ
replace cen4 = 4 if fips_state=="08"	//CO
replace cen4 = 1 if fips_state=="09"	//CT
replace cen4 = 3 if fips_state=="10"	//DE
replace cen4 = 3 if fips_state=="11"	//DC
replace cen4 = 3 if fips_state=="12"	//FL
replace cen4 = 3 if fips_state=="13"	//GA
										//GU
replace cen4 = 4 if fips_state=="15"	//HI
replace cen4 = 4 if fips_state=="16"	//ID
replace cen4 = 2 if fips_state=="17"	//IL
replace cen4 = 2 if fips_state=="18"	//IN
replace cen4 = 2 if fips_state=="19"	//IA
replace cen4 = 2 if fips_state=="20"	//KS
replace cen4 = 3 if fips_state=="21"	//KY
replace cen4 = 3 if fips_state=="22"	//LA
replace cen4 = 1 if fips_state=="23"	//ME
replace cen4 = 3 if fips_state=="24"	//MD
replace cen4 = 1 if fips_state=="25"	//MA
replace cen4 = 2 if fips_state=="26"	//MI
replace cen4 = 2 if fips_state=="27"	//MN
replace cen4 = 3 if fips_state=="28"	//MS
replace cen4 = 2 if fips_state=="29"	//MO
replace cen4 = 4 if fips_state=="30"	//MT
replace cen4 = 2 if fips_state=="31"	//NE
replace cen4 = 4 if fips_state=="32"	//NV
replace cen4 = 1 if fips_state=="33"	//NH
replace cen4 = 1 if fips_state=="34"	//NJ
replace cen4 = 4 if fips_state=="35"	//NM
replace cen4 = 1 if fips_state=="36"	//NY
replace cen4 = 3 if fips_state=="37"	//NC
replace cen4 = 2 if fips_state=="38"	//ND
replace cen4 = 2 if fips_state=="39"	//OH
replace cen4 = 3 if fips_state=="40"	//OK
replace cen4 = 4 if fips_state=="41"	//OR
replace cen4 = 1 if fips_state=="42"	//PA
										//PR
replace cen4 = 1 if fips_state=="44"	//RI
replace cen4 = 3 if fips_state=="45"	//SC
replace cen4 = 2 if fips_state=="46"	//SD
replace cen4 = 3 if fips_state=="47"	//TN
replace cen4 = 3 if fips_state=="48"	//TX
replace cen4 = 4 if fips_state=="49"	//UT 
replace cen4 = 1 if fips_state=="50"	//VT
replace cen4 = 3 if fips_state=="51"	//VA
										//VI
replace cen4 = 4 if fips_state=="53"	//WA
replace cen4 = 3 if fips_state=="54"	//WV
replace cen4 = 2 if fips_state=="55"	//WI
replace cen4 = 4 if fips_state=="56"	//WY
replace cen4 = 5 if fips_state=="60"	//AS
replace cen4 = 5 if fips_state=="66"	//GU
replace cen4 = 5 if fips_state=="72"	//PR
replace cen4 = 5 if fips_state=="78"	//VI
replace cen4 = 5 if fips_state=="FC"	//UP, FC

save `geo', replace

////////////////////////////////////////////////////////////////////////////////
//////////////////		add education		////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Geography/Crosswalks/zip_to_2010ZCTA/MasterXwalk/zcta2010tozip.dta", replace
rename zip zip5
destring ZCTA5, gen(zcta5)
tempfile zip
save `zip', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Stata/ACS/acs_educ_65up.dta", replace
keep zcta5 pct_hsgrads
drop if pct_hsgrads==.

merge 1:m zcta5 using `zip'
keep if _m==3
drop _m

//prioritize 2007 value, but otherwise take earliest
gen pct_hsg = pct_hsgrads if year==2007
egen zip5n = group(zip5)
xfill pct_hsg, i(zip5n)
replace pct_hsg = pct_hsgrads if pct_hsg==.

sort zip5 year
drop if zip5==zip5[_n-1]

merge 1:m zip5 using `geo'
keep if _m==2 | _m==3
drop _m

save `geo', replace

////////////////////////////////////////////////////////////////////////////////
//////////////////		add income			////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Stata/BackupData/ACS_Income.dta", replace
count
keep ZCTA5 B19013_001E
rename ZCTA5 zcta5
rename B19013_001E medinc
drop if medinc==.

merge 1:m zcta5 using `zip'
keep if _m==3
drop _m

sort zip5 year
drop if zip5==zip5[_n-1]

merge 1:m zip5 using `geo'
keep if _m==2 | _m==3
drop _m

///////  SAVE
keep bene_id fips_state fips_county zip3 zip5 cen4 zcta5 pct_hsg medinc
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/geoses_0713.dta", replace
/*
////////////////////////////////////////////////////////////////////////////////
/////////////////	GEOGRAPHY LONG 07-13   /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2013.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2013
tempfile geo
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2012.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2012
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2011.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2011
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2010.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2010
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2009.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2009
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2008.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2008
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2007.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2007
append using `geo'
save `geo', replace

//census regions
//NE 1, MW 2, S 3, W 4, O 5
gen cen4 = .
replace cen4 = 3 if fips_state=="01"  	//AL
replace cen4 = 4 if fips_state=="02"  	//AK
										//AS
replace cen4 = 4 if fips_state=="04"  	//AZ
replace cen4 = 3 if fips_state=="05"  	//AR
replace cen4 = 4 if fips_state=="06"	//CA	
										//CZ
replace cen4 = 4 if fips_state=="08"	//CO
replace cen4 = 1 if fips_state=="09"	//CT
replace cen4 = 3 if fips_state=="10"	//DE
replace cen4 = 3 if fips_state=="11"	//DC
replace cen4 = 3 if fips_state=="12"	//FL
replace cen4 = 3 if fips_state=="13"	//GA
										//GU
replace cen4 = 4 if fips_state=="15"	//HI
replace cen4 = 4 if fips_state=="16"	//ID
replace cen4 = 2 if fips_state=="17"	//IL
replace cen4 = 2 if fips_state=="18"	//IN
replace cen4 = 2 if fips_state=="19"	//IA
replace cen4 = 2 if fips_state=="20"	//KS
replace cen4 = 3 if fips_state=="21"	//KY
replace cen4 = 3 if fips_state=="22"	//LA
replace cen4 = 1 if fips_state=="23"	//ME
replace cen4 = 3 if fips_state=="24"	//MD
replace cen4 = 1 if fips_state=="25"	//MA
replace cen4 = 2 if fips_state=="26"	//MI
replace cen4 = 2 if fips_state=="27"	//MN
replace cen4 = 3 if fips_state=="28"	//MS
replace cen4 = 2 if fips_state=="29"	//MO
replace cen4 = 4 if fips_state=="30"	//MT
replace cen4 = 2 if fips_state=="31"	//NE
replace cen4 = 4 if fips_state=="32"	//NV
replace cen4 = 1 if fips_state=="33"	//NH
replace cen4 = 1 if fips_state=="34"	//NJ
replace cen4 = 4 if fips_state=="35"	//NM
replace cen4 = 1 if fips_state=="36"	//NY
replace cen4 = 3 if fips_state=="37"	//NC
replace cen4 = 2 if fips_state=="38"	//ND
replace cen4 = 2 if fips_state=="39"	//OH
replace cen4 = 3 if fips_state=="40"	//OK
replace cen4 = 4 if fips_state=="41"	//OR
replace cen4 = 1 if fips_state=="42"	//PA
										//PR
replace cen4 = 1 if fips_state=="44"	//RI
replace cen4 = 3 if fips_state=="45"	//SC
replace cen4 = 2 if fips_state=="46"	//SD
replace cen4 = 3 if fips_state=="47"	//TN
replace cen4 = 3 if fips_state=="48"	//TX
replace cen4 = 4 if fips_state=="49"	//UT 
replace cen4 = 1 if fips_state=="50"	//VT
replace cen4 = 3 if fips_state=="51"	//VA
										//VI
replace cen4 = 4 if fips_state=="53"	//WA
replace cen4 = 3 if fips_state=="54"	//WV
replace cen4 = 2 if fips_state=="55"	//WI
replace cen4 = 4 if fips_state=="56"	//WY
replace cen4 = 5 if fips_state=="60"	//AS
replace cen4 = 5 if fips_state=="66"	//GU
replace cen4 = 5 if fips_state=="72"	//PR
replace cen4 = 5 if fips_state=="78"	//VI
replace cen4 = 5 if fips_state=="FC"	//UP, FC

save `geo', replace

////////////////////////////////////////////////////////////////////////////////
//////////////////		add education		////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Geography/Crosswalks/zip_to_2010ZCTA/MasterXwalk/zcta2010tozip.dta", replace
rename zip zip5
destring ZCTA5, gen(zcta5)
tempfile zip
save `zip', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Stata/ACS/acs_educ_65up.dta", replace
keep zcta5 pct_hsgrads
drop if pct_hsgrads==.

merge 1:m zcta5 using `zip'
keep if _m==3
drop _m

sort zip5 year
drop if zip5==zip5[_n-1]
drop year 

merge 1:m zip5 using `geo'
keep if _m==2 | _m==3
drop _m

save `geo', replace

////////////////////////////////////////////////////////////////////////////////
//////////////////		add income			////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Stata/BackupData/ACS_Income.dta", replace
count
keep ZCTA5 B19013_001E
rename ZCTA5 zcta5
rename B19013_001E medinc
drop if medinc==.

merge 1:m zcta5 using `zip'
keep if _m==3
drop _m

sort zip5 year
drop if zip5==zip5[_n-1]
drop year

merge 1:m zip5 using `geo'
keep if _m==2 | _m==3
drop _m

///////  SAVE
keep bene_id year fips_state fips_county zip3 zip5 cen4 zcta5 pct_hsgrads medinc
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/geoses_long0713.dta", replace

////////////////////////////////////////////////////////////////////////////////
/////////////////	GEOGRAPHY LONG 02-13   /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2013.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2013
tempfile geo
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2012.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2012
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2011.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2011
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2010.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2010
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2009.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2009
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2008.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2008
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2007.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2007
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2006.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2006
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2005.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2005
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2004.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2004
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2003.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2003
append using `geo'
save `geo', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/Geography/bene_geo_2002.dta", clear
keep bene_id fips_state fips_county zip3 zip5
gen year = 2002
append using `geo'

//census regions
//NE 1, MW 2, S 3, W 4, O 5
gen cen4 = .
replace cen4 = 3 if fips_state=="01"  	//AL
replace cen4 = 4 if fips_state=="02"  	//AK
										//AS
replace cen4 = 4 if fips_state=="04"  	//AZ
replace cen4 = 3 if fips_state=="05"  	//AR
replace cen4 = 4 if fips_state=="06"	//CA	
										//CZ
replace cen4 = 4 if fips_state=="08"	//CO
replace cen4 = 1 if fips_state=="09"	//CT
replace cen4 = 3 if fips_state=="10"	//DE
replace cen4 = 3 if fips_state=="11"	//DC
replace cen4 = 3 if fips_state=="12"	//FL
replace cen4 = 3 if fips_state=="13"	//GA
										//GU
replace cen4 = 4 if fips_state=="15"	//HI
replace cen4 = 4 if fips_state=="16"	//ID
replace cen4 = 2 if fips_state=="17"	//IL
replace cen4 = 2 if fips_state=="18"	//IN
replace cen4 = 2 if fips_state=="19"	//IA
replace cen4 = 2 if fips_state=="20"	//KS
replace cen4 = 3 if fips_state=="21"	//KY
replace cen4 = 3 if fips_state=="22"	//LA
replace cen4 = 1 if fips_state=="23"	//ME
replace cen4 = 3 if fips_state=="24"	//MD
replace cen4 = 1 if fips_state=="25"	//MA
replace cen4 = 2 if fips_state=="26"	//MI
replace cen4 = 2 if fips_state=="27"	//MN
replace cen4 = 3 if fips_state=="28"	//MS
replace cen4 = 2 if fips_state=="29"	//MO
replace cen4 = 4 if fips_state=="30"	//MT
replace cen4 = 2 if fips_state=="31"	//NE
replace cen4 = 4 if fips_state=="32"	//NV
replace cen4 = 1 if fips_state=="33"	//NH
replace cen4 = 1 if fips_state=="34"	//NJ
replace cen4 = 4 if fips_state=="35"	//NM
replace cen4 = 1 if fips_state=="36"	//NY
replace cen4 = 3 if fips_state=="37"	//NC
replace cen4 = 2 if fips_state=="38"	//ND
replace cen4 = 2 if fips_state=="39"	//OH
replace cen4 = 3 if fips_state=="40"	//OK
replace cen4 = 4 if fips_state=="41"	//OR
replace cen4 = 1 if fips_state=="42"	//PA
										//PR
replace cen4 = 1 if fips_state=="44"	//RI
replace cen4 = 3 if fips_state=="45"	//SC
replace cen4 = 2 if fips_state=="46"	//SD
replace cen4 = 3 if fips_state=="47"	//TN
replace cen4 = 3 if fips_state=="48"	//TX
replace cen4 = 4 if fips_state=="49"	//UT 
replace cen4 = 1 if fips_state=="50"	//VT
replace cen4 = 3 if fips_state=="51"	//VA
										//VI
replace cen4 = 4 if fips_state=="53"	//WA
replace cen4 = 3 if fips_state=="54"	//WV
replace cen4 = 2 if fips_state=="55"	//WI
replace cen4 = 4 if fips_state=="56"	//WY
replace cen4 = 5 if fips_state=="60"	//AS
replace cen4 = 5 if fips_state=="66"	//GU
replace cen4 = 5 if fips_state=="72"	//PR
replace cen4 = 5 if fips_state=="78"	//VI
replace cen4 = 5 if fips_state=="FC"	//UP, FC

save `geo', replace

////////////////////////////////////////////////////////////////////////////////
//////////////////		add education		////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Geography/Crosswalks/zip_to_2010ZCTA/MasterXwalk/zcta2010tozip.dta", replace
rename zip zip5
destring ZCTA5, gen(zcta5)
tempfile zip
save `zip', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Stata/ACS/acs_educ_65up.dta", replace
keep zcta5 pct_hsgrads
drop if pct_hsgrads==.

merge 1:m zcta5 using `zip'
keep if _m==3
drop _m

sort zip5 year
drop if zip5==zip5[_n-1]
drop year 

merge 1:m zip5 using `geo'
keep if _m==2 | _m==3
drop _m

save `geo', replace

////////////////////////////////////////////////////////////////////////////////
//////////////////		add income			////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/ContextData/Stata/BackupData/ACS_Income.dta", replace
count
keep ZCTA5 B19013_001E
rename ZCTA5 zcta5
rename B19013_001E medinc
drop if medinc==.

merge 1:m zcta5 using `zip'
keep if _m==3
drop _m

sort zip5 year
drop if zip5==zip5[_n-1]
drop year

merge 1:m zip5 using `geo'
keep if _m==2 | _m==3
drop _m

///////  SAVE
keep bene_id year fips_state fips_county zip3 zip5 cen4 zcta5 pct_hsgrads medinc
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/geoses_long0213.dta", replace



