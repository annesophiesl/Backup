clear all
use "C:\Users\AnneSophie\Documents\Polit\BA\data\leader_done.dta"

drop oldage_ben survivors incapacity health family active_labour unemp housing other_social total health_exp pen_exp welf_exp unemp_exp social_exp transfer nonsoc_exp transfer_ave
drop pen_exp2 social_exp2 all_exp2 linc linc2
drop lag_pri lag_sec lag_teri lap_cap

merge 1:1 country year using "C:\Users\AnneSophie\Documents\Polit\BA\data\social_exp_dollar.dta"

drop if total==0
drop if year==2012
drop _merge

merge 1:1 year iso using "C:\Users\AnneSophie\Documents\Polit\BA\data\pen_gdp.dta"
drop if _merge!=3
drop _merge

merge 1:1 year country using "C:\Users\AnneSophie\Documents\Polit\BA\data\tax.dta"
drop if _merge!=3
drop _merge

gen pop = YOUNG+ workage + OLD
replace workage=workage*1000
replace pop= pop*1000
replace YOUNG=YOUNG*1000
replace SCHOOL_=SCHOOL_*1000
replace OLD=OLD*1000
replace YOUNG_ = YOUNG_*1000
gen workage_old = workage-YOUNG_

replace young_adult=YOUNG_ADULT/workage_old

/*
replace old=OLD/workage_old
replace young=YOUNG/workage_old
replace school_age=SCHOOL_AGE/workage_old
replace young_adult=YOUNG_ADULT/workage_old

*/

drop gdp_total gdp_capita gdp_capita_lag
rename rgdpe gdp_total
gen gdp_cap = gdp_total/workage
gen linc = ln(gdp_cap)

*gen lagged varialbes;
sort country year
gen cap_cap=q_gfcf/pop
by country: gen gdp_capita_lag = linc[_n - 10]
by country: gen lap_cap = cap_cap[_n-1]
by country: gen lag_pri = primary_wb[_n-10]
by country: gen lag_sec = secondary_wb[_n-10]
by country: gen lag_teri = teritary_wb[_n-10]

replace gdp_current=gdp_current/1000
replace tax_indi = tax_indi/gdp_current
replace tax_corp = tax_corp/gdp_current
replace tax_prop = tax_prop/gdp_current

gen men=workage/2
replace labour_force_m_work=labour_force_m_work*men
replace labour_force_m_work=labour_force_m_work/workage

* generate dependent

gen pensions = oldage + survivors + incapacity
replace active_=0 if active_==.
gen welfare = family + active + other_social
gen edu = edu_exp * gdp_total
gen all = all_exp * gdp_total

* all expenditures and education wrong!! (only in pct of gdp, gdp in current)
* gen new gdp_capita
* find gdp dollar, 2005 and total public spending 2005 dollar

gen pen_capita = pensions 
gen welf_capita = welfare 
gen health_capita = health
gen unemp_capita = unemp 
gen edu_capita = edu*100/ pop
gen all_capita = all*100 / pop
gen pen_old = pensions*pop/OLD


replace pen_capita = ln(pen_capita)
replace welf_capita = ln(welf_capita)
replace health_capita = ln(health)
replace unemp_capita = ln(unemp_capita)
replace edu_capita = ln(edu_capita)
replace all_capita = ln(all_capita)
replace pen_old = ln(pen_old)
replace open=open/pop
replace open =ln(open)

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




*save "C:\Users\AnneSophie\Documents\Polit\BA\data\data_percapita.dta", replace
*use "C:\Users\AnneSophie\Documents\Polit\BA\data\data_percapita.dta"



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
drop interval6
drop interval7
drop interval8
drop interval9


foreach x in pen_old gdp_capita_lag linc tax_indi tax_corp tax_prop open lap_cap lag_pri lag_sec lag_teri young young_adult school_age old corp welf_cap health_cap pen_cap unemp_cap edu_cap all_cap turn_over voter income_p90_p50 labour_force_m_work labour_force_f_work{
bysort interval4 country: egen av4_`x'=mean(`x')
bysort country: egen mean_`x'=mean(`x')
replace av4_`x'=mean_`x' if av4_`x'==.
}
bysort interval4 country: gen behold4=1 if _n==1

gen av4_soc_cap = av4_health + av4_welf + av4_pen_old + av4_unemp
gen av4_nonsoc_cap = av4_all_cap - av4_soc_cap

gen av4_linc2=av4_linc*av4_linc
gen av4_old2=av4_old*av4_old
gen av4_school_age2=av4_school_age*av4_school_age
gen av4_young_adult2=av4_young_adult*av4_young_adult
gen av4_young2=av4_young*av4_young
gen av4_labour_force_m_work2=av4_labour_force_m_work*av4_labour_force_m_work


tabulate country, generate (countryd)
encode country, generate(country_num)

gen av4_soc_cap2=av4_soc_cap*av4_soc_cap
gen av4_pen_cap2=av4_pen_cap*av4_pen_cap
gen av4_edu_cap2=av4_edu_cap*av4_edu_cap
gen av4_health_cap2=av4_health_cap*av4_health_cap
gen av4_welf_cap2=av4_welf_cap*av4_welf_cap
gen av4_nonsoc_cap2=av4_nonsoc_cap*av4_nonsoc_cap
gen av4_unemp_cap2=av4_unemp_cap*av4_unemp_cap

keep if behold4==1
tempfile total
save `total'
xtset country_num



foreach x in av4_all_cap av4_nonsoc_cap av4_soc_cap av4_pen_cap av4_welf_cap av4_unemp_cap av4_edu_cap av4_health_cap {
xtreg `x' av4_linc av4_linc2 av4_young_adult av4_young_adult2 av4_school_age av4_school_age2 av4_old av4_old2 av4_turn_over av4_voter av4_income_p90_p50 av4_labour_force_m_work av4_labour_force_m_work2 if behold4==1, robust re
outreg2 using "C:\Users\AnneSophie\Documents\Polit\BA\output\reg_spending_cap4.xls", append pvalue ctitle(`x') label sideway
}

xtreg av4_linc av4_gdp_capita_lag av4_lap_cap av4_open av4_young av4_young_adult av4_old av4_nonsoc_cap av4_edu_cap2 av4_edu_cap av4_nonsoc_cap2 av4_soc_cap av4_soc_cap2 if behold4==1, robust re
outreg2 using "C:\Users\AnneSophie\Documents\Polit\BA\output\reg_linc24.xls", replace pvalue ctitle(EQ. 1) label sideway


xtreg av4_linc av4_open av4_young av4_young_adult av4_old av4_health_cap av4_health_cap2 av4_pen_cap av4_pen_cap2 av4_welf_cap av4_welf_cap2 av4_unemp_cap av4_unemp_cap2 av4_nonsoc_cap av4_nonsoc_cap2 av4_edu_cap av4_edu_cap2 if behold4==1, robust re
outreg2 using "C:\Users\AnneSophie\Documents\Polit\BA\output\reg_linc24.xls", append pvalue ctitle(EQ. 2) label sideway

xtreg av4_linc av4_gdp_capita_lag av4_lap_cap av4_corp av4_open av4_young av4_young_adult av4_old av4_nonsoc_cap av4_edu_cap2 av4_edu_cap av4_nonsoc_cap2 av4_soc_cap av4_soc_cap2 if behold4==1, robust re
outreg2 using "C:\Users\AnneSophie\Documents\Polit\BA\output\reg_linc24.xls", append pvalue ctitle(EQ. 3) label sideway


xtreg av4_linc av4_corp av4_open av4_young av4_young_adult av4_old av4_health_cap av4_health_cap2 av4_pen_cap av4_pen_cap2 av4_welf_cap av4_welf_cap2 av4_unemp_cap av4_unemp_cap2 av4_nonsoc_cap av4_nonsoc_cap2 av4_edu_cap av4_edu_cap2 if behold4==1, robust re
outreg2 using "C:\Users\AnneSophie\Documents\Polit\BA\output\reg_linc24.xls", append pvalue ctitle(EQ. 4) label sideway

foreach x in av4_school_age av4_young_adult av4_old {
egen min_`x'=min(`x')
egen max_`x'=max(`x')
egen mean_`x'=mean(`x')
}

/*reg av3_soc_cap av3_linc av3_young_adult av3_school_age  av3_old av3_turn_over av3_voter av3_income_p90_p50 av3_labour_force_m_work if behold3==1, robust

foreach var in av3_linc av3_young_adult av3_school_age av3_old av3_turn_over av3_voter av3_income_p90_p50 av3_labour_force_m_work{
acprplot `var', lowess name(acpr_`var')
}

predict uhat, e
predict yhat, xb
gen uhat2=uhat*uhat
label variable uhat2 "Squared residuals"


graph twoway scatter uhat yhat, name(fig1, replace) 
graph twoway scatter uhat av3_linc, , name(fig2, replace) 
graph twoway scatter uhat2 yhat, name(fig3, replace) 
graph twoway scatter uhat2 av3_linc, , name(fig4, replace) */
/*

#delimit;
sem 
(av3_pen_cap <- av3_linc av3_linc2 av3_young_adult av3_young_adult2 av3_school_age av3_school_age2 av3_old av3_old2 av3_turn_over av3_voter av3_income_p90_p50 av3_labour_force_m_work av3_labour_force_m_work2)
(av3_edu_cap <- av3_linc av3_linc2 av3_young_adult av3_young_adult2 av3_school_age av3_school_age2 av3_old av3_old2 av3_turn_over av3_voter av3_income_p90_p50 av3_labour_force_m_work av3_labour_force_m_work2)
(av3_welf_cap <- av3_linc av3_linc2 av3_young_adult av3_young_adult2 av3_school_age av3_school_age2 av3_old av3_old2 av3_turn_over av3_voter av3_income_p90_p50 av3_labour_force_m_work av3_labour_force_m_work2)
(av3_nonsoc_cap <- av3_linc av3_linc2 av3_young_adult av3_young_adult2 av3_school_age av3_school_age2 av3_old av3_old2 av3_turn_over av3_voter av3_income_p90_p50 av3_labour_force_m_work av3_labour_force_m_work2)
(av3_unemp_cap <- av3_linc av3_linc2 av3_young_adult av3_young_adult2 av3_school_age av3_school_age2 av3_old av3_old2 av3_turn_over av3_voter av3_income_p90_p50 av3_labour_force_m_work av3_labour_force_m_work2)
(av3_health_cap <- av3_linc av3_linc2 av3_young_adult av3_young_adult2 av3_school_age av3_school_age2 av3_old av3_old2 av3_turn_over av3_voter av3_income_p90_p50 av3_labour_force_m_work av3_labour_force_m_work2)
(av3_linc <- av3_lap_cap av3_open av3_lag_pri av3_lag_sec av3_lag_teri av3_young av3_young_adult av3_old av3_corp av3_health_cap av3_pen_cap av3_welf_cap av3_unemp_cap av3_nonsoc_cap av3_edu_cap), nocapslatent;
*/
keep if behold4==1
#delimit;
sem
(av4_linc <- av4_lap_cap av4_lag_pri av4_lag_sec av4_lag_teri av4_gdp_capita_lag av4_open av4_lag_pri av4_lag_sec av4_lag_teri av4_young av4_young_adult av4_old av4_corp av4_soc_cap av4_soc_cap2 av4_nonsoc_cap av4_nonsoc_cap2 av4_edu_cap av4_edu_cap2)
(av4_soc_cap <- av4_linc av4_linc2 av4_young_adult av4_young_adult2 av4_school_age av4_school_age2 av4_old av4_old2 av4_turn_over av4_voter av4_income_p90_p50), nocapslatent;

