clear all
set more off

/*
•	Input: bsfccYYYY.dta, 06-13. 
•	Output: ccw_0613.dta, ccw_0713.dta, ccw_9913.dta, ccw_long0213
*/
////////////////////////////////////////////////////////////////////////////////
///////////////		LONG CCW DIAGNOSES 02-13		////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//bene_id has repeats in 2002-2005. Unique from 2006 on. 
/*
use "/disk/agedisk2/medicare/data/20pct/bsf/2002/bsfcc2002.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
sort bene_id
drop if bene_id==bene_id[_n-1]

gen year = 2002

tempfile ccw
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2003/bsfcc2003.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
sort bene_id
drop if bene_id==bene_id[_n-1]

gen year = 2003

append using `ccw'
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2004/bsfcc2004.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
sort bene_id
drop if bene_id==bene_id[_n-1]

gen year = 2004

append using `ccw'
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2005/bsfcc2005.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
sort bene_id
drop if bene_id==bene_id[_n-1]

gen year = 2005

append using `ccw'
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2006/bsfcc2006.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
gen year = 2006

append using `ccw'
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2007/bsfcc2007.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
gen year = 2007

append using `ccw'
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2008/bsfcc2008.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
gen year = 2008

append using `ccw'
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2009/bsfcc2009.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
gen year = 2009

append using `ccw'
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2010/bsfcc2010.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
gen year = 2010

append using `ccw'
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2011/bsfcc2011.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
gen year = 2011

append using `ccw'
save `ccw', replace

use "/disk/agedisk1/medicare/data/u/c/20pct/bsf/2012/bsfcc2012.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
gen year = 2012

append using `ccw'
save `ccw', replace

use "/disk/agedisk1/medicare/data/u/c/20pct/bsf/2013/bsfcc2013.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
gen year = 2013

append using `ccw'

sort bene_id year
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/ccw_long0213.dta", replace


////////////////////////////////////////////////////////////////////////////////
///////////////		IMPORT CCW DIAGNOSES 02-13		////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//bene_id has repeats in 2002-2005. Unique from 2006 on. 

use "/disk/agedisk2/medicare/data/20pct/bsf/2002/bsfcc2002.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
sort bene_id
drop if bene_id==bene_id[_n-1]

tempfile ccw
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2003/bsfcc2003.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
sort bene_id
drop if bene_id==bene_id[_n-1]

merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2004/bsfcc2004.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
sort bene_id
drop if bene_id==bene_id[_n-1]

merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2005/bsfcc2005.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
sort bene_id
drop if bene_id==bene_id[_n-1]

merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2006/bsfcc2006.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2007/bsfcc2007.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2008/bsfcc2008.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2009/bsfcc2009.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2010/bsfcc2010.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2011/bsfcc2011.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk1/medicare/data/u/c/20pct/bsf/2012/bsfcc2012.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk1/medicare/data/u/c/20pct/bsf/2013/bsfcc2013.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
merge 1:1 bene_id using `ccw'
drop _m

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/ccw_0213.dta", replace


////////////////////////////////////////////////////////////////////////////////
///////////////		IMPORT CCW DIAGNOSES 06-13		////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use "/disk/agedisk2/medicare/data/20pct/bsf/2006/bsfcc2006.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
tempfile ccw
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2007/bsfcc2007.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2008/bsfcc2008.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2009/bsfcc2009.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2010/bsfcc2010.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2011/bsfcc2011.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk1/medicare/data/u/c/20pct/bsf/2012/bsfcc2012.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk1/medicare/data/u/c/20pct/bsf/2013/bsfcc2013.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
merge 1:1 bene_id using `ccw'
drop _m

///////  SAVE
keep bene_id ami* atf_* atrialfe dia* str* hyp* ad* adrd* nadd* hyperl* alzhdmte alzhe
sort bene_id 
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/ccw_0613.dta", replace
*/
////////////////////////////////////////////////////////////////////////////////
///////////////		IMPORT CCW DIAGNOSES 07-13		////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use "/disk/agedisk2/medicare/data/20pct/bsf/2007/bsfcc2007.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
tempfile ccw
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2008/bsfcc2008.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2009/bsfcc2009.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2010/bsfcc2010.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2011/bsfcc2011.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk1/medicare/data/u/c/20pct/bsf/2012/bsfcc2012.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl*
merge 1:1 bene_id using `ccw'
drop _m
save `ccw', replace

use "/disk/agedisk1/medicare/data/u/c/20pct/bsf/2013/bsfcc2013.dta", clear
keep bene_id ami* atrial* diab* strk* hypert* alzh* hyperl* 
merge 1:1 bene_id using `ccw'
drop _m

///////  SAVE
sort bene_id 
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/ccw_0713.dta", replace
