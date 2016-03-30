use "C:\Users\AnneSophie\Documents\Polit\BA\data\leader_done.dta"

drop oldage_ben survivors incapacity health family active_labour unemp housing other_social total health_exp pen_exp welf_exp unemp_exp social_exp transfer nonsoc_exp transfer_ave
drop pen_exp2 social_exp2 all_exp2 linc linc2

merge 1:1 country year using "C:\Users\AnneSophie\Documents\Polit\BA\data\social_exp_dollar.dta"

drop if total==0
drop if turn_over>10
drop _merge

merge 1:1 year iso using "C:\Users\AnneSophie\Documents\Polit\BA\data\pen_gdp.dta"
drop if _merge!=3
drop _merge

merge 1:1 year country using "C:\Users\AnneSophie\Documents\Polit\BA\data\tax.dta"
drop if _merge!=3
drop _merge

gen pop = YOUNG+ workage + OLD
replace pop= pop*1000
replace YOUNG=YOUNG*1000
replace SCHOOL_=SCHOOL_*1000
replace OLD=OLD*1000
replace YOUNG_ = YOUNG_*1000


drop gdp_total gdp_capita gdp_capita_lag
rename rgdpe gdp_total
gen gdp_cap = gdp_total/pop
gen linc = log(gdp_cap)
*gen gdp_capita_lag = linc[n - 10]

replace gdp_current=gdp_current/1000
replace tax_indi = tax_indi/gdp_current
replace tax_corp = tax_corp/gdp_current

* generate dependent

gen pensions = oldage + survivors + incapacity
replace active_=0 if active_==.
gen welfare = family + active + other_social
gen edu = edu_exp * gdp_total
gen all = all_exp * gdp_total

* all expenditures and education wrong!! (only in pct of gdp, gdp in current)
* gen new gdp_capita
* find gdp dollar, 2005 and total public spending 2005 dollar

gen pen_capita = pensions / OLD
gen welf_capita = welfare / pop
gen health_capita = health / pop
gen unemp_capita = unemp / pop
gen edu_capita = edu*100/SCHOOL_AGE
gen all_capita = all*100 / pop

sum pen_capita, detail
gen touse = inrange(pen_capita, `r(p1)', `r(p99)')
sum pen_capita if touse

sum welf_capita, detail
gen touse2 = inrange(welf_cap, `r(p1)', `r(p99)')
sum welf_capita if touse2


sum health_capita, detail
gen touse3 = inrange(health_cap, `r(p1)', `r(p99)')
sum health_capita if touse3


sum unemp_capita, detail
gen touse4 = inrange(unemp_cap, `r(p1)', `r(p99)')
sum unemp_capita if touse4


sum edu_cap, detail
gen touse5 = inrange(edu_cap, `r(p1)', `r(p99)')
sum edu_capita if touse5


sum all_capita, detail
gen touse6 = inrange(all_cap, `r(p1)', `r(p99)')
sum all_capita if touse6



save "C:\Users\AnneSophie\Documents\Polit\BA\data\data_percapita.dta", replace
use "C:\Users\AnneSophie\Documents\Polit\BA\data\data_percapita.dta"



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

*gdp_capita_lag
foreach x in linc tax_indi tax_corp tax_prop open lap_cap lag_pri lag_sec lag_teri young young_adult school_age old corp welf_cap health_cap pen_cap unemp_cap edu_cap all_cap turn_over voter income_p90_p50 labour_force_m_work labour_force_f_work{
bysort interval5 country: egen av5_`x'=mean(`x')
bysort country: egen mean_`x'=mean(`x')
replace av5_`x'=mean_`x' if av5_`x'==.
}
bysort interval5 country: gen behold5=1 if _n==1

gen av5_soc_cap = av5_health + av5_edu + av5_welf + av5_pen + av5_unemp
gen av5_nonsoc_cap = av5_all_cap - av5_soc_cap

gen av5_linc2=av5_linc*av5_linc
gen av5_old2=av5_old*av5_old
gen av5_school_age2=av5_school_age*av5_school_age
gen av5_young_adult2=av5_young_adult*av5_young_adult
gen av5_young2=av5_young*av5_young
gen av5_labour_force_m_work2=av5_labour_force_m_work*av5_labour_force_m_work


tabulate country, generate (countryd)
encode country, generate(country_num)


xtset country_num
xtreg av5_health_cap av5_linc av5_tax_indi av5_tax_corp av5_tax_prop av5_linc2 av5_young_adult av5_young_adult2 av5_school_age av5_school_age2 av5_old av5_old2 av5_turn_over av5_voter av5_income_p90_p50 av5_labour_force_m_work av5_labour_force_m_work2 if behold5==1, robust re

/*
reg av3_soc_cap av3_linc av3_young_adult av3_school_age  av3_old av3_turn_over av3_voter av3_income_p90_p50 av3_labour_force_m_work if behold3==1, robust

foreach var in av3_linc av3_young_adult av3_school_age av3_old av3_turn_over av3_voter av3_income_p90_p50 av3_labour_force_m_work{
acprplot `var', lowess name(acpr_`var')
}*/

/*predict uhat, e
predict yhat, xb
gen uhat2=uhat*uhat
label variable uhat2 "Squared residuals"


graph twoway scatter uhat yhat, name(fig1, replace) 
graph twoway scatter uhat av5_linc, , name(fig2, replace) 
graph twoway scatter uhat2 yhat, name(fig3, replace) 
graph twoway scatter uhat2 av5_linc, , name(fig4, replace) */

sem (av5_soc_cap <- av5_linc av5_linc2 av5_young_adult av5_young_adult2 av5_school_age av5_school_age2 av5_old av5_old2 av5_turn_over av5_voter av5_income_p90_p50 av5_labour_force_m_work av5_labour_force_m_work2)(av5_linc <- av5_open av5_lag_pri av5_lag_sec av5_lag_teri av5_young av5_young_adult av5_old av5_corp av5_health_cap av5_pen_cap av5_welf_cap av5_unemp_cap av5_edu_cap av5_nonsoc_cap), nocapslatent
av5_tax_indi av5_tax_corp av5_tax_prop
