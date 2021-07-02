clear all
set more off

/*
•	Input: dementia_sum.dta, bene_demad_samp_YYYY.dta (08-13)
•	Output: adrdv4_0813.dta
•	Take all the people with various ADRD diagnoses. Makes a file with their timing variables, for verified diagnoses. Uses alzhe, alzhdmte, and incident_verify to make the variables within each year, then rowmin at end. AND does it all at end, so the file has both options. 
•	Does all verification within years
•	Effectively includes Patty’s old sample restrictions. 
*/

////////////////////////////////////////////////////////////////////////////////
////////////////	VERIFICATION FLAGS		////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
/*
incident_status: for the current year
   0="0.no AD or nonAD dementia"
   1="1.incident AD"
   2="2.incident nonAD dementia"
   3="3.incident AD-dementia before yr"   /* this means the nonAD dementia DX was before current year, but first AD dx is in current year */
   4="4.incident nonAD dementia-AD before yr"   /* this should never happen…if AD is the earliest dementia Dx then it will never be before a nonAD dx */
   7="7.already AD-dementia later"   /* this should never happen either…same reasons as above */
   8="8.already nonAD dementia-AD later"  /* this means dementia DX was prior to current year and AD dx came after current year */
   9="9.already AD and nonAD dementia"  /* both AD/nonAD dx incident in a prior year */\
   
incident_verify is:
	1 if the AD or non-AD dem is later confirmed as the same type
	2 if the AD or non-AD dem is later confirmed as any type of dementia (specified elsewhere)
	3 if the AD or non-AD dem is later switched to the other
	0 if we never see another dementia of any type
	.X if there's no incident (ie, nothing to be verified)
	//1 takes precedence over 2, which takes precendence over 3.
*/

//use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/bene_demad_samp_2006.dta", replace
//use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/bene_demad_samp_2007.dta", replace


//2008
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/bene_demad_samp_2008.dta", replace
keep bene_id incident_status incident_verify alzhe alzhdmte

keep if alzhdmte!=.
gen nadde = alzhdmte 
replace nadde = . if alzhdmte==alzhe & alzhdmte!=. & alzhe!=.
replace nadde = . if alzhdmte>alzhe & alzhdmte!=. & alzhe!=.

gen ADv_2008 = 1 if year(alzhe)==2008 & (incident_verify==1 | incident_verify==2)
gen ADv_dt_2008 = alzhe if ADv_2008==1

rename incident_status incident_status_2008
rename incident_verify incident_verify_2008

compress
tempfile ver2008
save `ver2008', replace

//2009
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/bene_demad_samp_2009.dta", replace
keep bene_id incident_status incident_verify alzhe alzhdmte

keep if alzhdmte!=.
gen nadde = alzhdmte 
replace nadde = . if alzhdmte==alzhe & alzhdmte!=. & alzhe!=.
replace nadde = . if alzhdmte>alzhe & alzhdmte!=. & alzhe!=.

gen ADv_2009 = 1 if year(alzhe)==2009 & (incident_verify==1 | incident_verify==2)
gen ADv_dt_2009 = alzhe if ADv_2009==1

rename incident_status incident_status_2009
rename incident_verify incident_verify_2009

compress
tempfile ver2009
save `ver2009', replace

//2010
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/bene_demad_samp_2010.dta", replace
keep bene_id incident_status incident_verify alzhe alzhdmte

keep if alzhdmte!=.
gen nadde = alzhdmte 
replace nadde = . if alzhdmte==alzhe & alzhdmte!=. & alzhe!=.
replace nadde = . if alzhdmte>alzhe & alzhdmte!=. & alzhe!=.

gen ADv_2010 = 1 if year(alzhe)==2010 & (incident_verify==1 | incident_verify==2)
gen ADv_dt_2010 = alzhe if ADv_2010==1

rename incident_status incident_status_2010
rename incident_verify incident_verify_2010

compress
tempfile ver2010
save `ver2010', replace

//2011
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/bene_demad_samp_2011.dta", replace
keep bene_id incident_status incident_verify alzhe alzhdmte

keep if alzhdmte!=.
gen nadde = alzhdmte 
replace nadde = . if alzhdmte==alzhe & alzhdmte!=. & alzhe!=.
replace nadde = . if alzhdmte>alzhe & alzhdmte!=. & alzhe!=.

gen ADv_2011 = 1 if year(alzhe)==2011 & (incident_verify==1 | incident_verify==2)
gen ADv_dt_2011 = alzhe if ADv_2011==1

rename incident_status incident_status_2011
rename incident_verify incident_verify_2011

compress
tempfile ver2011
save `ver2011', replace

//2012
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/bene_demad_samp_2012.dta", replace
keep bene_id incident_status incident_verify alzhe alzhdmte

keep if alzhdmte!=.
gen nadde = alzhdmte 
replace nadde = . if alzhdmte==alzhe & alzhdmte!=. & alzhe!=.
replace nadde = . if alzhdmte>alzhe & alzhdmte!=. & alzhe!=.

gen ADv_2012 = 1 if year(alzhe)==2012 & (incident_verify==1 | incident_verify==2)
gen ADv_dt_2012 = alzhe if ADv_2012==1

rename incident_status incident_status_2012
rename incident_verify incident_verify_2012

compress
tempfile ver2012
save `ver2012', replace

//2013
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/bene_demad_samp_2013.dta", replace
keep bene_id incident_status incident_verify alzhe alzhdmte

keep if alzhdmte!=.
gen nadde = alzhdmte 
replace nadde = . if alzhdmte==alzhe & alzhdmte!=. & alzhe!=.
replace nadde = . if alzhdmte>alzhe & alzhdmte!=. & alzhe!=.

gen ADv_2013 = 1 if year(alzhe)==2013 & (incident_verify==1 | incident_verify==2)
gen ADv_dt_2013 = alzhe if ADv_2013==1

rename incident_status incident_status_2013
rename incident_verify incident_verify_2013

compress
tempfile ver2013
save `ver2013', replace

////////////////////////////////////////////////////////////////////////////////
/////////////////////		MERGE			////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use `ver2008', replace
tempfile adrd
save `adrd', replace

use `ver2009', replace
merge 1:1 bene_id using `adrd'
drop _m
save `adrd', replace

use `ver2010', replace
merge 1:1 bene_id using `adrd'
drop _m
save `adrd', replace

use `ver2011', replace
merge 1:1 bene_id using `adrd'
drop _m
save `adrd', replace

use `ver2012', replace
merge 1:1 bene_id using `adrd'
drop _m
save `adrd', replace

use `ver2013', replace
merge 1:1 bene_id using `adrd'
drop _m
save `adrd', replace

//get birthday
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
keep bene_id bene_dob

merge 1:1 bene_id using `adrd'
keep if _m==3 | _m==2
drop _m

////////////////////////////////////////////////////////////////////////////////
////////////////		SUMMARY VARIABLES		////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// one obs per person, and everything xfilled from the merge

/*
Note: ADv must be observed - meaning that they can only happen from 2008 on in this data
		AD, ADRD, and NADD all count events back to 1999
*/

//AD timingee
gen AD_dt = alzhe
gen AD_year = year(AD_dt)
gen AD_ageD = AD_dt-bene_dob
gen AD_age = AD_ageD/365

egen ADv_dt = rowmin(ADv_dt_2008 ADv_dt_2009 ADv_dt_2010 ADv_dt_2011 ADv_dt_2012 ADv_dt_2013)
gen ADv_year = year(ADv_dt)
gen ADv_ageD = ADv_dt-bene_dob
gen ADv_age = ADv_ageD/365

//ADRD timing
gen ADRD_dt = alzhdmte
gen ADRD_year = year(ADRD_dt)
gen ADRD_ageD = ADRD_dt-bene_dob
gen ADRD_age = ADRD_ageD/365

//Non AD dementia
gen NADD_dt = nadde
gen NADD_year = year(NADD_dt)
gen NADD_ageD = NADD_dt-bene_dob
gen NADD_age = NADD_ageD/365

//save
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/adrdv4_0813.dta", replace
