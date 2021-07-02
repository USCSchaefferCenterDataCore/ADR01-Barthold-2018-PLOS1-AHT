clear all
set more off
capture log close

/*
•	Input: fdb_ndc_extract.dta
•	Output: just log
•	Gets NDCs/classes associated with class variables
•	Examines the different classes that include certain strings, in both the hic3 class variables, and the ahfs class variable. 
		note: ndcs by gname are found in ndcall_tclass_all_2016_02_10.dta (see ndcbygname.do)
*/


/*
hic3 or ahfs? hic3 is closer to fdb, which we had been using.
it designates a separate class for combination therapy.
so, a user of a combination of two classes would count toward both.
ahfs can be cleaner - but what does it do with ndcs that are combination therapy?
for the purposes of counting the users, i will include combo therapy users.
but for analytic putposes, it probably makes sense to not use combo people. 

the other ndc class file, with gname:
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/DrugInfo/ndcall_tclass_all_2016_02_10.dta", replace
*/

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Extracts/FDB/fdb_ndc_extract.dta", replace
/*
////////////////////////////////////////////////////////////////////////////////
////////////				diabetes			////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//Biguanides - big - hic3
levelsof hic3_desc if strpos(hic3_desc, "BIGUANIDE")
//levelsof ndc if strpos(hic3_desc, "BIGUANIDE"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "BIGUANIDE")
//levelsof ndc if strpos(ahfs_desc, "BIGUANIDE"), clean

//Glucagon-like peptides - glp - hic3
levelsof hic3_desc if strpos(hic3_desc, "GLUCAGON")
levelsof hic3_desc if strpos(hic3_desc, "GLP")
//levelsof ndc if strpos(hic3_desc, "GLUCAGON"), clean
//levelsof ndc if strpos(hic3_desc, "GLP"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "GLUCAGON")
//levelsof ndc if strpos(ahfs_desc, "GLUCAGON"), clean

//Thiazolidinedione - thi - hic3
levelsof hic3_desc if strpos(hic3_desc, "THIAZOLIDINEDIONE")
//levelsof ndc if strpos(hic3_desc, "THIAZOLIDINEDIONE"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "THIAZOLIDINEDIONE")
//levelsof ndc if strpos(ahfs_desc, "THIAZOLIDINEDIONE"), clean

//Insulins - ins - hic3
levelsof hic3_desc if strpos(hic3_desc, "INSULIN") 
levelsof hic3_desc if strpos(hic3_desc, "INSULIN-LIKE GROWTH")  //these are not anti-hyperglycemic
//levelsof ndc if strpos(hic3_desc, "INSULIN"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "INSULIN")
//levelsof ndc if strpos(ahfs_desc, "INSULIN"), clean

//Sulfonylureas - sul - ahfs
levelsof hic3_desc if strpos(hic3_desc, "SULFONYLUREA")
//levelsof ndc if strpos(hic3_desc, "SULFONYLUREA"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "SULFONYLUREA")
//levelsof ndc if strpos(ahfs_desc, "SULFONYLUREA"), clean

//DPP-4 - dpp - hic3
levelsof hic3_desc if strpos(hic3_desc, "DPP-4")
//levelsof ndc if strpos(hic3_desc, "DPP-4"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "DPP-4")
//levelsof ndc if strpos(ahfs_desc, "DPP-4"), clean

//Amylin agonists - amy - hic3 (same as ahfs)
levelsof hic3_desc if strpos(hic3_desc, "AMYLIN")
//levelsof ndc if strpos(hic3_desc, "AMYLIN"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "AMYLIN")
//levelsof ndc if strpos(ahfs_desc, "AMYLIN"), clean

//Metreleptin - met - hic3
levelsof hic3_desc if strpos(hic3_desc, "LEPTIN")
//levelsof ndc if strpos(hic3_desc, "LEPTIN"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "LEPTIN")
//levelsof ndc if strpos(ahfs_desc, "LEPTIN"), clean
*/
////////////////////////////////////////////////////////////////////////////////
////////////				Hypertension			////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//ACE inhibitors - ace - hic3
levelsof hic3_desc if strpos(hic3_desc, "ACE INHIBITOR")
//levelsof ndc if strpos(hic3_desc, "ACE INHIBITOR"), clean
//levelsof ahfs_desc if strpos(ahfs_desc, "ANGIOTENSIN-CONVERTING")
//levelsof ndc if strpos(ahfs_desc, "ANGIOTENSIN-CONVERTING"), clean

//ARBs - arb - hic3
levelsof hic3_desc if strpos(hic3_desc, "ANGIOTENSIN II")
levelsof hic3_desc if strpos(hic3_desc, "ANGIOTENSIN REC")
//levelsof ndc if strpos(hic3_desc, "ANGIOTENSIN II"), clean
//levelsof ndc if strpos(hic3_desc, "ANGIOTENSIN REC"), clean
//levelsof ahfs_desc if strpos(ahfs_desc, "ANGIOTENSIN II")
//levelsof ndc if strpos(ahfs_desc, "ANGIOTENSIN II"), clean
levelsof ndc if hic3_desc=="RENIN INHIBITOR,DIRECT & ANGIOTENSIN RECEPT ANTAG.", clean

//Beta-blockers - bbl - hic3
levelsof hic3_desc if strpos(hic3_desc, "BETA BLO")
levelsof hic3_desc if strpos(hic3_desc, "BETA-ADREN")
//levelsof ndc if strpos(hic3_desc, "BETA BLO"), clean
//levelsof ndc if strpos(hic3_desc, "BETA-ADREN"), clean
//levelsof ahfs_desc if strpos(ahfs_desc, "BETA")
//levelsof ndc if strpos(ahfs_desc, "BETA"), clean

//CCBs - ccb - hic3
levelsof hic3_desc if strpos(hic3_desc, "CALCIUM CHAN") | strpos(hic3_desc, "CALC.CHANNEL BLKR") | strpos(hic3_desc, "CAL.CHANL BLKR")
//levelsof ndc if strpos(hic3_desc, "CALCIUM CHAN"), clean
//levelsof ahfs_desc if strpos(ahfs_desc, "CALCIUM-CHAN")
//levelsof ndc if strpos(ahfs_desc, "CALCIUM-CHAN"), clean

//Loop Diuretics - diu - hic3 (prob the same)
levelsof hic3_desc if strpos(hic3_desc, "LOOP DIURETIC")
levelsof hic3_desc if strpos(hic3_desc, "LOOP")
//levelsof ndc if strpos(hic3_desc, "LOOP DIURETIC"), clean
//levelsof ahfs_desc if strpos(ahfs_desc, "LOOP DIURETIC")
//levelsof ndc if strpos(ahfs_desc, "LOOP DIURETIC"), clean

//Thiazide - thia - hic3
//levelsof ahfs_desc if strpos(ahfs_desc, "THIAZIDE")
levelsof hic3_desc if strpos(hic3_desc, "THIAZIDE")

//NEPRILYSIN INHIBITOR - nepr - hic3
	//only appears in combo with ARB
levelsof hic3_desc if strpos(hic3_desc, "NEPRILYSIN")
levelsof ndc if strpos(hic3_desc, "NEPRILYSIN"), clean
//levelsof ahfs_desc if strpos(ahfs_desc, "NEPRILYSIN")

////////////////////////////////////////////////////////////////////////////////
////////////				GERD				////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
/*
//PPIs - ppi - prefer hic3
levelsof hic3_desc if strpos(hic3_desc, "PROTON")
//levelsof ndc if strpos(hic3_desc, "PROTON"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "PROTON")
//levelsof ndc if strpos(ahfs_desc, "PROTON"), clean

//Histamine 2 receptor antagonists - hi2 - hic3
levelsof hic3_desc if strpos(hic3_desc, "HISTAMINE H2")
//levelsof ndc if strpos(hic3_desc, "HISTAMINE H2"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "HISTAMINE H2")
//levelsof ndc if strpos(ahfs_desc, "HISTAMINE H2"), clean


////////////////////////////////////////////////////////////////////////////////
////////////				Insomnia			////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//Endocrine-Metabolic Agent - mel - hic3
levelsof hic3_desc if strpos(hic3_desc, "MELATONIN")
//levelsof ndc if strpos(hic3_desc, "MELATONIN"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "MELATONIN")
//levelsof ndc if strpos(ahfs_desc, "MELATONIN"), clean

//Atypical antipsychotics - aap - hic3
levelsof hic3_desc if strpos(hic3_desc, "ATYPICAL")
//levelsof ndc if strpos(hic3_desc, "ATYPICAL"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "ATYPICAL")
//levelsof ndc if strpos(ahfs_desc, "ATYPICAL"), clean

//Benzodiazepine - ben - ahfs
levelsof hic3_desc if strpos(hic3_desc, "BENZODIAZEPINE")
//levelsof ndc if strpos(hic3_desc, "BENZODIAZEPINE"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "BENZODIAZEPINE")
//levelsof ndc if strpos(ahfs_desc, "BENZODIAZEPINE"), clean

//Nonbarbiturate Hypnotic - nbh - hic3
levelsof hic3_desc if strpos(hic3_desc, "NON-BARB")
//levelsof ndc if strpos(hic3_desc, "NON-BARB"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "HYPNOTIC")
//levelsof ndc if strpos(ahfs_desc, "HYPNOTIC"), clean

////////////////////////////////////////////////////////////////////////////////
////////////		Other common drugs used by statin users		////////////////
////////////////////////////////////////////////////////////////////////////////
//Anticonvulsants - acon - hic3
levelsof hic3_desc if strpos(hic3_desc, "ANTICONVULSANTS")
//levelsof ndc if strpos(hic3_desc, "ANTICONVULSANTS"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "ANTICONVULSANTS")
//levelsof ndc if strpos(ahfs_desc, "ANTICONVULSANTS"), clean

//Bone resorption inhibitor - brin - hic3
levelsof hic3_desc if strpos(hic3_desc, "BONE RESORPTION INHIBITOR")
//levelsof ndc if strpos(hic3_desc, "BONE RESORPTION INHIBITOR"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "BONE RESORPTION INHIBITOR")
//levelsof ndc if strpos(ahfs_desc, "BONE RESORPTION INHIBITOR"), clean

//Lipotropics - lipo - hic3
levelsof hic3_desc if strpos(hic3_desc, "LIPOTROPICS")
//levelsof ndc if strpos(hic3_desc, "LIPOTROPICS"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "LIPOTROPICS")
//levelsof ndc if strpos(ahfs_desc, "LIPOTROPICS"), clean

//Platelet aggregation inhibitors - pagi - hic3
levelsof hic3_desc if strpos(hic3_desc, "PLATELET AGGREGATION")
//levelsof ndc if strpos(hic3_desc, "PLATELET AGGREGATION"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "PLATELET AGGREGATION")
//levelsof ndc if strpos(ahfs_desc, "PLATELET AGGREGATION"), clean

//Potassium replacements - pota - hic3
levelsof hic3_desc if strpos(hic3_desc, "POTASSIUM REPLACEMENT")
//levelsof ndc if strpos(hic3_desc, "ANTICONVULSANTS"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "ANTICONVULSANTS")
//levelsof ndc if strpos(ahfs_desc, "ANTICONVULSANTS"), clean

//Selective serotonin reuptake inhibitors (SSRIs) - ssri - hic3
levelsof hic3_desc if strpos(hic3_desc, "SSRI")
//levelsof ndc if strpos(hic3_desc, "SSRI"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "SSRI")
//levelsof ndc if strpos(ahfs_desc, "SSRI"), clean

//Thiazide and related diuretics - thia - hic3
levelsof hic3_desc if strpos(hic3_desc, "THIAZIDE")
//levelsof ndc if strpos(hic3_desc, "THIAZIDE"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "THIAZIDE")
//levelsof ndc if strpos(ahfs_desc, "THIAZIDE"), clean

//Thyroid hormones - thyr - hic3
levelsof hic3_desc if hic3_desc=="THYROID HORMONE"
//levelsof ndc if hic3_desc=="THYROID HORMONE"
levelsof ahfs_desc if strpos(ahfs_desc, "THYROID HORMONE")
//levelsof ndc if strpos(ahfs_desc, "THYROID HORMONE"), clean

//Vasodilators, coronary - vaso - hic3
levelsof hic3_desc if strpos(hic3_desc, "VASODILATORS")
//levelsof ndc if strpos(hic3_desc, "VASODILATORS"), clean
levelsof ahfs_desc if strpos(ahfs_desc, "VASODILATORS")
//levelsof ndc if strpos(ahfs_desc, "VASODILATORS"), clean

