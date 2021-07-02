clear all
set more off
capture log close

/*
•	bsfcuYYYY.dta, 06-13
•	phy_0613.dta, phy_long0613.do
•	Brings in the BSF cost and use files, gets count for number of physician visits during the year. 
•	Makes a wide file and a long file. 
*/

////////////////////////////////////////////////////////////////////////////////
//																			  //
//							Wide file										  //
//																			  //
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/bsf/2006/bsfcu2006.dta", replace
keep bene_id em_events phys_events
count

gen phyvis_2006 = 0
replace phyvis_2006 = phys_events if phys_events!=.
sum phyvis_2006, detail

drop em_events phys_events

tempfile wide
save `wide', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2007/bsfcu2007.dta", replace
keep bene_id em_events phys_events
count

gen phyvis_2007 = 0
replace phyvis_2007 = phys_events if phys_events!=.
sum phyvis_2007, detail

drop em_events phys_events

merge 1:1 bene_id using `wide'
drop _m
save `wide', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2008/bsfcu2008.dta", replace
keep bene_id em_events phys_events
count

gen phyvis_2008 = 0
replace phyvis_2008 = phys_events if phys_events!=.
sum phyvis_2008, detail

drop em_events phys_events

merge 1:1 bene_id using `wide'
drop _m
save `wide', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2009/bsfcu2009.dta", replace
keep bene_id em_events phys_events
count

gen phyvis_2009 = 0
replace phyvis_2009 = phys_events if phys_events!=.
sum phyvis_2009, detail

drop em_events phys_events

merge 1:1 bene_id using `wide'
drop _m
save `wide', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2010/bsfcu2010.dta", replace
keep bene_id em_events phys_events
count

gen phyvis_2010 = 0
replace phyvis_2010 = phys_events if phys_events!=.
sum phyvis_2010, detail

drop em_events phys_events

merge 1:1 bene_id using `wide'
drop _m
save `wide', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2011/bsfcu2011.dta", replace
keep bene_id em_events phys_events
count

gen phyvis_2011 = 0
replace phyvis_2011 = phys_events if phys_events!=.
sum phyvis_2011, detail

drop em_events phys_events

merge 1:1 bene_id using `wide'
drop _m
save `wide', replace

use "/disk/agedisk1/medicare/data/u/c/20pct/bsf/2012/bsfcu2012.dta", replace
keep bene_id em_events phys_events
count

gen phyvis_2012 = 0
replace phyvis_2012 = phys_events if phys_events!=.
sum phyvis_2012, detail

drop em_events phys_events

merge 1:1 bene_id using `wide'
drop _m
save `wide', replace

use "/disk/agedisk3/medicare/data/20pct/bsf/2013/bsfcu2013.dta", replace
keep bene_id em_event phys_eve
count

gen phyvis_2013 = 0
replace phyvis_2013 = phys_eve if phys_eve!=.
sum phyvis_2013, detail

drop em_event phys_eve

merge 1:1 bene_id using `wide'
drop _m

//save
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/phy_0613.dta", replace

////////////////////////////////////////////////////////////////////////////////
//																			  //
//							Long file										  //
//																			  //
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/bsf/2006/bsfcu2006.dta", replace
keep bene_id em_events phys_events
count

gen year = 2006

gen phyvis = 0
replace phyvis = phys_events if phys_events!=.
sum phyvis, detail

drop em_events phys_events

tempfile long
save `long', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2007/bsfcu2007.dta", replace
keep bene_id em_events phys_events
count

gen year = 2007

gen phyvis = 0
replace phyvis = phys_events if phys_events!=.
sum phyvis, detail

drop em_events phys_events

append using `long'
save `long', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2008/bsfcu2008.dta", replace
keep bene_id em_events phys_events
count

gen year = 2008

gen phyvis = 0
replace phyvis = phys_events if phys_events!=.
sum phyvis, detail

drop em_events phys_events

append using `long'
save `long', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2009/bsfcu2009.dta", replace
keep bene_id em_events phys_events
count

gen year = 2009

gen phyvis = 0
replace phyvis = phys_events if phys_events!=.
sum phyvis, detail

drop em_events phys_events

append using `long'
save `long', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2010/bsfcu2010.dta", replace
keep bene_id em_events phys_events
count

gen year = 2010

gen phyvis = 0
replace phyvis = phys_events if phys_events!=.
sum phyvis, detail

drop em_events phys_events

append using `long'
save `long', replace

use "/disk/agedisk2/medicare/data/20pct/bsf/2011/bsfcu2011.dta", replace
keep bene_id em_events phys_events
count

gen year = 2011

gen phyvis = 0
replace phyvis = phys_events if phys_events!=.
sum phyvis, detail

drop em_events phys_events

append using `long'
save `long', replace

use "/disk/agedisk1/medicare/data/u/c/20pct/bsf/2012/bsfcu2012.dta", replace
keep bene_id em_events phys_events
count

gen year = 2012

gen phyvis = 0
replace phyvis = phys_events if phys_events!=.
sum phyvis, detail

drop em_events phys_events

append using `long'
save `long', replace

use "/disk/agedisk3/medicare/data/20pct/bsf/2013/bsfcu2013.dta", replace
keep bene_id em_event phys_eve
count

gen year = 2013

gen phyvis = 0
replace phyvis = phys_eve if phys_eve!=.
sum phyvis, detail

drop em_event phys_eve

append using `long'

//save
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/phy_long0613.dta", replace
