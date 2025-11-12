*This script is using the weights from SDID to create event-study graphs

*only using SDID to get the weights, so reps set to 2
global reps 2

*load cleaned data from "01_raw_data_clean.do"
use "data\stl_02_13.dta", clear 

xtset countycode year 

gen treat = st_louis == 1 & year > 2007
keep if min_births > 8000

*run SDID to get weights
sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)

matrix weights = e(omega)
svmat double weights, names(weight)
save data\county_weights.dta, replace

preserve
keep weight1 weight2
drop if missing(weight2)
rename weight1 county_weight 
rename weight2 countycode
save data\county_weights, replace
restore

matrix lambda = e(lambda)
svmat double lambda, names(time_wt)
save data\time_weights.dta, replace

preserve
keep time_wt1 time_wt2
drop if missing(time_wt2)
rename time_wt1 time_weight 
rename time_wt2 year
save data\time_weights, replace
restore

merge m:1 countycode using data\county_weights.dta
drop _merge
merge m:1 year using data\time_weights.dta
drop _merge

gen sdid_weight = county_weight * time_weight
replace sdid_weight = 1 if missing(sdid_weight)

forvalues year = 2002(1)2013{
	gen treat_`year' = year == `year' & st_louis == 1
}

*run event-study specification using SDID weights
reghdfe EPB treat_2002-treat_2006 treat_2008-treat_2013 [pweight=sdid_weight], absorb(year countycode) vce(cluster countycode)
parmest, saving(data\EPB_sdid_event_new, replace)

set scheme s1mono

*convert coefficient estimates to event-study graph
preserve
use "data\EPB_sdid_event_new", clear
replace parm = "2007" if parm == "_cons"
replace parm = subinstr(parm, "treat_","",.)
destring parm, replace
sort parm
replace min95 = 0 if parm == 2007
replace max95 = 0 if parm == 2007
replace estimate = 0 if parm == 2007
twoway (line estimate parm, lwidth(thick)) (line min95 parm, lpattern(dash) lcolor(gs10)) (line max95 parm, lpattern(dash) lcolor(gs10)), xline(0, lcolor(black)) yline(0, lcolor(black)) legend(off) xtitle("") ytitle("EPBs per 1,000 Live Births") xticks(2002(2)2013) xlabels(2002(2)2013) xline(2007, lpattern(dash))
restore

*run SDID specification in order to get weights
sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)

drop weight1 weight2
matrix weights = e(omega)
svmat double weights, names(weight)
save data\county_weights.dta, replace

preserve
keep weight1 weight2
drop if missing(weight2)
rename weight1 county_weight 
rename weight2 countycode
save data\county_weights, replace
restore

drop weight1 weight2
matrix lambda = e(lambda)
svmat double lambda, names(time_wt)
save data\time_weights.dta, replace

preserve
keep time_wt1 time_wt2
drop if missing(time_wt2)
rename time_wt1 time_weight 
rename time_wt2 year
save data\time_weights, replace
restore

merge m:1 countycode using data\county_weights.dta
drop _merge
merge m:1 year using data\time_weights.dta
drop _merge

gen sdid_weight = county_weight * time_weight
replace sdid_weight = 1 if missing(sdid_weight)

*run event-study graph
reghdfe IMR treat_2002-treat_2006 treat_2008-treat_2013 [pweight=sdid_weight], absorb(year countycode) vce(cluster countycode)
parmest, saving(IMR_sdid_event_new, replace)

set scheme s1mono

*event-study graphs
preserve
use "IMR_sdid_event_new", clear
replace parm = "2007" if parm == "_cons"
replace parm = subinstr(parm, "treat_","",.)
destring parm, replace
sort parm
replace min95 = 0 if parm == 2007
replace max95 = 0 if parm == 2007
replace estimate = 0 if parm == 2007
twoway (line estimate parm, lwidth(thick)) (line min95 parm, lpattern(dash) lcolor(gs10)) (line max95 parm, lpattern(dash) lcolor(gs10)), xline(0, lcolor(black)) yline(0, lcolor(black)) legend(off) xtitle("") ytitle("Infant Mortality Rate") xticks(2002(2)2013) xlabels(2002(2)2013) xline(2007, lpattern(dash))
restore

***************************
*Repeat Separately By Race*
***************************

use data\stl_data_new_race.dta, clear

*First black mothers
gen treat = st_louis == 1 & year > 2007

keep if mother_black == 1
xtset countycode year 
keep if min_births > 1000
merge m:1 countycode using data\counties_8k.dta
keep if _merge == 3
sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)

cap drop weight1 weight2
matrix weights = e(omega)
svmat double weights, names(weight)
save data\county_weights.dta, replace

preserve
keep weight1 weight2
drop if missing(weight2)
rename weight1 county_weight 
rename weight2 countycode
save data\county_weights, replace
restore

drop weight1 weight2
matrix lambda = e(lambda)
svmat double lambda, names(time_wt)
save data\time_weights.dta, replace

preserve
keep time_wt1 time_wt2
drop if missing(time_wt2)
rename time_wt1 time_weight 
rename time_wt2 year
save data\time_weights, replace
restore

drop _merge
merge m:1 countycode using data\county_weights.dta
drop _merge
merge m:1 year using data\time_weights.dta
drop _merge

gen sdid_weight = county_weight * time_weight
replace sdid_weight = 1 if missing(sdid_weight)

forvalues year = 2002(1)2013{
	gen treat_`year' = year == `year' & st_louis == 1
}

reghdfe EPB treat_2002-treat_2006 treat_2008-treat_2013 [pweight=sdid_weight], absorb(year countycode) vce(cluster countycode)
parmest, saving(data\EPB_sdid_event_black_new, replace)

set scheme s1mono

*event-study graphs
preserve
use "data\EPB_sdid_event_black_new", clear
replace parm = "2007" if parm == "_cons"
replace parm = subinstr(parm, "treat_","",.)
destring parm, replace
sort parm
replace min95 = 0 if parm == 2007
replace max95 = 0 if parm == 2007
replace estimate = 0 if parm == 2007
twoway (line estimate parm, lwidth(thick)) (line min95 parm, lpattern(dash) lcolor(gs10)) (line max95 parm, lpattern(dash) lcolor(gs10)), xline(0, lcolor(black)) yline(0, lcolor(black)) legend(off) xtitle("") ytitle("EPB Rate") xticks(2002(2)2013) xlabels(2002(2)2013) xline(2007, lpattern(dash))
restore

sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)

cap drop time_wt*
cap drop *weight*
cap drop weight1 weight2 
cap drop county_weight time_weight
matrix weights = e(omega)
svmat double weights, names(weight)
save data\county_weights.dta, replace

preserve
keep weight1 weight2
drop if missing(weight2)
rename weight1 county_weight 
rename weight2 countycode
save data\county_weights, replace
restore

drop weight1 weight2
matrix lambda = e(lambda)
svmat double lambda, names(time_wt)
save data\time_weights.dta, replace

preserve
keep time_wt1 time_wt2
drop if missing(time_wt2)
rename time_wt1 time_weight 
rename time_wt2 year
save data\time_weights, replace
restore

merge m:1 countycode using data\county_weights.dta
drop _merge
merge m:1 year using data\time_weights.dta
drop _merge

gen sdid_weight = county_weight * time_weight
replace sdid_weight = 1 if missing(sdid_weight)

reghdfe IMR treat_2002-treat_2006 treat_2008-treat_2013 [pweight=sdid_weight], absorb(year countycode) vce(cluster countycode)
parmest, saving(data\IMR_sdid_event_new_black, replace)

set scheme s1mono

*event-study graphs
preserve
use "data\IMR_sdid_event_new_black", clear
replace parm = "2007" if parm == "_cons"
replace parm = subinstr(parm, "treat_","",.)
destring parm, replace
sort parm
replace min95 = 0 if parm == 2007
replace max95 = 0 if parm == 2007
replace estimate = 0 if parm == 2007
twoway (line estimate parm, lwidth(thick)) (line min95 parm, lpattern(dash) lcolor(gs10)) (line max95 parm, lpattern(dash) lcolor(gs10)), xline(0, lcolor(black)) yline(0, lcolor(black)) legend(off) xtitle("") ytitle("Infant Mortality Rate") xticks(2002(2)2013) xlabels(2002(2)2013) xline(2007, lpattern(dash))
restore

use data\stl_data_new_race.dta, clear

*Next White mothers
gen treat = st_louis == 1 & year > 2007

keep if mother_black == 0
xtset countycode year 
merge m:1 countycode using counties_8k.dta
keep if _merge == 3
sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)

cap drop weight1 weight2
matrix weights = e(omega)
svmat double weights, names(weight)
save data\county_weights.dta, replace

preserve
keep weight1 weight2
drop if missing(weight2)
rename weight1 county_weight 
rename weight2 countycode
save data\county_weights, replace
restore

drop weight1 weight2
matrix lambda = e(lambda)
svmat double lambda, names(time_wt)
save data\time_weights.dta, replace

preserve
keep time_wt1 time_wt2
drop if missing(time_wt2)
rename time_wt1 time_weight 
rename time_wt2 year
save data\time_weights, replace
restore

drop _merge
merge m:1 countycode using data\county_weights.dta
drop _merge
merge m:1 year using data\time_weights.dta
drop _merge

gen sdid_weight = county_weight * time_weight
replace sdid_weight = 1 if missing(sdid_weight)

forvalues year = 2002(1)2013{
	gen treat_`year' = year == `year' & st_louis == 1
}

reghdfe EPB treat_2002-treat_2006 treat_2008-treat_2013 [pweight=sdid_weight], absorb(year countycode) vce(cluster countycode)
parmest, saving(data\EPB_sdid_event_white_new, replace)

set scheme s1mono

*event-study graphs
preserve
use "data\EPB_sdid_event_white_new", clear
replace parm = "2007" if parm == "_cons"
replace parm = subinstr(parm, "treat_","",.)
destring parm, replace
sort parm
replace min95 = 0 if parm == 2007
replace max95 = 0 if parm == 2007
replace estimate = 0 if parm == 2007
twoway (line estimate parm, lwidth(thick)) (line min95 parm, lpattern(dash) lcolor(gs10)) (line max95 parm, lpattern(dash) lcolor(gs10)), xline(0, lcolor(black)) yline(0, lcolor(black)) legend(off) xtitle("") ytitle("EPB Rate") xticks(2002(2)2013) xlabels(2002(2)2013) xline(2007, lpattern(dash))
restore

sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)

cap drop time_wt*
cap drop *weight*
cap drop weight1 weight2 
cap drop county_weight time_weight
matrix weights = e(omega)
svmat double weights, names(weight)
save data\county_weights.dta, replace

preserve
keep weight1 weight2
drop if missing(weight2)
rename weight1 county_weight 
rename weight2 countycode
save data\county_weights, replace
restore

drop weight1 weight2
matrix lambda = e(lambda)
svmat double lambda, names(time_wt)
save data\time_weights.dta, replace

preserve
keep time_wt1 time_wt2
drop if missing(time_wt2)
rename time_wt1 time_weight 
rename time_wt2 year
save data\time_weights, replace
restore

merge m:1 countycode using data\county_weights.dta
drop _merge
merge m:1 year using data\time_weights.dta
drop _merge

gen sdid_weight = county_weight * time_weight
replace sdid_weight = 1 if missing(sdid_weight)

reghdfe IMR treat_2002-treat_2006 treat_2008-treat_2013 [pweight=sdid_weight], absorb(year countycode) vce(cluster countycode)
parmest, saving(data\IMR_sdid_event_new_white, replace)

set scheme s1mono

*event-study graphs
preserve
use "data\IMR_sdid_event_new_white", clear
replace parm = "2007" if parm == "_cons"
replace parm = subinstr(parm, "treat_","",.)
destring parm, replace
sort parm
replace min95 = 0 if parm == 2007
replace max95 = 0 if parm == 2007
replace estimate = 0 if parm == 2007
twoway (line estimate parm, lwidth(thick)) (line min95 parm, lpattern(dash) lcolor(gs10)) (line max95 parm, lpattern(dash) lcolor(gs10)), xline(0, lcolor(black)) yline(0, lcolor(black)) legend(off) xtitle("") ytitle("Infant Mortality Rate") xticks(2002(2)2013) xlabels(2002(2)2013) xline(2007, lpattern(dash))
restore

cd "plots"
*Combine event-studies (FIGURE 4 in paper)
graph combine epb_all.gph epb_black.gph epb_white.gph imr_all.gph imr_black.gph imr_white.gph, rows(2)