clear all
set more off
capture log close


/*
•	Input: statcce_YYYYp.dta, for 2007-2013.
o	insamp_0713.dta
•	Output: stat_long0713a.dta
•	Make year variable. Restrict to the people who were insamp in that year. 
•	Append the 7 years to get long file.
*/

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
//					Merge the stats within each year 						  //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////	2007 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/statcce_2007p.dta", replace
rename stat_consdays_2007 stat_consdays 
rename stat_clms_2007 stat_clms 
keep bene_id stat_consdays stat_clms

gen year = 2007
replace stat_clms = 0 if stat_clms==.
replace stat_consdays = 0 if stat_consdays==.

tempfile 2007
save `2007', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2007'
keep if _m==3
drop _m
keep if insamp_2007==1

rename age_beg_2007 age
drop age_beg* 

save `2007', replace 

////////////////////////	2008 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/statcce_2008p.dta", replace
rename stat_consdays_2008 stat_consdays 
rename stat_clms_2008 stat_clms 
keep bene_id stat_consdays stat_clms

gen year = 2008
replace stat_clms = 0 if stat_clms==.
replace stat_consdays = 0 if stat_consdays==.

tempfile 2008
save `2008', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2008'
keep if _m==3
drop _m
keep if insamp_2008==1

rename age_beg_2008 age
drop age_beg* 

save `2008', replace 

////////////////////////	2009 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/statcce_2009p.dta", replace
rename stat_consdays_2009 stat_consdays 
rename stat_clms_2009 stat_clms 
keep bene_id stat_consdays stat_clms

gen year = 2009
replace stat_clms = 0 if stat_clms==.
replace stat_consdays = 0 if stat_consdays==.

tempfile 2009
save `2009', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2009'
keep if _m==3
drop _m
keep if insamp_2009==1

rename age_beg_2009 age
drop age_beg* 

save `2009', replace 

////////////////////////	2010 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/statcce_2010p.dta", replace
rename stat_consdays_2010 stat_consdays 
rename stat_clms_2010 stat_clms 
keep bene_id stat_consdays stat_clms

gen year = 2010
replace stat_clms = 0 if stat_clms==.
replace stat_consdays = 0 if stat_consdays==.

tempfile 2010
save `2010', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2010'
keep if _m==3
drop _m
keep if insamp_2010==1

rename age_beg_2010 age
drop age_beg* 

save `2010', replace 

////////////////////////	2011 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/statcce_2011p.dta", replace
rename stat_consdays_2011 stat_consdays 
rename stat_clms_2011 stat_clms 
keep bene_id stat_consdays stat_clms

gen year = 2011
replace stat_clms = 0 if stat_clms==.
replace stat_consdays = 0 if stat_consdays==.

tempfile 2011
save `2011', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2011'
keep if _m==3
drop _m
keep if insamp_2011==1

rename age_beg_2011 age
drop age_beg* 

save `2011', replace 

////////////////////////	2012 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/statcce_2012p.dta", replace
rename stat_consdays_2012 stat_consdays 
rename stat_clms_2012 stat_clms 
keep bene_id stat_consdays stat_clms

gen year = 2012
replace stat_clms = 0 if stat_clms==.
replace stat_consdays = 0 if stat_consdays==.

tempfile 2012
save `2012', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2012'
keep if _m==3
drop _m
keep if insamp_2012==1

rename age_beg_2012 age
drop age_beg* 

save `2012', replace 

////////////////////////	2013 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/statcce_2013p.dta", replace
rename stat_consdays_2013 stat_consdays 
rename stat_clms_2013 stat_clms 
keep bene_id stat_consdays stat_clms

gen year = 2013
replace stat_clms = 0 if stat_clms==.
replace stat_consdays = 0 if stat_consdays==.

tempfile 2013
save `2013', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2013'
keep if _m==3
drop _m
keep if insamp_2013==1

rename age_beg_2013 age
drop age_beg* 

save `2013', replace 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
//			Append the stat files from 07-13 to get long file				  //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use `2007', replace
tempfile stat
save `stat', replace

use `2008', replace
append using `stat'
save `stat', replace

use `2009', replace
append using `stat'
save `stat', replace

use `2010', replace
append using `stat'
save `stat', replace

use `2011', replace
append using `stat'
save `stat', replace

use `2012', replace
append using `stat'
save `stat', replace

use `2013', replace
append using `stat'
save `stat', replace

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_long0713a.dta", replace

