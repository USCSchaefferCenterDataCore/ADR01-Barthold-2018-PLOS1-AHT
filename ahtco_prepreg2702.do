clear all
set more off
capture log close


/*
•	Input: ahtco_long0713a.dta, 
o	adrdv4_0813.dta, hcc_long0713.dta, ccw_0713.dta, geoedu_long0713.dta, stat_long0713.dta, phy_long0613.dta, adrx_long0713.dta
•	Output: ahtco_long0713_2702.dta
o	Note that this file includes observations for people after they get ADRD (or whatever).
o	It also includes obs for people in the year that they die. 
o	Includes all the people who got AD 1999-2007 (not picked up in the ADv variable)
o	In subsequent files, you need to drop the observations that occur after the diagnosis of interest. Maybe also drop dying people. 
•	In the long file of aht use, merges in concurrent obs for AD diagnoses, HCC, CCW, geoedu, and statin use. 
•	Makes RAS vars, user vars, combo vars and lags of those for the 14 classes, and statins. 
•	Makes AD_inc vars, comorbidity variables.
*/

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_long0713a.dta", replace
tempfile aht
save `aht', replace

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
//			Merge in AD info, and CCW info, geoedu, statins					  //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/adrdv4_0813.dta", replace
keep bene_id ///
AD_dt AD_year AD_ageD AD_age ///
ADv_dt ADv_year ADv_age ADv_ageD  ///
ADRD_dt ADRD_year ADRD_age ADRD_ageD ///
NADD_dt NADD_year NADD_age NADD_ageD

merge 1:m bene_id using `aht'
drop if _m==1  //dropping those in the AD file, but not the aht file
drop _m
save `aht', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/hcc_long0713.dta", replace
merge 1:1 bene_id year using `aht'
drop if _m==1 //dropping those in the hcc file, but not in the aht file. 
drop _m

sum hcc_comm if hcc_comm!=., detail
gen hcc4 = .
replace hcc4 = 1 if hcc_comm>=r(min) & hcc_comm<r(p25)
replace hcc4 = 2 if hcc_comm>=r(p25) & hcc_comm<r(p50)
replace hcc4 = 3 if hcc_comm>=r(p50) & hcc_comm<r(p75)
replace hcc4 = 4 if hcc_comm>=r(p75) & hcc_comm!=.

sort bene_id year
gen hcc4_L1 = .
replace hcc4_L1 = hcc4[_n-1] if bene_id==bene_id[_n-1]
replace hcc4_L1 = . if year==2007

save `aht', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/phy_long0613.dta", replace
merge 1:1 bene_id year using `aht'
drop if _m==1 //dropping those in the phy file, but not in the aht file. 
drop _m

sum phyvis if phyvis!=., detail
gen phyvis4 = .
replace phyvis4 = 1 if phyvis>=r(min) & phyvis<r(p25)
replace phyvis4 = 2 if phyvis>=r(p25) & phyvis<r(p50)
replace phyvis4 = 3 if phyvis>=r(p50) & phyvis<r(p75)
replace phyvis4 = 4 if phyvis>=r(p75) & phyvis!=.

sort bene_id year
gen phyvis4_L1 = .
replace phyvis4_L1 = phyvis4[_n-1] if bene_id==bene_id[_n-1]
replace phyvis4_L1 = . if year==2007

save `aht', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/ccw_0713.dta", replace
keep bene_id amie atrialfe diabtese strktiae hypert_ever hyperl_ever alzhe alzhdmte
rename alzhe ADccw_dt
rename alzhdmte ADRDccw_dt
rename hypert_ever hyperte
rename hyperl_ever hyperle

gen NADDccw_dt = ADRDccw_dt 
replace NADDccw_dt = . if ADRDccw_dt==ADccw_dt & ADRDccw_dt!=. & ADccw_dt!=.
replace NADDccw_dt = . if ADRDccw_dt>ADccw_dt & ADRDccw_dt!=. & ADccw_dt!=.

gen ADccw_year = year(ADccw_dt)
gen ADRDccw_year = year(ADRDccw_dt)
gen NADDccw_year = year(NADDccw_dt)

merge 1:m bene_id using `aht'
drop if _m==1 //dropping those in the ccw file, but not i the aht file
drop _m
save `aht', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/geoses_long0713.dta", replace
merge 1:1 bene_id year using `aht'
drop if _m==1 //dropping those in the geoses file, but not in the aht file. 
drop _m

//xfill by hand, because the values may not be consistent within bene_id
sort bene_id year
replace fips_county = fips_county[_n-1] if fips_county=="" & bene_id==bene_id[_n-1]
replace pct_hsgrads = pct_hsgrads[_n-1] if pct_hsgrads==. & bene_id==bene_id[_n-1]
replace medinc = medinc[_n-1] if medinc==. & bene_id==bene_id[_n-1]

gsort -bene_id -year
replace fips_county = fips_county[_n-1] if fips_county=="" & bene_id==bene_id[_n-1]
replace pct_hsgrads = pct_hsgrads[_n-1] if pct_hsgrads==. & bene_id==bene_id[_n-1]
replace medinc = medinc[_n-1] if medinc==. & bene_id==bene_id[_n-1]

sort bene_id year

//to get consistent values of county within cluster (ie county), prioritize earliest value of fips_county within each person.
egen idn = group(bene_id)
gen county07 = fips_county if year==2007
xfill county07, i(idn)
replace county07 = fips_county if year==2008 & county07==""
xfill county07, i(idn)
replace county07 = fips_county if year==2009 & county07==""
xfill county07, i(idn)
replace county07 = fips_county if year==2010 & county07==""
xfill county07, i(idn)
replace county07 = fips_county if year==2011 & county07==""
xfill county07, i(idn)
replace county07 = fips_county if year==2012 & county07==""
xfill county07, i(idn)
replace county07 = fips_county if year==2013 & county07==""
xfill county07, i(idn)

//drop missing value people
count
drop if fips_county==""
count
drop if county07==""
count
drop if pct_hsgrads==.
count
drop if medinc==.
count
drop idn

sum medinc if medinc!=., detail
gen medinc4 = .
replace medinc4 = 1 if medinc>=r(min) & medinc<r(p25) 
replace medinc4 = 2 if medinc>=r(p25) & medinc<r(p50) 
replace medinc4 = 3 if medinc>=r(p50) & medinc<r(p75) 
replace medinc4 = 4 if medinc>=r(p75) & medinc!=. 
gen medinc4_L1 = medinc4[_n-1] if bene_id==bene_id[_n-1]

sum pct_hsgrads if pct_hsgrads!=., detail
gen pct_hsgrads4 = .
replace pct_hsgrads4 = 1 if pct_hsgrads>=r(min) & pct_hsgrads<r(p25) 
replace pct_hsgrads4 = 2 if pct_hsgrads>=r(p25) & pct_hsgrads<r(p50) 
replace pct_hsgrads4 = 3 if pct_hsgrads>=r(p50) & pct_hsgrads<r(p75) 
replace pct_hsgrads4 = 4 if pct_hsgrads>=r(p75) & pct_hsgrads!=. 
gen pct_hsgrads4_L1 = pct_hsgrads4[_n-1] if bene_id==bene_id[_n-1]

save `aht', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_long0713a.dta", replace
rename stat_consdays stat_pdays
merge 1:1 bene_id year using `aht'
drop if _m==1 //dropping those in the statin file, but not in the aht file
drop _m

replace stat_clms = 0 if stat_clms==.
replace stat_pdays = 0 if stat_pdays==.

save `aht', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/ADdrug/adrx_long0713.dta", replace
keep bene_id year adrx_clms adrx_pdays
merge 1:1 bene_id year using `aht'
drop if _m==1 //dropping those in the adrx file, but not in the aht file
drop _m

replace adrx_clms = 0 if adrx_clms==.
replace adrx_pdays = 0 if adrx_pdays==.

save `aht', replace

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_long0713b.dta", replace
*/
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
//			Make t and t-1 variables for drug use, diagnoses, 				  //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_long0713b.dta", replace

sort bene_id year

///////////////////////    	DRUG VARIABLES       	////////////////////////////

//Make summary variables for acei a2rb bblo cchb loop thia, ras
/* 10 subgroups:
	aceiso aceicchb aceithia 
	a2rbso a2rbthia 
	bbloso bblothia 
	cchbso  
	loopso
	thiaso
*/

//Aggregate categories variables
//Make clm, pday, and user vars for the aggregate categories
//Each of these (acei a2rb bblo cchb loop thia ras aht) all include the use of the corresponding combo pills
gen acei_clms = 0
gen acei_pdays = 0
replace acei_clms = aceiso_clms + aceicchb_clms + aceithia_clms
replace acei_pdays = aceiso_pdays + aceicchb_pdays + aceithia_pdays
replace acei_pdays = 365 if acei_pdays>365

gen a2rb_clms = 0
gen a2rb_pdays = 0
replace a2rb_clms = a2rbso_clms + a2rbthia_clms 
replace a2rb_pdays = a2rbso_pdays + a2rbthia_pdays 
replace a2rb_pdays = 365 if a2rb_pdays>365

gen bblo_clms = 0
gen bblo_pdays = 0
replace bblo_clms = bbloso_clms + bblothia_clms
replace bblo_pdays = bbloso_pdays + bblothia_pdays
replace bblo_pdays = 365 if bblo_pdays>365

gen cchb_clms = 0
gen cchb_pdays = 0
replace cchb_clms = cchbso_clms + aceicchb_clms
replace cchb_pdays = cchbso_pdays + aceicchb_pdays
replace cchb_pdays = 365 if cchb_pdays>365

gen loop_clms = 0
gen loop_pdays = 0
replace loop_clms = loopso_clms 
replace loop_pdays = loopso_pdays 
replace loop_pdays = 365 if loop_pdays>365

gen thia_clms = 0
gen thia_pdays = 0
replace thia_clms = thiaso_clms + aceithia_clms + a2rbthia_clms + bblothia_clms
replace thia_pdays = thiaso_pdays + aceithia_pdays + a2rbthia_pdays + bblothia_pdays
replace thia_pdays = 365 if thia_pdays>365

gen aht_clms = 0
gen aht_pdays = 0
replace aht_clms = acei_clms + a2rb_clms + bblo_clms + cchb_clms + loop_clms + thia_clms
replace aht_pdays = acei_pdays + a2rb_pdays + bblo_pdays + cchb_pdays + loop_pdays + thia_pdays
replace aht_pdays = 365 if aht_pdays>365

gen ras_clms = 0
gen ras_pdays = 0
replace ras_clms = acei_clms + a2rb_clms
replace ras_pdays = acei_pdays + a2rb_pdays
replace ras_pdays = 365 if ras_pdays>365

gen rasso_clms = 0
gen rasso_pdays = 0
replace rasso_clms = aceiso_clms + a2rbso_clms
replace rasso_pdays = aceiso_pdays + a2rbso_pdays
replace rasso_pdays = 365 if rasso_pdays>365

//user vars
// note: user vars in the bigger categories pick up people that fall into none of the sub-categories. 
local vars "aht ras rasso acei aceiso aceicchb aceithia a2rb a2rbso a2rbthia bblo bbloso bblothia cchb cchbso loop loopso thia thiaso stat adrx"
foreach i in `vars'{
	gen `i'_user = 0
	replace `i'_user = 1 if `i'_pdays>=270 & `i'_clms>=2
}

//high exposure vars
/*
foreach i in `vars'{
	sum `i'_pdays if `i'_user==1, detail
	gen `i'_high = 0
	replace `i'_high = 1 if `i'_pdays>=r(p50)
}
*/

//lag vars
foreach i in `vars'{
	gen `i'_user_L1 = 0
	replace `i'_user_L1 = 1 if `i'_pdays[_n-1]>=270 & `i'_clms[_n-1]>=2 & bene_id==bene_id[_n-1]
	replace `i'_user_L1 = . if year==2007
	
	gen `i'_user_L12 = 0
	replace `i'_user_L12 = 1 if `i'_pdays[_n-1]>=270 & `i'_pdays[_n-2]>=270 & `i'_clms[_n-1]>=2 & `i'_clms[_n-2]>=2 & bene_id==bene_id[_n-1] & bene_id==bene_id[_n-2]
	replace `i'_user_L12 = . if year==2007 | year==2008  

	gen `i'_user_L2 = 0
	replace `i'_user_L2 = 1 if `i'_pdays[_n-2]>=270 & `i'_clms[_n-2]>=2 & bene_id==bene_id[_n-2]
	replace `i'_user_L2 = . if year==2007 | year==2008  

	//gen `i'_mpr = 0
	//replace `i'_mpr = `i'_pdays/365 
	//replace `i'_mpr = 1 if `i'_mpr>1

	//gen `i'_mpr_012 = 0
	//replace `i'_mpr_012 = (`i'_pdays + `i'_pdays[_n-1] + `i'_pdays[_n-2])/1095 if bene_id==bene_id[_n-1] & bene_id==bene_id[_n-2]
	//replace `i'_mpr_012 = 1 if `i'_mpr_012>1
	//replace `i'_mpr_012 = . if year==2007 | year==2008  
	
	//gen `i'_mpr_L12 = 0
	//replace `i'_mpr_L12 = (`i'_pdays[_n-1] + `i'_pdays[_n-2])/730 if bene_id==bene_id[_n-1] & bene_id==bene_id[_n-2]
	//replace `i'_mpr_L12 = 1 if `i'_mpr_L12>1
	//replace `i'_mpr_L12 = . if year==2007 | year==2008  
}

//interaction variables
/* 		Everything above looked at combination pills. Now, we'll make dummies for
			6 solo users of each class, adn 15 interactions */
			
//solo variables - ras acei a2rb bblo cchb loop thia
//		note that these user variables account for use of the combo pills

////////////	Current
//solo
gen ras_solo = 0
replace ras_solo = 1 if rasso_user==1 & (bblo_user==0 & cchb_user==0 & loop_user==0 & thia_user==0)
gen acei_solo = 0 
replace acei_solo = 1 if aceiso_user==1 & (a2rb_user==0 & bblo_user==0 & cchb_user==0 & loop_user==0 & thia_user==0)
gen a2rb_solo = 0 
replace a2rb_solo = 1 if a2rbso_user==1 & (acei_user==0 & bblo_user==0 & cchb_user==0 & loop_user==0 & thia_user==0)
gen bblo_solo = 0 
replace bblo_solo = 1 if bbloso_user==1 & (acei_user==0 & a2rb_user==0 & cchb_user==0 & loop_user==0 & thia_user==0)
gen cchb_solo = 0 
replace cchb_solo = 1 if cchbso_user==1 & (acei_user==0 & a2rb_user==0 & bblo_user==0 & loop_user==0 & thia_user==0)
gen loop_solo = 0 
replace loop_solo = 1 if loopso_user==1 & (acei_user==0 & a2rb_user==0 & bblo_user==0 & cchb_user==0 & thia_user==0)
gen thia_solo = 0 
replace thia_solo = 1 if thiaso_user==1 & (acei_user==0 & a2rb_user==0 & bblo_user==0 & cchb_user==0 & loop_user==0)

gen classcount = 0
replace classcount = acei_user + a2rb_user + bblo_user + cchb_user + loop_user + thia_user

gen any_solo = 0
replace any_solo = 1 if classcount==1

gen any_combo = 0
replace any_combo = 1 if classcount>1 & classcount!=.

//interaction variables of ras and non-ras. 
gen ras_comb = 0
replace ras_comb = 1 if ras_user==1 & (bblo_user==1 | cchb_user==1 | loop_user==1 | thia_user==1)
replace ras_comb = 1 if aceicchb_user==1 | aceithia_user==1 | a2rbthia_user==1 

//interactions of acei and a2rb - note that these aren't truly mutually exclusive, because you can be a combo user for both acei and a2rb
gen acei_comb = 0
replace acei_comb = 1 if acei_user==1 & (a2rb_user==1 | bblo_user==1 | cchb_user==1 | loop_user==1 | thia_user==1)
replace acei_comb = 1 if aceicchb_user==1 | aceithia_user==1

gen a2rb_comb = 0
replace a2rb_comb = 1 if a2rb_user==1 & (acei_user==1 | bblo_user==1 | cchb_user==1 | loop_user==1 | thia_user==1)
replace a2rb_comb = 1 if a2rbthia_user==1 

////////////	L1
//solo
gen ras_solo_L1 = 0
replace ras_solo_L1 = 1 if rasso_user_L1==1 & (bblo_user_L1==0 & cchb_user_L1==0 & loop_user_L1==0 & thia_user_L1==0)
gen acei_solo_L1 = 0 
replace acei_solo_L1 = 1 if aceiso_user_L1==1 & (a2rb_user_L1==0 & bblo_user_L1==0 & cchb_user_L1==0 & loop_user_L1==0 & thia_user_L1==0)
gen a2rb_solo_L1 = 0 
replace a2rb_solo_L1 = 1 if a2rbso_user_L1==1 & (acei_user_L1==0 & bblo_user_L1==0 & cchb_user_L1==0 & loop_user_L1==0 & thia_user_L1==0)
gen bblo_solo_L1 = 0 
replace bblo_solo_L1 = 1 if bbloso_user_L1==1 & (acei_user_L1==0 & a2rb_user_L1==0 & cchb_user_L1==0 & loop_user_L1==0 & thia_user_L1==0)
gen cchb_solo_L1 = 0 
replace cchb_solo_L1 = 1 if cchbso_user_L1==1 & (acei_user_L1==0 & a2rb_user_L1==0 & bblo_user_L1==0 & loop_user_L1==0 & thia_user_L1==0)
gen loop_solo_L1 = 0 
replace loop_solo_L1 = 1 if loopso_user_L1==1 & (acei_user_L1==0 & a2rb_user_L1==0 & bblo_user_L1==0 & cchb_user_L1==0 & thia_user_L1==0)
gen thia_solo_L1 = 0 
replace thia_solo_L1 = 1 if thiaso_user_L1==1 & (acei_user_L1==0 & a2rb_user_L1==0 & bblo_user_L1==0 & cchb_user_L1==0 & loop_user_L1==0)

gen classcount_L1 = 0
replace classcount_L1 = acei_user_L1 + a2rb_user_L1 + bblo_user_L1 + cchb_user_L1 + loop_user_L1 + thia_user_L1

gen any_solo_L1 = 0
replace any_solo_L1 = 1 if classcount_L1==1

gen any_combo_L1 = 0
replace any_combo_L1 = 1 if classcount_L1>1 & classcount_L1!=.

//interaction variables of ras and non-ras. 
gen ras_comb_L1 = 0
replace ras_comb_L1 = 1 if ras_user_L1==1 & (bblo_user_L1==1 | cchb_user_L1==1 | loop_user_L1==1 | thia_user_L1==1)
replace ras_comb_L1 = 1 if aceicchb_user_L1==1 | aceithia_user_L1==1 | a2rbthia_user_L1==1 

//interactions of acei and a2rb - note that these aren't truly mutually exclusive, because you can be a combo user for both acei and a2rb
gen acei_comb_L1 = 0
replace acei_comb_L1 = 1 if acei_user_L1==1 & (a2rb_user_L1==1 | bblo_user_L1==1 | cchb_user_L1==1 | loop_user_L1==1 | thia_user_L1==1)
replace acei_comb_L1 = 1 if aceicchb_user_L1==1 | aceithia_user_L1==1

gen a2rb_comb_L1 = 0
replace a2rb_comb_L1 = 1 if a2rb_user_L1==1 & (acei_user_L1==1 | bblo_user_L1==1 | cchb_user_L1==1 | loop_user_L1==1 | thia_user_L1==1)
replace a2rb_comb_L1 = 1 if a2rbthia_user_L1==1 

//L2
gen classcount_L2 = 0
replace classcount_L2 = acei_user_L2 + a2rb_user_L2 + bblo_user_L2 + cchb_user_L2 + loop_user_L2 + thia_user_L2

////////////	L12
//solo
gen ras_solo_L12 = 0
replace ras_solo_L12 = 1 if rasso_user_L12==1 & (bblo_user_L12==0 & cchb_user_L12==0 & loop_user_L12==0 & thia_user_L12==0)
gen acei_solo_L12 = 0 
replace acei_solo_L12 = 1 if aceiso_user_L12==1 & (a2rb_user_L12==0 & bblo_user_L12==0 & cchb_user_L12==0 & loop_user_L12==0 & thia_user_L12==0)
gen a2rb_solo_L12 = 0 
replace a2rb_solo_L12 = 1 if a2rbso_user_L12==1 & (acei_user_L12==0 & bblo_user_L12==0 & cchb_user_L12==0 & loop_user_L12==0 & thia_user_L12==0)
gen bblo_solo_L12 = 0 
replace bblo_solo_L12 = 1 if bbloso_user_L12==1 & (acei_user_L12==0 & a2rb_user_L12==0 & cchb_user_L12==0 & loop_user_L12==0 & thia_user_L12==0)
gen cchb_solo_L12 = 0 
replace cchb_solo_L12 = 1 if cchbso_user_L12==1 & (acei_user_L12==0 & a2rb_user_L12==0 & bblo_user_L12==0 & loop_user_L12==0 & thia_user_L12==0)
gen loop_solo_L12 = 0 
replace loop_solo_L12 = 1 if loopso_user_L12==1 & (acei_user_L12==0 & a2rb_user_L12==0 & bblo_user_L12==0 & cchb_user_L12==0 & thia_user_L12==0)
gen thia_solo_L12 = 0 
replace thia_solo_L12 = 1 if thiaso_user_L12==1 & (acei_user_L12==0 & a2rb_user_L12==0 & bblo_user_L12==0 & cchb_user_L12==0 & loop_user_L12==0)

gen classcount_L12 = 0
replace classcount_L12 = acei_user_L12 + a2rb_user_L12 + bblo_user_L12 + cchb_user_L12 + loop_user_L12 + thia_user_L12

gen any_solo_L12 = 0
replace any_solo_L12 = 1 if classcount_L12==1 & classcount_L1==1 & classcount_L2==1

gen any_combo_L12 = 0
replace any_combo_L12 = 1 if classcount_L12>1 & classcount_L12!=.

//interaction variables of ras and non-ras. 
gen ras_comb_L12 = 0
replace ras_comb_L12 = 1 if ras_user_L12==1 & (bblo_user_L12==1 | cchb_user_L12==1 | loop_user_L12==1 | thia_user_L12==1)
replace ras_comb_L12 = 1 if aceicchb_user_L12==1 | aceithia_user_L12==1 | a2rbthia_user_L12==1 

//interactions of acei and a2rb - note that these aren't truly mutually exclusive, because you can be a combo user for both acei and a2rb
gen acei_comb_L12 = 0
replace acei_comb_L12 = 1 if acei_user_L12==1 & (a2rb_user_L12==1 | bblo_user_L12==1 | cchb_user_L12==1 | loop_user_L12==1 | thia_user_L12==1)
replace acei_comb_L12 = 1 if aceicchb_user_L12==1 | aceithia_user_L12==1

gen a2rb_comb_L12 = 0
replace a2rb_comb_L12 = 1 if a2rb_user_L12==1 & (acei_user_L12==1 | bblo_user_L12==1 | cchb_user_L12==1 | loop_user_L12==1 | thia_user_L12==1)
replace a2rb_comb_L12 = 1 if a2rbthia_user_L12==1 

//interactions of specific classes
/*		This will make 15 comb vars:  5+4+3+2+1  (to be used with 6 solo variables)  
acei_solo_L1 acei_a2rb_L1 acei_bblo_L1 acei_cchb_L1 acei_loop_L1 acei_thia_L1 
a2rb_solo_L1 a2rb_bblo_L1 a2rb_cchb_L1 a2rb_loop_L1 a2rb_thia_L1 
bblo_solo_L1 bblo_cchb_L1 bblo_loop_L1 bblo_thia_L1 
cchb_solo_L1 cchb_loop_L1 cchb_thia_L1 
loop_solo_L1 loop_thia_L1
thia_solo_L1
*/

//acei and 5
gen acei_a2rb_L1 = 0
replace acei_a2rb_L1 = 1 if acei_user_L1==1 & a2rb_user_L1==1
gen acei_bblo_L1 = 0
replace acei_bblo_L1 = 1 if acei_user_L1==1 & bblo_user_L1==1
gen acei_cchb_L1 = 0
replace acei_cchb_L1 = 1 if acei_user_L1==1 & cchb_user_L1==1
gen acei_loop_L1 = 0
replace acei_loop_L1 = 1 if acei_user_L1==1 & loop_user_L1==1
gen acei_thia_L1 = 0
replace acei_thia_L1 = 1 if acei_user_L1==1 & thia_user_L1==1

//a2rb and 4
gen a2rb_bblo_L1 = 0
replace a2rb_bblo_L1 = 1 if a2rb_user_L1==1 & bblo_user_L1==1
gen a2rb_cchb_L1 = 0
replace a2rb_cchb_L1 = 1 if a2rb_user_L1==1 & cchb_user_L1==1
gen a2rb_loop_L1 = 0
replace a2rb_loop_L1 = 1 if a2rb_user_L1==1 & loop_user_L1==1
gen a2rb_thia_L1 = 0
replace a2rb_thia_L1 = 1 if a2rb_user_L1==1 & thia_user_L1==1

//bblo and 3
gen bblo_cchb_L1 = 0
replace bblo_cchb_L1 = 1 if bblo_user_L1==1 & cchb_user_L1==1
gen bblo_loop_L1 = 0
replace bblo_loop_L1 = 1 if bblo_user_L1==1 & loop_user_L1==1
gen bblo_thia_L1 = 0
replace bblo_thia_L1 = 1 if bblo_user_L1==1 & thia_user_L1==1

//cchb and 2
gen cchb_loop_L1 = 0
replace cchb_loop_L1 = 1 if cchb_user_L1==1 & loop_user_L1==1
gen cchb_thia_L1 = 0
replace cchb_thia_L1 = 1 if cchb_user_L1==1 & thia_user_L1==1

//loop and 1
gen loop_thia_L1 = 0
replace loop_thia_L1 = 1 if loop_user_L1==1 & thia_user_L1==1

/////////////////////////////////////////////////////////////
//any of the other 4
gen oth4_user = 0
replace oth4_user = 1 if bblo_user==1 | cchb_user==1 | loop_user==1 | thia_user==1
gen oth4_user_L12 = 0
replace oth4_user_L12 = 1 if bblo_user_L12==1 | cchb_user_L12==1 | loop_user_L12==1 | thia_user_L12==1

//1 RAS at the the threshold
gen ras1_user = 0
replace ras1_user = 1 if acei_user==1 | a2rb_user==1
gen ras1_user_L12 = 0
replace ras1_user_L12 = 1 if acei_user_L12==1 | a2rb_user_L12==1

///////////////////////    		AD VARIABLES       	////////////////////////////
local adrd "AD ADv ADRD NADD NADDccw ADccw ADRDccw"
foreach i in `adrd'{
	gen `i'_inc = 0
	replace `i'_inc = 1 if `i'_year==year 
	replace `i'_inc = 2 if `i'_year<year 
}

//Comorbidities prior to year t, all based on ccw
gen cmd_ami = 0 
gen cmd_atf = 0 
gen cmd_dia = 0 
gen cmd_str = 0 
gen cmd_hyp = 0 
gen cmd_hyperl = 0 
replace cmd_ami = 1 if year(amie)<year
replace cmd_atf = 1 if year(atrialfe)<year
replace cmd_dia = 1 if year(diabtese)<year
replace cmd_str = 1 if year(strktiae)<year
replace cmd_hyp = 1 if year(hyperte)<year
replace cmd_hyperl = 1 if year(hyperle)<year

gen cmd_NADD = 0
replace cmd_NADD = 1 if NADDccw_inc==2

gen ys_hypert = 0
replace ys_hypert = year-year(hyperte)
replace ys_hypert = 0 if ys_hypert<0
replace ys_hypert = 0 if ys_hypert==.

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_long0713c2702.dta", replace

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
//			bene level variables on treatment, controls, outcomes			  //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_long0713c2702.dta", replace
egen idn = group(bene_id)
sort bene_id year

//treatment - ever user (ever 2 claims in a single year), ever high
// note: user vars in the bigger categories pick up people that fall into none of the sub-categories. 
local vars "aht ras rasso acei aceiso aceicchb aceithia a2rb a2rbso a2rbthia bblo bbloso bblothia cchb cchbso loop loopso thia thiaso"
foreach i in `vars'{
	egen `i'_user_ever = max(`i'_user), by(bene_id)
	//egen `i'_high_ever = max(`i'_high), by(bene_id)
}

//outcome - ever any of the diagnoses
local adrd "AD ADv ADRD NADD NADDccw ADccw ADRDccw"
foreach i in `adrd'{
	gen `i'_ever = .
	replace `i'_ever = 1 if `i'_inc==1 | `i'_inc==2
}
xfill AD_ever ADv_ever ADRD_ever NADD_ever NADDccw_ever ADccw_ever ADRDccw_ever, i(idn)
foreach i in `adrd'{
	replace `i'_ever = 0 if `i'_ever==.
}

//controls - age female race_d* hcc_comm cmd_* pct_hsgrads 
//		(prioritizing earliest value of time-variant variables)
gen agesq = age^2

gen age1 = age if year==2007
gen hcc_comm1 = hcc_comm if year==2007
gen pct_hsgrads1 = pct_hsgrads if year==2007
xfill age1 hcc_comm1 pct_hsgrads1, i(idn)
replace age1 = age if year==2008 & age1==.
replace hcc_comm1 = hcc_comm if year==2008 & hcc_comm1==.
replace pct_hsgrads1 = pct_hsgrads if year==2008 & pct_hsgrads1==.
xfill age1 hcc_comm1 pct_hsgrads1, i(idn)
replace age1 = age if year==2009 & age1==.
replace hcc_comm1 = hcc_comm if year==2009 & hcc_comm1==.
replace pct_hsgrads1 = pct_hsgrads if year==2009 & pct_hsgrads1==.
xfill age1 hcc_comm1 pct_hsgrads1, i(idn)
replace age1 = age if year==2010 & age1==.
replace hcc_comm1 = hcc_comm if year==2010 & hcc_comm1==.
replace pct_hsgrads1 = pct_hsgrads if year==2010 & pct_hsgrads1==.
xfill age1 hcc_comm1 pct_hsgrads1, i(idn)
replace age1 = age if year==2011 & age1==.
replace hcc_comm1 = hcc_comm if year==2011 & hcc_comm1==.
replace pct_hsgrads1 = pct_hsgrads if year==2011 & pct_hsgrads1==.
xfill age1 hcc_comm1 pct_hsgrads1, i(idn)
replace age1 = age if year==2012 & age1==.
replace hcc_comm1 = hcc_comm if year==2012 & hcc_comm1==.
replace pct_hsgrads1 = pct_hsgrads if year==2012 & pct_hsgrads1==.
xfill age1 hcc_comm1 pct_hsgrads1, i(idn)
replace age1 = age if year==2013 & age1==.
replace hcc_comm1 = hcc_comm if year==2013 & hcc_comm1==.
replace pct_hsgrads1 = pct_hsgrads if year==2013 & pct_hsgrads1==.
xfill age1 hcc_comm1 pct_hsgrads1, i(idn)

local cmd "ami atf dia str hyp hyperl"
foreach i in `cmd'{
	gen `i'_ever = .
	replace `i'_ever = 1 if cmd_`i'==1
}
xfill ami_ever atf_ever dia_ever str_ever hyp_ever hyperl_ever, i(idn)
foreach i in `cmd'{
	replace `i'_ever = 0 if `i'_ever==.
}

//used AChEI or memantine prior to reference year
gen adrx_prior = 0
replace adrx_prior = 1 if adrx_clms[_n-1]>=2 & bene_id==bene_id[_n-1]
replace adrx_prior = 1 if adrx_clms[_n-2]>=2 & bene_id==bene_id[_n-2]
replace adrx_prior = 1 if adrx_clms[_n-3]>=2 & bene_id==bene_id[_n-3]
replace adrx_prior = 1 if adrx_clms[_n-4]>=2 & bene_id==bene_id[_n-4]
replace adrx_prior = 1 if adrx_clms[_n-5]>=2 & bene_id==bene_id[_n-5]
replace adrx_prior = 1 if adrx_clms[_n-6]>=2 & bene_id==bene_id[_n-6]

drop idn

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
//			Long file of AHT use, AD incidence, and controls 				  //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/*
Note that this file includes observations for people after they get ADRD (or whatever).
It also includes obs for people in the year that they die. 
In subsequent files, you need to drop the observations that occur after the diagnosis of interest.
Maybe also drop dying people.

This file also includes all the people who got AD 1999-2007 (not picked up in the ADv variable)
*/
compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_long0713_2702.dta", replace

