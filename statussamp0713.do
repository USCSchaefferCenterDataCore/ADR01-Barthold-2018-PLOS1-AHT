clear all
set more off
capture log close

/*
•	Input: bene_status_yearYYYY.dta, bene_demog2013.dta
•	Output: bene level: insamp_YYYY.dta, 0612 0812
•	Gets status variables in each year, and requires insamp:
o	3 full years of FFS enrollment, 3 full years in Part D. age_beg>=67. No drop flag.
•	Makes vars for sex, race, and death date.
*/

////////////////////////////////////////////////////////////////////////////////
//////////////////		Sample				////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////  	2004 		////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_status_year2004.dta", replace
keep bene_id enrffs_allyr age_beg sex death_date birth_date
rename death_date death_dt
rename birth_date bene_dob

gen ffs2004 = 0
replace ffs2004 = 1 if enrffs_allyr=="Y"

drop enrffs_allyr age_beg

tempfile status
save `status', replace

////////  	2005 		////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_status_year2005.dta", replace
keep bene_id enrffs_allyr age_beg sex death_date birth_date
rename death_date death_dt
rename birth_date bene_dob

gen ffs2005 = 0
replace ffs2005 = 1 if enrffs_allyr=="Y"

drop enrffs_allyr age_beg

merge 1:1 bene_id using `status'
drop _m
save `status', replace

////////  	2006 		////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_status_year2006.dta", replace
keep bene_id enrffs_allyr ptd_allyr anyptd age_beg race_bg sex death_date birth_date
rename death_date death_dt
rename birth_date bene_dob

gen ptd2006 = 0
replace ptd2006 = 1 if ptd_allyr=="Y"
gen ffs2006 = 0
replace ffs2006 = 1 if enrffs_allyr=="Y"

gen age_beg_2006 = age_beg
drop enrffs_allyr ptd_allyr anyptd age_beg

merge 1:1 bene_id using `status'
drop _m
save `status', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_demog2013.dta", replace
keep bene_id dropflag
merge 1:1 bene_id using `status'
keep if _m==3
drop _m 

gen insamp_2006 = 0
replace insamp_2006 = 1 if (ffs2006==1 & ffs2005==1 & ffs2004==1) & ptd2006==1 & age_beg_2006>=67 & dropflag=="N"
keep if insamp_2006==1
drop dropflag

sort bene_id
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2006.dta", replace

////////  	2007 		////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_status_year2007.dta", replace
keep bene_id enrffs_allyr ptd_allyr anyptd age_beg race_bg sex death_date birth_date
rename death_date death_dt
rename birth_date bene_dob

gen ptd2007 = 0
replace ptd2007 = 1 if ptd_allyr=="Y"
gen ffs2007 = 0
replace ffs2007 = 1 if enrffs_allyr=="Y"

gen age_beg_2007 = age_beg
drop enrffs_allyr ptd_allyr anyptd age_beg

merge 1:1 bene_id using `status'
drop _m
save `status', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_demog2013.dta", replace
keep bene_id dropflag
merge 1:1 bene_id using `status'
keep if _m==3
drop _m 

gen insamp_2007 = 0
replace insamp_2007 = 1 if (ffs2007==1 & ffs2006==1 & ffs2005==1) & (ptd2007==1) & age_beg_2007>=67 & dropflag=="N"
keep if insamp_2007==1
drop dropflag

sort bene_id
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2007.dta", replace

////////  	2008 		////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_status_year2008.dta", replace
keep bene_id enrffs_allyr ptd_allyr anyptd age_beg race_bg sex death_date birth_date
rename death_date death_dt
rename birth_date bene_dob

gen ptd2008 = 0
replace ptd2008 = 1 if ptd_allyr=="Y"
gen ffs2008 = 0
replace ffs2008 = 1 if enrffs_allyr=="Y"

gen age_beg_2008 = age_beg
drop enrffs_allyr ptd_allyr anyptd age_beg

merge 1:1 bene_id using `status'
drop _m
save `status', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_demog2013.dta", replace
keep bene_id dropflag
merge 1:1 bene_id using `status'
keep if _m==3
drop _m 

gen insamp_2008 = 0
replace insamp_2008 = 1 if (ffs2008==1 & ffs2007==1 & ffs2006==1) & (ptd2008==1 & ptd2007==1) & age_beg_2008>=67 & dropflag=="N"
keep if insamp_2008==1
drop dropflag

sort bene_id
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2008.dta", replace

////////  	2009 		////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_status_year2009.dta", replace
keep bene_id enrffs_allyr ptd_allyr anyptd age_beg race_bg sex death_date birth_date
rename death_date death_dt
rename birth_date bene_dob

gen ptd2009 = 0
replace ptd2009 = 1 if ptd_allyr=="Y"
gen ffs2009 = 0
replace ffs2009 = 1 if enrffs_allyr=="Y"

gen age_beg_2009 = age_beg
drop enrffs_allyr ptd_allyr anyptd age_beg

merge 1:1 bene_id using `status'
drop _m
save `status', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_demog2013.dta", replace
keep bene_id dropflag
merge 1:1 bene_id using `status'
keep if _m==3
drop _m 

gen insamp_2009 = 0
replace insamp_2009 = 1 if (ffs2009==1 & ffs2008==1 & ffs2007==1) & (ptd2009==1 & ptd2008==1 & ptd2007==1) & age_beg_2009>=67 & dropflag=="N"
keep if insamp_2009==1
drop dropflag

sort bene_id
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2009.dta", replace

////////  	2010 		////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_status_year2010.dta", replace
keep bene_id enrffs_allyr ptd_allyr anyptd age_beg race_bg sex death_date birth_date
rename death_date death_dt
rename birth_date bene_dob

gen ptd2010 = 0
replace ptd2010 = 1 if ptd_allyr=="Y"
gen ffs2010 = 0
replace ffs2010 = 1 if enrffs_allyr=="Y"

gen age_beg_2010 = age_beg
drop enrffs_allyr ptd_allyr anyptd age_beg

merge 1:1 bene_id using `status'
drop _m
save `status', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_demog2013.dta", replace
keep bene_id dropflag
merge 1:1 bene_id using `status'
keep if _m==3
drop _m 

gen insamp_2010 = 0
replace insamp_2010 = 1 if (ffs2010==1 & ffs2009==1 & ffs2008==1) & (ptd2010==1 & ptd2009==1 & ptd2008==1) & age_beg_2010>=67 & dropflag=="N"
keep if insamp_2010==1
drop dropflag

sort bene_id
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2010.dta", replace

////////  	2011 		////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_status_year2011.dta", replace
keep bene_id enrffs_allyr ptd_allyr anyptd age_beg race_bg sex death_date birth_date
rename death_date death_dt
rename birth_date bene_dob

gen ptd2011 = 0
replace ptd2011 = 1 if ptd_allyr=="Y"
gen ffs2011 = 0
replace ffs2011 = 1 if enrffs_allyr=="Y"

gen age_beg_2011 = age_beg
drop enrffs_allyr ptd_allyr anyptd age_beg

merge 1:1 bene_id using `status'
drop _m
save `status', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_demog2013.dta", replace
keep bene_id dropflag
merge 1:1 bene_id using `status'
keep if _m==3
drop _m 

gen insamp_2011 = 0
replace insamp_2011 = 1 if (ffs2011==1 & ffs2010==1 & ffs2009==1) & (ptd2011==1 & ptd2010==1 & ptd2009==1) & age_beg_2011>=67 & dropflag=="N"
keep if insamp_2011==1
drop dropflag

sort bene_id
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2011.dta", replace

////////  	2012 		////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_status_year2012.dta", replace
keep bene_id enrffs_allyr ptd_allyr anyptd age_beg race_bg sex death_date birth_date
rename death_date death_dt
rename birth_date bene_dob

gen ptd2012 = 0
replace ptd2012 = 1 if ptd_allyr=="Y"
gen ffs2012 = 0
replace ffs2012 = 1 if enrffs_allyr=="Y"

gen age_beg_2012 = age_beg
drop enrffs_allyr ptd_allyr anyptd age_beg

merge 1:1 bene_id using `status'
drop _m
save `status', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_demog2013.dta", replace
keep bene_id dropflag
merge 1:1 bene_id using `status'
keep if _m==3
drop _m 

gen insamp_2012 = 0
replace insamp_2012 = 1 if (ffs2012==1 & ffs2011==1 & ffs2010==1) & (ptd2012==1 & ptd2011==1 & ptd2010==1) & age_beg_2012>=67 & dropflag=="N"
keep if insamp_2012==1
drop dropflag

sort bene_id
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2012.dta", replace

////////  	2013 		////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_status_year2013.dta", replace
keep bene_id enrFFS_allyr ptD_allyr anyptD age_beg race_bg sex death_date birth_date
rename death_date death_dt
rename birth_date bene_dob

gen ptd2013 = 0
replace ptd2013 = 1 if ptD_allyr=="Y"
gen ffs2013 = 0
replace ffs2013 = 1 if enrFFS_allyr=="Y"

gen age_beg_2013 = age_beg
drop enrFFS_allyr ptD_allyr anyptD age_beg

merge 1:1 bene_id using `status'
drop _m
save `status', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/BeneStatus/bene_demog2013.dta", replace
keep bene_id dropflag
merge 1:1 bene_id using `status'
keep if _m==3
drop _m 

gen insamp_2013 = 0
replace insamp_2013 = 1 if (ffs2013==1 & ffs2012==1 & ffs2011==1) & (ptd2013==1 & ptd2012==1 & ptd2011==1) & age_beg_2013>=67 & dropflag=="N"
keep if insamp_2013==1
drop dropflag

sort bene_id
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2013.dta", replace
*/
////////////////////////////////////////////////////////////////////////////////
//////////////////		merge 06-13				////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2006.dta", replace
gen y2004 = 1
gen y2005 = 1
gen y2006 = 1
tempfile samp
save `samp', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2007.dta", replace
gen y2005 = 1
gen y2006 = 1
gen y2007 = 1
merge 1:1 bene_id using `samp'
drop _m
save `samp', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2008.dta", replace
gen y2006 = 1
gen y2007 = 1
gen y2008 = 1
merge 1:1 bene_id using `samp'
drop _m
save `samp', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2009.dta", replace
gen y2007 = 1
gen y2008 = 1
gen y2009 = 1
merge 1:1 bene_id using `samp'
drop _m
save `samp', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2010.dta", replace
gen y2008 = 1
gen y2009 = 1
gen y2010 = 1
merge 1:1 bene_id using `samp'
drop _m
save `samp', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2011.dta", replace
gen y2009 = 1
gen y2010 = 1
gen y2011 = 1
sort bene_id
merge 1:1 bene_id using `samp'
drop _m
save `samp', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2012.dta", replace
gen y2010 = 1
gen y2011 = 1
gen y2012 = 1
merge 1:1 bene_id using `samp'
drop _m
save `samp', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2013.dta", replace
gen y2011 = 1
gen y2012 = 1
gen y2013 = 1
merge 1:1 bene_id using `samp'
drop _m

////////////////////////////////////////////////////////////////////////////////
//////////////////		make vars			////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

egen idn = group(bene_id)

//keep one obs per person - not necessary after merge
//xfill - not necessary - the above merges effectively xfill the variables wide
//fill in zeros - not necessary - none of the variables are counts

//Status Lag flags
//don't need these, because I have my insamps

//multiyear status flags 
//don't need these, because I have my insamps

//death timing
gen death_year = year(death_dt)
gen death_ageD = death_dt - bene_dob
gen death_age = death_ageD/365 
gen dead = 0
replace dead = 1 if death_dt!=.

//years insamp
gen firstyis = .
gen lastyis = .
local years "2013 2012 2011 2010 2009 2008 2007 2006"
foreach i in `years'{
	replace firstyis = `i' if insamp_`i'==1
}
local years "2006 2007 2008 2009 2010 2011 2012 2013"
foreach i in `years'{
	replace lastyis = `i' if insamp_`i'==1
}

//years/days observed
gen firstyoo = .
gen firstdoo = .
local years "2013 2012 2011 2010 2009 2008 2007 2006"
foreach i in `years'{
	replace firstyoo = `i' if y`i'==1
}
replace firstdoo = 16802 if firstyoo==2006
replace firstdoo = 17167 if firstyoo==2007
replace firstdoo = 17532 if firstyoo==2008
replace firstdoo = 17898 if firstyoo==2009
replace firstdoo = 18263 if firstyoo==2010
replace firstdoo = 18628 if firstyoo==2011
replace firstdoo = 18993 if firstyoo==2012
replace firstdoo = 19359 if firstyoo==2013

gen lastyoo = .
gen lastdoo = .
local years "2006 2007 2008 2009 2010 2011 2012 2013"
foreach i in `years'{
	replace lastyoo = `i' if y`i'==1
}
replace lastdoo = 17166 if lastyoo==2006
replace lastdoo = 17531 if lastyoo==2007
replace lastdoo = 17897 if lastyoo==2008
replace lastdoo = 18262 if lastyoo==2009
replace lastdoo = 18627 if lastyoo==2010
replace lastdoo = 18992 if lastyoo==2011
replace lastdoo = 19358 if lastyoo==2012
replace lastdoo = 19723 if lastyoo==2013

replace lastdoo = death_dt if death_dt!=. & death_dt<lastdoo
replace lastyoo = year(death_dt) if death_dt!=. & death_dt<lastdoo

//race - 0 unknown, 1 white, 2 black, 3 other, 4 asian/pacific islander, 5 hispanic, 6 american indian/alaskan native
gen race_dw = 0
replace race_dw = 1 if race_bg=="1"
gen race_db = 0
replace race_db = 1 if race_bg=="2"
gen race_dh = 0
replace race_dh = 1 if race_bg=="5"
gen race_do = 0
replace race_do = 1 if race_bg=="0" | race_bg=="3" | race_bg=="4" | race_bg=="6" | race_bg==""

//sex - 1 male, 2 female
gen female = 0
replace female = 1 if sex=="2"

drop idn
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0613.dta", replace

////////////////////////////////////////////////////////////////////////////////
//////////////////		merge wide 07-13	 ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2007.dta", replace
gen y2005 = 1
gen y2006 = 1
gen y2007 = 1
tempfile samp
save `samp', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2008.dta", replace
gen y2006 = 1
gen y2007 = 1
gen y2008 = 1
merge 1:1 bene_id using `samp'
drop _m
save `samp', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2009.dta", replace
gen y2007 = 1
gen y2008 = 1
gen y2009 = 1
merge 1:1 bene_id using `samp'
drop _m
save `samp', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2010.dta", replace
gen y2008 = 1
gen y2009 = 1
gen y2010 = 1
merge 1:1 bene_id using `samp'
drop _m
save `samp', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2011.dta", replace
gen y2009 = 1
gen y2010 = 1
gen y2011 = 1
sort bene_id
merge 1:1 bene_id using `samp'
drop _m
save `samp', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2012.dta", replace
gen y2010 = 1
gen y2011 = 1
gen y2012 = 1
merge 1:1 bene_id using `samp'
drop _m
save `samp', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_2013.dta", replace
gen y2011 = 1
gen y2012 = 1
gen y2013 = 1
merge 1:1 bene_id using `samp'
drop _m

////////////////////////////////////////////////////////////////////////////////
//////////////////		make vars			////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

egen idn = group(bene_id)

//keep one obs per person - not necessary after merge
//xfill - not necessary - the above merges effectively xfill the variables wide
//fill in zeros - not necessary - none of the variables are counts

//Status Lag flags
//don't need these, because I have my insamps

//multiyear status flags 
//don't need these, because I have my insamps

//death timing
gen death_year = year(death_dt)
gen death_ageD = death_dt - bene_dob
gen death_age = death_ageD/365 
gen dead = 0
replace dead = 1 if death_dt!=.

//years insamp
gen firstyis = .
gen lastyis = .
local years "2013 2012 2011 2010 2009 2008 2007"
foreach i in `years'{
	replace firstyis = `i' if insamp_`i'==1
}
local years "2007 2008 2009 2010 2011 2012 2013"
foreach i in `years'{
	replace lastyis = `i' if insamp_`i'==1
}

//years/days observed
gen firstyoo = .
gen firstdoo = .
local years "2013 2012 2011 2010 2009 2008 2007"
foreach i in `years'{
	replace firstyoo = `i' if y`i'==1
}
replace firstdoo = 17167 if firstyoo==2007
replace firstdoo = 17532 if firstyoo==2008
replace firstdoo = 17898 if firstyoo==2009
replace firstdoo = 18263 if firstyoo==2010
replace firstdoo = 18628 if firstyoo==2011
replace firstdoo = 18993 if firstyoo==2012
replace firstdoo = 19359 if firstyoo==2013

gen lastyoo = .
gen lastdoo = .
local years "2007 2008 2009 2010 2011 2012 2013"
foreach i in `years'{
	replace lastyoo = `i' if y`i'==1
}
replace lastdoo = 17531 if lastyoo==2007
replace lastdoo = 17897 if lastyoo==2008
replace lastdoo = 18262 if lastyoo==2009
replace lastdoo = 18627 if lastyoo==2010
replace lastdoo = 18992 if lastyoo==2011
replace lastdoo = 19358 if lastyoo==2012
replace lastdoo = 19723 if lastyoo==2013

replace lastdoo = death_dt if death_dt!=. & death_dt<lastdoo
replace lastyoo = year(death_dt) if death_dt!=. & death_dt<lastdoo

//race - 0 unknown, 1 white, 2 black, 3 other, 4 asian/pacific islander, 5 hispanic, 6 american indian/alaskan native
gen race_dw = 0
replace race_dw = 1 if race_bg=="1"
gen race_db = 0
replace race_db = 1 if race_bg=="2"
gen race_dh = 0
replace race_dh = 1 if race_bg=="5"
gen race_do = 0
replace race_do = 1 if race_bg=="0" | race_bg=="3" | race_bg=="4" | race_bg=="6" | race_bg==""

//sex - 1 male, 2 female
gen female = 0
replace female = 1 if sex=="2"

drop idn
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
