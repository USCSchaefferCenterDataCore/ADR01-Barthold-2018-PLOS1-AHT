//clear all
//set more off
//capture log close

/*
•	Input: ndcall_tclass_all_2016_02_10.dta
•	Output: just log
•	Gets NDCs associated with gnames 
		note: ndcs associated with class variables should come from fdb_ndc_extract.dta (see ndcbyclass.do)
*/
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
//																			  //
//			anxiety, sedatives													  //
//																		      //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/DrugInfo/ndcall_tclass_all_2016_02_10.dta", replace
count

//RAMELTEON
//ndcs
levelsof gname if strpos(gname, "RAMELTEON")
levelsof ndc if strpos(gname, "RAMELTEON"), clean

//classes
tab ther_class_fdb if strpos(gname, "RAMELTEON")
levelsof ther_class_fdb if strpos(gname, "RAMELTEON")
tab ther_class_ims if strpos(gname, "RAMELTEON")
levelsof ther_class_ims if strpos(gname, "RAMELTEON")
tab ther_class_rxn if strpos(gname, "RAMELTEON")
levelsof ther_class_rxn if strpos(gname, "RAMELTEON")

//ZOLPIDEM
//ndcs
levelsof gname if strpos(gname, "ZOLPIDEM")
levelsof ndc if strpos(gname, "ZOLPIDEM"), clean

//classes
tab ther_class_fdb if strpos(gname, "ZOLPIDEM")
levelsof ther_class_fdb if strpos(gname, "ZOLPIDEM")
tab ther_class_ims if strpos(gname, "ZOLPIDEM")
levelsof ther_class_ims if strpos(gname, "ZOLPIDEM")
tab ther_class_rxn if strpos(gname, "ZOLPIDEM")
levelsof ther_class_rxn if strpos(gname, "ZOLPIDEM")

//DIAZEPAM
//ndcs
levelsof gname if strpos(gname, "DIAZEPAM")
levelsof ndc if strpos(gname, "DIAZEPAM"), clean

//classes
tab ther_class_fdb if strpos(gname, "DIAZEPAM")
levelsof ther_class_fdb if strpos(gname, "DIAZEPAM")
tab ther_class_ims if strpos(gname, "DIAZEPAM")
levelsof ther_class_ims if strpos(gname, "DIAZEPAM")
tab ther_class_rxn if strpos(gname, "DIAZEPAM")
levelsof ther_class_rxn if strpos(gname, "DIAZEPAM")

/*
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
//																			  //
//					RAS-AHT													  //
//																		      //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/DrugInfo/ndcall_tclass_all_2016_02_10.dta", replace
count

////////////////////////////////////////////////////////////////////////////////
///////					  ARBS
////////////////////////////////////////////////////////////////////////////////

levelsof gname if strpos(gname, "SACUBITRIL")

levelsof ndc if ndc=="00078065920" | ndc=="00078065935" | ndc=="00078065961" | ///
	ndc=="00078065967" | ndc=="00078069620" | ndc=="00078069635" | ndc=="00078069661" | ///
	ndc=="00078069667" | ndc=="00078077720" | ndc=="00078077735" | ndc=="00078077761" | ///
	ndc=="00078077767"

levelsof gname if ndc=="00078057215" | ndc=="00078057415"

/////////////////////////////////////////////////BBB permeability = 1
levelsof gname if strpos(gname, "CANDESARTAN")
levelsof ndc if strpos(gname, "CANDESARTAN"), clean  //all
levelsof ndc if gname=="CANDESARTAN CILEXETIL", clean //solo


levelsof gname if strpos(gname, "EPROSARTAN")
levelsof ndc if strpos(gname, "EPROSARTAN"), clean
levelsof ndc if gname=="EPROSARTAN MESYLATE", clean

levelsof gname if strpos(gname, "IRBESARTAN")
levelsof ndc if strpos(gname, "IRBESARTAN"), clean
levelsof ndc if gname=="IRBESARTAN", clean
levelsof ndc if gname=="IRBESARTAN", clean

levelsof gname if strpos(gname, "TELMISARTAN")
levelsof ndc if strpos(gname, "TELMISARTAN"), clean
levelsof ndc if gname=="TELMISARTAN", clean
levelsof ndc if gname=="TELMISARTAN", clean

levelsof gname if strpos(gname, "VALSARTAN")
levelsof ndc if strpos(gname, "VALSARTAN"), clean
levelsof ndc if gname=="VALSARTAN", clean
levelsof ndc if gname=="VALSARTAN", clean

/////////////////////////////////////////////////BBB permeability = 0
levelsof gname if strpos(gname, "LOSARTAN")
levelsof ndc if strpos(gname, "LOSARTAN"), clean
levelsof ndc if gname=="LOSARTAN POTASSIUM", clean
levelsof ndc if gname=="LOSARTAN POTASSIUM", clean

levelsof gname if strpos(gname, "OLMESARTAN")
levelsof ndc if strpos(gname, "OLMESARTAN"), clean
levelsof ndc if gname=="OLMESARTAN MEDOXOMIL", clean
levelsof ndc if gname=="OLMESARTAN MEDOXOMIL", clean

////////////////////////////////////////////////////////////////////////////////
///////                    ACE inh
////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////BBB permeability = 1
levelsof gname if strpos(gname, "CAPTOPRIL")
levelsof ndc if strpos(gname, "CAPTOPRIL"), clean
levelsof ndc if gname=="CAPTOPRIL", clean

levelsof gname if strpos(gname, "FOSINOPRIL")
levelsof ndc if strpos(gname, "FOSINOPRIL"), clean
levelsof ndc if gname=="FOSINOPRIL SODIUM", clean

levelsof gname if strpos(gname, "LISINOPRIL")
levelsof ndc if strpos(gname, "LISINOPRIL"), clean
levelsof ndc if gname=="LISINOPRIL", clean

levelsof gname if strpos(gname, "PERINDOPRIL")
levelsof ndc if strpos(gname, "PERINDOPRIL"), clean
levelsof ndc if gname=="PERINDOPRIL ERBUMINE", clean //same (no combo)

levelsof gname if strpos(gname, "RAMIPRIL")
levelsof ndc if strpos(gname, "RAMIPRIL"), clean
levelsof ndc if gname=="RAMIPRIL", clean //same (no combo)

levelsof gname if strpos(gname, "TRANDOLAPRIL")
levelsof ndc if strpos(gname, "TRANDOLAPRIL"), clean
levelsof ndc if gname=="TRANDOLAPRIL", clean

/////////////////////////////////////////////////BBB permeability = 0
levelsof gname if strpos(gname, "BENAZEPRIL")
levelsof ndc if strpos(gname, "BENAZEPRIL"), clean
levelsof ndc if gname=="BENAZEPRIL HCL", clean //always combo?

levelsof gname if strpos(gname, "ENALAPRIL")
levelsof ndc if strpos(gname, "ENALAPRIL"), clean
levelsof ndc if gname=="ENALAPRIL MALEATE" | gname=="ENALAPRILAT DIHYDRATE", clean

levelsof gname if strpos(gname, "MOEXIPRIL")
levelsof ndc if strpos(gname, "MOEXIPRIL"), clean
levelsof ndc if gname=="MOEXIPRIL HCL", clean //always combo?

levelsof gname if strpos(gname, "QUINAPRIL")
levelsof ndc if strpos(gname, "QUINAPRIL"), clean
levelsof ndc if gname=="QUINAPRIL HCL", clean //always combo?

levelsof gname if strpos(gname, "IMIDAPRIL")  //does not exist
levelsof ndc if strpos(gname, "IMIDAPRIL"), clean //does not exist
levelsof ndc if gname=="IMIDAPRIL", clean //does not exist

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/DrugInfo/ndcall_tclass_all_2016_02_10.dta", replace
levelsof ther_class_fdb if gname=="BENAZEPRIL HCL"
levelsof ther_class_fdb if gname=="MOEXIPRIL HCL"
levelsof ther_class_fdb if gname=="QUINAPRIL HCL"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//																			  //
//																			  //
//					STATINS													  //
//																		      //
//																			  //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/DrugInfo/ndcall_tclass_all_2016_02_10.dta", replace
count

//ATORVASTATIN
//ndcs
levelsof gname if strpos(gname, "ATORVASTATIN")
levelsof ndc if strpos(gname, "ATORVASTATIN CALCIUM"), clean
levelsof ndc if strpos(gname, "AMLODIPINE/ATORVASTATIN"), clean

//classes
tab ther_class_fdb if strpos(gname, "ATORVASTATIN")
levelsof ther_class_fdb if strpos(gname, "ATORVASTATIN")
tab ther_class_ims if strpos(gname, "ATORVASTATIN")
levelsof ther_class_ims if strpos(gname, "ATORVASTATIN")
tab ther_class_rxn if strpos(gname, "ATORVASTATIN")
levelsof ther_class_rxn if strpos(gname, "ATORVASTATIN")


//FLUVASTATIN
//ndcs
levelsof gname if strpos(gname, "FLUVASTATIN")
levelsof ndc if strpos(gname, "FLUVASTATIN SODIUM"), clean


//classes
tab ther_class_fdb if strpos(gname, "FLUVASTATIN")
levelsof ther_class_fdb if strpos(gname, "FLUVASTATIN")
tab ther_class_ims if strpos(gname, "FLUVASTATIN")
levelsof ther_class_ims if strpos(gname, "FLUVASTATIN")
tab ther_class_rxn if strpos(gname, "FLUVASTATIN")
levelsof ther_class_rxn if strpos(gname, "FLUVASTATIN")


//LOVASTATIN
//ndcs
levelsof gname if strpos(gname, "LOVASTATIN")
levelsof ndc if strpos(gname, "LOVASTATIN"), clean
levelsof ndc if strpos(gname, "NIACIN/LOVASTATIN"), clean

//classes
tab ther_class_fdb if strpos(gname, "LOVASTATIN")
levelsof ther_class_fdb if strpos(gname, "LOVASTATIN")
tab ther_class_ims if strpos(gname, "LOVASTATIN")
levelsof ther_class_ims if strpos(gname, "LOVASTATIN")
tab ther_class_rxn if strpos(gname, "LOVASTATIN")
levelsof ther_class_rxn if strpos(gname, "LOVASTATIN")

//PITAVASTATIN
//ndcs
levelsof gname if strpos(gname, "PITAVASTATIN")
levelsof ndc if strpos(gname, "PITAVASTATIN CALCIUM"), clean


//classes
tab ther_class_fdb if strpos(gname, "PITAVASTATIN")
levelsof ther_class_fdb if strpos(gname, "PITAVASTATIN")
tab ther_class_ims if strpos(gname, "PITAVASTATIN")
levelsof ther_class_ims if strpos(gname, "PITAVASTATIN")
tab ther_class_rxn if strpos(gname, "PITAVASTATIN")
levelsof ther_class_rxn if strpos(gname, "PITAVASTATIN")


//PRAVASTATIN
//ndcs
levelsof gname if strpos(gname, "PRAVASTATIN")
levelsof ndc if strpos(gname, "PRAVASTATIN SODIUM"), clean
levelsof ndc if strpos(gname, "ASPIRIN(CALC&MG)/PRAVASTATIN"), clean

//classes
tab ther_class_fdb if strpos(gname, "PRAVASTATIN")
levelsof ther_class_fdb if strpos(gname, "PRAVASTATIN")
tab ther_class_ims if strpos(gname, "PRAVASTATIN")
levelsof ther_class_ims if strpos(gname, "PRAVASTATIN")
tab ther_class_rxn if strpos(gname, "PRAVASTATIN")
levelsof ther_class_rxn if strpos(gname, "PRAVASTATIN")

//ROSUVASTATIN
//ndcs
levelsof gname if strpos(gname, "ROSUVASTATIN")
levelsof ndc if strpos(gname, "ROSUVASTATIN CALCIUM"), clean


//classes
tab ther_class_fdb if strpos(gname, "ROSUVASTATIN")
levelsof ther_class_fdb if strpos(gname, "ROSUVASTATIN")
tab ther_class_ims if strpos(gname, "ROSUVASTATIN")
levelsof ther_class_ims if strpos(gname, "ROSUVASTATIN")
tab ther_class_rxn if strpos(gname, "ROSUVASTATIN")
levelsof ther_class_rxn if strpos(gname, "ROSUVASTATIN")


//SIMVASTATIN
//ndcs
levelsof gname if strpos(gname, "SIMVASTATIN"), clean
levelsof ndc if strpos(gname, "SIMVASTATIN"), clean
levelsof ndc if strpos(gname, "EZETIMIBE/SIMVASTATIN"), clean
levelsof ndc if strpos(gname, "NIACIN/SIMVASTATIN"), clean
levelsof ndc if strpos(gname, "SITAGLIPTIN/SIMVASTATIN"), clean


//classes
tab ther_class_fdb if strpos(gname, "SIMVASTATIN")
levelsof ther_class_fdb if strpos(gname, "SIMVASTATIN")
tab ther_class_ims if strpos(gname, "SIMVASTATIN")
levelsof ther_class_ims if strpos(gname, "SIMVASTATIN")
tab ther_class_rxn if strpos(gname, "SIMVASTATIN")
levelsof ther_class_rxn if strpos(gname, "SIMVASTATIN")


////////////////////////////////////////////////////////////////////////////////
///////////////		PPIS			////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//omeprazole, pantoprazole, lansoprazole, esomeprazole, rabeprazole

levelsof gname if strpos(gname, "OMEPRAZOLE")
levelsof ndc if gname=="OMEPRAZOLE" | gname=="OMEPRAZOLE MAGNESIUM" | ///
gname=="OMEPRAZOLE/CLARITH/AMOXICILLIN" | gname=="OMEPRAZOLE/SODIUM BICARBONATE", clean

levelsof gname if strpos(gname, "PANTOPRAZOLE")
levelsof ndc if strpos(gname, "PANTOPRAZOLE"), clean

levelsof gname if strpos(gname, "LANSOPRAZOLE")
levelsof ndc if strpos(gname, "LANSOPRAZOLE"), clean

levelsof gname if strpos(gname, "ESOMEPRAZOLE")
levelsof ndc if strpos(gname, "ESOMEPRAZOLE"), clean

levelsof gname if strpos(gname, "RABEPRAZOLE")
levelsof ndc if strpos(gname, "RABEPRAZOLE"), clean

////////////////////////////////////////////////////////////////////////////////
///////////////		AD drugs			////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Clean_Data/DrugInfo/ndcall_tclass_all_2016_02_10.dta", replace
count

levelsof ndc if gname=="DONEPEZIL HCL", clean
tab ther_class_fdb if gname=="DONEPEZIL HCL"
levelsof ther_class_fdb if gname=="DONEPEZIL HCL", clean
tab ther_class_ims if gname=="DONEPEZIL HCL"
levelsof ther_class_ims if gname=="DONEPEZIL HCL", clean
tab ther_class_rxn if gname=="DONEPEZIL HCL"
levelsof ther_class_rxn if gname=="DONEPEZIL HCL", clean

levelsof ndc if gname=="GALANTAMINE HBR", clean
tab ther_class_fdb if gname=="GALANTAMINE HBR"
levelsof ther_class_fdb if gname=="GALANTAMINE HBR", clean
tab ther_class_ims if gname=="GALANTAMINE HBR"
levelsof ther_class_ims if gname=="GALANTAMINE HBR", clean
tab ther_class_rxn if gname=="GALANTAMINE HBR"
levelsof ther_class_rxn if gname=="GALANTAMINE HBR", clean

levelsof ndc if gname=="MEMANTINE HCL", clean
tab ther_class_fdb if gname=="MEMANTINE HCL"
levelsof ther_class_fdb if gname=="MEMANTINE HCL", clean
tab ther_class_ims if gname=="MEMANTINE HCL"
levelsof ther_class_ims if gname=="MEMANTINE HCL", clean
tab ther_class_rxn if gname=="MEMANTINE HCL"
levelsof ther_class_rxn if gname=="MEMANTINE HCL", clean

levelsof ndc if gname=="RIVASTIGMINE", clean
tab ther_class_fdb if gname=="RIVASTIGMINE"
levelsof ther_class_fdb if gname=="RIVASTIGMINE", clean
tab ther_class_ims if gname=="RIVASTIGMINE"
levelsof ther_class_ims if gname=="RIVASTIGMINE", clean
tab ther_class_rxn if gname=="RIVASTIGMINE"
levelsof ther_class_rxn if gname=="RIVASTIGMINE", clean

levelsof ndc if gname=="RIVASTIGMINE TARTRATE", clean
tab ther_class_fdb if gname=="RIVASTIGMINE TARTRATE"
levelsof ther_class_fdb if gname=="RIVASTIGMINE TARTRATE", clean
tab ther_class_ims if gname=="RIVASTIGMINE TARTRATE"
levelsof ther_class_ims if gname=="RIVASTIGMINE TARTRATE", clean
tab ther_class_rxn if gname=="RIVASTIGMINE TARTRATE"
levelsof ther_class_rxn if gname=="RIVASTIGMINE TARTRATE", clean

levelsof ndc if gname=="TACRINE HCL", clean
tab ther_class_fdb if gname=="TACRINE HCL"
levelsof ther_class_fdb if gname=="TACRINE HCL", clean
tab ther_class_ims if gname=="TACRINE HCL"
levelsof ther_class_ims if gname=="TACRINE HCL", clean
tab ther_class_rxn if gname=="TACRINE HCL"
levelsof ther_class_rxn if gname=="TACRINE HCL", clean
