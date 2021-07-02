clear all
set more off

/*
•	Input: bene_hcc10scoresYYYY.dta, 06-13. 
•	Output: hcc_0613.dta
•	Merges hcc files, makes variables for the hcc comm rating in each year. 
*/

////////////////////////////////////////////////////////////////////////////////
/////////////////		HCC WIDE 06-13	   /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2006.dta", clear
keep bene_id hcc_comm
gen y2006 = 1
rename hcc_comm hcc_comm_2006
tempfile hcc
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2007.dta", clear
keep bene_id hcc_comm
gen y2007 = 1
rename hcc_comm hcc_comm_2007
merge 1:1 bene_id using `hcc'
drop _m
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2008.dta", clear
keep bene_id hcc_comm
gen y2008 = 1
rename hcc_comm hcc_comm_2008
merge 1:1 bene_id using `hcc'
drop _m
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2009.dta", clear
keep bene_id hcc_comm
gen y2009 = 1
rename hcc_comm hcc_comm_2009
merge 1:1 bene_id using `hcc'
drop _m
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2010.dta", clear
keep bene_id hcc_comm
gen y2010 = 1
rename hcc_comm hcc_comm_2010
merge 1:1 bene_id using `hcc'
drop _m
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2011.dta", clear
keep bene_id hcc_comm
gen y2011 = 1
rename hcc_comm hcc_comm_2011
merge 1:1 bene_id using `hcc'
drop _m
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2012.dta", clear
keep bene_id hcc_comm
gen y2012 = 1
rename hcc_comm hcc_comm_2012
merge 1:1 bene_id using `hcc'
drop _m
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2013.dta", clear
keep bene_id hcc_comm
gen y2013 = 1
rename hcc_comm hcc_comm_2013
merge 1:1 bene_id using `hcc'
drop _m

///////////////////////   variables
gen hcc_comm_earliest = .
local years "2013 2012 2011 2010 2009 2008 2007 2006"
foreach i in `years'{
	replace hcc_comm_earliest = hcc_comm_`i' if y`i'==1
}

drop y20*

///////  SAVE
sort bene_id
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/hcc_0613.dta", replace

////////////////////////////////////////////////////////////////////////////////
/////////////////		HCC WIDE 07-13	   /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2007.dta", clear
keep bene_id hcc_comm
gen y2007 = 1
rename hcc_comm hcc_comm_2007
tempfile hcc
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2008.dta", clear
keep bene_id hcc_comm
gen y2008 = 1
rename hcc_comm hcc_comm_2008
merge 1:1 bene_id using `hcc'
drop _m
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2009.dta", clear
keep bene_id hcc_comm
gen y2009 = 1
rename hcc_comm hcc_comm_2009
merge 1:1 bene_id using `hcc'
drop _m
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2010.dta", clear
keep bene_id hcc_comm
gen y2010 = 1
rename hcc_comm hcc_comm_2010
merge 1:1 bene_id using `hcc'
drop _m
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2011.dta", clear
keep bene_id hcc_comm
gen y2011 = 1
rename hcc_comm hcc_comm_2011
merge 1:1 bene_id using `hcc'
drop _m
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2012.dta", clear
keep bene_id hcc_comm
gen y2012 = 1
rename hcc_comm hcc_comm_2012
merge 1:1 bene_id using `hcc'
drop _m
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2013.dta", clear
keep bene_id hcc_comm
gen y2013 = 1
rename hcc_comm hcc_comm_2013
merge 1:1 bene_id using `hcc'
drop _m

///////////////////////   variables
gen hcc_comm_earliest = .
local years "2013 2012 2011 2010 2009 2008 2007"
foreach i in `years'{
	replace hcc_comm_earliest = hcc_comm_`i' if y`i'==1
}

drop y20*

///////  SAVE
sort bene_id
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/hcc_0713.dta", replace

////////////////////////////////////////////////////////////////////////////////
/////////////////		HCC LONG 07-13	   /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2007.dta", clear
keep bene_id hcc_comm
gen year = 2007
tempfile hcc
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2008.dta", clear
keep bene_id hcc_comm
gen year = 2008
append using `hcc'
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2009.dta", clear
keep bene_id hcc_comm
gen year = 2009
append using `hcc'
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2010.dta", clear
keep bene_id hcc_comm
gen year = 2010
append using `hcc'
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2011.dta", clear
keep bene_id hcc_comm
gen year = 2011
append using `hcc'
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2012.dta", clear
keep bene_id hcc_comm
gen year = 2012
append using `hcc'
save `hcc', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/HealthStatus/HCCscores/bene_hcc10scores2013.dta", clear
keep bene_id hcc_comm
gen year = 2013
append using `hcc'
save `hcc', replace

///////  SAVE
sort bene_id year
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/hcc_long0713.dta", replace
