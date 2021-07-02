clear all
set more off
capture log close

/*
•	Input: XXXX(so)_XXXX_YYYY.dta, 0713
o	insamp_0713.dta
•	Output: ahtco_YYYY.dta, ahtco_long0713a.dta
•	Merges the 14 classes (solos and combos) for each year. Make year variable. Fill in zeros. Restrict to the people who were insamp in that year. (Note they could still die that year).
•	Append the 7 years to get long file.
*/

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
//					Merge the 10 AHTs within each year 						  //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////	2007 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceiso_2007p.dta", replace
rename aceiso_pdays_2007 aceiso_pdays 
rename aceiso_clms_2007 aceiso_clms 
keep bene_id aceiso_pdays aceiso_clms

tempfile 2007
save `2007', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceicchb_2007p.dta", replace
rename aceicchb_pdays_2007 aceicchb_pdays 
rename aceicchb_clms_2007 aceicchb_clms 
keep bene_id aceicchb_pdays aceicchb_clms

merge 1:1 bene_id using `2007'
drop _m
save `2007', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceithia_2007p.dta", replace
rename aceithia_pdays_2007 aceithia_pdays 
rename aceithia_clms_2007 aceithia_clms 
keep bene_id aceithia_pdays aceithia_clms

merge 1:1 bene_id using `2007'
drop _m
save `2007', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbso_2007p.dta", replace
rename a2rbso_pdays_2007 a2rbso_pdays 
rename a2rbso_clms_2007 a2rbso_clms 
keep bene_id a2rbso_pdays a2rbso_clms

merge 1:1 bene_id using `2007'
drop _m
save `2007', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbthia_2007p.dta", replace
rename a2rbthia_pdays_2007 a2rbthia_pdays 
rename a2rbthia_clms_2007 a2rbthia_clms 
keep bene_id a2rbthia_pdays a2rbthia_clms

merge 1:1 bene_id using `2007'
drop _m
save `2007', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bbloso_2007p.dta", replace
rename bbloso_pdays_2007 bbloso_pdays 
rename bbloso_clms_2007 bbloso_clms 
keep bene_id bbloso_pdays bbloso_clms

merge 1:1 bene_id using `2007'
drop _m
save `2007', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bblothia_2007p.dta", replace
rename bblothia_pdays_2007 bblothia_pdays 
rename bblothia_clms_2007 bblothia_clms 
keep bene_id bblothia_pdays bblothia_clms

merge 1:1 bene_id using `2007'
drop _m
save `2007', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2007p.dta", replace
rename cchbso_pdays_2007 cchbso_pdays 
rename cchbso_clms_2007 cchbso_clms 
keep bene_id cchbso_pdays cchbso_clms

merge 1:1 bene_id using `2007'
drop _m
save `2007', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/loopso_2007p.dta", replace
rename loopso_pdays_2007 loopso_pdays 
rename loopso_clms_2007 loopso_clms 
keep bene_id loopso_pdays loopso_clms

merge 1:1 bene_id using `2007'
drop _m
save `2007', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/thiaso_2007p.dta", replace
rename thiaso_pdays_2007 thiaso_pdays 
rename thiaso_clms_2007 thiaso_clms 
keep bene_id thiaso_pdays thiaso_clms

merge 1:1 bene_id using `2007'
drop _m
save `2007', replace

// Organize 2007
gen year = 2007

local vars "pdays clms"
foreach i in `vars'{
	replace aceiso_`i' = 0 if aceiso_`i'==.
	replace aceithia_`i' = 0 if aceithia_`i'==.
	replace aceicchb_`i' = 0 if aceicchb_`i'==.
	replace a2rbso_`i' = 0 if a2rbso_`i'==.
	replace a2rbthia_`i' = 0 if a2rbthia_`i'==.
	replace bbloso_`i' = 0 if bbloso_`i'==.
	replace bblothia_`i' = 0 if bblothia_`i'==.
	replace cchbso_`i' = 0 if cchbso_`i'==.
	replace loopso_`i' = 0 if loopso_`i'==.
	replace thiaso_`i' = 0 if thiaso_`i'==.
}

save `2007', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2007'
keep if _m==3
drop _m
keep if insamp_2007==1

rename age_beg_2007 age
drop age_beg*

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2007.dta", replace

////////////////////////	2008 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceiso_2008p.dta", replace
rename aceiso_pdays_2008 aceiso_pdays 
rename aceiso_clms_2008 aceiso_clms 
keep bene_id aceiso_pdays aceiso_clms

tempfile 2008
save `2008', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceicchb_2008p.dta", replace
rename aceicchb_pdays_2008 aceicchb_pdays 
rename aceicchb_clms_2008 aceicchb_clms 
keep bene_id aceicchb_pdays aceicchb_clms

merge 1:1 bene_id using `2008'
drop _m
save `2008', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceithia_2008p.dta", replace
rename aceithia_pdays_2008 aceithia_pdays 
rename aceithia_clms_2008 aceithia_clms 
keep bene_id aceithia_pdays aceithia_clms

merge 1:1 bene_id using `2008'
drop _m
save `2008', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbso_2008p.dta", replace
rename a2rbso_pdays_2008 a2rbso_pdays 
rename a2rbso_clms_2008 a2rbso_clms 
keep bene_id a2rbso_pdays a2rbso_clms

merge 1:1 bene_id using `2008'
drop _m
save `2008', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbthia_2008p.dta", replace
rename a2rbthia_pdays_2008 a2rbthia_pdays 
rename a2rbthia_clms_2008 a2rbthia_clms 
keep bene_id a2rbthia_pdays a2rbthia_clms

merge 1:1 bene_id using `2008'
drop _m
save `2008', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bbloso_2008p.dta", replace
rename bbloso_pdays_2008 bbloso_pdays 
rename bbloso_clms_2008 bbloso_clms 
keep bene_id bbloso_pdays bbloso_clms

merge 1:1 bene_id using `2008'
drop _m
save `2008', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bblothia_2008p.dta", replace
rename bblothia_pdays_2008 bblothia_pdays 
rename bblothia_clms_2008 bblothia_clms 
keep bene_id bblothia_pdays bblothia_clms

merge 1:1 bene_id using `2008'
drop _m
save `2008', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2008p.dta", replace
rename cchbso_pdays_2008 cchbso_pdays 
rename cchbso_clms_2008 cchbso_clms 
keep bene_id cchbso_pdays cchbso_clms

merge 1:1 bene_id using `2008'
drop _m
save `2008', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/loopso_2008p.dta", replace
rename loopso_pdays_2008 loopso_pdays 
rename loopso_clms_2008 loopso_clms 
keep bene_id loopso_pdays loopso_clms

merge 1:1 bene_id using `2008'
drop _m
save `2008', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/thiaso_2008p.dta", replace
rename thiaso_pdays_2008 thiaso_pdays 
rename thiaso_clms_2008 thiaso_clms 
keep bene_id thiaso_pdays thiaso_clms

merge 1:1 bene_id using `2008'
drop _m
save `2008', replace

// Organize 2008
gen year = 2008

local vars "pdays clms"
foreach i in `vars'{
	replace aceiso_`i' = 0 if aceiso_`i'==.
	replace aceithia_`i' = 0 if aceithia_`i'==.
	replace aceicchb_`i' = 0 if aceicchb_`i'==.
	replace a2rbso_`i' = 0 if a2rbso_`i'==.
	replace a2rbthia_`i' = 0 if a2rbthia_`i'==.
	replace bbloso_`i' = 0 if bbloso_`i'==.
	replace bblothia_`i' = 0 if bblothia_`i'==.
	replace cchbso_`i' = 0 if cchbso_`i'==.
	replace loopso_`i' = 0 if loopso_`i'==.
	replace thiaso_`i' = 0 if thiaso_`i'==.
}

save `2008', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2008'
keep if _m==3
drop _m
keep if insamp_2008==1

rename age_beg_2008 age
drop age_beg*

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2008.dta", replace

////////////////////////	2009 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceiso_2009p.dta", replace
rename aceiso_pdays_2009 aceiso_pdays 
rename aceiso_clms_2009 aceiso_clms 
keep bene_id aceiso_pdays aceiso_clms

tempfile 2009
save `2009', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceicchb_2009p.dta", replace
rename aceicchb_pdays_2009 aceicchb_pdays 
rename aceicchb_clms_2009 aceicchb_clms 
keep bene_id aceicchb_pdays aceicchb_clms

merge 1:1 bene_id using `2009'
drop _m
save `2009', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceithia_2009p.dta", replace
rename aceithia_pdays_2009 aceithia_pdays 
rename aceithia_clms_2009 aceithia_clms 
keep bene_id aceithia_pdays aceithia_clms

merge 1:1 bene_id using `2009'
drop _m
save `2009', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbso_2009p.dta", replace
rename a2rbso_pdays_2009 a2rbso_pdays 
rename a2rbso_clms_2009 a2rbso_clms 
keep bene_id a2rbso_pdays a2rbso_clms

merge 1:1 bene_id using `2009'
drop _m
save `2009', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbthia_2009p.dta", replace
rename a2rbthia_pdays_2009 a2rbthia_pdays 
rename a2rbthia_clms_2009 a2rbthia_clms 
keep bene_id a2rbthia_pdays a2rbthia_clms

merge 1:1 bene_id using `2009'
drop _m
save `2009', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bbloso_2009p.dta", replace
rename bbloso_pdays_2009 bbloso_pdays 
rename bbloso_clms_2009 bbloso_clms 
keep bene_id bbloso_pdays bbloso_clms

merge 1:1 bene_id using `2009'
drop _m
save `2009', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bblothia_2009p.dta", replace
rename bblothia_pdays_2009 bblothia_pdays 
rename bblothia_clms_2009 bblothia_clms 
keep bene_id bblothia_pdays bblothia_clms

merge 1:1 bene_id using `2009'
drop _m
save `2009', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2009p.dta", replace
rename cchbso_pdays_2009 cchbso_pdays 
rename cchbso_clms_2009 cchbso_clms 
keep bene_id cchbso_pdays cchbso_clms

merge 1:1 bene_id using `2009'
drop _m
save `2009', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/loopso_2009p.dta", replace
rename loopso_pdays_2009 loopso_pdays 
rename loopso_clms_2009 loopso_clms 
keep bene_id loopso_pdays loopso_clms

merge 1:1 bene_id using `2009'
drop _m
save `2009', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/thiaso_2009p.dta", replace
rename thiaso_pdays_2009 thiaso_pdays 
rename thiaso_clms_2009 thiaso_clms 
keep bene_id thiaso_pdays thiaso_clms

merge 1:1 bene_id using `2009'
drop _m
save `2009', replace

// Organize 2009
gen year = 2009

local vars "pdays clms"
foreach i in `vars'{
	replace aceiso_`i' = 0 if aceiso_`i'==.
	replace aceithia_`i' = 0 if aceithia_`i'==.
	replace aceicchb_`i' = 0 if aceicchb_`i'==.
	replace a2rbso_`i' = 0 if a2rbso_`i'==.
	replace a2rbthia_`i' = 0 if a2rbthia_`i'==.
	replace bbloso_`i' = 0 if bbloso_`i'==.
	replace bblothia_`i' = 0 if bblothia_`i'==.
	replace cchbso_`i' = 0 if cchbso_`i'==.
	replace loopso_`i' = 0 if loopso_`i'==.
	replace thiaso_`i' = 0 if thiaso_`i'==.
}

save `2009', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2009'
keep if _m==3
drop _m
keep if insamp_2009==1

rename age_beg_2009 age
drop age_beg*

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2009.dta", replace

////////////////////////	2010 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceiso_2010p.dta", replace
rename aceiso_pdays_2010 aceiso_pdays 
rename aceiso_clms_2010 aceiso_clms 
keep bene_id aceiso_pdays aceiso_clms

tempfile 2010
save `2010', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceicchb_2010p.dta", replace
rename aceicchb_pdays_2010 aceicchb_pdays 
rename aceicchb_clms_2010 aceicchb_clms 
keep bene_id aceicchb_pdays aceicchb_clms

merge 1:1 bene_id using `2010'
drop _m
save `2010', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceithia_2010p.dta", replace
rename aceithia_pdays_2010 aceithia_pdays 
rename aceithia_clms_2010 aceithia_clms 
keep bene_id aceithia_pdays aceithia_clms

merge 1:1 bene_id using `2010'
drop _m
save `2010', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbso_2010p.dta", replace
rename a2rbso_pdays_2010 a2rbso_pdays 
rename a2rbso_clms_2010 a2rbso_clms 
keep bene_id a2rbso_pdays a2rbso_clms

merge 1:1 bene_id using `2010'
drop _m
save `2010', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbthia_2010p.dta", replace
rename a2rbthia_pdays_2010 a2rbthia_pdays 
rename a2rbthia_clms_2010 a2rbthia_clms 
keep bene_id a2rbthia_pdays a2rbthia_clms

merge 1:1 bene_id using `2010'
drop _m
save `2010', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bbloso_2010p.dta", replace
rename bbloso_pdays_2010 bbloso_pdays 
rename bbloso_clms_2010 bbloso_clms 
keep bene_id bbloso_pdays bbloso_clms

merge 1:1 bene_id using `2010'
drop _m
save `2010', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bblothia_2010p.dta", replace
rename bblothia_pdays_2010 bblothia_pdays 
rename bblothia_clms_2010 bblothia_clms 
keep bene_id bblothia_pdays bblothia_clms

merge 1:1 bene_id using `2010'
drop _m
save `2010', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2010p.dta", replace
rename cchbso_pdays_2010 cchbso_pdays 
rename cchbso_clms_2010 cchbso_clms 
keep bene_id cchbso_pdays cchbso_clms

merge 1:1 bene_id using `2010'
drop _m
save `2010', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/loopso_2010p.dta", replace
rename loopso_pdays_2010 loopso_pdays 
rename loopso_clms_2010 loopso_clms 
keep bene_id loopso_pdays loopso_clms

merge 1:1 bene_id using `2010'
drop _m
save `2010', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/thiaso_2010p.dta", replace
rename thiaso_pdays_2010 thiaso_pdays 
rename thiaso_clms_2010 thiaso_clms 
keep bene_id thiaso_pdays thiaso_clms

merge 1:1 bene_id using `2010'
drop _m
save `2010', replace

// Organize 2010
gen year = 2010

local vars "pdays clms"
foreach i in `vars'{
	replace aceiso_`i' = 0 if aceiso_`i'==.
	replace aceithia_`i' = 0 if aceithia_`i'==.
	replace aceicchb_`i' = 0 if aceicchb_`i'==.
	replace a2rbso_`i' = 0 if a2rbso_`i'==.
	replace a2rbthia_`i' = 0 if a2rbthia_`i'==.
	replace bbloso_`i' = 0 if bbloso_`i'==.
	replace bblothia_`i' = 0 if bblothia_`i'==.
	replace cchbso_`i' = 0 if cchbso_`i'==.
	replace loopso_`i' = 0 if loopso_`i'==.
	replace thiaso_`i' = 0 if thiaso_`i'==.
}

save `2010', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2010'
keep if _m==3
drop _m
keep if insamp_2010==1

rename age_beg_2010 age
drop age_beg*

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2010.dta", replace

////////////////////////	2011 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceiso_2011p.dta", replace
rename aceiso_pdays_2011 aceiso_pdays 
rename aceiso_clms_2011 aceiso_clms 
keep bene_id aceiso_pdays aceiso_clms

tempfile 2011
save `2011', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceicchb_2011p.dta", replace
rename aceicchb_pdays_2011 aceicchb_pdays 
rename aceicchb_clms_2011 aceicchb_clms 
keep bene_id aceicchb_pdays aceicchb_clms

merge 1:1 bene_id using `2011'
drop _m
save `2011', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceithia_2011p.dta", replace
rename aceithia_pdays_2011 aceithia_pdays 
rename aceithia_clms_2011 aceithia_clms 
keep bene_id aceithia_pdays aceithia_clms

merge 1:1 bene_id using `2011'
drop _m
save `2011', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbso_2011p.dta", replace
rename a2rbso_pdays_2011 a2rbso_pdays 
rename a2rbso_clms_2011 a2rbso_clms 
keep bene_id a2rbso_pdays a2rbso_clms

merge 1:1 bene_id using `2011'
drop _m
save `2011', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbthia_2011p.dta", replace
rename a2rbthia_pdays_2011 a2rbthia_pdays 
rename a2rbthia_clms_2011 a2rbthia_clms 
keep bene_id a2rbthia_pdays a2rbthia_clms

merge 1:1 bene_id using `2011'
drop _m
save `2011', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bbloso_2011p.dta", replace
rename bbloso_pdays_2011 bbloso_pdays 
rename bbloso_clms_2011 bbloso_clms 
keep bene_id bbloso_pdays bbloso_clms

merge 1:1 bene_id using `2011'
drop _m
save `2011', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bblothia_2011p.dta", replace
rename bblothia_pdays_2011 bblothia_pdays 
rename bblothia_clms_2011 bblothia_clms 
keep bene_id bblothia_pdays bblothia_clms

merge 1:1 bene_id using `2011'
drop _m
save `2011', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2011p.dta", replace
rename cchbso_pdays_2011 cchbso_pdays 
rename cchbso_clms_2011 cchbso_clms 
keep bene_id cchbso_pdays cchbso_clms

merge 1:1 bene_id using `2011'
drop _m
save `2011', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/loopso_2011p.dta", replace
rename loopso_pdays_2011 loopso_pdays 
rename loopso_clms_2011 loopso_clms 
keep bene_id loopso_pdays loopso_clms

merge 1:1 bene_id using `2011'
drop _m
save `2011', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/thiaso_2011p.dta", replace
rename thiaso_pdays_2011 thiaso_pdays 
rename thiaso_clms_2011 thiaso_clms 
keep bene_id thiaso_pdays thiaso_clms

merge 1:1 bene_id using `2011'
drop _m
save `2011', replace

// Organize 2011
gen year = 2011

local vars "pdays clms"
foreach i in `vars'{
	replace aceiso_`i' = 0 if aceiso_`i'==.
	replace aceithia_`i' = 0 if aceithia_`i'==.
	replace aceicchb_`i' = 0 if aceicchb_`i'==.
	replace a2rbso_`i' = 0 if a2rbso_`i'==.
	replace a2rbthia_`i' = 0 if a2rbthia_`i'==.
	replace bbloso_`i' = 0 if bbloso_`i'==.
	replace bblothia_`i' = 0 if bblothia_`i'==.
	replace cchbso_`i' = 0 if cchbso_`i'==.
	replace loopso_`i' = 0 if loopso_`i'==.
	replace thiaso_`i' = 0 if thiaso_`i'==.
}

save `2011', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2011'
keep if _m==3
drop _m
keep if insamp_2011==1

rename age_beg_2011 age
drop age_beg*

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2011.dta", replace

////////////////////////	2012 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceiso_2012p.dta", replace
rename aceiso_pdays_2012 aceiso_pdays 
rename aceiso_clms_2012 aceiso_clms 
keep bene_id aceiso_pdays aceiso_clms

tempfile 2012
save `2012', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceicchb_2012p.dta", replace
rename aceicchb_pdays_2012 aceicchb_pdays 
rename aceicchb_clms_2012 aceicchb_clms 
keep bene_id aceicchb_pdays aceicchb_clms

merge 1:1 bene_id using `2012'
drop _m
save `2012', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceithia_2012p.dta", replace
rename aceithia_pdays_2012 aceithia_pdays 
rename aceithia_clms_2012 aceithia_clms 
keep bene_id aceithia_pdays aceithia_clms

merge 1:1 bene_id using `2012'
drop _m
save `2012', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbso_2012p.dta", replace
rename a2rbso_pdays_2012 a2rbso_pdays 
rename a2rbso_clms_2012 a2rbso_clms 
keep bene_id a2rbso_pdays a2rbso_clms

merge 1:1 bene_id using `2012'
drop _m
save `2012', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbthia_2012p.dta", replace
rename a2rbthia_pdays_2012 a2rbthia_pdays 
rename a2rbthia_clms_2012 a2rbthia_clms 
keep bene_id a2rbthia_pdays a2rbthia_clms

merge 1:1 bene_id using `2012'
drop _m
save `2012', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bbloso_2012p.dta", replace
rename bbloso_pdays_2012 bbloso_pdays 
rename bbloso_clms_2012 bbloso_clms 
keep bene_id bbloso_pdays bbloso_clms

merge 1:1 bene_id using `2012'
drop _m
save `2012', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bblothia_2012p.dta", replace
rename bblothia_pdays_2012 bblothia_pdays 
rename bblothia_clms_2012 bblothia_clms 
keep bene_id bblothia_pdays bblothia_clms

merge 1:1 bene_id using `2012'
drop _m
save `2012', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2012p.dta", replace
rename cchbso_pdays_2012 cchbso_pdays 
rename cchbso_clms_2012 cchbso_clms 
keep bene_id cchbso_pdays cchbso_clms

merge 1:1 bene_id using `2012'
drop _m
save `2012', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/loopso_2012p.dta", replace
rename loopso_pdays_2012 loopso_pdays 
rename loopso_clms_2012 loopso_clms 
keep bene_id loopso_pdays loopso_clms

merge 1:1 bene_id using `2012'
drop _m
save `2012', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/thiaso_2012p.dta", replace
rename thiaso_pdays_2012 thiaso_pdays 
rename thiaso_clms_2012 thiaso_clms 
keep bene_id thiaso_pdays thiaso_clms

merge 1:1 bene_id using `2012'
drop _m
save `2012', replace

// Organize 2012
gen year = 2012

local vars "pdays clms"
foreach i in `vars'{
	replace aceiso_`i' = 0 if aceiso_`i'==.
	replace aceithia_`i' = 0 if aceithia_`i'==.
	replace aceicchb_`i' = 0 if aceicchb_`i'==.
	replace a2rbso_`i' = 0 if a2rbso_`i'==.
	replace a2rbthia_`i' = 0 if a2rbthia_`i'==.
	replace bbloso_`i' = 0 if bbloso_`i'==.
	replace bblothia_`i' = 0 if bblothia_`i'==.
	replace cchbso_`i' = 0 if cchbso_`i'==.
	replace loopso_`i' = 0 if loopso_`i'==.
	replace thiaso_`i' = 0 if thiaso_`i'==.
}

save `2012', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2012'
keep if _m==3
drop _m
keep if insamp_2012==1

rename age_beg_2012 age
drop age_beg*

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2012.dta", replace

////////////////////////	2013 		////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceiso_2013p.dta", replace
rename aceiso_pdays_2013 aceiso_pdays 
rename aceiso_clms_2013 aceiso_clms 
keep bene_id aceiso_pdays aceiso_clms

tempfile 2013
save `2013', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceicchb_2013p.dta", replace
rename aceicchb_pdays_2013 aceicchb_pdays 
rename aceicchb_clms_2013 aceicchb_clms 
keep bene_id aceicchb_pdays aceicchb_clms

merge 1:1 bene_id using `2013'
drop _m
save `2013', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/aceithia_2013p.dta", replace
rename aceithia_pdays_2013 aceithia_pdays 
rename aceithia_clms_2013 aceithia_clms 
keep bene_id aceithia_pdays aceithia_clms

merge 1:1 bene_id using `2013'
drop _m
save `2013', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbso_2013p.dta", replace
rename a2rbso_pdays_2013 a2rbso_pdays 
rename a2rbso_clms_2013 a2rbso_clms 
keep bene_id a2rbso_pdays a2rbso_clms

merge 1:1 bene_id using `2013'
drop _m
save `2013', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/a2rbthia_2013p.dta", replace
rename a2rbthia_pdays_2013 a2rbthia_pdays 
rename a2rbthia_clms_2013 a2rbthia_clms 
keep bene_id a2rbthia_pdays a2rbthia_clms

merge 1:1 bene_id using `2013'
drop _m
save `2013', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bbloso_2013p.dta", replace
rename bbloso_pdays_2013 bbloso_pdays 
rename bbloso_clms_2013 bbloso_clms 
keep bene_id bbloso_pdays bbloso_clms

merge 1:1 bene_id using `2013'
drop _m
save `2013', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/bblothia_2013p.dta", replace
rename bblothia_pdays_2013 bblothia_pdays 
rename bblothia_clms_2013 bblothia_clms 
keep bene_id bblothia_pdays bblothia_clms

merge 1:1 bene_id using `2013'
drop _m
save `2013', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/cchbso_2013p.dta", replace
rename cchbso_pdays_2013 cchbso_pdays 
rename cchbso_clms_2013 cchbso_clms 
keep bene_id cchbso_pdays cchbso_clms

merge 1:1 bene_id using `2013'
drop _m
save `2013', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/loopso_2013p.dta", replace
rename loopso_pdays_2013 loopso_pdays 
rename loopso_clms_2013 loopso_clms 
keep bene_id loopso_pdays loopso_clms

merge 1:1 bene_id using `2013'
drop _m
save `2013', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/thiaso_2013p.dta", replace
rename thiaso_pdays_2013 thiaso_pdays 
rename thiaso_clms_2013 thiaso_clms 
keep bene_id thiaso_pdays thiaso_clms

merge 1:1 bene_id using `2013'
drop _m
save `2013', replace

// Organize 2013
gen year = 2013

local vars "pdays clms"
foreach i in `vars'{
	replace aceiso_`i' = 0 if aceiso_`i'==.
	replace aceithia_`i' = 0 if aceithia_`i'==.
	replace aceicchb_`i' = 0 if aceicchb_`i'==.
	replace a2rbso_`i' = 0 if a2rbso_`i'==.
	replace a2rbthia_`i' = 0 if a2rbthia_`i'==.
	replace bbloso_`i' = 0 if bbloso_`i'==.
	replace bblothia_`i' = 0 if bblothia_`i'==.
	replace cchbso_`i' = 0 if cchbso_`i'==.
	replace loopso_`i' = 0 if loopso_`i'==.
	replace thiaso_`i' = 0 if thiaso_`i'==.
}

save `2013', replace

// Merge with insamp
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/base/insamp_0713.dta", replace
merge 1:1 bene_id using `2013'
keep if _m==3
drop _m
keep if insamp_2013==1

rename age_beg_2013 age
drop age_beg*

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2013.dta", replace

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
//			Append the aht files from 07-13 to get long file				  //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2007.dta", replace
tempfile aht
save `aht', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2008.dta", replace
append using `aht'
save `aht', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2009.dta", replace
append using `aht'
save `aht', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2010.dta", replace
append using `aht'
save `aht', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2011.dta", replace
append using `aht'
save `aht', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2012.dta", replace
append using `aht'
save `aht', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_2013.dta", replace
append using `aht'
save `aht', replace

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_long0713a.dta", replace

