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
gen health_exp = health/gdp_current
gen pen_exp = (oldage_ben + survivors + incapacity)/gdp_current
gen welf_exp = (family + active_labour  + other_social)/gdp_current
gen unemp_exp = unemp/gdp_current
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

merge 1:1 country year using "C:\Users\AnneSophie\Documents\Polit\BA\data\income_udv.dta"
drop _merge

gen pri_sec_share= secondary_share + elementary_share
replace pri_sec_share=. if pri_sec_share==0
replace teritary_share =.  if teritary_share==0
gen open = q_x + q_m
gen lap_cap = q_gfcf[n-10]


gen iso="empty"
replace iso="USA" if country=="United States"
replace iso="CAN" if country=="Canada"
replace iso="GBR" if country=="United Kingdom"
replace iso="BEL" if country=="Belgium"
replace iso="IRL" if country=="Ireland"
replace iso="NLD" if country=="Netherlands"
replace iso="LUX" if country=="Luxembourg"
replace iso="FRA" if country=="France"
replace iso="CHE" if country=="Switzerland"
replace iso="ESP" if country=="Spain"
replace iso="PRT" if country=="Portugal"
replace iso="DEU" if country=="Germany"
replace iso="POL" if country=="Poland"
replace iso="AUT" if country=="Austria"
replace iso="HUN" if country=="Hungary"
*replace iso="CZE" if country=="Czechoslovakia" 
replace iso="CZE" if country=="Czech Republic"
replace iso="SVK" if country=="Slovak Republic"
replace iso="ITA" if country=="Italy"
replace iso="SVN" if country=="Slovenia"
replace iso="GRC" if country=="Greece"
replace iso="BGR" if country=="Bulgaria"
replace iso="EST" if country=="Estonia"
replace iso="LVA" if country=="Latvia"
replace iso="LTU" if country=="Lithuania"
replace iso="FIN" if country=="Finland"
replace iso="SWE" if country=="Sweden"
replace iso="NOR" if country=="Norway"
replace iso="DNK" if country=="Denmark"
replace iso="ISL" if country=="Iceland"
replace iso="ISR" if country=="Israel"
replace iso="JPN" if country=="Japan"
replace iso="KOR" if country=="Korea"
replace iso="AUS" if country=="Australia"
replace iso="NZL" if country=="New Zealand"
replace iso="CHL" if country=="Chile"
replace iso="MEX" if country=="Mexico"
replace iso="TUR" if country=="Turkey"

*gen lag_pri = primary_wb[n-10]
*gen lag_sec = secondary_wb[n-10]
*gen lag_teri = teritary_wb[n-10]

*DATASÆT DONE!!!

save "C:\Users\AnneSophie\Documents\Polit\BA\data\data_done.dta"*/


use "C:\Users\AnneSophie\Documents\Polit\BA\data\leader_done.dta"

*removing outliers


sum linc, detail
gen touse1 = inrange(linc, `r(p1)', `r(p99)')
sum linc if touse1


sum young_adult, detail
gen touse4 = inrange(young_adult, `r(p1)', `r(p99)')
sum young_adult if touse4


sum old, detail
gen touse2 = inrange(old, `r(p1)', `r(p99)')
sum old if touse2


sum labour_force_m_work, detail
gen touse3 = inrange(labour_force_m_work, `r(p1)', `r(p99)')
sum labour_force_m_work if touse3

forvalues y = 3/10{
gen interval`y'=0
replace interval`y' = 1 if year>1980+`y'
replace interval`y' = 2 if year>1980+`y'+`y'
replace interval`y' = 3 if year>1980+`y'+`y'+`y'
replace interval`y' = 4 if year>1980+`y'+`y'+`y'+`y'
replace interval`y' = 5 if year>1980+`y'+`y'+`y'+`y'+`y'
replace interval`y' = 6 if year>1980+`y'+`y'+`y'+`y'+`y'+`y'
replace interval`y' = 7 if year>1980+`y'+`y'+`y'+`y'+`y'+`y'+`y'
replace interval`y' = 8 if year>1980+`y'+`y'+`y'+`y'+`y'+`y'+`y'+`y'
replace interval`y' = 9 if year>1980+`y'+`y'+`y'+`y'+`y'+`y'+`y'+`y'+`y'
replace interval`y' = 10 if year>1980+`y'+`y'+`y'+`y'+`y'+`y'+`y'+`y'+`y'+`y'
replace interval`y' = 11 if year>1980+`y'+`y'+`y'+`y'+`y'+`y'+`y'+`y'+`y'+`y'+`y'
}
drop interval4
drop interval6
drop interval7
drop interval8
drop interval9

foreach x in linc gdp_capita_lag open lap_cap lag_pri lag_sec lag_teri young young_adult school_age old corp welf_exp health_exp pen_exp unemp_exp edu_exp all_exp_pct turn_over voter income_p90_p50 labour_force_m_work labour_force_f_work{
bysort interval3 country: egen av3_`x'=mean(`x')
}
bysort interval3 country: gen behold3=1 if _n==1

foreach x in linc gdp_capita_lag open lap_cap lag_pri lag_sec lag_teri young young_adult school_age old corp welf_exp health_exp pen_exp unemp_exp edu_exp all_exp_pct turn_over voter income_p90_p50 labour_force_m_work labour_force_f_work{
bysort interval5 country: egen av5_`x'=mean(`x')
}
bysort interval5 country: gen behold5=1 if _n==1

foreach x in linc gdp_capita_lag open lap_cap lag_pri lag_sec lag_teri young young_adult school_age old corp welf_exp health_exp pen_exp unemp_exp edu_exp all_exp_pct turn_over voter income_p90_p50 labour_force_m_work labour_force_f_work{
bysort interval10 country: egen av10_`x'=mean(`x')
}
bysort interval10 country: gen behold10=1 if _n==1

gen av3_soc_exp = av3_health + av3_edu + av3_welf + av3_pen + av3_unemp
gen av3_nonsoc_exp = av3_all_exp - av3_soc_exp

gen av5_soc_exp = av5_health + av5_edu + av5_welf + av5_pen + av5_unemp
gen av5_nonsoc_exp = av5_all_exp - av5_soc_exp

gen av10_soc_exp = av10_health + av10_edu + av10_welf + av10_pen + av10_unemp
gen av10_nonsoc_exp = av10_all_exp - av10_soc_exp

gen av3_linc2=av3_linc*av3_linc
gen av5_linc2=av5_linc*av5_linc
gen av10_linc2=av10_linc*av10_linc

gen av3_old2=av3_old*av3_old
gen av5_old2=av5_old*av5_old
gen av10_old2=av10_old*av10_old

gen av3_school_age2=av3_school_age*av3_school_age
gen av5_school_age2=av5_school_age*av5_school_age
gen av10_school_age2=av10_school_age*av10_school_age

gen av3_young_adult2=av3_young_adult*av3_young_adult
gen av5_young_adult2=av5_young_adult*av5_young_adult
gen av10_young_adult2=av10_young_adult*av10_young_adult

gen av3_young2=av3_young*av3_young
gen av5_young2=av5_young*av5_young
gen av10_young2=av10_young*av10_young

gen av3_labour_force_m_work2=av3_labour_force_m_work*av3_labour_force_m_work
gen av5_labour_force_m_work2=av5_labour_force_m_work*av5_labour_force_m_work
gen av10_labour_force_m_work2=av10_labour_force_m_work*av10_labour_force_m_work

tabulate country, generate (countryd)
encode country, generate(country_num)


*panel data
xtset country_num
xtreg av3_pen_exp av3_linc av3_linc2 av3_young_adult av3_young_adult2 av3_school_age av3_school_age2 av3_old av3_old2 av3_turn_over av3_voter av3_income_p90_p50 av3_labour_force_m_work av3_labour_force_m_work2 if behold3==1, robust
predict uhat2, e
predict yhat, xb
gen uhat2=uhat*uhat
label variable uhat2 "Squared residuals"*/

*uden indkomst
/*keep country country_num year behold3 av3_pen_exp av3_linc av3_linc2 av3_young_adult av3_young_adult2 av3_school_age av3_school_age2 av3_old av3_old2 av3_turn_over av3_voter av3_labour_force_m_work av3_labour_force_m_work2

xtreg av3_pen_exp av3_linc av3_linc2 av3_young_adult av3_young_adult2 av3_school_age av3_school_age2 av3_old av3_old2 av3_turn_over av3_voter av3_labour_force_m_work av3_labour_force_m_work2 if behold3==1, robust
predict uhat4, e


graph twoway scatter uhat yhat, name(fig1, replace) 
graph twoway scatter uhat av3_linc, , name(fig2, replace) 
graph twoway scatter uhat2 yhat, name(fig3, replace) 
graph twoway scatter uhat2 av3_linc, , name(fig4, replace) 

graph twoway scatter uhat av3_labour_force_m_work, , name(fig5, replace) 
graph twoway scatter uhat2 av3_labour_force_m_work, , name(fig6, replace) */
keep country country_num year behold5 av5_soc_exp av5_linc av5_linc2 av5_young_adult av5_young_adult2 av5_school_age av5_school_age2 av5_old av5_old2 av5_turn_over av5_voter av5_income_p90_p50 av5_labour_force_m_work av5_labour_force_m_work2
keep if behold5==1


xtset country_num

xtreg av5_soc_exp av5_linc av5_linc2 av5_young_adult av5_young_adult2 av5_school_age av5_school_age2 av5_old av5_old2 av5_turn_over av5_voter av5_income_p90_p50 av5_labour_force_m_work av5_labour_force_m_work2

predict uhat, e
predict yhat, xb
gen uhat2=uhat*uhat

keep if behold5==1

xtreg av5_soc_exp av5_linc av5_linc2 av5_young_adult av5_young_adult2 av5_school_age av5_school_age2 av5_old av5_old2 av5_turn_over av5_voter av5_labour_force_m_work av5_labour_force_m_work2

predict uhat_be, e
predict yhat_be, xb
gen uhat2_be=uhat*uhat

/*xtreg av10_soc_exp av10_linc av10_linc2 av10_young_adult av10_young_adult2 av10_school_age av10_school_age2 av10_old av10_old2 av10_turn_over av10_voter av10_income_p90_p50 av10_labour_force_m_work av10_labour_force_m_work2 if behold10==1



regress av3_soc_exp av3_linc av3_linc2 av3_young_adult av3_young_adult2 av3_school_age av3_school_age2 av3_old av3_old2 av3_turn_over av3_voter av3_income_p90_p50 av3_labour_force_m_work av3_labour_force_m_work2 countryd* if behold3==1
regress av5_soc_exp av5_linc av5_linc2 av5_young_adult av5_young_adult2 av5_school_age av5_school_age2 av5_old av5_old2 av5_turn_over av5_voter av5_income_p90_p50 av5_labour_force_m_work av5_labour_force_m_work2 countryd* if behold5==1
regress av10_soc_exp av10_linc av10_linc2 av10_young_adult av10_young_adult2 av10_school_age av10_school_age2 av10_old av10_old2 av10_turn_over av10_voter av10_income_p90_p50 av10_labour_force_m_work av10_labour_force_m_work2 countryd* if behold10==1



*regress income

xtreg av3_linc av3_gdp_capita_lag av3_open av3_lap_cap av3_lag_pri av3_lag_sec av3_lag_teri av3_young av3_young2 av3_young_adult av3_young_adult2 av3_old av3_old2 av3_corp av3_welf av3_edu av3_health_exp av3_pen_exp av3_unemp_exp av3_nonsoc_exp
regress av3_linc av3_gdp_capita_lag av3_open av3_lap_cap av3_lag_pri av3_lag_sec av3_lag_teri av3_young av3_young2 av3_young_adult av3_young_adult2 av3_old av3_old2 av3_corp av3_welf av3_edu av3_health_exp av3_pen_exp av3_unemp_exp av3_nonsoc_exp countryd*

regress linc gdp_capita_lag open lap_cap lag_pri lag_sec lag_teri young young_adult old corp social_exp nonsoc_exp





sem (linc <- gdp_capita_lag open lag_pri lag_sec lag_teri young young_adult old corp health_exp pen_exp welf_exp unemp_exp nonsoc_exp) ///
 (health_exp <- eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2) ///
 (unemp_exp <- eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2)  ///
 (pen_exp <- eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2) ///
 (nonsoc_exp <- eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2) ///
 (all_exp <- eastern turn_over linc linc2 young_adult young_adult2 old old2 school_age school2 income_p90_p10 income_p90_p50 voter labour_force labour_force2),method (ml) nocapslatent
