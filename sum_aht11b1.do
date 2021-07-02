
clear all
set more off
capture log close

/*
•	Input:  ahtco_long0713_902.dta
•	Output: outsum
•	Sample: Each person year has no deaths in that year, and 90 days of a single AHT class in years t-1 and t-2, and 2 claims. No prior use of AChEI or meman
•	Summarizes treatment, output, and control variables, at bene level
o	Across RAS vs nonRAS margin. 
o	Drug definitions account for combo molecules.
*/

//Input the long file of AHT users
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_long0713_902.dta", replace

//These numbers are kinda meaningless
count 
codebook bene_id

//drop the obs for people after they get incident
//drop if ADRDccw_inc==2
//drop if NADDccw_inc==2 //redundant
drop if ADccw_inc==2  //redundant
count
codebook bene_id

//drop the obs for people that died in that year
count 
drop if death_year==year
count
drop if death_year<year
count
codebook bene_id

//keep only the obs in the long file where the person used a single class in years t-1 and t-2
keep if acei_user_L12==1 | a2rb_user_L12==1 | bblo_user_L12==1 | cchb_user_L12==1 | loop_user_L12==1 | thia_user_L12==1
count
codebook bene_id

//drop those that used an AChEI or memantine prior to reference year
drop if adrx_prior==1
count
codebook bene_id
/*
//follow-up time
egen yearf = min(year), by(bene_id)
egen yearl = max(year), by(bene_id)
gen follow = yearl-yearf+1

preserve
//switch to bene-level, in their first reference year.
sort bene_id year
drop if bene_id==bene_id[_n-1]

////////////////////////////////////////////////////////////////////////////////
///////////			SUMMARY STATS				////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
sum yearf yearl follow
tab yearf
tab yearl
tab follow

//setup outsum
outsum female using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(SETUP 1) replace

/*
ALL: aht ras rasso acei aceiso aceicchb aceithia a2rb a2rbso a2rbthia bblo bbloso bblothia cchb cchbso loop loopso thia thiaso stat
SPECIFIC PILLS: aceiso aceicchb aceithia a2rbso a2rbthia bbloso bblothia cchbso thiaso
CLASSES AND GROUPS: aht ras rasso acei a2rb bblo cchb loop thia
*/

local vars "aht ras rasso acei aceiso aceicchb aceithia a2rb a2rbso a2rbthia bblo bbloso bblothia cchb cchbso loop loopso thia thiaso oth4 stat"
local pills "aceiso aceicchb aceithia a2rbso a2rbthia bbloso bblothia cchbso loopso thiaso"
local groups "aht ras acei a2rb bblo cchb loop thia oth4"

////////////////////////////////////////////////////////////////////////////////
//  Sum stats based on current use of drugs
////////////////////////////////////////////////////////////////////////////////
/////	Treatment
/*foreach i in `pills'{
	outsum `i'_user using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(`i') append
}*/

foreach i in `groups'{
	outsum `i'_user using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(`i') append
	outsum `i'_user if ras_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(`i' & RAS) append
	outsum `i'_user if ras_user==0 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(`i' & no RAS) append
	outsum `i'_user if ras_comb==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(`i' & RAS combo) append
	outsum `i'_user if acei_comb==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(`i' & ACEI combo) append
	outsum `i'_user if a2rb_comb==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(`i' & ARB combo) append
	outsum `i'_user if classcount==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(any solo) append
	outsum `i'_user if classcount>1 & classcount!=. using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(any combo) append
}

//Solo vs combo across sex and race
/*
	outsum any_solo classcount ras_solo ras_comb acei_solo acei_comb a2rb_solo a2rb_comb using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(All) append
	outsum any_solo classcount ras_solo ras_comb acei_solo acei_comb a2rb_solo a2rb_comb if female==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Female) append
	outsum any_solo classcount ras_solo ras_comb acei_solo acei_comb a2rb_solo a2rb_comb if female==0 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Male) append
	outsum any_solo classcount ras_solo ras_comb acei_solo acei_comb a2rb_solo a2rb_comb if race_dw==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(White) append
	outsum any_solo classcount ras_solo ras_comb acei_solo acei_comb a2rb_solo a2rb_comb if race_db==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Black) append
	outsum any_solo classcount ras_solo ras_comb acei_solo acei_comb a2rb_solo a2rb_comb if race_dh==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Hisp) append
	outsum any_solo classcount ras_solo ras_comb acei_solo acei_comb a2rb_solo a2rb_comb if race_do==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Other) append
*/

/* What drugs are being used by each income quartile? 
foreach i in `groups'{
	outsum `i'_user if medinc4==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(`i' 1) append
	outsum `i'_user if medinc4==2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(`i' 2) append
	outsum `i'_user if medinc4==3 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(`i' 3) append
	outsum `i'_user if medinc4==4 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(`i' 4) append
}
*/
/////	Outcome
local adrd "ADv ADccw"
foreach i in `adrd'{
	outsum `i'_inc using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Any AHT) append
	outsum `i'_inc if ras_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(RAS user) append
	outsum `i'_inc if ras_user==0 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(RAS nonuser) append
	outsum `i'_inc if acei_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(ACE user) append
	outsum `i'_inc if a2rb_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(ARB user) append
	outsum `i'_inc if oth4_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Oth4 user) append
	outsum `i'_inc if bblo_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(BBL user) append
	outsum `i'_inc if cchb_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(CCB user) append
	outsum `i'_inc if loop_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Loop user) append
	outsum `i'_inc if thia_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Thia user) append

	outsum `i'_inc if classcount==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(any solo) append
	outsum `i'_inc if classcount>1 & classcount!=. using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(any combo) append

	outsum `i'_inc if ras_user==1 & any_solo==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(RAS solo) append
	outsum `i'_inc if oth4_user==1 & any_solo==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Oth4 solo) append
	outsum `i'_inc if ras_user==1 & any_combo==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(RAS combo) append
	outsum `i'_inc if oth4_user==1 & any_combo==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Oth4 combo) append
}

/////	Controls
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Any AHT) append
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if ras_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(RAS user) append
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if ras_user==0 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(RAS nonuser) append
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if acei_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(ACE user) append
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if a2rb_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(ARB user) append
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if oth4_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Oth4 user) append
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if bblo_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(BBL user) append
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if cchb_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(CCB user) append
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if loop_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Loop user) append
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if thia_user==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Thia user) append

outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if classcount==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(any solo) append
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if classcount>1 & classcount!=. using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(any combo) append

outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if ras_user==1 & any_solo==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(RAS solo) append
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if oth4_user==1 & any_solo==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Oth4 solo) append
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if ras_user==1 & any_combo==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(RAS combo) append
outsum age female race_d* pct_hsgrads medinc phyvis hcc_comm cmd_* classcount any_combo if oth4_user==1 & any_combo==1 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/sum_aht11b1.xls", ctitle(Oth4 combo) append

////////////////////////////////////////////////////////////////////////////////
//switch to bene-level, for 2013 observations, rather than first reference year
restore
*/
tab year
keep if year==2013

//Describe AHT use
//All
count

//Combo solo
count if any_combo==1
count if any_solo==1

//RAS
count if ras_user==1
count if ras_user==1 & any_solo==1
count if ras_user==1 & any_combo==1
count if ras_user==1 & oth4_user==1
count if ras_user==1 & bblo_user==1
count if ras_user==1 & cchb_user==1
count if ras_user==1 & loop_user==1
count if ras_user==1 & thia_user==1

//RAS nonusers
count if ras_user==0
count if ras_user==0 & any_solo==1
count if ras_user==0 & any_combo==1
count if ras_user==0 & oth4_user==1
count if ras_user==0 & bblo_user==1
count if ras_user==0 & cchb_user==1
count if ras_user==0 & loop_user==1
count if ras_user==0 & thia_user==1

//non-RAS users (other 4 users)
count if oth4_user==1
count if oth4_user==1 & any_solo==1
count if oth4_user==1 & any_combo==1
count if oth4_user==1 & acei_user==1
count if oth4_user==1 & a2rb_user==1
count if oth4_user==1 & bblo_user==1
count if oth4_user==1 & cchb_user==1
count if oth4_user==1 & loop_user==1
count if oth4_user==1 & thia_user==1

//ACE
count if acei_user==1
count if acei_user==1 & any_solo==1
count if acei_user==1 & any_combo==1
count if acei_user==1 & a2rb_user==1
count if acei_user==1 & oth4_user==1
count if acei_user==1 & bblo_user==1
count if acei_user==1 & cchb_user==1
count if acei_user==1 & loop_user==1
count if acei_user==1 & thia_user==1

//ARB
count if a2rb_user==1 
count if a2rb_user==1 & any_solo==1
count if a2rb_user==1 & any_combo==1
count if a2rb_user==1 & oth4_user==1
count if a2rb_user==1 & bblo_user==1
count if a2rb_user==1 & cchb_user==1
count if a2rb_user==1 & loop_user==1
count if a2rb_user==1 & thia_user==1

//BBL
count if bblo_user==1 
count if bblo_user==1 & any_solo==1
count if bblo_user==1 & cchb_user==1
count if bblo_user==1 & loop_user==1
count if bblo_user==1 & thia_user==1

//CCB
count if cchb_user==1 
count if cchb_user==1 & any_solo==1
count if cchb_user==1 & loop_user==1
count if cchb_user==1 & thia_user==1

//Loop
count if loop_user==1
count if loop_user==1 & any_solo==1
count if loop_user==1 & thia_user==1

//Thia
count if thia_user==1
count if thia_user==1 & any_solo==1
