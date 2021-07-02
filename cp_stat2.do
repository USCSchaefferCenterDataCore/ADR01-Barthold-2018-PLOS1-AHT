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
•	These classes exist, but there are no claims: stat a2rbbblo statthia cchbthia
*/

////////////////////////////////////////////////////////////////////////////////
/////////			NDC level file with stat	////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//keep the ndcs defined by gname, excluding the combo pills
use "/disk/agedisk3/medicare.work/goldman-DUA25731/DATA/Extracts/FDB/fdb_ndc_extract.dta", replace
keep ndc 

destring ndc, gen(ndcn)
egen ator = anymatch(ndcn), values(00071015523 00071015534 00071015540 00071015623 00071015640 00071015694 00071015723 ///
00071015740 00071015773 00071015788 00071015823 00071015873 00071015888 00071015892 ///
00378201505 00378201577 00378201705 00378201777 00378212105 00378212177 00378212205 ///
00378212277 00591377410 00591377419 00591377510 00591377519 00591377605 00591377619 ///
00591377705 00591377719 00781538192 00781538292 00781538492 00781538892 00904629061 ///
00904629161 33358021090 49999039230 49999039290 49999046730 49999046790 49999046830 ///
49999046890 49999088230 49999088290 51079040901 51079040920 51079041020 51079041101 ///
51079041120 51079041201 51079041203 52959004630 52959075990 52959076090 54569446600 ///
54569446601 54569446700 54569458700 54569458701 54569538200 54569628300 54868393400 ///
54868393401 54868393402 54868394600 54868394601 54868394602 54868394603 54868422900 ///
54868422901 54868422902 54868493400 54868493401 54868632200 55111012105 55111012190 ///
55111012205 55111012290 55111012305 55111012390 55111012405 55111012490 55289080030 ///
55289086130 55289087030 55887062490 55887092990 57866861501 58864060830 58864062315 ///
58864062330 58864068530 58864083430 60505257808 60505257809 60505257908 60505257909 ///
60505258008 60505258009 60505267108 60505267109 63304082705 63304082790 63304082805 ///
63304082890 63304082905 63304082990 63304083005 63304083090 66116027630 67544006030 ///
67544024730 68030861501 68084056401 68084056411 68084056501 68084056511 68084058901 ///
68084058911 68084059025 68115049430 68115049460 68115066815 68115066830 68115066890 ///
68115080090 68115083630 68115083690 68258104001 68258600009 68258600209 68258900101 ///
68258915401)

egen ator_c1 = anymatch(ndcn), values(00069215030 00069216030 00069217030 00069218030 00069219030 00069225030 00069226030 ///
00069227030 00069296030 00069297030 00069298030 00378616177 00378616277 00378616377 ///
00378616405 00378616477 00378616505 00378616577 00378616605 00378616677 00378616777 ///
00378616805 00378616877 00378616905 00378616977 00378617005 00378617077 00378617177 ///
54868120700 54868520900 63304049930 63304050030 63304050130 63304050230 63304050330 ///
63304058730 63304058830 63304058930 63304059030 63304059130 63304060330)


egen flu = anymatch(ndcn), values(00078017605 00078017615 00078023405 00078023415 00078035405 00078035415 00093744201 ///
00093744256 00093744301 00093744356 00378802077 00378802093 00378802177 00378802193 ///
54569476100 54569549800 54868460100)

egen lo = anymatch(ndcn), values (00006073061 00006073128 00006073161 00006073182 00006073194 00006073261 00006073282 ///
00006073294 00093057606 00093057610 00093057619 00093057693 00093092606 00093092610 ///
00093092619 00093092693 00093092806 00093092810 00093092819 00093092893 00185007001 ///
00185007005 00185007010 00185007060 00185007201 00185007210 00185007260 00185007401 ///
00185007410 00185007460 00228263306 00228263350 00228263406 00228263450 00228263506 ///
00228263550 00378651091 00378652005 00378652091 00378654005 00378654091 00781121010 ///
00781121060 00781121310 00781121360 00781132305 00781132360 00904558152 00904558252 ///
00904558352 12280010860 16590054730 21695053690 23490584001 42291037690 42291037710 ///
42291037790 45963063301 45963063304 45963063401 45963063404 45963063501 45963063504 ///
49884075401 49884075402 49884075410 49884075501 49884075502 49884075510 49884075601 ///
49884075602 49884075610 49999029330 49999047030 49999047060 49999047130 49999047160 ///
51079097401 51079097420 51079097501 51079097520 51079097556 51079097601 51079097620 ///
51079097656 52959072030 53489060701 53489060706 53489060801 53489060806 53489060810 ///
53489060901 53489060906 53489060910 54458091410 54458091510 54458091610 54458093610 ///
54458093710 54458093810 54458098210 54458098310 54458098410 54569534700 54868068601 ///
54868458500 54868458501 54868458502 54868458503 54868459300 54868459301 54868477400 ///
54868477401 54868477403 54868535800 54868551300 55045301508 55289069214 55289088130 ///
55887035030 58016090000 58016090090 58016092200 58016092230 58016092290 58016097900 ///
58016097902 58016097960 58864078030 58864078060 58864078130 59630062830 59630062930 ///
59630063030 60429024810 60429024910 60429024960 60429025010 60429025090 60505017700 ///
60505017800 60505017900 61442014101 61442014110 61442014160 61442014201 61442014205 ///
61442014210 61442014260 61442014301 61442014305 61442014310 61442014360 62022062730 ///
62022062830 62022062930 62022063030 62022077030 62022078030 62022078130 62037079101 ///
62037079160 62037079201 62037079260 62037079301 62037079360 63629146403 63739028010 ///
63739028015 63739028110 63739028115 63739028210 65243035209 66116027730 66336031060 ///
66336041205 67544022545 68084013101 68084013111 68084013201 68084013211 68084013301 ///
68084013311 68084055801 68084055901 68084056001 68115021930 68115021960 68115065800 ///
68180046701 68180046703 68180046707 68180046801 68180046803 68180046805 68180046807 ///
68180046901 68180046903 68180046905 68180046907)

egen lo_c1 = anymatch(ndcn), values(00074300590 00074300790 00074301090 00074307290 54868480700 54868480701 54868480702 ///
54868508700 54868565300 60598000690 60598000790 60598000890 60598000990)

egen pita = anymatch(ndcn), values(00002477090 00002477190 00002477290)

egen pra = anymatch(ndcn), values(00003515405 00003517805 00003517806 00003517875 00003519410 00003519433 00003519510 ///
00003519533 00093077110 00093077198 00093720110 00093720198 00093720210 00093720298 ///
00093727010 00093727098 00247113930 00247114030 00247114060 00247127630 00378055277 ///
00378055377 00378055477 00378055777 00378821010 00378821077 00378822010 00378822077 ///
00378824010 00378824077 00378828005 00378828077 00440815730 00440815890 00591001310 ///
00591001319 00591001410 00591001419 00591001610 00591001619 00591001905 00591001919 ///
00781523110 00781523192 00781523210 00781523292 00781523410 00781523492 00904589161 ///
00904589261 00904589361 00904611361 00904611461 00904611561 10135049890 10135049990 ///
10135050090 12280033530 12280033590 16252052690 16252052750 16252052790 16252052850 ///
16252052890 16252052990 21695017830 21695017990 23490935206 43063014330 43063019530 ///
49884017609 49884017610 49884017909 49884017910 49884018009 49884018010 50111076117 ///
50111076203 50111076217 50111076403 50111076417 51079045801 51079045820 51079078201 ///
51079078220 54458090802 54458092510 54458092610 54458092710 54458098507 54458098510 ///
54458098610 54458098709 54569461000 54569579300 54569579400 54569579401 54868327000 ///
54868327002 54868463400 54868557600 54868557700 54868557800 54868557801 55111022905 ///
55111022990 55111023005 55111023090 55111023105 55111023190 55111027405 55111027490 ///
55289087130 55887019230 58016001200 58016001230 58016001300 58016001330 58864074330 ///
60429036905 60505016805 60505016809 60505016907 60505016909 60505017007 60505017008 ///
60505017009 60505132305 60505132309 63304059590 63304059690 63304059790 63304059805 ///
63304059890 68084018601 68084018701 68084018711 68084018801 68084018811 68084050001 ///
68084050011 68084050101 68084050111 68084050201 68084050211 68115066490 68180048502 ///
68180048509 68180048602 68180048609 68180048702 68180048709 68180048802 68180048809 ///
68382007005 68382007016 68382007105 68382007116 68382007205 68382007216 68382007305 ///
68382007316 68462019505 68462019590 68462019605 68462019690 68462019705 68462019790 ///
68462019805 68462019890)

egen pra_c1 = anymatch(ndcn), value(00003517311 00003518311)

egen rosu = anymatch(ndcn), values(00310075139 00310075190 00310075239 00310075290 00310075430 00310075590 12280016415 ///
12280016490 12280035130 12280035190 35356041330 43353003160 49999087330 49999087390 ///
49999099290 54569560000 54569567200 54569574600 54868189000 54868189001 54868496300 ///
54868496301 54868496302 54868496303 54868508500 54868508501 54868508502 54868508503 ///
54868534100 55289093230 55289093530 58016003700 58016003730 58016003760 58016003790 ///
58016005200 58016005230 58016005260 58016005290 58016007100 58016007130 68071078430)

egen sim = anymatch(ndcn), values(00006054328 00006054331 00006054354 00006054361 00006054382 00006072628 00006072631 ///
00006072654 00006072661 00006072682 00006073528 00006073531 00006073554 00006073561 ///
00006073582 00006073587 00006074028 00006074031 00006074054 00006074061 00006074082 ///
00006074087 00006074928 00006074931 00006074954 00006074961 00006074982 00093715219 ///
00093715256 00093715293 00093715298 00093715310 00093715319 00093715356 00093715393 ///
00093715398 00093715410 00093715419 00093715456 00093715493 00093715498 00093715510 ///
00093715519 00093715556 00093715593 00093715598 00093715610 00093715619 00093715656 ///
00093715693 00093715698 00247115230 00247115330 00247115360 00406206503 00406206505 ///
00406206510 00406206560 00406206590 00406206603 00406206605 00406206610 00406206660 ///
00406206690 00406206703 00406206705 00406206710 00406206760 00406206790 00406206803 ///
00406206805 00406206810 00406206860 00406206890 00406206903 00406206905 00406206910 ///
00406206960 00406206990 00440832230 00440832390 00440832490 00781507031 00781507092 ///
00781507131 00781507192 00781507231 00781507292 00781507331 00781507392 00781507431 ///
00781507492 00904580061 00904580161 00904580261 10135050905 10135050990 10135051005 ///
10135051030 10135051090 10135051105 10135051130 10135051190 10135051205 10135051230 ///
10135051290 16252050530 16252050550 16252050590 16252050630 16252050650 16252050690 ///
16252050730 16252050750 16252050790 16252050830 16252050850 16252050890 16252050930 ///
16252050950 16252050990 16714068101 16714068102 16714068201 16714068202 16714068203 ///
16714068301 16714068302 16714068303 16714068401 16714068402 16714068403 16714068501 ///
16714068502 16714068503 16729000410 16729000415 16729000417 16729000510 16729000515 ///
16729000517 16729000610 16729000615 16729000617 16729000710 16729000715 16729000717 ///
21695074030 23490935409 24658021010 24658021030 24658021045 24658021090 24658021110 ///
24658021130 24658021145 24658021190 24658021210 24658021230 24658021245 24658021290 ///
24658021310 24658021330 24658021345 24658021390 24658021410 24658021430 24658021445 ///
24658021490 24658030010 24658030090 24658030110 24658030130 24658030145 24658030190 ///
24658030210 24658030230 24658030245 24658030290 24658030310 24658030330 24658030345 ///
24658030390 24658030410 24658030430 24658030445 24658030490 43063000801 43063008030 ///
43353022845 45802009301 45802009365 45802009375 45802029265 45802029275 45802038401 ///
45802038465 45802038475 45802038493 45802087901 45802087965 45802087975 45802087993 ///
45802092465 49999030630 49999088930 49999088960 49999088990 49999090330 50742013710 ///
50742013810 50742013910 50742014010 51079039301 51079039320 51079039801 51079039820 ///
51079045401 51079045420 51079045501 51079045520 51079045601 51079045620 51079068601 ///
51079068620 52959011230 54458092804 54458093210 54458093310 54458093410 54569440400 ///
54569564000 54569583301 54569583302 54569583401 54868263901 54868310400 54868310401 ///
54868415700 54868415701 54868418100 54868418101 54868562700 54868562701 54868562800 ///
54868562801 54868562900 54868562901 54868562902 54868563000 54868563001 55111019705 ///
55111019730 55111019790 55111019805 55111019830 55111019890 55111019905 55111019910 ///
55111019930 55111019990 55111020005 55111020010 55111020030 55111020090 55111026805 ///
55111026830 55111026890 55111072610 55111072630 55111072690 55111073510 55111073530 ///
55111073590 55111074010 55111074030 55111074090 55111074910 55111074930 55111074990 ///
55111075010 55111075030 55111075090 55289029314 55289029330 55289029390 55289033814 ///
55289033890 55289039530 55289039590 55289087430 57866798201 57866798301 57866798601 ///
58016000600 58016000700 58016000730 58016000790 58016000830 58016036530 58016036560 ///
58016036590 58016038500 58016038560 58864068230 58864076030 63304078910 63304078930 ///
63304078990 63304079010 63304079030 63304079090 63304079110 63304079130 63304079190 ///
63304079210 63304079230 63304079290 63304079310 63304079330 63304079350 63304079390 ///
63739041910 63739042010 63739042110 63739042210 63739043510 63739043610 63739043704 ///
63739043710 63739043810 63739057210 63739057310 65243006515 65243006545 65243008215 ///
65243008245 65243012745 65243034845 65243034945 65243036709 65243036745 65862005030 ///
65862005090 65862005126 65862005130 65862005190 65862005199 65862005226 65862005230 ///
65862005290 65862005299 65862005322 65862005330 65862005390 65862005399 65862005430 ///
65862005439 65862005490 65862005499 66336098630 67544005145 67544008160 67544125445 ///
67544125545 67544125645 68084016101 68084016111 68084016201 68084016211 68084016301 ///
68084016311 68084016401 68084016411 68084016501 68084016511 68084051001 68084051101 ///
68084051111 68084051201 68084051211 68084051301 68084051311 68084051401 68084051411 ///
68115075930 68180047801 68180047802 68180047803 68180047901 68180047902 68180047903 ///
68180048001 68180048002 68180048003 68180048101 68180048102 68180048103 68180048206 ///
68180048209 68382006505 68382006506 68382006510 68382006514 68382006516 68382006605 ///
68382006606 68382006610 68382006614 68382006616 68382006624 68382006705 68382006706 ///
68382006710 68382006714 68382006716 68382006724 68382006805 68382006806 68382006810 ///
68382006814 68382006816 68382006840 68382006905 68382006906 68382006910 68382006914 ///
68382006916 68645026154 68645026254 68645026354) 

egen sim_c1 = anymatch(ndcn), values(12280018130 12280018190 12280038530 12280038590 12280038630 49999095730 49999095830 ///
54569564800 54569576800 54868518700 54868518900 54868518901 54868525000 54868525900 ///
54868525901 55289028030 55289052030 55289098021 66582031101 66582031128 66582031131 ///
66582031154 66582031182 66582031228 66582031231 66582031254 66582031282 66582031287 ///
66582031301 66582031331 66582031352 66582031354 66582031374 66582031386 66582031501 ///
66582031531 66582031552 66582031554 66582031566 66582031574)

egen sim_c2 = anymatch(ndcn), values(00074331290 00074331590 00074331690 00074345590 00074345790 00074345990 54868588600 ///
54868588601 54868590400 54868590401 54868616900)

egen sim_c3 = anymatch(ndcn), values(00006075331 00006075731 00006075754 00006075782 00006077331 00006077354 00006077382)

gen stat = 1 if ator==1 | ator_c1==1 | flu==1 | lo==1 | lo_c1==1 | pita==1 | pra==1 | pra_c1==1 | rosu==1 | sim==1 | sim_c1==1 | sim_c2==1 | sim_c3==1

keep if stat==1 

tempfile stat
save `stat', replace

////////////////////////////////////////////////////////////////////////////////
///////////////////////			stat pull			////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////		2006			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2006/pde2006.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `stat'
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
	gen stat_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & stat==1
}

drop doy_srvc
xfill stat_a*, i(idn)

/////////////////bene-class timing
egen stat_fdays_2006 = sum(dayssply), by(idn)
egen stat_clms_2006 = count(dayssply), by(idn)
egen stat_minfilldt_2006 = min(srvc_dt), by(idn)
egen stat_maxfilldt_2006 = max(srvc_dt), by(idn)
gen stat_fillperiod_2006 = stat_maxfilldt_2006 - stat_minfilldt_2006 + 1

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
	replace snf_push = snf_push + 1 if stat_a`d'==1 & snf_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the snf_push)
	//if that stat_a spot is empty:
	gen v1 = 1 if snf_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
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
	replace ips_push = ips_push + 1 if stat_a`d'==1 & ips_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the ips_push)
	//if that stat_a spot is not full:
	gen v1 = 1 if ips_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen stat_pdays_2006 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2006 possession days
*/
forvalues d = 1/365{
	replace stat_pdays_2006 = stat_pdays_2006 + 1 if stat_a`d'==1
}
drop stat_a*
replace stat_pdays_2006 = 365 if stat_pdays_2006>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen stat_push_2006 = rowmax(lastfill_push inyear_push) 
replace stat_push_2006 = 0 if stat_push_2006==.
replace stat_push_2006 = 0 if stat_push_2006<0

keep bene_id stat* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2006p.dta", replace

keep bene_id stat_push_2006
tempfile push
save `push', replace

////////////////		2007			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2007/pde2007.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `stat'
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
replace pushstock = pushstock + stat_push_2006 if bene_id!=bene_id[_n-1] | _n==1

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
	gen stat_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & stat==1
}

drop doy_srvc
xfill stat_a*, i(idn)

/////////////////bene-class timing
egen stat_fdays_2007 = sum(dayssply), by(idn)
egen stat_clms_2007 = count(dayssply), by(idn)
egen stat_minfilldt_2007 = min(srvc_dt), by(idn)
egen stat_maxfilldt_2007 = max(srvc_dt), by(idn)
gen stat_fillperiod_2007 = stat_maxfilldt_2007 - stat_minfilldt_2007 + 1

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
	replace snf_push = snf_push + 1 if stat_a`d'==1 & snf_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the snf_push)
	//if that stat_a spot is empty:
	gen v1 = 1 if snf_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
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
	replace ips_push = ips_push + 1 if stat_a`d'==1 & ips_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the ips_push)
	//if that stat_a spot is not full:
	gen v1 = 1 if ips_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen stat_pdays_2007 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2007 possession days
*/
forvalues d = 1/365{
	replace stat_pdays_2007 = stat_pdays_2007 + 1 if stat_a`d'==1
}
drop stat_a*
replace stat_pdays_2007 = 365 if stat_pdays_2007>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen stat_push_2007 = rowmax(lastfill_push inyear_push) 
replace stat_push_2007 = 0 if stat_push_2007==.
replace stat_push_2007 = 0 if stat_push_2007<0

keep bene_id stat* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2007p.dta", replace

keep bene_id stat_push_2007
tempfile push
save `push', replace

////////////////		2008			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2008/pde2008.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `stat'
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
replace pushstock = pushstock + stat_push_2007 if bene_id!=bene_id[_n-1] | _n==1

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
	gen stat_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & stat==1
}

drop doy_srvc
xfill stat_a*, i(idn)

/////////////////bene-class timing
egen stat_fdays_2008 = sum(dayssply), by(idn)
egen stat_clms_2008 = count(dayssply), by(idn)
egen stat_minfilldt_2008 = min(srvc_dt), by(idn)
egen stat_maxfilldt_2008 = max(srvc_dt), by(idn)
gen stat_fillperiod_2008 = stat_maxfilldt_2008 - stat_minfilldt_2008 + 1

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
	replace snf_push = snf_push + 1 if stat_a`d'==1 & snf_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the snf_push)
	//if that stat_a spot is empty:
	gen v1 = 1 if snf_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
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
	replace ips_push = ips_push + 1 if stat_a`d'==1 & ips_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the ips_push)
	//if that stat_a spot is not full:
	gen v1 = 1 if ips_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen stat_pdays_2008 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2008 possession days
*/
forvalues d = 1/365{
	replace stat_pdays_2008 = stat_pdays_2008 + 1 if stat_a`d'==1
}
drop stat_a*
replace stat_pdays_2008 = 365 if stat_pdays_2008>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen stat_push_2008 = rowmax(lastfill_push inyear_push) 
replace stat_push_2008 = 0 if stat_push_2008==.
replace stat_push_2008 = 0 if stat_push_2008<0

keep bene_id stat* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2008p.dta", replace

keep bene_id stat_push_2008
tempfile push
save `push', replace

////////////////		2009			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2009/pde2009.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `stat'
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
replace pushstock = pushstock + stat_push_2008 if bene_id!=bene_id[_n-1] | _n==1

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
	gen stat_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & stat==1
}

drop doy_srvc
xfill stat_a*, i(idn)

/////////////////bene-class timing
egen stat_fdays_2009 = sum(dayssply), by(idn)
egen stat_clms_2009 = count(dayssply), by(idn)
egen stat_minfilldt_2009 = min(srvc_dt), by(idn)
egen stat_maxfilldt_2009 = max(srvc_dt), by(idn)
gen stat_fillperiod_2009 = stat_maxfilldt_2009 - stat_minfilldt_2009 + 1

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
	replace snf_push = snf_push + 1 if stat_a`d'==1 & snf_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the snf_push)
	//if that stat_a spot is empty:
	gen v1 = 1 if snf_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
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
	replace ips_push = ips_push + 1 if stat_a`d'==1 & ips_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the ips_push)
	//if that stat_a spot is not full:
	gen v1 = 1 if ips_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen stat_pdays_2009 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2009 possession days
*/
forvalues d = 1/365{
	replace stat_pdays_2009 = stat_pdays_2009 + 1 if stat_a`d'==1
}
drop stat_a*
replace stat_pdays_2009 = 365 if stat_pdays_2009>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen stat_push_2009 = rowmax(lastfill_push inyear_push) 
replace stat_push_2009 = 0 if stat_push_2009==.
replace stat_push_2009 = 0 if stat_push_2009<0

keep bene_id stat* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2009p.dta", replace

keep bene_id stat_push_2009
tempfile push
save `push', replace

////////////////		2010			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2010/pde2010.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `stat'
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
replace pushstock = pushstock + stat_push_2009 if bene_id!=bene_id[_n-1] | _n==1

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
	gen stat_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & stat==1
}

drop doy_srvc
xfill stat_a*, i(idn)

/////////////////bene-class timing
egen stat_fdays_2010 = sum(dayssply), by(idn)
egen stat_clms_2010 = count(dayssply), by(idn)
egen stat_minfilldt_2010 = min(srvc_dt), by(idn)
egen stat_maxfilldt_2010 = max(srvc_dt), by(idn)
gen stat_fillperiod_2010 = stat_maxfilldt_2010 - stat_minfilldt_2010 + 1

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
	replace snf_push = snf_push + 1 if stat_a`d'==1 & snf_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the snf_push)
	//if that stat_a spot is empty:
	gen v1 = 1 if snf_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
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
	replace ips_push = ips_push + 1 if stat_a`d'==1 & ips_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the ips_push)
	//if that stat_a spot is not full:
	gen v1 = 1 if ips_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen stat_pdays_2010 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2010 possession days
*/
forvalues d = 1/365{
	replace stat_pdays_2010 = stat_pdays_2010 + 1 if stat_a`d'==1
}
drop stat_a*
replace stat_pdays_2010 = 365 if stat_pdays_2010>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen stat_push_2010 = rowmax(lastfill_push inyear_push) 
replace stat_push_2010 = 0 if stat_push_2010==.
replace stat_push_2010 = 0 if stat_push_2010<0

keep bene_id stat* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2010p.dta", replace

keep bene_id stat_push_2010
tempfile push
save `push', replace

////////////////		2011			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2011/pde2011.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `stat'
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
replace pushstock = pushstock + stat_push_2010 if bene_id!=bene_id[_n-1] | _n==1

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
	gen stat_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & stat==1
}

drop doy_srvc
xfill stat_a*, i(idn)

/////////////////bene-class timing
egen stat_fdays_2011 = sum(dayssply), by(idn)
egen stat_clms_2011 = count(dayssply), by(idn)
egen stat_minfilldt_2011 = min(srvc_dt), by(idn)
egen stat_maxfilldt_2011 = max(srvc_dt), by(idn)
gen stat_fillperiod_2011 = stat_maxfilldt_2011 - stat_minfilldt_2011 + 1

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
	replace snf_push = snf_push + 1 if stat_a`d'==1 & snf_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the snf_push)
	//if that stat_a spot is empty:
	gen v1 = 1 if snf_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
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
	replace ips_push = ips_push + 1 if stat_a`d'==1 & ips_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the ips_push)
	//if that stat_a spot is not full:
	gen v1 = 1 if ips_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen stat_pdays_2011 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2011 possession days
*/
forvalues d = 1/365{
	replace stat_pdays_2011 = stat_pdays_2011 + 1 if stat_a`d'==1
}
drop stat_a*
replace stat_pdays_2011 = 365 if stat_pdays_2011>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen stat_push_2011 = rowmax(lastfill_push inyear_push) 
replace stat_push_2011 = 0 if stat_push_2011==.
replace stat_push_2011 = 0 if stat_push_2011<0

keep bene_id stat* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2011p.dta", replace

keep bene_id stat_push_2011
tempfile push
save `push', replace

////////////////		2012			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2012/pde2012.dta", replace
keep bene_id srvc_dt prod_srvc_id days_suply_num
rename prod_srvc_id ndc
rename days_suply_num dayssply

merge m:1 ndc using `stat'
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
replace pushstock = pushstock + stat_push_2011 if bene_id!=bene_id[_n-1] | _n==1

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
	gen stat_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & stat==1
}

drop doy_srvc
xfill stat_a*, i(idn)

/////////////////bene-class timing
egen stat_fdays_2012 = sum(dayssply), by(idn)
egen stat_clms_2012 = count(dayssply), by(idn)
egen stat_minfilldt_2012 = min(srvc_dt), by(idn)
egen stat_maxfilldt_2012 = max(srvc_dt), by(idn)
gen stat_fillperiod_2012 = stat_maxfilldt_2012 - stat_minfilldt_2012 + 1

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
	replace snf_push = snf_push + 1 if stat_a`d'==1 & snf_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the snf_push)
	//if that stat_a spot is empty:
	gen v1 = 1 if snf_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
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
	replace ips_push = ips_push + 1 if stat_a`d'==1 & ips_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the ips_push)
	//if that stat_a spot is not full:
	gen v1 = 1 if ips_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen stat_pdays_2012 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2012 possession days
*/
forvalues d = 1/365{
	replace stat_pdays_2012 = stat_pdays_2012 + 1 if stat_a`d'==1
}
drop stat_a*
replace stat_pdays_2012 = 365 if stat_pdays_2012>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen stat_push_2012 = rowmax(lastfill_push inyear_push) 
replace stat_push_2012 = 0 if stat_push_2012==.
replace stat_push_2012 = 0 if stat_push_2012<0

keep bene_id stat* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2012p.dta", replace

keep bene_id stat_push_2012
tempfile push
save `push', replace

////////////////		2013			////////////////////////////////////////
use "/disk/agedisk2/medicpd/data/20pct/pde/2013/pde2013.dta", replace
keep bene_id srvc_dt prdsrvid dayssply
rename prdsrvid ndc

merge m:1 ndc using `stat'
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
replace pushstock = pushstock + stat_push_2012 if bene_id!=bene_id[_n-1] | _n==1

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
	gen stat_a`d' = 1 if `d'>=doy_srvc & `d'<=(doy_srvc+dayssply2) & stat==1
}

drop doy_srvc
xfill stat_a*, i(idn)

/////////////////bene-class timing
egen stat_fdays_2013 = sum(dayssply), by(idn)
egen stat_clms_2013 = count(dayssply), by(idn)
egen stat_minfilldt_2013 = min(srvc_dt), by(idn)
egen stat_maxfilldt_2013 = max(srvc_dt), by(idn)
gen stat_fillperiod_2013 = stat_maxfilldt_2013 - stat_minfilldt_2013 + 1

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
	replace snf_push = snf_push + 1 if stat_a`d'==1 & snf_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the snf_push)
	//if that stat_a spot is empty:
	gen v1 = 1 if snf_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
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
	replace ips_push = ips_push + 1 if stat_a`d'==1 & ips_a`d'==1

	//if the stat_a`d' is 1, do nothing (already added it to the ips_push)
	//if that stat_a spot is not full:
	gen v1 = 1 if ips_push>0 & stat_a`d'==.
	replace stat_a`d' = 1 if v1==1
	replace ips_push = ips_push-1 if v1==1
	drop v1
	replace ips_push = 10 if ips_push>10
}
drop ips_a*

////////////////  Final possession day calculations
gen stat_pdays_2013 = 0

/*The array is filled using dayssply2, which includes adjustments for early fills.
Then, the array is adjusted further for IPS and SNF days. 
So, the sum of the ones in the array is the total 2013 possession days
*/
forvalues d = 1/365{
	replace stat_pdays_2013 = stat_pdays_2013 + 1 if stat_a`d'==1
}
drop stat_a*
replace stat_pdays_2013 = 365 if stat_pdays_2013>365

//////////////// Calculate the number of extra push days that could go into next year. 
//inyear_push = extra push days from early fills throughout the year, IPS days, and SNF days. (each of which was capped at 10, but I will still cap whole thing at 30). 
//lastfill_push is the amount from the last fill that goes into next year (capped at 90). 
gen inyear_push = earlyfill_push + snf_push + ips_push
replace inyear_push = 30 if inyear_push>30 & inyear_push!=.
egen stat_push_2013 = rowmax(lastfill_push inyear_push) 
replace stat_push_2013 = 0 if stat_push_2013==.
replace stat_push_2013 = 0 if stat_push_2013<0

keep bene_id stat* 

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2013p.dta", replace

////////////////////////////////////////////////////////////////////////////////
/////////////// 	Merge stat 07-13	////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2007p.dta", replace
gen ystat2007 = 1
tempfile stat
save `stat', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2008p.dta", replace
gen ystat2008 = 1
merge 1:1 bene_id using `stat'
drop _m
save `stat', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2009p.dta", replace
gen ystat2009 = 1
merge 1:1 bene_id using `stat'
drop _m
save `stat', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2010p.dta", replace
gen ystat2010 = 1
merge 1:1 bene_id using `stat'
drop _m
save `stat', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2011p.dta", replace
gen ystat2011 = 1
merge 1:1 bene_id using `stat'
drop _m
save `stat', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2012p.dta", replace
gen ystat2012 = 1
merge 1:1 bene_id using `stat'
drop _m
save `stat', replace

use "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_2013p.dta", replace
gen ystat2013 = 1
merge 1:1 bene_id using `stat'
drop _m
save `stat', replace

//keep one obs person - not necessary after merge
//no need to xfill after merge

//timing variables
gen stat_firstyoo=.
gen stat_lastyoo=.
local years "2013 2012 2011 2010 2009 2008 2007"
foreach i in `years'{
	replace stat_firstyoo = `i' if ystat`i'==1
}
local years "2007 2008 2009 2010 2011 2012 2013"
foreach i in `years'{
	replace stat_lastyoo = `i' if ystat`i'==1
}
gen stat_yearcount = stat_lastyoo - stat_firstyoo + 1

//utilization variables 
forvalues i = 2007/2013{
	replace stat_fillperiod_`i' = 0 if stat_fillperiod_`i'==.
	replace stat_clms_`i' = 0 if stat_clms_`i'==.
	replace stat_fdays_`i' = 0 if stat_fdays_`i'==.
	replace stat_pdays_`i' = 0 if stat_pdays_`i'==.
}	
//minfilldt maxfilldt push

//total utilization
gen stat_clms = stat_clms_2007+stat_clms_2008+stat_clms_2009+stat_clms_2010+stat_clms_2011+stat_clms_2012+stat_clms_2013
gen stat_fdays = stat_fdays_2007+stat_fdays_2008+stat_fdays_2009+stat_fdays_2010+stat_fdays_2011+stat_fdays_2012+stat_fdays_2013
gen stat_pdays = stat_pdays_2007+stat_pdays_2008+stat_pdays_2009+stat_pdays_2010+stat_pdays_2011+stat_pdays_2012+stat_pdays_2013

//timing variables 
egen stat_minfilldt = rowmin(stat_minfilldt_2007 stat_minfilldt_2008 stat_minfilldt_2009 stat_minfilldt_2010 stat_minfilldt_2011 stat_minfilldt_2012 stat_minfilldt_2013)
egen stat_maxfilldt = rowmax(stat_maxfilldt_2007 stat_maxfilldt_2008 stat_maxfilldt_2009 stat_maxfilldt_2010 stat_maxfilldt_2011 stat_maxfilldt_2012 stat_maxfilldt_2013)

gen stat_fillperiod = stat_maxfilldt - stat_minfilldt + 1

gen stat_pdayspy = stat_pdays/stat_yearcount
gen stat_fdayspy = stat_fdays/stat_yearcount
gen stat_clmspy = stat_clms/stat_yearcount

sort bene_id
drop if bene_id==bene_id[_n-1]

compress
save "/disk/agedisk3/medicare.work/goldman-DUA25731/PROJECTS/AD-Statins/Data/poly/stat_0713p.dta", replace

