/*use "C:\Users\AnneSophie\Documents\Polit\BA\data\data.dta", clear

replace labour_force=. if labour_force==0
replace gini=. if gini==0
replace income_p90_p10=. if income_p90_p10==0
replace income_p90_p50=. if income_p90_p50==0
replace poverty_rate=. if poverty_rate==0
replace employment=. if employment==0

*redefining
rename old OLD
gen old=OLD/workage
rename young YOUNG
gen young=YOUNG/workage
rename school_age SCHOOL_AGE
gen school_age=SCHOOL_AGE/workage
rename young_adult YOUNG_ADULT
gen young_adult=YOUNG_ADULT/workage
gen linc=ln(gdp_capita)

gen idacr="empty"
replace idacr="USA" if country=="United States"
replace idacr="CAN" if country=="Canada"
replace idacr="UKG" if country=="United Kingdom"
replace idacr="BEL" if country=="Belgium"
replace idacr="IRE" if country=="Ireland"
replace idacr="NTH" if country=="Netherlands"
replace idacr="LUX" if country=="Luxembourg"
replace idacr="BEL" if country=="Belgium"
replace idacr="FRN" if country=="France"
replace idacr="SWZ" if country=="Switzerland"
replace idacr="SPN" if country=="Spain"
replace idacr="POR" if country=="Portugal"
replace idacr="GFR" if country=="Germany"
replace idacr="POL" if country=="Poland"
replace idacr="AUS" if country=="Austria"
replace idacr="HUN" if country=="Hungary"
replace idacr="CZE" if country=="Czechoslovakia" 
replace idacr="CZR" if country=="Czech Republic"
replace idacr="SLO" if country=="Slovak Republic"
replace idacr="ITA" if country=="Italy"
replace idacr="SLV" if country=="Slovenia"
replace idacr="GRC" if country=="Greece"
replace idacr="BUL" if country=="Bulgaria"
replace idacr="EST" if country=="Estonia"
replace idacr="LAT" if country=="Latvia"
replace idacr="LIT" if country=="Lithuania"
replace idacr="FIN" if country=="Finland"
replace idacr="SWD" if country=="Sweden"
replace idacr="NOR" if country=="Norway"
replace idacr="DEN" if country=="Denmark"
replace idacr="ICE" if country=="Iceland"
replace idacr="ISR" if country=="Israel"
replace idacr="JPN" if country=="Japan"
replace idacr="ROK" if country=="Korea"
replace idacr="AUL" if country=="Australia"
replace idacr="NEW" if country=="New Zealand"
replace idacr="CHL" if country=="Chile"
replace idacr="MEX" if country=="Mexico"
replace idacr="TUR" if country=="Turkey"

rename time year
merge 1:1 country year using "C:\Users\AnneSophie\Documents\Polit\BA\data\expenditures.dta"


*generate dependent variables
gen health_exp = health/gdp_current*100
gen pen_exp = (oldage_ben + survivors + incapacity)/gdp_current*100
gen welf_exp = (family + active_labour  + other_social)/gdp_current*100
gen unemp_exp = unemp/gdp_current*100
gen social_exp = health_exp + pen_exp + welf_exp + unemp_exp
gen transfer = unemp_exp + pen_exp + health_exp + welf_exp
gen nonsoc_exp = all_exp - social_exp

*average growth and transfer for decades
gen decade=0
replace decade=1 if inrange(year, 1980, 1989)
replace decade=2 if inrange(year, 1990, 1999)
replace decade=3 if inrange(year, 2000, 2010)
bysort decade country: egen growth_ave=mean(gdp_growth)
bysort country decade: egen transfer_ave=mean(transfer)
bysort country decade: gen behold_decade=1 if _n==1
*export excel transfer_ave growth_ave country decade if behold_decade==1 using "C:\Users\AnneSophie\Documents\Polit\BA\output\growth_raw.xls", firstrow(variables) replace

*DUMMY, former eastern countries
gen eastern=0
replace eastern=1 if country=="Poland"
replace eastern=1 if country=="Czech Republic"
replace eastern=1 if country=="Slovenia"
replace eastern=1 if country=="Slovak Republic"
replace eastern=1 if country=="Estonia"

*SQAURED
gen linc2 = linc*linc
gen school2 = school*school
gen old2 = old*old
gen young_adult2 = young_adult*young_adult
gen labour_force2 = labour_force*labour_force

drop _merge
merge 1:1 idacr year using "C:\Users\AnneSophie\Documents\Polit\BA\data\leader_done.dta"
drop if _merge==2
drop _merge
drop antal_turn*
drop interval*
*insheet using "http://privatewww.essex.ac.uk/~ksg/data/31Aug15_Archigos_4.0.txt"
*gen splitat=strpos(startdate, "-")
*generate str1 elec_year=""
*replace elec_year=substr(startdate, 1, splitat -1)
*destring elec_year, replace

gen corptism=0
replace corptism=4 if country=="Norway" | country=="Sweden" | country=="Austria" | country=="Netherlands"
replace corptism=3 if country=="Denmark" | country=="Germany"
replace corptism=2.5 if country=="Finland"
replace corptism=2 if country=="Belgium" | country=="Switzerland"
replace corptism=1.5 if country=="Japan"
replace corptism=0.5 if country=="Italy" | country=="New Zealand"

merge 1:1 country year using "C:\Users\AnneSophie\Documents\Polit\BA\data\pen8.dta"
drop if _merge==2
drop _merge

rename idacr countrycode
merge 1:1 countrycode year using "C:\Users\AnneSophie\Documents\Polit\BA\data\pen_na.dta"
drop if _merge==2
drop _merge

merge 1:1 country year using "C:\Users\AnneSophie\Documents\Polit\BA\data\income.dta"
drop _merge

gen pri_sec_share= secondary_share + elementary_share
replace pri_sec_share=. if pri_sec_share==0
replace teritary_share =.  if teritary_share==0
gen open = q_x + q_m
gen lap_cap = q_gfcf[n-10]


*DATASÆT DONE!!!

save "C:\Users\AnneSophie\Documents\Polit\BA\data\data_done.dta"*/


use "C:\Users\AnneSophie\Documents\Polit\BA\data\data_done.dta"

*regress income
regress linc gdp_capita_lag open lag_cap pri_sec_share teritary_share young young_adult old corp health_exp pen_exp welf_exp unemp_exp social_exp nonsoc_exp


*ALM OLS
regress health_exp eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2
regress social_exp eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2
regress pen_exp eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2
regress all_exp eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2
regress welf_exp eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2
regress nonsoc_exp eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2




*2SLS
regress social_exp linc linc2 eastern young_adult young_adult2 old old2 school_age school2 labour_force labour_force2 income_p90_p10 income_p90_p50 voter
predict social_exphat
regress linc social_exphat eastern young_adult young_adult2 old old2 school_age school2 labour_force income_p90_p10 income_p90_p50 voter



sem (linc <- gdp_capita_lag open lap_cap pri_sec_share teritary_share young young_adult old corp health_exp pen_exp welf_exp unemp_exp nonsoc_exp) ///
 (health_exp <- eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2) ///
 (unemp_exp <- eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2)  ///
 (pen_exp <- eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2) ///
 (nonsoc_exp <- eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2) ///
 (all_exp <- eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2)
