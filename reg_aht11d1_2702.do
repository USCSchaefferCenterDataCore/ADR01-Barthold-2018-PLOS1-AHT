
clear all
set more off
capture log close

/*
•	Input: ahtco_long0713_902.dta
•	Output: outreg
•	Sample: Each person year has no deaths in that year, and 90 days of a single AHT class in years t-1 and t-2, and 2 claims. No prior use of AChEI or meman.
•	Regs for `i’_user_L12, for ras, acei a2rb
*/

//Input the long file of AHT users
use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/ahtco_long0713_2702.dta", replace

//drop the obs for people after they get incident 
drop if ADccw_inc==2  

//drop the obs for people that died in that year
drop if death_year==year
drop if death_year<year

//keep only the obs in the long file where the person used a class in years t-1 and t-2
keep if acei_user_L12==1 | a2rb_user_L12==1 | bblo_user_L12==1 | cchb_user_L12==1 | loop_user_L12==1 | thia_user_L12==1

//no one has NADD before the beginning of the year
//drop cmd_NADD

//drop hypertension variable
drop cmd_hyp

//drop those that used an AChEI or memantine prior to reference year
drop if adrx_prior==1
count
codebook bene_id

//setup outreg
logistic ADv_inc ras_user_L1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(SETUP 1) replace

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
// 					LOGIT													  //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

///////////////  ADv
logistic ADv_inc ras_user_L12 age agesq female race_d* i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(All) append
logistic ADv_inc acei_user_L12 a2rb_user_L12 age agesq female race_d* i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(All) append

//Female
logistic ADv_inc ras_user_L12 age agesq race_d* i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if female==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Female) append
logistic ADv_inc acei_user_L12 a2rb_user_L12 age agesq race_d* i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if female==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Female) append

//Male
logistic ADv_inc ras_user_L12 age agesq race_d* i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if female==0, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Male) append
logistic ADv_inc acei_user_L12 a2rb_user_L12 age agesq race_d* i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if female==0, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Male) append

//White
logistic ADv_inc ras_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_dw==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(White) append
logistic ADv_inc acei_user_L12 a2rb_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_dw==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(White) append
logistic ADv_inc ras_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_dw==1 & female==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(White fem) append
logistic ADv_inc acei_user_L12 a2rb_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_dw==1 & female==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(White fem) append
logistic ADv_inc ras_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_dw==1 & female==0, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(White mal) append
logistic ADv_inc acei_user_L12 a2rb_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_dw==1 & female==0, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(White mal) append

//Black
logistic ADv_inc ras_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_db==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Black) append
logistic ADv_inc acei_user_L12 a2rb_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_db==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Black) append
logistic ADv_inc ras_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_db==1 & female==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Black fem) append
logistic ADv_inc acei_user_L12 a2rb_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_db==1 & female==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Black fem) append
logistic ADv_inc ras_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_db==1 & female==0, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Black mal) append
logistic ADv_inc acei_user_L12 a2rb_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_db==1 & female==0, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Black mal) append

//Hispanic
logistic ADv_inc ras_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_dh==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Hispanic) append
logistic ADv_inc acei_user_L12 a2rb_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_dh==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Hispanic) append
logistic ADv_inc ras_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_dh==1 & female==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Hispanic fem) append
logistic ADv_inc acei_user_L12 a2rb_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_dh==1 & female==1, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Hispanic fem) append
logistic ADv_inc ras_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_dh==1 & female==0, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Hispanic mal) append
logistic ADv_inc acei_user_L12 a2rb_user_L12 age agesq female i.hcc4_L1 cmd_* i.pct_hsgrads4_L1 i.medinc4_L1 i.phyvis4_L1 stat_user_L1 ys_hypert if race_dh==1 & female==0, vce(cluster county07)
outreg2 using "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Programs/poly/aht/reg_aht11d1_2702.xls", cttop(Hispanic mal) append


