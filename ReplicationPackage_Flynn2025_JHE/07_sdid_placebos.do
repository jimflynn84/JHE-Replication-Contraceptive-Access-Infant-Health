*SDID placebo estimates
*don't care about inference, just estimates
global reps 2

use data\stl_data_new.dta, clear

xtset countycode year 

merge m:1 countycode using data\counties_8k.dta
keep if _merge == 3

egen county_num = group(countycode)

forvalues cty = 1(1)95{
cap drop treat
gen treat = county_num == `cty' & year > 2007
sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\epb_8k_`cty')
sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\imr_8k_`cty')
}

forvalues cty = 1(1)95{
append using data\sdid_placebo\epb_8k_`cty'
cap gen county = `cty'
replace county = `cty' if missing(county)
}

histogram estimate, xline(-2.178) bins(30)
*save as plots\imr_8k.gph
*p-value = 2/95 = .0188

clear
forvalues cty = 1(1)95{
append using data\sdid_placebo\imr_8k_`cty'
cap gen county = `cty'
replace county = `cty' if missing(county)
}

histogram estimate, xline(-1.738) bins(30)
*save as plots\imr_8k.gph
*p-value = 2/95 = .0188

*Repeat with 10K cutoff
use data\stl_data_new.dta, clear

xtset countycode year 

merge m:1 countycode using data\counties_10k.dta
keep if _merge == 3

egen county_num = group(countycode)
tab county_num if countycode == 29189
*St. Louis is #34 for 10k threshold

forvalues cty = 1(1)65{
cap drop treat
gen treat = county_num == `cty' & year > 2007
sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\epb_10k_`cty')
sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\imr_10k_`cty')
}

clear
forvalues cty = 1(1)65{
append using data\sdid_placebo\epb_10k_`cty'
cap gen county = `cty'
replace county = `cty' if missing(county)
}

histogram estimate, xline(-2.622) bins(30)
*save as plots\epb_10k.gph
*p-value = 1/65 = .0153

clear
forvalues cty = 1(1)65{
append using data\sdid_placebo\imr_10k_`cty'
cap gen county = `cty'
replace county = `cty' if missing(county)
}

histogram estimate, xline(-2.077) bins(30)
*save as plots\imr_10k.gph
*p-value = 1/65 = .0153

*Repeat with 6K cutoff
use data\stl_data_new.dta, clear

xtset countycode year 

merge m:1 countycode using data\counties_6k.dta
keep if _merge == 3

egen county_num = group(countycode)
tab county_num if countycode == 29189
*St. Louis is #65 for 6k threshold

forvalues cty = 1(1)123{
cap drop treat
gen treat = county_num == `cty' & year > 2007
sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\epb_6k_`cty')
sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\imr_6k_`cty')
}

clear
forvalues cty = 1(1)123{
append using data\sdid_placebo\epb_6k_`cty'
cap gen county = `cty'
replace county = `cty' if missing(county)
}

histogram estimate, xline(-2.05) bins(30)
*save as plots\epb_6k.gph
*p-value = 4/123 = .0325

clear
forvalues cty = 1(1)123{
append using data\sdid_placebo\imr_6k_`cty'
cap gen county = `cty'
replace county = `cty' if missing(county)
}

histogram estimate, xline(-1.58) bins(30)
*save as plots\imr_6k.gph
*p-value = 3/123 = .0244

***************************
*Repeat separately by race*
***************************
use data\stl_data_new_race.dta, clear

keep if mother_black == 0 
xtset countycode year 

merge m:1 countycode using data\counties_8k.dta
gen eightk = _merge == 3
drop _merge
merge m:1 countycode using data\counties_10k.dta
gen tenk = _merge == 3
drop _merge
merge m:1 countycode using data\counties_6k.dta
gen sixk = _merge == 3

*run with 6k threshold
preserve
keep if sixk == 1
egen county_num = group(countycode)
tab county_num if countycode == 29189
sum county_num 
local max = r(max)
display `max'
forvalues cty = 1(1)`max'{
cap drop treat
cap gen treat = county_num == `cty' & year > 2007
tab treat
sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\epb_6k_`cty'_white)
sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\imr_6k_`cty'_white)
}
restore

*eightk threshold
preserve
keep if eightk == 1
egen county_num = group(countycode)
tab county_num if countycode == 29189
sum county_num 
local max = r(max)
display `max'
forvalues cty = 1(1)`max'{
cap drop treat
cap gen treat = county_num == `cty' & year > 2007
tab treat
sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\epb_8k_`cty'_white)
sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\imr_8k_`cty'_white)
}
restore

*10k treshold
preserve
keep if tenk == 1
egen county_num = group(countycode)
tab county_num if countycode == 29189
sum county_num 
local max = r(max)
display `max'
forvalues cty = 1(1)`max'{
cap drop treat
cap gen treat = county_num == `cty' & year > 2007
tab treat
sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\epb_10k_`cty'_white)
sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\imr_10k_`cty'_white)
}
restore

clear
forvalues cty = 1(1)123{
	append using data\sdid_placebo\epb_6k_`cty'_white
	cap gen county = `cty'
	replace county = `cty' if missing(county)
}

histogram estimate, xline(-2.01) bins(30)
*save as plots\epb_6k_white.gph
*p-value = 2/123 = .0163

clear
forvalues cty = 1(1)123{
	append using data\sdid_placebo\imr_6k_`cty'_white
	cap gen county = `cty'
	replace county = `cty' if missing(county)
}

histogram estimate, xline(-1.30) bins(30)
*save as plots\imr_6k_white.gph
*p-value = 6/123 = .0408

clear
forvalues cty = 1(1)95{
	append using data\sdid_placebo\epb_8k_`cty'_white
	cap gen county = `cty'
	replace county = `cty' if missing(county)
}

histogram estimate, xline(-2.02) bins(30)
*save as plots\epb_8k_white.gph
*p-value = 2/95 = .0211

clear
forvalues cty = 1(1)95{
	append using data\sdid_placebo\imr_8k_`cty'_white
	cap gen county = `cty'
	replace county = `cty' if missing(county)
}

histogram estimate, xline(-1.22) bins(30)
*save as plots\imr_8k_white.gph
*p-value = 8/95 = .0842


clear
forvalues cty = 1(1)65{
	append using data\sdid_placebo\epb_10k_`cty'_white
	cap gen county = `cty'
	replace county = `cty' if missing(county)
}

histogram estimate, xline(-2.12) bins(30)
*save as plots\epb_10k_white.gph
*p-value = 2/65 = .0308


clear
forvalues cty = 1(1)65{
	append using data\sdid_placebo\imr_10k_`cty'_white
	cap gen county = `cty'
	replace county = `cty' if missing(county)
}

histogram estimate, xline(-1.28) bins(30)
*save as plots\imr_10k_white.gph
*p-value = 3/65 = .0462


*repeat process for black mothers
use data\stl_data_new_race.dta, clear

keep if mother_black == 1
drop if min_births < 1000

merge m:1 countycode using data\counties_8k.dta
gen eightk = _merge == 3
drop _merge
merge m:1 countycode using data\counties_10k.dta
gen tenk = _merge == 3
drop _merge
merge m:1 countycode using data\counties_6k.dta
gen sixk = _merge == 3

bysort countycode: gen cty_count = _N
drop if cty_count == 1

*6k threshold
preserve
keep if sixk == 1
egen county_num = group(countycode)
tab county_num if countycode == 29189
sum county_num 
xtset county_num year 
forvalues cty = 1(1)81{
cap drop treat
cap gen treat = county_num == `cty' & year > 2007
tab treat
sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\epb_6k_`cty'_black)
sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\imr_6k_`cty'_black)
}
restore

*8k threshold
preserve
keep if eightk == 1
egen county_num = group(countycode)
tab county_num if countycode == 29189
sum county_num 
xtset county_num year 
forvalues cty = 1(1)68{
cap drop treat
cap gen treat = county_num == `cty' & year > 2007
tab treat
sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\epb_8k_`cty'_black)
sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\imr_8k_`cty'_black)
}
restore

*10k threshold
preserve
keep if tenk == 1
egen county_num = group(countycode)
tab county_num if countycode == 29189
sum county_num 
xtset county_num year 
forvalues cty = 1(1)51{
cap drop treat
cap gen treat = county_num == `cty' & year > 2007
tab treat
sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\epb_10k_`cty'_black)
sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)
parmest, saving (data\sdid_placebo\imr_10k_`cty'_black)
}
restore

*St. Louis is #40 for 6k threshold
clear
forvalues cty = 1(1)81{
	append using data\sdid_placebo\epb_6k_`cty'_black
	cap gen county = `cty'
	replace county = `cty' if missing(county)
}

histogram estimate, xline(-2.12) bins(30)
*save as plots\epb_6k_black.gph
*p-value = 17/81 = .2099

clear
forvalues cty = 1(1)81{
	append using data\sdid_placebo\imr_6k_`cty'_black
	cap gen county = `cty'
	replace county = `cty' if missing(county)
}

histogram estimate, xline(-2.84) bins(30)
*save as plots\imr_6k_black.gph
*p-value = 5/81 = .0617

*St. Louis is #36 for 8k
clear
forvalues cty = 1(1)68{
	append using data\sdid_placebo\epb_8k_`cty'_black
	cap gen county = `cty'
	replace county = `cty' if missing(county)
}

histogram estimate, xline(-1.95) bins(30)
*save as plots\epb_8k_black.gph
*p-value = 17/68 = .2500

clear
forvalues cty = 1(1)68{
	append using data\sdid_placebo\imr_8k_`cty'_black
	cap gen county = `cty'
	replace county = `cty' if missing(county)
}

histogram estimate, xline(-2.88) bins(30)
*save as plots\imr_8k_black.gph
*p-value = 2/68 = .0294


*St. Louis is #25 for 10k threshold
clear
forvalues cty = 1(1)51{
	append using data\sdid_placebo\epb_10k_`cty'_black
	cap gen county = `cty'
	replace county = `cty' if missing(county)
}

histogram estimate, xline(-2.18) bins(30)
*save as plots\epb_10k_black.gph
*p-value = 9/51 = .1765

clear
forvalues cty = 1(1)51{
	append using data\sdid_placebo\imr_10k_`cty'_black
	cap gen county = `cty'
	replace county = `cty' if missing(county)
}

histogram estimate, xline(-3.00) bins(30)
*save as plots\imr_10k_black.gph
*p-value = 2/51 = .0392

*Appendix Figure A.12
graph combine plots\epb_10k.gph plots\epb_8k.gph plots\epb_6k.gph plots\imr_10k.gph plots\imr_8k.gph plots\imr_6k.gph, rows(2)

*Appendix Figure A.13
graph combine plots\epb_6k_black.gph plots\epb_8k_black.gph plots\epb_10k_black.gph plots\epb_6k_white.gph plots\epb_8k_white.gph plots\epb_10k_white.gph, rows(2)

*Appendix Figure A.14
graph combine plots\imr_6k_black.gph plots\imr_8k_black.gph plots\imr_10k_black.gph plots\imr_6k_white.gph plots\imr_8k_white.gph plots\imr_10k_white.gph, rows(2)
