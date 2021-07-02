clear all
set more off
capture log close

/*
•	Input: XXXXX_YYYY.dta for donep galan meman rivas
•	Output: adrx_long0713.dta
•	Merges the 4 classes for each year. Make year variable. Fill in zeros. 
•	Append the 7 years to get long file.
*/

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
//					Merge the 4 classes of drugs within each year 			  //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////	2007 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/donep_2007p.dta", replace
rename donep_pdays_2007 donep_pdays
rename donep_clms_2007 donep_clms
keep bene_id donep_pdays donep_clms

tempfile 2007
save `2007', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/galan_2007p.dta", replace
rename galan_pdays_2007 galan_pdays
rename galan_clms_2007 galan_clms
keep bene_id galan_pdays galan_clms

merge 1:1 bene_id using `2007'
drop _m
save `2007', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/meman_2007p.dta", replace
rename meman_pdays_2007 meman_pdays
rename meman_clms_2007 meman_clms
keep bene_id meman_pdays meman_clms

merge 1:1 bene_id using `2007'
drop _m
save `2007', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/rivas_2007p.dta", replace
rename rivas_pdays_2007 rivas_pdays
rename rivas_clms_2007 rivas_clms
keep bene_id rivas_pdays rivas_clms

merge 1:1 bene_id using `2007'
drop _m

//Organize 2007
gen year = 2007

local vars "pdays clms"
foreach i in `vars'{
	replace donep_`i' = 0 if donep_`i'==.
	replace galan_`i' = 0 if galan_`i'==.
	replace meman_`i' = 0 if meman_`i'==.
	replace rivas_`i' = 0 if rivas_`i'==.
}

gen adrx_clms = donep_clms + galan_clms + meman_clms + rivas_clms
gen adrx_pdays = donep_pdays + galan_pdays + meman_pdays + rivas_pdays

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2007.dta", replace

////////////////////////	2008 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/donep_2008p.dta", replace
rename donep_pdays_2008 donep_pdays
rename donep_clms_2008 donep_clms
keep bene_id donep_pdays donep_clms

tempfile 2008
save `2008', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/galan_2008p.dta", replace
rename galan_pdays_2008 galan_pdays
rename galan_clms_2008 galan_clms
keep bene_id galan_pdays galan_clms

merge 1:1 bene_id using `2008'
drop _m
save `2008', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/meman_2008p.dta", replace
rename meman_pdays_2008 meman_pdays
rename meman_clms_2008 meman_clms
keep bene_id meman_pdays meman_clms

merge 1:1 bene_id using `2008'
drop _m
save `2008', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/rivas_2008p.dta", replace
rename rivas_pdays_2008 rivas_pdays
rename rivas_clms_2008 rivas_clms
keep bene_id rivas_pdays rivas_clms

merge 1:1 bene_id using `2008'
drop _m

//Organize 2008
gen year = 2008

local vars "pdays clms"
foreach i in `vars'{
	replace donep_`i' = 0 if donep_`i'==.
	replace galan_`i' = 0 if galan_`i'==.
	replace meman_`i' = 0 if meman_`i'==.
	replace rivas_`i' = 0 if rivas_`i'==.
}

gen adrx_clms = donep_clms + galan_clms + meman_clms + rivas_clms
gen adrx_pdays = donep_pdays + galan_pdays + meman_pdays + rivas_pdays

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2008.dta", replace

////////////////////////	2009 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/donep_2009p.dta", replace
rename donep_pdays_2009 donep_pdays
rename donep_clms_2009 donep_clms
keep bene_id donep_pdays donep_clms

tempfile 2009
save `2009', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/galan_2009p.dta", replace
rename galan_pdays_2009 galan_pdays
rename galan_clms_2009 galan_clms
keep bene_id galan_pdays galan_clms

merge 1:1 bene_id using `2009'
drop _m
save `2009', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/meman_2009p.dta", replace
rename meman_pdays_2009 meman_pdays
rename meman_clms_2009 meman_clms
keep bene_id meman_pdays meman_clms

merge 1:1 bene_id using `2009'
drop _m
save `2009', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/rivas_2009p.dta", replace
rename rivas_pdays_2009 rivas_pdays
rename rivas_clms_2009 rivas_clms
keep bene_id rivas_pdays rivas_clms

merge 1:1 bene_id using `2009'
drop _m

//Organize 2009
gen year = 2009

local vars "pdays clms"
foreach i in `vars'{
	replace donep_`i' = 0 if donep_`i'==.
	replace galan_`i' = 0 if galan_`i'==.
	replace meman_`i' = 0 if meman_`i'==.
	replace rivas_`i' = 0 if rivas_`i'==.
}

gen adrx_clms = donep_clms + galan_clms + meman_clms + rivas_clms
gen adrx_pdays = donep_pdays + galan_pdays + meman_pdays + rivas_pdays

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2009.dta", replace

////////////////////////	2010 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/donep_2010p.dta", replace
rename donep_pdays_2010 donep_pdays
rename donep_clms_2010 donep_clms
keep bene_id donep_pdays donep_clms

tempfile 2010
save `2010', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/galan_2010p.dta", replace
rename galan_pdays_2010 galan_pdays
rename galan_clms_2010 galan_clms
keep bene_id galan_pdays galan_clms

merge 1:1 bene_id using `2010'
drop _m
save `2010', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/meman_2010p.dta", replace
rename meman_pdays_2010 meman_pdays
rename meman_clms_2010 meman_clms
keep bene_id meman_pdays meman_clms

merge 1:1 bene_id using `2010'
drop _m
save `2010', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/rivas_2010p.dta", replace
rename rivas_pdays_2010 rivas_pdays
rename rivas_clms_2010 rivas_clms
keep bene_id rivas_pdays rivas_clms

merge 1:1 bene_id using `2010'
drop _m

//Organize 2010
gen year = 2010

local vars "pdays clms"
foreach i in `vars'{
	replace donep_`i' = 0 if donep_`i'==.
	replace galan_`i' = 0 if galan_`i'==.
	replace meman_`i' = 0 if meman_`i'==.
	replace rivas_`i' = 0 if rivas_`i'==.
}

gen adrx_clms = donep_clms + galan_clms + meman_clms + rivas_clms
gen adrx_pdays = donep_pdays + galan_pdays + meman_pdays + rivas_pdays

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2010.dta", replace

////////////////////////	2011 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/donep_2011p.dta", replace
rename donep_pdays_2011 donep_pdays
rename donep_clms_2011 donep_clms
keep bene_id donep_pdays donep_clms

tempfile 2011
save `2011', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/galan_2011p.dta", replace
rename galan_pdays_2011 galan_pdays
rename galan_clms_2011 galan_clms
keep bene_id galan_pdays galan_clms

merge 1:1 bene_id using `2011'
drop _m
save `2011', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/meman_2011p.dta", replace
rename meman_pdays_2011 meman_pdays
rename meman_clms_2011 meman_clms
keep bene_id meman_pdays meman_clms

merge 1:1 bene_id using `2011'
drop _m
save `2011', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/rivas_2011p.dta", replace
rename rivas_pdays_2011 rivas_pdays
rename rivas_clms_2011 rivas_clms
keep bene_id rivas_pdays rivas_clms

merge 1:1 bene_id using `2011'
drop _m

//Organize 2011
gen year = 2011

local vars "pdays clms"
foreach i in `vars'{
	replace donep_`i' = 0 if donep_`i'==.
	replace galan_`i' = 0 if galan_`i'==.
	replace meman_`i' = 0 if meman_`i'==.
	replace rivas_`i' = 0 if rivas_`i'==.
}

gen adrx_clms = donep_clms + galan_clms + meman_clms + rivas_clms
gen adrx_pdays = donep_pdays + galan_pdays + meman_pdays + rivas_pdays

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2011.dta", replace

////////////////////////	2012 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/donep_2012p.dta", replace
rename donep_pdays_2012 donep_pdays
rename donep_clms_2012 donep_clms
keep bene_id donep_pdays donep_clms

tempfile 2012
save `2012', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/galan_2012p.dta", replace
rename galan_pdays_2012 galan_pdays
rename galan_clms_2012 galan_clms
keep bene_id galan_pdays galan_clms

merge 1:1 bene_id using `2012'
drop _m
save `2012', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/meman_2012p.dta", replace
rename meman_pdays_2012 meman_pdays
rename meman_clms_2012 meman_clms
keep bene_id meman_pdays meman_clms

merge 1:1 bene_id using `2012'
drop _m
save `2012', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/rivas_2012p.dta", replace
rename rivas_pdays_2012 rivas_pdays
rename rivas_clms_2012 rivas_clms
keep bene_id rivas_pdays rivas_clms

merge 1:1 bene_id using `2012'
drop _m

//Organize 2012
gen year = 2012

local vars "pdays clms"
foreach i in `vars'{
	replace donep_`i' = 0 if donep_`i'==.
	replace galan_`i' = 0 if galan_`i'==.
	replace meman_`i' = 0 if meman_`i'==.
	replace rivas_`i' = 0 if rivas_`i'==.
}

gen adrx_clms = donep_clms + galan_clms + meman_clms + rivas_clms
gen adrx_pdays = donep_pdays + galan_pdays + meman_pdays + rivas_pdays

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2012.dta", replace

////////////////////////	2013 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/donep_2013p.dta", replace
rename donep_pdays_2013 donep_pdays
rename donep_clms_2013 donep_clms
keep bene_id donep_pdays donep_clms

tempfile 2013
save `2013', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/galan_2013p.dta", replace
rename galan_pdays_2013 galan_pdays
rename galan_clms_2013 galan_clms
keep bene_id galan_pdays galan_clms

merge 1:1 bene_id using `2013'
drop _m
save `2013', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/meman_2013p.dta", replace
rename meman_pdays_2013 meman_pdays
rename meman_clms_2013 meman_clms
keep bene_id meman_pdays meman_clms

merge 1:1 bene_id using `2013'
drop _m
save `2013', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/rivas_2013p.dta", replace
rename rivas_pdays_2013 rivas_pdays
rename rivas_clms_2013 rivas_clms
keep bene_id rivas_pdays rivas_clms

merge 1:1 bene_id using `2013'
drop _m

//Organize 2013
gen year = 2013

local vars "pdays clms"
foreach i in `vars'{
	replace donep_`i' = 0 if donep_`i'==.
	replace galan_`i' = 0 if galan_`i'==.
	replace meman_`i' = 0 if meman_`i'==.
	replace rivas_`i' = 0 if rivas_`i'==.
}

gen adrx_clms = donep_clms + galan_clms + meman_clms + rivas_clms
gen adrx_pdays = donep_pdays + galan_pdays + meman_pdays + rivas_pdays

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2013.dta", replace

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
//			Append the adrx files from 07-13 to get long file				  //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2007.dta", replace
tempfile adrx
save `adrx', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2008.dta", replace
append using `adrx'
save `adrx', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2009.dta", replace
append using `adrx'
save `adrx', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2010.dta", replace
append using `adrx'
save `adrx', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2011.dta", replace
append using `adrx'
save `adrx', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2012.dta", replace
append using `adrx'
save `adrx', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_2013.dta", replace
append using `adrx'
save `adrx', replace

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_long0713.dta", replace
