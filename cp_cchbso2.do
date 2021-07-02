clear all
set more off
capture log close

/*
•	Input: pdeYYYY.dta, fdb_ndc_extract.dta, ipcYYYY.dta, snfcYYYY.dta
•	Output: XXXX(so)_XXXX_YYYYp.dta, 0713
•	For drugs of interest, pulls users from 06-13, by class name 
o	Classes determined by ndcbyclass.do 
•	Makes arrays of use to characterize use during the year. Pushes forward extra pills from early fills, the last fill of the year, IP days, and SNF days. 
o	New patricia push, and gets rid of repeat claims on the same day.
•	Makes wide file, showing days of use in each unit of time.
•	These classes exist, but there are no claims: cchbso a2rbbblo cchbsothia cchbthia
*/

////////////////////////////////////////////////////////////////////////////////
/////////			NDC level file with cchbso	////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//keep the ndcs defined by gname, excluding the combo pills
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Extracts/FDB/fdb_ndc_extract.dta", replace
keep ndc hic3_desc ahfs_desc

gen cchbso = 1 if hic3_desc=="CALCIUM CHANNEL BLOCKING AGENTS" | ///
	hic3_desc=="RENIN INHIBITOR, DIRECT & CALCIUM CHANNEL BLOCKER" | ///
	hic3_desc=="ANTIHYPERLIP - HMG-COA&CALCIUM CHANNEL BLOCKER CB" | ///
	hic3_desc=="ANALGESICS, NEURONAL-TYPE CALCIUM CHANNEL BLOCKERS"

keep if cchbso==1 

tempfile cchbso
save `cchbso', replace

////////////////////////////////////////////////////////////////////////////////
///////////////////////			cchbso pull			////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////		2006			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2006/pde2006.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `cchbso'
keep if _m==3 
drop _m
codebook bene_id

egen idn = group(bene_id)
sort bene_id srvc_dt

//Two claims for the same bene on the same day?
/* ~38 claims out of a 1000 (for 2006 loops) are by the same person on the same day
(i.e. 19 pairs of claims). We think those prescritpions are meant to be taken together,
meaning that if it's two 30 day fills, it is worth 30 possession days, not 60. 
So, we'll take the max of the two claims on the same day, and then drop one of the 
observations. 
*/
egen claim=group(bene_id srvc_dt)

gen repeat = 1 if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]
replace repeat = 1 if srvc_dt==srvc_dt[_n+1] & bene_id==bene_id[_n+1]

egen repeatday = max(dayssply), by(claim)
replace dayssply = repeatday if repeat==1

drop repeat repeatday claim
drop if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]

//////////////////  Early fills pushes
//for people that fill their prescription before emptying their last, carry the extra pills forward
//extrapill_push is the amount, from that fill date, that is superfluous for reaching the next fill date. Capped at 10. 
gen doy_srvc = doy(srvc_dt)
replace doy_srvc = 0 if year(srvc_dt)<2006
replace doy_srvc = 365 if year(srvc_dt)>2006

gen extrapill_push = 0
replace extrapill_push = extrapill_push + (doy_srvc+dayssply)-(doy_srvc[_n+1]) if bene_id==bene_id[_n+1]
replace extrapill_push = 0 if extrapill_push<0
replace extrapill_push = 10 if extrapill_push>10

//pushstock is the accumulated stock of extra pills. Capped at 10. 
gen pushstock = extrapill_push
replace extrapill_push = 10 if extrapill_push>10

gen need = 0
replace need = (doy_srvc[_n+1])-(doy_srvc+dayssply)
replace need = (365 - (doy_srvc)+dayssply) if bene_id!=bene_id[_n+1]
replace need = 0 if need<0

gen dayssply2 = dayssply

// Creating a loop that will loop through one observation at a time and do the following
/* 1. Add the previous pushstock to the current pushstock
   2. Add the needed extra pills to the dayssply which is the dayssply + the min of either the need or the pushstock since:
	a. If need < pushstock, then need gets added to dayssply
	b. If need >= pushstock, then pushstock gets added to dayssply
   3. Calculate the new pushstock, which is the pushstock minus the need with a bottom cap at 0 and a high cap at 10 */
	
local N=_N

forvalues i=1/`N' {
	quietly replace pushstock=pushstock[_n-1]+pushstock if pushstock[_n-1]<. & bene_id==bene_id[_n-1] in `i'
	quietly replace dayssply2=dayssply2+min(need,pushstock) if bene_id==bene_id[_n-1] in `i'
	quietly replace pushstock=min(max(pushstock-need,0),10) if bene_id==bene_id[_n-1] in `i'
}

//value of early fill push stock at the end of the year
gen earlyfill_push = pushstock if bene_id!=bene_id[_n+1]
replace earlyfill_push = 0 if earlyfill_push<0
replace earlyfill_push = 10 if earlyfill_push>10 & earlyfill_push!=.
//extra pills from last prescription at end of year, capped at 90
gen lastfill_push = (doy_srvc+dayssply-365) if bene_id!=bene_id[_n+1]
replace lastfill_push = 0 if lastfill_push<0 & lastfill_push!=.
replace lastfill_push = 90 if lastfill_push>90 & lastfill_push!=.

xfill earlyfill_push lastfill_push, i(idn)

drop pushstock need extrapill_push

///////////////// Array
forvalues d = 1/365{
	gen cchbso_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & cchbso==1
}

drop doy_srvc
xfill cchbso_a*, i(idn)

/////////////////bene-class timing
egen cchbso_fdays_2006 = sum(dayssply), by(idn)
egen cchbso_clms_2006 = count(dayssply), by(idn)
egen cchbso_minfilldt_2006 = min(srvc_dt), by(idn)
egen cchbso_maxfilldt_2006 = max(srvc_dt), by(idn)
gen cchbso_fillperiod_2006 = cchbso_maxfilldt_2006 - cchbso_minfilldt_2006 + 1

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

replace earlyfill_push = 0 if earlyfill_push==.
replace lastfill_push = 0 if lastfill_push==.

tempfile classarray
save `classarray', replace

/////////////////		 Bring in SNF 		////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/snf/2006/snfc2006.dta", clear
keep bene_id from_dt thru_dt

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2006
replace doy_from = 365 if year(from_dt)>2006
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2006
replace doy_thru = 365 if year(thru_dt)>2006

////////////// Array
forvalues d = 1/365{
	gen snf_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru 
}
drop from_dt thru_dt doy_from doy_thru
xfill snf_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////   SNF push
//snf_push is the extra days added for SNF days concurrent with drug days. Capped at 10. 
gen snf_push = 0

forvalues d = 1/365{
	replace snf_push = snf_push + 1 if cchbso_a`d'==1 & snf_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the snf_push)
	//if that cchbso_a spot is empty:
	gen v1 = 1 if snf_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace snf_push = snf_push-1 if v1==1
	drop v1
	replace snf_push = 10 if snf_push>10
}
drop snf_a*

save `classarray', replace

/////////////////		 Bring in IP 		////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/ip/2006/ipc2006.dta", clear
keep bene_id from_dt thru_dt 

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2006
replace doy_from = 365 if year(from_dt)>2006
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2006
replace doy_thru = 365 if year(thru_dt)>2006

//////////////// Array
forvalues d = 1/365{
	gen ips_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru
}
drop from_dt thru_dt doy_from doy_thru
xfill ips_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////////  IP push
//ips_push is the extra days added for ip days concurrent with drug days
gen ips_push = 0

forvalues d = 1/365{
	replace ips_push = ips_push + 1 if cchbso_a`d'==1 & ips_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the ips_push)
	//if that cchbso_a spot is not full:
	gen v1 = 1 if ips_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen cchbso_pdays_2006 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2006 possession days
*/
forvalues d = 1/365{
	replace cchbso_pdays_2006 = cchbso_pdays_2006 + 1 if cchbso_a`d'==1
}
drop cchbso_a*
replace cchbso_pdays_2006 = 365 if cchbso_pdays_2006>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen cchbso_push_2006 = rowmax(lastfill_push inyear_push) 
replace cchbso_push_2006 = 0 if cchbso_push_2006==.
replace cchbso_push_2006 = 0 if cchbso_push_2006<0

keep bene_id cchbso* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2006p.dta", replace

keep bene_id cchbso_push_2006
tempfile push
save `push', replace

////////////////		2007			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2007/pde2007.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `cchbso'
keep if _m==3 
drop _m

merge m:1 bene_id using `push'
keep if _m==3 | _m==1
drop _m

egen idn = group(bene_id)
sort bene_id srvc_dt

//Two claims for the same bene on the same day?
/* ~38 claims out of a 1000 (for 2006 loops) are by the same person on the same day
(i.e. 19 pairs of claims). We think those prescritpions are meant to be taken together,
meaning that if it's two 30 day fills, it is worth 30 possession days, not 60. 
So, we'll take the max of the two claims on the same day, and then drop one of the 
observations. 
*/
egen claim=group(bene_id srvc_dt)

gen repeat = 1 if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]
replace repeat = 1 if srvc_dt==srvc_dt[_n+1] & bene_id==bene_id[_n+1]

egen repeatday = max(dayssply), by(claim)
replace dayssply = repeatday if repeat==1

drop repeat repeatday claim
drop if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]

//////////////////  Early fills pushes
//for people that fill their prescription before emptying their last, carry the extra pills forward
//extrapill_push is the amount, from that fill date, that is superfluous for reaching the next fill date. Capped at 10. 
gen doy_srvc = doy(srvc_dt)
replace doy_srvc = 0 if year(srvc_dt)<2007
replace doy_srvc = 365 if year(srvc_dt)>2007

gen extrapill_push = 0
replace extrapill_push = extrapill_push + (doy_srvc+dayssply)-(doy_srvc[_n+1]) if bene_id==bene_id[_n+1]
replace extrapill_push = 0 if extrapill_push<0
replace extrapill_push = 10 if extrapill_push>10

//pushstock is the accumulated stock of extra pills. Capped at 10. 
gen pushstock = extrapill_push
replace extrapill_push = 10 if extrapill_push>10

//add the pushstock from last year
replace pushstock = pushstock + cchbso_push_2006 if bene_id!=bene_id[_n-1] | _n==1

gen need = 0
replace need = (doy_srvc[_n+1])-(doy_srvc+dayssply)
replace need = (365 - (doy_srvc)+dayssply) if bene_id!=bene_id[_n+1]
replace need = 0 if need<0

gen dayssply2 = dayssply

// Creating a loop that will loop through one observation at a time and do the following
/* 1. Add the previous pushstock to the current pushstock
   2. Add the needed extra pills to the dayssply which is the dayssply + the min of either the need or the pushstock since:
	a. If need < pushstock, then need gets added to dayssply
	b. If need >= pushstock, then pushstock gets added to dayssply
   3. Calculate the new pushstock, which is the pushstock minus the need with a bottom cap at 0 and a high cap at 10 */
	
local N=_N

forvalues i=1/`N' {
	quietly replace pushstock=pushstock[_n-1]+pushstock if pushstock[_n-1]<. & bene_id==bene_id[_n-1] in `i'
	quietly replace dayssply2=dayssply2+min(need,pushstock) if bene_id==bene_id[_n-1] in `i'
	quietly replace pushstock=min(max(pushstock-need,0),10) if bene_id==bene_id[_n-1] in `i'
}

//value of early fill push stock at the end of the year
gen earlyfill_push = pushstock if bene_id!=bene_id[_n+1]
replace earlyfill_push = 0 if earlyfill_push<0
replace earlyfill_push = 10 if earlyfill_push>10 & earlyfill_push!=.
//extra pills from last prescription at end of year, capped at 90
gen lastfill_push = (doy_srvc+dayssply-365) if bene_id!=bene_id[_n+1]
replace lastfill_push = 0 if lastfill_push<0 & lastfill_push!=.
replace lastfill_push = 90 if lastfill_push>90 & lastfill_push!=.

xfill earlyfill_push lastfill_push, i(idn)

drop pushstock need extrapill_push

///////////////// Array
forvalues d = 1/365{
	gen cchbso_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & cchbso==1
}

drop doy_srvc
xfill cchbso_a*, i(idn)

/////////////////bene-class timing
egen cchbso_fdays_2007 = sum(dayssply), by(idn)
egen cchbso_clms_2007 = count(dayssply), by(idn)
egen cchbso_minfilldt_2007 = min(srvc_dt), by(idn)
egen cchbso_maxfilldt_2007 = max(srvc_dt), by(idn)
gen cchbso_fillperiod_2007 = cchbso_maxfilldt_2007 - cchbso_minfilldt_2007 + 1

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

replace earlyfill_push = 0 if earlyfill_push==.
replace lastfill_push = 0 if lastfill_push==.

tempfile classarray
save `classarray', replace

/////////////////		 Bring in SNF 		////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/snf/2007/snfc2007.dta", clear
keep bene_id from_dt thru_dt

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2007
replace doy_from = 365 if year(from_dt)>2007
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2007
replace doy_thru = 365 if year(thru_dt)>2007

////////////// Array
forvalues d = 1/365{
	gen snf_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru 
}
drop from_dt thru_dt doy_from doy_thru
xfill snf_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////   SNF push
//snf_push is the extra days added for SNF days concurrent with drug days. Capped at 10. 
gen snf_push = 0

forvalues d = 1/365{
	replace snf_push = snf_push + 1 if cchbso_a`d'==1 & snf_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the snf_push)
	//if that cchbso_a spot is empty:
	gen v1 = 1 if snf_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace snf_push = snf_push-1 if v1==1
	drop v1
	replace snf_push = 10 if snf_push>10
}
drop snf_a*

save `classarray', replace

/////////////////		 Bring in IP 		////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/ip/2007/ipc2007.dta", clear
keep bene_id from_dt thru_dt 

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2007
replace doy_from = 365 if year(from_dt)>2007
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2007
replace doy_thru = 365 if year(thru_dt)>2007

//////////////// Array
forvalues d = 1/365{
	gen ips_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru
}
drop from_dt thru_dt doy_from doy_thru
xfill ips_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////////  IP push
//ips_push is the extra days added for ip days concurrent with drug days
gen ips_push = 0

forvalues d = 1/365{
	replace ips_push = ips_push + 1 if cchbso_a`d'==1 & ips_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the ips_push)
	//if that cchbso_a spot is not full:
	gen v1 = 1 if ips_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen cchbso_pdays_2007 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2007 possession days
*/
forvalues d = 1/365{
	replace cchbso_pdays_2007 = cchbso_pdays_2007 + 1 if cchbso_a`d'==1
}
drop cchbso_a*
replace cchbso_pdays_2007 = 365 if cchbso_pdays_2007>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen cchbso_push_2007 = rowmax(lastfill_push inyear_push) 
replace cchbso_push_2007 = 0 if cchbso_push_2007==.
replace cchbso_push_2007 = 0 if cchbso_push_2007<0

keep bene_id cchbso* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2007p.dta", replace

keep bene_id cchbso_push_2007
tempfile push
save `push', replace

////////////////		2008			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2008/pde2008.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `cchbso'
keep if _m==3 
drop _m

merge m:1 bene_id using `push'
keep if _m==3 | _m==1
drop _m

egen idn = group(bene_id)
sort bene_id srvc_dt

//Two claims for the same bene on the same day?
/* ~38 claims out of a 1000 (for 2006 loops) are by the same person on the same day
(i.e. 19 pairs of claims). We think those prescritpions are meant to be taken together,
meaning that if it's two 30 day fills, it is worth 30 possession days, not 60. 
So, we'll take the max of the two claims on the same day, and then drop one of the 
observations. 
*/
egen claim=group(bene_id srvc_dt)

gen repeat = 1 if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]
replace repeat = 1 if srvc_dt==srvc_dt[_n+1] & bene_id==bene_id[_n+1]

egen repeatday = max(dayssply), by(claim)
replace dayssply = repeatday if repeat==1

drop repeat repeatday claim
drop if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]

//////////////////  Early fills pushes
//for people that fill their prescription before emptying their last, carry the extra pills forward
//extrapill_push is the amount, from that fill date, that is superfluous for reaching the next fill date. Capped at 10. 
gen doy_srvc = doy(srvc_dt)
replace doy_srvc = 0 if year(srvc_dt)<2008
replace doy_srvc = 365 if year(srvc_dt)>2008

gen extrapill_push = 0
replace extrapill_push = extrapill_push + (doy_srvc+dayssply)-(doy_srvc[_n+1]) if bene_id==bene_id[_n+1]
replace extrapill_push = 0 if extrapill_push<0
replace extrapill_push = 10 if extrapill_push>10

//pushstock is the accumulated stock of extra pills. Capped at 10. 
gen pushstock = extrapill_push
replace extrapill_push = 10 if extrapill_push>10

//add the pushstock from last year
replace pushstock = pushstock + cchbso_push_2007 if bene_id!=bene_id[_n-1] | _n==1

gen need = 0
replace need = (doy_srvc[_n+1])-(doy_srvc+dayssply)
replace need = (365 - (doy_srvc)+dayssply) if bene_id!=bene_id[_n+1]
replace need = 0 if need<0

gen dayssply2 = dayssply

// Creating a loop that will loop through one observation at a time and do the following
/* 1. Add the previous pushstock to the current pushstock
   2. Add the needed extra pills to the dayssply which is the dayssply + the min of either the need or the pushstock since:
	a. If need < pushstock, then need gets added to dayssply
	b. If need >= pushstock, then pushstock gets added to dayssply
   3. Calculate the new pushstock, which is the pushstock minus the need with a bottom cap at 0 and a high cap at 10 */
	
local N=_N

forvalues i=1/`N' {
	quietly replace pushstock=pushstock[_n-1]+pushstock if pushstock[_n-1]<. & bene_id==bene_id[_n-1] in `i'
	quietly replace dayssply2=dayssply2+min(need,pushstock) if bene_id==bene_id[_n-1] in `i'
	quietly replace pushstock=min(max(pushstock-need,0),10) if bene_id==bene_id[_n-1] in `i'
}

//value of early fill push stock at the end of the year
gen earlyfill_push = pushstock if bene_id!=bene_id[_n+1]
replace earlyfill_push = 0 if earlyfill_push<0
replace earlyfill_push = 10 if earlyfill_push>10 & earlyfill_push!=.
//extra pills from last prescription at end of year, capped at 90
gen lastfill_push = (doy_srvc+dayssply-365) if bene_id!=bene_id[_n+1]
replace lastfill_push = 0 if lastfill_push<0 & lastfill_push!=.
replace lastfill_push = 90 if lastfill_push>90 & lastfill_push!=.

xfill earlyfill_push lastfill_push, i(idn)

drop pushstock need extrapill_push

///////////////// Array
forvalues d = 1/365{
	gen cchbso_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & cchbso==1
}

drop doy_srvc
xfill cchbso_a*, i(idn)

/////////////////bene-class timing
egen cchbso_fdays_2008 = sum(dayssply), by(idn)
egen cchbso_clms_2008 = count(dayssply), by(idn)
egen cchbso_minfilldt_2008 = min(srvc_dt), by(idn)
egen cchbso_maxfilldt_2008 = max(srvc_dt), by(idn)
gen cchbso_fillperiod_2008 = cchbso_maxfilldt_2008 - cchbso_minfilldt_2008 + 1

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

replace earlyfill_push = 0 if earlyfill_push==.
replace lastfill_push = 0 if lastfill_push==.

tempfile classarray
save `classarray', replace

/////////////////		 Bring in SNF 		////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/snf/2008/snfc2008.dta", clear
keep bene_id from_dt thru_dt

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2008
replace doy_from = 365 if year(from_dt)>2008
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2008
replace doy_thru = 365 if year(thru_dt)>2008

////////////// Array
forvalues d = 1/365{
	gen snf_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru 
}
drop from_dt thru_dt doy_from doy_thru
xfill snf_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////   SNF push
//snf_push is the extra days added for SNF days concurrent with drug days. Capped at 10. 
gen snf_push = 0

forvalues d = 1/365{
	replace snf_push = snf_push + 1 if cchbso_a`d'==1 & snf_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the snf_push)
	//if that cchbso_a spot is empty:
	gen v1 = 1 if snf_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace snf_push = snf_push-1 if v1==1
	drop v1
	replace snf_push = 10 if snf_push>10
}
drop snf_a*

save `classarray', replace

/////////////////		 Bring in IP 		////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/ip/2008/ipc2008.dta", clear
keep bene_id from_dt thru_dt 

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2008
replace doy_from = 365 if year(from_dt)>2008
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2008
replace doy_thru = 365 if year(thru_dt)>2008

//////////////// Array
forvalues d = 1/365{
	gen ips_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru
}
drop from_dt thru_dt doy_from doy_thru
xfill ips_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////////  IP push
//ips_push is the extra days added for ip days concurrent with drug days
gen ips_push = 0

forvalues d = 1/365{
	replace ips_push = ips_push + 1 if cchbso_a`d'==1 & ips_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the ips_push)
	//if that cchbso_a spot is not full:
	gen v1 = 1 if ips_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen cchbso_pdays_2008 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2008 possession days
*/
forvalues d = 1/365{
	replace cchbso_pdays_2008 = cchbso_pdays_2008 + 1 if cchbso_a`d'==1
}
drop cchbso_a*
replace cchbso_pdays_2008 = 365 if cchbso_pdays_2008>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen cchbso_push_2008 = rowmax(lastfill_push inyear_push) 
replace cchbso_push_2008 = 0 if cchbso_push_2008==.
replace cchbso_push_2008 = 0 if cchbso_push_2008<0

keep bene_id cchbso* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2008p.dta", replace

keep bene_id cchbso_push_2008
tempfile push
save `push', replace

////////////////		2009			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2009/pde2009.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `cchbso'
keep if _m==3 
drop _m

merge m:1 bene_id using `push'
keep if _m==3 | _m==1
drop _m

egen idn = group(bene_id)
sort bene_id srvc_dt

//Two claims for the same bene on the same day?
/* ~38 claims out of a 1000 (for 2006 loops) are by the same person on the same day
(i.e. 19 pairs of claims). We think those prescritpions are meant to be taken together,
meaning that if it's two 30 day fills, it is worth 30 possession days, not 60. 
So, we'll take the max of the two claims on the same day, and then drop one of the 
observations. 
*/
egen claim=group(bene_id srvc_dt)

gen repeat = 1 if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]
replace repeat = 1 if srvc_dt==srvc_dt[_n+1] & bene_id==bene_id[_n+1]

egen repeatday = max(dayssply), by(claim)
replace dayssply = repeatday if repeat==1

drop repeat repeatday claim
drop if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]

//////////////////  Early fills pushes
//for people that fill their prescription before emptying their last, carry the extra pills forward
//extrapill_push is the amount, from that fill date, that is superfluous for reaching the next fill date. Capped at 10. 
gen doy_srvc = doy(srvc_dt)
replace doy_srvc = 0 if year(srvc_dt)<2009
replace doy_srvc = 365 if year(srvc_dt)>2009

gen extrapill_push = 0
replace extrapill_push = extrapill_push + (doy_srvc+dayssply)-(doy_srvc[_n+1]) if bene_id==bene_id[_n+1]
replace extrapill_push = 0 if extrapill_push<0
replace extrapill_push = 10 if extrapill_push>10

//pushstock is the accumulated stock of extra pills. Capped at 10. 
gen pushstock = extrapill_push
replace extrapill_push = 10 if extrapill_push>10

//add the pushstock from last year
replace pushstock = pushstock + cchbso_push_2008 if bene_id!=bene_id[_n-1] | _n==1

gen need = 0
replace need = (doy_srvc[_n+1])-(doy_srvc+dayssply)
replace need = (365 - (doy_srvc)+dayssply) if bene_id!=bene_id[_n+1]
replace need = 0 if need<0

gen dayssply2 = dayssply

// Creating a loop that will loop through one observation at a time and do the following
/* 1. Add the previous pushstock to the current pushstock
   2. Add the needed extra pills to the dayssply which is the dayssply + the min of either the need or the pushstock since:
	a. If need < pushstock, then need gets added to dayssply
	b. If need >= pushstock, then pushstock gets added to dayssply
   3. Calculate the new pushstock, which is the pushstock minus the need with a bottom cap at 0 and a high cap at 10 */
	
local N=_N

forvalues i=1/`N' {
	quietly replace pushstock=pushstock[_n-1]+pushstock if pushstock[_n-1]<. & bene_id==bene_id[_n-1] in `i'
	quietly replace dayssply2=dayssply2+min(need,pushstock) if bene_id==bene_id[_n-1] in `i'
	quietly replace pushstock=min(max(pushstock-need,0),10) if bene_id==bene_id[_n-1] in `i'
}

//value of early fill push stock at the end of the year
gen earlyfill_push = pushstock if bene_id!=bene_id[_n+1]
replace earlyfill_push = 0 if earlyfill_push<0
replace earlyfill_push = 10 if earlyfill_push>10 & earlyfill_push!=.
//extra pills from last prescription at end of year, capped at 90
gen lastfill_push = (doy_srvc+dayssply-365) if bene_id!=bene_id[_n+1]
replace lastfill_push = 0 if lastfill_push<0 & lastfill_push!=.
replace lastfill_push = 90 if lastfill_push>90 & lastfill_push!=.

xfill earlyfill_push lastfill_push, i(idn)

drop pushstock need extrapill_push

///////////////// Array
forvalues d = 1/365{
	gen cchbso_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & cchbso==1
}

drop doy_srvc
xfill cchbso_a*, i(idn)

/////////////////bene-class timing
egen cchbso_fdays_2009 = sum(dayssply), by(idn)
egen cchbso_clms_2009 = count(dayssply), by(idn)
egen cchbso_minfilldt_2009 = min(srvc_dt), by(idn)
egen cchbso_maxfilldt_2009 = max(srvc_dt), by(idn)
gen cchbso_fillperiod_2009 = cchbso_maxfilldt_2009 - cchbso_minfilldt_2009 + 1

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

replace earlyfill_push = 0 if earlyfill_push==.
replace lastfill_push = 0 if lastfill_push==.

tempfile classarray
save `classarray', replace

/////////////////		 Bring in SNF 		////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/snf/2009/snfc2009.dta", clear
keep bene_id from_dt thru_dt

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2009
replace doy_from = 365 if year(from_dt)>2009
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2009
replace doy_thru = 365 if year(thru_dt)>2009

////////////// Array
forvalues d = 1/365{
	gen snf_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru 
}
drop from_dt thru_dt doy_from doy_thru
xfill snf_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////   SNF push
//snf_push is the extra days added for SNF days concurrent with drug days. Capped at 10. 
gen snf_push = 0

forvalues d = 1/365{
	replace snf_push = snf_push + 1 if cchbso_a`d'==1 & snf_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the snf_push)
	//if that cchbso_a spot is empty:
	gen v1 = 1 if snf_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace snf_push = snf_push-1 if v1==1
	drop v1
	replace snf_push = 10 if snf_push>10
}
drop snf_a*

save `classarray', replace

/////////////////		 Bring in IP 		////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/ip/2009/ipc2009.dta", clear
keep bene_id from_dt thru_dt 

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2009
replace doy_from = 365 if year(from_dt)>2009
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2009
replace doy_thru = 365 if year(thru_dt)>2009

//////////////// Array
forvalues d = 1/365{
	gen ips_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru
}
drop from_dt thru_dt doy_from doy_thru
xfill ips_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////////  IP push
//ips_push is the extra days added for ip days concurrent with drug days
gen ips_push = 0

forvalues d = 1/365{
	replace ips_push = ips_push + 1 if cchbso_a`d'==1 & ips_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the ips_push)
	//if that cchbso_a spot is not full:
	gen v1 = 1 if ips_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen cchbso_pdays_2009 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2009 possession days
*/
forvalues d = 1/365{
	replace cchbso_pdays_2009 = cchbso_pdays_2009 + 1 if cchbso_a`d'==1
}
drop cchbso_a*
replace cchbso_pdays_2009 = 365 if cchbso_pdays_2009>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen cchbso_push_2009 = rowmax(lastfill_push inyear_push) 
replace cchbso_push_2009 = 0 if cchbso_push_2009==.
replace cchbso_push_2009 = 0 if cchbso_push_2009<0

keep bene_id cchbso* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2009p.dta", replace

keep bene_id cchbso_push_2009
tempfile push
save `push', replace

////////////////		2010			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2010/pde2010.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `cchbso'
keep if _m==3 
drop _m

merge m:1 bene_id using `push'
keep if _m==3 | _m==1
drop _m

egen idn = group(bene_id)
sort bene_id srvc_dt

//Two claims for the same bene on the same day?
/* ~38 claims out of a 1000 (for 2006 loops) are by the same person on the same day
(i.e. 19 pairs of claims). We think those prescritpions are meant to be taken together,
meaning that if it's two 30 day fills, it is worth 30 possession days, not 60. 
So, we'll take the max of the two claims on the same day, and then drop one of the 
observations. 
*/
egen claim=group(bene_id srvc_dt)

gen repeat = 1 if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]
replace repeat = 1 if srvc_dt==srvc_dt[_n+1] & bene_id==bene_id[_n+1]

egen repeatday = max(dayssply), by(claim)
replace dayssply = repeatday if repeat==1

drop repeat repeatday claim
drop if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]

//////////////////  Early fills pushes
//for people that fill their prescription before emptying their last, carry the extra pills forward
//extrapill_push is the amount, from that fill date, that is superfluous for reaching the next fill date. Capped at 10. 
gen doy_srvc = doy(srvc_dt)
replace doy_srvc = 0 if year(srvc_dt)<2010
replace doy_srvc = 365 if year(srvc_dt)>2010

gen extrapill_push = 0
replace extrapill_push = extrapill_push + (doy_srvc+dayssply)-(doy_srvc[_n+1]) if bene_id==bene_id[_n+1]
replace extrapill_push = 0 if extrapill_push<0
replace extrapill_push = 10 if extrapill_push>10

//pushstock is the accumulated stock of extra pills. Capped at 10. 
gen pushstock = extrapill_push
replace extrapill_push = 10 if extrapill_push>10

//add the pushstock from last year
replace pushstock = pushstock + cchbso_push_2009 if bene_id!=bene_id[_n-1] | _n==1

gen need = 0
replace need = (doy_srvc[_n+1])-(doy_srvc+dayssply)
replace need = (365 - (doy_srvc)+dayssply) if bene_id!=bene_id[_n+1]
replace need = 0 if need<0

gen dayssply2 = dayssply

// Creating a loop that will loop through one observation at a time and do the following
/* 1. Add the previous pushstock to the current pushstock
   2. Add the needed extra pills to the dayssply which is the dayssply + the min of either the need or the pushstock since:
	a. If need < pushstock, then need gets added to dayssply
	b. If need >= pushstock, then pushstock gets added to dayssply
   3. Calculate the new pushstock, which is the pushstock minus the need with a bottom cap at 0 and a high cap at 10 */
	
local N=_N

forvalues i=1/`N' {
	quietly replace pushstock=pushstock[_n-1]+pushstock if pushstock[_n-1]<. & bene_id==bene_id[_n-1] in `i'
	quietly replace dayssply2=dayssply2+min(need,pushstock) if bene_id==bene_id[_n-1] in `i'
	quietly replace pushstock=min(max(pushstock-need,0),10) if bene_id==bene_id[_n-1] in `i'
}

//value of early fill push stock at the end of the year
gen earlyfill_push = pushstock if bene_id!=bene_id[_n+1]
replace earlyfill_push = 0 if earlyfill_push<0
replace earlyfill_push = 10 if earlyfill_push>10 & earlyfill_push!=.
//extra pills from last prescription at end of year, capped at 90
gen lastfill_push = (doy_srvc+dayssply-365) if bene_id!=bene_id[_n+1]
replace lastfill_push = 0 if lastfill_push<0 & lastfill_push!=.
replace lastfill_push = 90 if lastfill_push>90 & lastfill_push!=.

xfill earlyfill_push lastfill_push, i(idn)

drop pushstock need extrapill_push

///////////////// Array
forvalues d = 1/365{
	gen cchbso_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & cchbso==1
}

drop doy_srvc
xfill cchbso_a*, i(idn)

/////////////////bene-class timing
egen cchbso_fdays_2010 = sum(dayssply), by(idn)
egen cchbso_clms_2010 = count(dayssply), by(idn)
egen cchbso_minfilldt_2010 = min(srvc_dt), by(idn)
egen cchbso_maxfilldt_2010 = max(srvc_dt), by(idn)
gen cchbso_fillperiod_2010 = cchbso_maxfilldt_2010 - cchbso_minfilldt_2010 + 1

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

replace earlyfill_push = 0 if earlyfill_push==.
replace lastfill_push = 0 if lastfill_push==.

tempfile classarray
save `classarray', replace

/////////////////		 Bring in SNF 		////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/snf/2010/snfc2010.dta", clear
keep bene_id from_dt thru_dt

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2010
replace doy_from = 365 if year(from_dt)>2010
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2010
replace doy_thru = 365 if year(thru_dt)>2010

////////////// Array
forvalues d = 1/365{
	gen snf_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru 
}
drop from_dt thru_dt doy_from doy_thru
xfill snf_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////   SNF push
//snf_push is the extra days added for SNF days concurrent with drug days. Capped at 10. 
gen snf_push = 0

forvalues d = 1/365{
	replace snf_push = snf_push + 1 if cchbso_a`d'==1 & snf_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the snf_push)
	//if that cchbso_a spot is empty:
	gen v1 = 1 if snf_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace snf_push = snf_push-1 if v1==1
	drop v1
	replace snf_push = 10 if snf_push>10
}
drop snf_a*

save `classarray', replace

/////////////////		 Bring in IP 		////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/ip/2010/ipc2010.dta", clear
keep bene_id from_dt thru_dt 

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2010
replace doy_from = 365 if year(from_dt)>2010
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2010
replace doy_thru = 365 if year(thru_dt)>2010

//////////////// Array
forvalues d = 1/365{
	gen ips_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru
}
drop from_dt thru_dt doy_from doy_thru
xfill ips_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////////  IP push
//ips_push is the extra days added for ip days concurrent with drug days
gen ips_push = 0

forvalues d = 1/365{
	replace ips_push = ips_push + 1 if cchbso_a`d'==1 & ips_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the ips_push)
	//if that cchbso_a spot is not full:
	gen v1 = 1 if ips_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen cchbso_pdays_2010 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2010 possession days
*/
forvalues d = 1/365{
	replace cchbso_pdays_2010 = cchbso_pdays_2010 + 1 if cchbso_a`d'==1
}
drop cchbso_a*
replace cchbso_pdays_2010 = 365 if cchbso_pdays_2010>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen cchbso_push_2010 = rowmax(lastfill_push inyear_push) 
replace cchbso_push_2010 = 0 if cchbso_push_2010==.
replace cchbso_push_2010 = 0 if cchbso_push_2010<0

keep bene_id cchbso* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2010p.dta", replace

keep bene_id cchbso_push_2010
tempfile push
save `push', replace

////////////////		2011			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2011/pde2011.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `cchbso'
keep if _m==3 
drop _m

merge m:1 bene_id using `push'
keep if _m==3 | _m==1
drop _m

egen idn = group(bene_id)
sort bene_id srvc_dt

//Two claims for the same bene on the same day?
/* ~38 claims out of a 1000 (for 2006 loops) are by the same person on the same day
(i.e. 19 pairs of claims). We think those prescritpions are meant to be taken together,
meaning that if it's two 30 day fills, it is worth 30 possession days, not 60. 
So, we'll take the max of the two claims on the same day, and then drop one of the 
observations. 
*/
egen claim=group(bene_id srvc_dt)

gen repeat = 1 if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]
replace repeat = 1 if srvc_dt==srvc_dt[_n+1] & bene_id==bene_id[_n+1]

egen repeatday = max(dayssply), by(claim)
replace dayssply = repeatday if repeat==1

drop repeat repeatday claim
drop if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]

//////////////////  Early fills pushes
//for people that fill their prescription before emptying their last, carry the extra pills forward
//extrapill_push is the amount, from that fill date, that is superfluous for reaching the next fill date. Capped at 10. 
gen doy_srvc = doy(srvc_dt)
replace doy_srvc = 0 if year(srvc_dt)<2011
replace doy_srvc = 365 if year(srvc_dt)>2011

gen extrapill_push = 0
replace extrapill_push = extrapill_push + (doy_srvc+dayssply)-(doy_srvc[_n+1]) if bene_id==bene_id[_n+1]
replace extrapill_push = 0 if extrapill_push<0
replace extrapill_push = 10 if extrapill_push>10

//pushstock is the accumulated stock of extra pills. Capped at 10. 
gen pushstock = extrapill_push
replace extrapill_push = 10 if extrapill_push>10

//add the pushstock from last year
replace pushstock = pushstock + cchbso_push_2010 if bene_id!=bene_id[_n-1] | _n==1

gen need = 0
replace need = (doy_srvc[_n+1])-(doy_srvc+dayssply)
replace need = (365 - (doy_srvc)+dayssply) if bene_id!=bene_id[_n+1]
replace need = 0 if need<0

gen dayssply2 = dayssply

// Creating a loop that will loop through one observation at a time and do the following
/* 1. Add the previous pushstock to the current pushstock
   2. Add the needed extra pills to the dayssply which is the dayssply + the min of either the need or the pushstock since:
	a. If need < pushstock, then need gets added to dayssply
	b. If need >= pushstock, then pushstock gets added to dayssply
   3. Calculate the new pushstock, which is the pushstock minus the need with a bottom cap at 0 and a high cap at 10 */
	
local N=_N

forvalues i=1/`N' {
	quietly replace pushstock=pushstock[_n-1]+pushstock if pushstock[_n-1]<. & bene_id==bene_id[_n-1] in `i'
	quietly replace dayssply2=dayssply2+min(need,pushstock) if bene_id==bene_id[_n-1] in `i'
	quietly replace pushstock=min(max(pushstock-need,0),10) if bene_id==bene_id[_n-1] in `i'
}

//value of early fill push stock at the end of the year
gen earlyfill_push = pushstock if bene_id!=bene_id[_n+1]
replace earlyfill_push = 0 if earlyfill_push<0
replace earlyfill_push = 10 if earlyfill_push>10 & earlyfill_push!=.
//extra pills from last prescription at end of year, capped at 90
gen lastfill_push = (doy_srvc+dayssply-365) if bene_id!=bene_id[_n+1]
replace lastfill_push = 0 if lastfill_push<0 & lastfill_push!=.
replace lastfill_push = 90 if lastfill_push>90 & lastfill_push!=.

xfill earlyfill_push lastfill_push, i(idn)

drop pushstock need extrapill_push

///////////////// Array
forvalues d = 1/365{
	gen cchbso_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & cchbso==1
}

drop doy_srvc
xfill cchbso_a*, i(idn)

/////////////////bene-class timing
egen cchbso_fdays_2011 = sum(dayssply), by(idn)
egen cchbso_clms_2011 = count(dayssply), by(idn)
egen cchbso_minfilldt_2011 = min(srvc_dt), by(idn)
egen cchbso_maxfilldt_2011 = max(srvc_dt), by(idn)
gen cchbso_fillperiod_2011 = cchbso_maxfilldt_2011 - cchbso_minfilldt_2011 + 1

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

replace earlyfill_push = 0 if earlyfill_push==.
replace lastfill_push = 0 if lastfill_push==.

tempfile classarray
save `classarray', replace

/////////////////		 Bring in SNF 		////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/snf/2011/snfc2011.dta", clear
keep bene_id from_dt thru_dt

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2011
replace doy_from = 365 if year(from_dt)>2011
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2011
replace doy_thru = 365 if year(thru_dt)>2011

////////////// Array
forvalues d = 1/365{
	gen snf_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru 
}
drop from_dt thru_dt doy_from doy_thru
xfill snf_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////   SNF push
//snf_push is the extra days added for SNF days concurrent with drug days. Capped at 10. 
gen snf_push = 0

forvalues d = 1/365{
	replace snf_push = snf_push + 1 if cchbso_a`d'==1 & snf_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the snf_push)
	//if that cchbso_a spot is empty:
	gen v1 = 1 if snf_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace snf_push = snf_push-1 if v1==1
	drop v1
	replace snf_push = 10 if snf_push>10
}
drop snf_a*

save `classarray', replace

/////////////////		 Bring in IP 		////////////////////////////////////
use "/disk/agedisk2/medicare/data/20pct/ip/2011/ipc2011.dta", clear
keep bene_id from_dt thru_dt 

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2011
replace doy_from = 365 if year(from_dt)>2011
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2011
replace doy_thru = 365 if year(thru_dt)>2011

//////////////// Array
forvalues d = 1/365{
	gen ips_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru
}
drop from_dt thru_dt doy_from doy_thru
xfill ips_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////////  IP push
//ips_push is the extra days added for ip days concurrent with drug days
gen ips_push = 0

forvalues d = 1/365{
	replace ips_push = ips_push + 1 if cchbso_a`d'==1 & ips_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the ips_push)
	//if that cchbso_a spot is not full:
	gen v1 = 1 if ips_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen cchbso_pdays_2011 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2011 possession days
*/
forvalues d = 1/365{
	replace cchbso_pdays_2011 = cchbso_pdays_2011 + 1 if cchbso_a`d'==1
}
drop cchbso_a*
replace cchbso_pdays_2011 = 365 if cchbso_pdays_2011>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen cchbso_push_2011 = rowmax(lastfill_push inyear_push) 
replace cchbso_push_2011 = 0 if cchbso_push_2011==.
replace cchbso_push_2011 = 0 if cchbso_push_2011<0

keep bene_id cchbso* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2011p.dta", replace

keep bene_id cchbso_push_2011
tempfile push
save `push', replace

////////////////		2012			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2012/pde2012.dta", replace
keep bene_id srvc_dt prod_srvc_id days_suply_num
rename prod_srvc_id ndc
rename days_suply_num dayssply

merge m:1 ndc using `cchbso'
keep if _m==3 
drop _m

merge m:1 bene_id using `push'
keep if _m==3 | _m==1
drop _m

egen idn = group(bene_id)
sort bene_id srvc_dt

//Two claims for the same bene on the same day?
/* ~38 claims out of a 1000 (for 2006 loops) are by the same person on the same day
(i.e. 19 pairs of claims). We think those prescritpions are meant to be taken together,
meaning that if it's two 30 day fills, it is worth 30 possession days, not 60. 
So, we'll take the max of the two claims on the same day, and then drop one of the 
observations. 
*/
egen claim=group(bene_id srvc_dt)

gen repeat = 1 if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]
replace repeat = 1 if srvc_dt==srvc_dt[_n+1] & bene_id==bene_id[_n+1]

egen repeatday = max(dayssply), by(claim)
replace dayssply = repeatday if repeat==1

drop repeat repeatday claim
drop if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]

//////////////////  Early fills pushes
//for people that fill their prescription before emptying their last, carry the extra pills forward
//extrapill_push is the amount, from that fill date, that is superfluous for reaching the next fill date. Capped at 10. 
gen doy_srvc = doy(srvc_dt)
replace doy_srvc = 0 if year(srvc_dt)<2012
replace doy_srvc = 365 if year(srvc_dt)>2012

gen extrapill_push = 0
replace extrapill_push = extrapill_push + (doy_srvc+dayssply)-(doy_srvc[_n+1]) if bene_id==bene_id[_n+1]
replace extrapill_push = 0 if extrapill_push<0
replace extrapill_push = 10 if extrapill_push>10

//pushstock is the accumulated stock of extra pills. Capped at 10. 
gen pushstock = extrapill_push
replace extrapill_push = 10 if extrapill_push>10

//add the pushstock from last year
replace pushstock = pushstock + cchbso_push_2011 if bene_id!=bene_id[_n-1] | _n==1

gen need = 0
replace need = (doy_srvc[_n+1])-(doy_srvc+dayssply)
replace need = (365 - (doy_srvc)+dayssply) if bene_id!=bene_id[_n+1]
replace need = 0 if need<0

gen dayssply2 = dayssply

// Creating a loop that will loop through one observation at a time and do the following
/* 1. Add the previous pushstock to the current pushstock
   2. Add the needed extra pills to the dayssply which is the dayssply + the min of either the need or the pushstock since:
	a. If need < pushstock, then need gets added to dayssply
	b. If need >= pushstock, then pushstock gets added to dayssply
   3. Calculate the new pushstock, which is the pushstock minus the need with a bottom cap at 0 and a high cap at 10 */
	
local N=_N

forvalues i=1/`N' {
	quietly replace pushstock=pushstock[_n-1]+pushstock if pushstock[_n-1]<. & bene_id==bene_id[_n-1] in `i'
	quietly replace dayssply2=dayssply2+min(need,pushstock) if bene_id==bene_id[_n-1] in `i'
	quietly replace pushstock=min(max(pushstock-need,0),10) if bene_id==bene_id[_n-1] in `i'
}

//value of early fill push stock at the end of the year
gen earlyfill_push = pushstock if bene_id!=bene_id[_n+1]
replace earlyfill_push = 0 if earlyfill_push<0
replace earlyfill_push = 10 if earlyfill_push>10 & earlyfill_push!=.
//extra pills from last prescription at end of year, capped at 90
gen lastfill_push = (doy_srvc+dayssply-365) if bene_id!=bene_id[_n+1]
replace lastfill_push = 0 if lastfill_push<0 & lastfill_push!=.
replace lastfill_push = 90 if lastfill_push>90 & lastfill_push!=.

xfill earlyfill_push lastfill_push, i(idn)

drop pushstock need extrapill_push

///////////////// Array
forvalues d = 1/365{
	gen cchbso_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & cchbso==1
}

drop doy_srvc
xfill cchbso_a*, i(idn)

/////////////////bene-class timing
egen cchbso_fdays_2012 = sum(dayssply), by(idn)
egen cchbso_clms_2012 = count(dayssply), by(idn)
egen cchbso_minfilldt_2012 = min(srvc_dt), by(idn)
egen cchbso_maxfilldt_2012 = max(srvc_dt), by(idn)
gen cchbso_fillperiod_2012 = cchbso_maxfilldt_2012 - cchbso_minfilldt_2012 + 1

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

replace earlyfill_push = 0 if earlyfill_push==.
replace lastfill_push = 0 if lastfill_push==.

tempfile classarray
save `classarray', replace

/////////////////		 Bring in SNF 		////////////////////////////////////
use "/disk/agedisk1/medicare/data/u/c/20pct/snf/2012/snfc2012.dta", clear
keep bene_id from_dt thru_dt

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2012
replace doy_from = 365 if year(from_dt)>2012
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2012
replace doy_thru = 365 if year(thru_dt)>2012

////////////// Array
forvalues d = 1/365{
	gen snf_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru 
}
drop from_dt thru_dt doy_from doy_thru
xfill snf_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////   SNF push
//snf_push is the extra days added for SNF days concurrent with drug days. Capped at 10. 
gen snf_push = 0

forvalues d = 1/365{
	replace snf_push = snf_push + 1 if cchbso_a`d'==1 & snf_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the snf_push)
	//if that cchbso_a spot is empty:
	gen v1 = 1 if snf_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace snf_push = snf_push-1 if v1==1
	drop v1
	replace snf_push = 10 if snf_push>10
}
drop snf_a*

save `classarray', replace

/////////////////		 Bring in IP 		////////////////////////////////////
use "/disk/agedisk1/medicare/data/u/c/20pct/ip/2012/ipc2012.dta", clear
keep bene_id from_dt thru_dt 

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2012
replace doy_from = 365 if year(from_dt)>2012
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2012
replace doy_thru = 365 if year(thru_dt)>2012

//////////////// Array
forvalues d = 1/365{
	gen ips_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru
}
drop from_dt thru_dt doy_from doy_thru
xfill ips_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////////  IP push
//ips_push is the extra days added for ip days concurrent with drug days
gen ips_push = 0

forvalues d = 1/365{
	replace ips_push = ips_push + 1 if cchbso_a`d'==1 & ips_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the ips_push)
	//if that cchbso_a spot is not full:
	gen v1 = 1 if ips_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen cchbso_pdays_2012 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2012 possession days
*/
forvalues d = 1/365{
	replace cchbso_pdays_2012 = cchbso_pdays_2012 + 1 if cchbso_a`d'==1
}
drop cchbso_a*
replace cchbso_pdays_2012 = 365 if cchbso_pdays_2012>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen cchbso_push_2012 = rowmax(lastfill_push inyear_push) 
replace cchbso_push_2012 = 0 if cchbso_push_2012==.
replace cchbso_push_2012 = 0 if cchbso_push_2012<0

keep bene_id cchbso* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2012p.dta", replace

keep bene_id cchbso_push_2012
tempfile push
save `push', replace

////////////////		2013			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2013/pde2013.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `cchbso'
keep if _m==3 
drop _m

merge m:1 bene_id using `push'
keep if _m==3 | _m==1
drop _m

egen idn = group(bene_id)
sort bene_id srvc_dt

//Two claims for the same bene on the same day?
/* ~38 claims out of a 1000 (for 2006 loops) are by the same person on the same day
(i.e. 19 pairs of claims). We think those prescritpions are meant to be taken together,
meaning that if it's two 30 day fills, it is worth 30 possession days, not 60. 
So, we'll take the max of the two claims on the same day, and then drop one of the 
observations. 
*/
egen claim=group(bene_id srvc_dt)

gen repeat = 1 if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]
replace repeat = 1 if srvc_dt==srvc_dt[_n+1] & bene_id==bene_id[_n+1]

egen repeatday = max(dayssply), by(claim)
replace dayssply = repeatday if repeat==1

drop repeat repeatday claim
drop if srvc_dt==srvc_dt[_n-1] & bene_id==bene_id[_n-1]

//////////////////  Early fills pushes
//for people that fill their prescription before emptying their last, carry the extra pills forward
//extrapill_push is the amount, from that fill date, that is superfluous for reaching the next fill date. Capped at 10. 
gen doy_srvc = doy(srvc_dt)
replace doy_srvc = 0 if year(srvc_dt)<2013
replace doy_srvc = 365 if year(srvc_dt)>2013

gen extrapill_push = 0
replace extrapill_push = extrapill_push + (doy_srvc+dayssply)-(doy_srvc[_n+1]) if bene_id==bene_id[_n+1]
replace extrapill_push = 0 if extrapill_push<0
replace extrapill_push = 10 if extrapill_push>10

//pushstock is the accumulated stock of extra pills. Capped at 10. 
gen pushstock = extrapill_push
replace extrapill_push = 10 if extrapill_push>10

//add the pushstock from last year
replace pushstock = pushstock + cchbso_push_2012 if bene_id!=bene_id[_n-1] | _n==1

gen need = 0
replace need = (doy_srvc[_n+1])-(doy_srvc+dayssply)
replace need = (365 - (doy_srvc)+dayssply) if bene_id!=bene_id[_n+1]
replace need = 0 if need<0

gen dayssply2 = dayssply

// Creating a loop that will loop through one observation at a time and do the following
/* 1. Add the previous pushstock to the current pushstock
   2. Add the needed extra pills to the dayssply which is the dayssply + the min of either the need or the pushstock since:
	a. If need < pushstock, then need gets added to dayssply
	b. If need >= pushstock, then pushstock gets added to dayssply
   3. Calculate the new pushstock, which is the pushstock minus the need with a bottom cap at 0 and a high cap at 10 */
	
local N=_N

forvalues i=1/`N' {
	quietly replace pushstock=pushstock[_n-1]+pushstock if pushstock[_n-1]<. & bene_id==bene_id[_n-1] in `i'
	quietly replace dayssply2=dayssply2+min(need,pushstock) if bene_id==bene_id[_n-1] in `i'
	quietly replace pushstock=min(max(pushstock-need,0),10) if bene_id==bene_id[_n-1] in `i'
}

//value of early fill push stock at the end of the year
gen earlyfill_push = pushstock if bene_id!=bene_id[_n+1]
replace earlyfill_push = 0 if earlyfill_push<0
replace earlyfill_push = 10 if earlyfill_push>10 & earlyfill_push!=.
//extra pills from last prescription at end of year, capped at 90
gen lastfill_push = (doy_srvc+dayssply-365) if bene_id!=bene_id[_n+1]
replace lastfill_push = 0 if lastfill_push<0 & lastfill_push!=.
replace lastfill_push = 90 if lastfill_push>90 & lastfill_push!=.

xfill earlyfill_push lastfill_push, i(idn)

drop pushstock need extrapill_push

///////////////// Array
forvalues d = 1/365{
	gen cchbso_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & cchbso==1
}

drop doy_srvc
xfill cchbso_a*, i(idn)

/////////////////bene-class timing
egen cchbso_fdays_2013 = sum(dayssply), by(idn)
egen cchbso_clms_2013 = count(dayssply), by(idn)
egen cchbso_minfilldt_2013 = min(srvc_dt), by(idn)
egen cchbso_maxfilldt_2013 = max(srvc_dt), by(idn)
gen cchbso_fillperiod_2013 = cchbso_maxfilldt_2013 - cchbso_minfilldt_2013 + 1

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

replace earlyfill_push = 0 if earlyfill_push==.
replace lastfill_push = 0 if lastfill_push==.

tempfile classarray
save `classarray', replace

/////////////////		 Bring in SNF 		////////////////////////////////////
use "/disk/agedisk3/medicare/data/20pct/snf/2013/snfc2013.dta", clear
keep bene_id from_dt thru_dt

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2013
replace doy_from = 365 if year(from_dt)>2013
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2013
replace doy_thru = 365 if year(thru_dt)>2013

////////////// Array
forvalues d = 1/365{
	gen snf_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru 
}
drop from_dt thru_dt doy_from doy_thru
xfill snf_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////   SNF push
//snf_push is the extra days added for SNF days concurrent with drug days. Capped at 10. 
gen snf_push = 0

forvalues d = 1/365{
	replace snf_push = snf_push + 1 if cchbso_a`d'==1 & snf_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the snf_push)
	//if that cchbso_a spot is empty:
	gen v1 = 1 if snf_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace snf_push = snf_push-1 if v1==1
	drop v1
	replace snf_push = 10 if snf_push>10
}
drop snf_a*

save `classarray', replace

/////////////////		 Bring in IP 		////////////////////////////////////
use "/disk/agedisk3/medicare/data/20pct/ip/2013/ipc2013.dta", clear
keep bene_id from_dt thru_dt 

merge m:1 bene_id using `classarray'
keep if _m==3 | _m==2
drop _m
codebook bene_id

gen doy_from = doy(from_dt)
replace doy_from = 0 if year(from_dt)<2013
replace doy_from = 365 if year(from_dt)>2013
gen doy_thru = doy(thru_dt)
replace doy_thru = 0 if year(thru_dt)<2013
replace doy_thru = 365 if year(thru_dt)>2013

//////////////// Array
forvalues d = 1/365{
	gen ips_a`d' = 1 if `d'>=doy_from & `d'<=doy_thru
}
drop from_dt thru_dt doy_from doy_thru
xfill ips_a*, i(idn)

sort bene_id
drop if bene_id==bene_id[_n-1]
codebook bene_id

///////////////  IP push
//ips_push is the extra days added for ip days concurrent with drug days
gen ips_push = 0

forvalues d = 1/365{
	replace ips_push = ips_push + 1 if cchbso_a`d'==1 & ips_a`d'==1

	//if the cchbso_a`d' is 1, do nothing (already added it to the ips_push)
	//if that cchbso_a spot is not full:
	gen v1 = 1 if ips_push>0 & cchbso_a`d'==.
	replace cchbso_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen cchbso_pdays_2013 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2013 possession days
*/
forvalues d = 1/365{
	replace cchbso_pdays_2013 = cchbso_pdays_2013 + 1 if cchbso_a`d'==1
}
drop cchbso_a*
replace cchbso_pdays_2013 = 365 if cchbso_pdays_2013>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen cchbso_push_2013 = rowmax(lastfill_push inyear_push) 
replace cchbso_push_2013 = 0 if cchbso_push_2013==.
replace cchbso_push_2013 = 0 if cchbso_push_2013<0

keep bene_id cchbso* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2013p.dta", replace

////////////////////////////////////////////////////////////////////////////////
/////////////// 	Merge cchbso 07-13	////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2007p.dta", replace
gen ycchbso2007 = 1
tempfile cchbso
save `cchbso', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2008p.dta", replace
gen ycchbso2008 = 1
merge 1:1 bene_id using `cchbso'
drop _m
save `cchbso', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2009p.dta", replace
gen ycchbso2009 = 1
merge 1:1 bene_id using `cchbso'
drop _m
save `cchbso', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2010p.dta", replace
gen ycchbso2010 = 1
merge 1:1 bene_id using `cchbso'
drop _m
save `cchbso', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2011p.dta", replace
gen ycchbso2011 = 1
merge 1:1 bene_id using `cchbso'
drop _m
save `cchbso', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2012p.dta", replace
gen ycchbso2012 = 1
merge 1:1 bene_id using `cchbso'
drop _m
save `cchbso', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2013p.dta", replace
gen ycchbso2013 = 1
merge 1:1 bene_id using `cchbso'
drop _m
save `cchbso', replace

//keep one obs person - not necessary after merge
//no need to xfill after merge

//timing variables
gen cchbso_firstyoo=.
gen cchbso_lastyoo=.
local years "2013 2012 2011 2010 2009 2008 2007"
foreach i in `years'{
	replace cchbso_firstyoo = `i' if ycchbso`i'==1
}
local years "2007 2008 2009 2010 2011 2012 2013"
foreach i in `years'{
	replace cchbso_lastyoo = `i' if ycchbso`i'==1
}
gen cchbso_yearcount = cchbso_lastyoo - cchbso_firstyoo + 1

//utilization variables 
forvalues i = 2007/2013{
	replace cchbso_fillperiod_`i' = 0 if cchbso_fillperiod_`i'==.
	replace cchbso_clms_`i' = 0 if cchbso_clms_`i'==.
	replace cchbso_fdays_`i' = 0 if cchbso_fdays_`i'==.
	replace cchbso_pdays_`i' = 0 if cchbso_pdays_`i'==.
}	
//minfilldt maxfilldt push

//total utilization
gen cchbso_clms = cchbso_clms_2007+cchbso_clms_2008+cchbso_clms_2009+cchbso_clms_2010+cchbso_clms_2011+cchbso_clms_2012+cchbso_clms_2013
gen cchbso_fdays = cchbso_fdays_2007+cchbso_fdays_2008+cchbso_fdays_2009+cchbso_fdays_2010+cchbso_fdays_2011+cchbso_fdays_2012+cchbso_fdays_2013
gen cchbso_pdays = cchbso_pdays_2007+cchbso_pdays_2008+cchbso_pdays_2009+cchbso_pdays_2010+cchbso_pdays_2011+cchbso_pdays_2012+cchbso_pdays_2013

//timing variables 
egen cchbso_minfilldt = rowmin(cchbso_minfilldt_2007 cchbso_minfilldt_2008 cchbso_minfilldt_2009 cchbso_minfilldt_2010 cchbso_minfilldt_2011 cchbso_minfilldt_2012 cchbso_minfilldt_2013)
egen cchbso_maxfilldt = rowmax(cchbso_maxfilldt_2007 cchbso_maxfilldt_2008 cchbso_maxfilldt_2009 cchbso_maxfilldt_2010 cchbso_maxfilldt_2011 cchbso_maxfilldt_2012 cchbso_maxfilldt_2013)

gen cchbso_fillperiod = cchbso_maxfilldt - cchbso_minfilldt + 1

gen cchbso_pdayspy = cchbso_pdays/cchbso_yearcount
gen cchbso_fdayspy = cchbso_fdays/cchbso_yearcount
gen cchbso_clmspy = cchbso_clms/cchbso_yearcount

sort bene_id
drop if bene_id==bene_id[_n-1]

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_0713p.dta", replace

