*Main results using Synthetic Control Method (SCM)

use data/stl_data_new.dta, clear

keep if min_births > 8000

*Appendix Figure A.15
xtset countycode year
foreach x in EPB {
set more off
#delimit ; 
	synth `x' `x'(2007) `x'(2006) `x'(2005) `x'(2004) `x'(2003) `x'(2002), 
	nested trunit(29189) trperiod(2008) fig mspeperiod(2002(1)2007) resultsperiod(2002(1)2013)
	keep("data\synth\EPB_8k_new.dta", replace);
#delimit cr
}

*Appendix Figure A.19
preserve
xtset countycode year
foreach x in IMR {
set more off
#delimit ; 
	synth `x' `x'(2007) `x'(2006) `x'(2005) `x'(2004) `x'(2003) `x'(2002), 
	nested trunit(29189) trperiod(2008) fig mspeperiod(2002(1)2007) resultsperiod(2002(1)2013)
	keep("data\synth\IMR_8k_new.dta", replace);
#delimit cr
}

*Next, re-run for each possible placebo
sort countycode year
egen county_num = group(countycode)
tab county_num if st_louis == 1
*51

save data\stl_data_new8k.dta, replace
use data\stl_data_new8k.dta, clear

xtset county_num year

forvalues cty = 1(1)95 {
foreach x in EPB {
set more off
#delimit ; 
	cap synth `x' `x'(2007) `x'(2006) `x'(2005) `x'(2004) `x'(2003) `x'(2002), 
	nested trunit(`cty') trperiod(2008) fig mspeperiod(2002(1)2007) resultsperiod(2002(1)2013)
	keep("data\synth\EPB_8k_new_`cty'.dta", replace);
#delimit cr
}
}

forvalues cty = 1(1)95 {
foreach x in IMR {
set more off
#delimit ; 
	cap synth `x' `x'(2007) `x'(2006) `x'(2005) `x'(2004) `x'(2003) `x'(2002), 
	nested trunit(`cty') trperiod(2008) fig mspeperiod(2002(1)2007) resultsperiod(2002(1)2013)
	keep("data\synth\IMR_8k_new_`cty'.dta", replace);
#delimit cr
}
}
	
*Histogram of DiD Estimates
*EPB
forvalues cty = 1(1)95{
use "data\synth\EPB_8k_new_`cty'.dta", clear
rename _C county_num
rename _W weight
keep county_num weight
merge 1:m county_num using data\stl_data_new8k.dta
replace weight = 1 if county_num == `cty'
gen post_treat = county_num == `cty' & year > 2007
eststo: areg EPB post_treat i.year [pweight = weight], absorb(countycode) vce(cluster countycode)
parmest, saving(data\synth\EPB_`cty', replace)
}

forvalues cty = 1(1)95{
use data\synth\EPB_`cty', clear
keep if parm == "post_treat"
gen county_num = `cty'
save data\synth\EPB_`cty'_est, replace
}

clear
forvalues cty = 1(1)95{
append using data\synth\EPB_`cty'_est
}

set scheme s1mono
*Appendix Figure A.16
hist estimate, bin(30) xline(-1.93) xticks(-3(1)3) xlabels(-3(1)3)

*IMR
*Histogram of DiD Estimates
*EPB
forvalues cty = 1(1)95{
use "data\synth\IMR_8k_new_`cty'.dta", clear
rename _C county_num
rename _W weight
keep county_num weight
merge 1:m county_num using data\stl_data_new8k.dta
replace weight = 1 if county_num == `cty'
gen post_treat = county_num == `cty' & year > 2007
eststo: areg IMR post_treat i.year [pweight = weight], absorb(countycode) vce(cluster countycode)
parmest, saving(data\synth\IMR_`cty', replace)
}

forvalues cty = 1(1)95{
use data\synth\IMR_`cty', clear
keep if parm == "post_treat"
gen county_num = `cty'
save data\synth\IMR_`cty'_est, replace
}

clear
forvalues cty = 1(1)95{
append using data\synth\IMR_`cty'_est
}

set scheme s1mono
*Appendix Figure A.20
hist estimate, bin(30) xline(-1.93) xticks(-3(1)3) xlabels(-3(1)3)

*graph comparing evolution of outcome vs synthetic control for St. Louis vs. donor pool counties
*EPB
forvalues cty = 1(1)95{
use data\synth\EPB_8k_new_`cty'.dta, clear
gen dif = _Y_t - _Y_s
rename _time year
drop if missing(year)
keep dif year
gen cty = `cty'
save data\synth\EPB_8k_new_`cty'_evo.dta, replace
}

clear
forvalues cty = 1(1)95{
append using data\synth\EPB_8k_new_`cty'_evo.dta
}

preserve
keep if year < 2008
gen err_sq = dif^2
gen post = year > 2007
bysort cty: egen mspe = mean(err_sq)
gen rmspe = sqrt(mspe)
sum rmspe if cty == 51
scalar stl_rmspe = r(mean)
display stl_rmspe
gen limit = stl_rmspe * 15
drop if rmspe > limit
keep if year == 2002 
keep cty
tempfile counties
save `counties'
restore

tab year
merge m:1 cty using `counties'
keep if _merge == 3
tab year

*Appendix Figure A.17
twoway (line dif year if cty == 1, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 2, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 3, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 4, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 5, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 6, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 7, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 8, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 9, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 10, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 11, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 12, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 13, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 14, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 15, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 16, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 17, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 18, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 19, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 20, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 21, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 22, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 23, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 24, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 25, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 26, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 27, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 28, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 29, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 30, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 31, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 32, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 33, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 34, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 35, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 36, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 37, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 38, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 39, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 40, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 41, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 42, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 43, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 44, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 45, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 46, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 47, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 48, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 49, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 50, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 51, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 52, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 53, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 54, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 55, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 56, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 57, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 58, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 59, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 60, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 61, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 62, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 63, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 64, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 65, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 66, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 67, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 68, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 69, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 70, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 71, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 72, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 73, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 74, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 75, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 76, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 77, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 78, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 79, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 80, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 81, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 82, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 83, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 84, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 85, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 86, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 87, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 88, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 89, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 90, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 91, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 92, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 93, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 94, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 95, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 51, lpattern(solid)lcolor(black)lwidth(vthick)) ///
	, xticks(2002(2)2013) xlabels(2002(2)2013) xtitle("") ytitle("Difference") ///
	legend(off) xline(2007,lpattern(dot)) yline(0,lpattern(dot))


*Now for infant mortality
forvalues cty = 1(1)95{
use data\synth\IMR_8k_new_`cty'.dta, clear
gen dif = _Y_t - _Y_s
rename _time year
drop if missing(year)
keep dif year
gen cty = `cty'
save data\synth\IMR_8k_new_`cty'_evo.dta
}

clear
forvalues cty = 1(1)95{
append using data\synth\IMR_8k_new_`cty'_evo.dta
}

preserve
keep if year < 2008
gen err_sq = dif^2
gen post = year > 2007
bysort cty: egen mspe = mean(err_sq)
gen rmspe = sqrt(mspe)
sum rmspe if cty == 51
scalar stl_rmspe = r(mean)
display stl_rmspe
gen limit = stl_rmspe * 50
drop if rmspe > limit
keep if year == 2002 
keep cty
tempfile counties
save `counties'
restore

merge m:1 cty using `counties'
tab year 
keep if _merge == 3
tab year 

*Appendix Figure A.21
twoway (line dif year if cty == 1, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 2, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 3, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 4, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 5, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 6, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 7, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 8, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 9, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 10, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 11, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 12, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 13, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 14, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 15, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 16, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 17, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 18, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 19, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 20, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 21, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 22, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 23, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 24, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 25, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 26, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 27, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 28, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 29, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 30, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 31, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 32, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 33, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 34, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 35, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 36, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 37, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 38, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 39, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 40, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 41, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 42, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 43, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 44, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 45, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 46, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 47, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 48, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 49, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 50, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 51, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 52, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 53, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 54, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 55, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 56, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 57, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 58, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 59, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 60, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 61, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 62, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 63, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 64, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 65, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 66, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 67, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 68, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 69, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 70, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 71, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 72, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 73, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 74, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 75, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 76, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 77, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 78, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 79, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 80, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 81, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 82, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 83, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 84, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 85, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 86, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 87, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 88, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 89, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 90, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 91, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 92, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 93, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 94, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 95, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 51, lpattern(solid)lcolor(black)lwidth(vthick)) ///
	, xticks(2002(2)2013) xlabels(2002(2)2013) xtitle("") ytitle("Difference") ///
	legend(off) xline(2007,lpattern(dot)) yline(0,lpattern(dot))
	
	
**************************
*Synth separately by race*	
**************************
		
*Black mothers
use data\stl_data_new_race.dta, clear

merge m:1 countycode using counties_8k.dta
keep if _merge == 3
drop if min_births < 1000

keep if mother_black == 1

*synth for St. Louis
xtset countycode year
foreach x in EPB {
set more off
#delimit ; 
	synth `x' `x'(2007) `x'(2006) `x'(2005) `x'(2004) `x'(2003) `x'(2002), 
	nested trunit(29189) trperiod(2008) fig mspeperiod(2002(1)2007) resultsperiod(2002(1)2013)
	keep("data\synth\EPB_8k_new_black.dta", replace);
#delimit cr
*save as data\synth\synth_epb_black.gph
}	

*infant mortality
xtset countycode year
foreach x in IMR {
set more off
#delimit ; 
	synth `x' `x'(2007) `x'(2006) `x'(2005) `x'(2004) `x'(2003) `x'(2002), 
	nested trunit(29189) trperiod(2008) fig mspeperiod(2002(1)2007) resultsperiod(2002(1)2013)
	keep("data\synth\IMR_8k_new_black.dta", replace);
#delimit cr
*save as data\synth\synth_imr_black.gph
}

*Next, re-run for each possible placebo
sort countycode year
egen county_num = group(countycode)
tab county_num if st_louis == 1
*36
drop _merge
save data\stl_data_new8k_black.dta, replace
use data\stl_data_new8k_black.dta, clear

xtset county_num year

forvalues cty = 1(1)68 {
foreach x in EPB {
set more off
#delimit ; 
	cap synth `x' `x'(2007) `x'(2006) `x'(2005) `x'(2004) `x'(2003) `x'(2002), 
	nested trunit(`cty') trperiod(2008) fig mspeperiod(2002(1)2007) resultsperiod(2002(1)2013)
	keep("data\synth\EPB_8k_new_`cty'_black.dta", replace);
#delimit cr
}
}

forvalues cty = 1(1)68 {
foreach x in IMR {
set more off
#delimit ; 
	cap synth `x' `x'(2007) `x'(2006) `x'(2005) `x'(2004) `x'(2003) `x'(2002), 
	nested trunit(`cty') trperiod(2008) fig mspeperiod(2002(1)2007) resultsperiod(2002(1)2013)
	keep("data\synth\IMR_8k_new_`cty'_black.dta", replace);
#delimit cr
}
}
	
*Histogram of DiD Estimates
*EPB
forvalues cty = 1(1)68{
use "data\synth\EPB_8k_new_`cty'_black.dta", clear
rename _C county_num
rename _W weight
keep county_num weight
merge 1:m county_num using data\stl_data_new8k.dta
replace weight = 1 if county_num == `cty'
gen post_treat = county_num == `cty' & year > 2007
eststo: areg EPB post_treat i.year [pweight = weight], absorb(countycode) vce(cluster countycode)
parmest, saving(data\synth\EPB_`cty'_black, replace)
}

forvalues cty = 1(1)68{
use data\synth\EPB_`cty'_black, clear
keep if parm == "post_treat"
gen county_num = `cty'
save data\synth\EPB_`cty'_est_black, replace
}

clear
forvalues cty = 1(1)68{
append using data\synth\EPB_`cty'_est_black
}

set scheme s1mono
hist estimate, bin(30) xline(-.25) xticks(-3(1)3) xlabels(-3(1)3)
*save as data\synth\placebo_epb_synth_black.gph

*IMR
*Histogram of DiD Estimates
forvalues cty = 1(1)68{
use "data\synth\IMR_8k_new_`cty'_black.dta", clear
rename _C county_num
rename _W weight
keep county_num weight
merge 1:m county_num using data\stl_data_new8k_black.dta
replace weight = 1 if county_num == `cty'
gen post_treat = county_num == `cty' & year > 2007
eststo: areg IMR post_treat i.year [pweight = weight], absorb(countycode) vce(cluster countycode)
parmest, saving(data\synth\IMR_`cty'_black, replace)
}

forvalues cty = 1(1)68{
use data\synth\IMR_`cty'_black, clear
keep if parm == "post_treat"
gen county_num = `cty'
save data\synth\IMR_`cty'_est_black, replace
}

clear
forvalues cty = 1(1)68{
append using data\synth\IMR_`cty'_est_black
}

set scheme s1mono
hist estimate, bin(30) xline(-.85) xticks(-3(1)3) xlabels(-3(1)3)
*save as data\synth\placebo_imr_synth_black.gph

*evolution graph
forvalues cty = 1(1)68{
use data\synth\EPB_8k_new_`cty'_black.dta, clear
gen dif = _Y_t - _Y_s
rename _time year
drop if missing(year)
keep dif year
gen cty = `cty'
save data\synth\EPB_8k_new_`cty'_evo_black.dta
}

clear
forvalues cty = 1(1)68{
append using data\synth\EPB_8k_new_`cty'_evo_black.dta
}

preserve
keep if year < 2008
gen err_sq = dif^2
gen post = year > 2007
bysort cty: egen mspe = mean(err_sq)
gen rmspe = sqrt(mspe)
sum rmspe if cty == 51
scalar stl_rmspe = r(mean)
display stl_rmspe
gen limit = stl_rmspe * 3
drop if rmspe > limit
keep if year == 2002 
keep cty
tempfile counties
save `counties'
restore

tab year
merge m:1 cty using `counties'
keep if _merge == 3
tab year

twoway (line dif year if cty == 1, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 2, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 3, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 4, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 5, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 6, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 7, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 8, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 9, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 10, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 11, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 12, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 13, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 14, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 15, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 16, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 17, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 18, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 19, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 20, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 21, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 22, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 23, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 24, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 25, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 26, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 27, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 28, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 29, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 30, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 31, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 32, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 33, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 34, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 35, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 36, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 37, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 38, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 39, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 40, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 41, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 42, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 43, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 44, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 45, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 46, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 47, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 48, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 49, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 50, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 51, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 52, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 53, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 54, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 55, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 56, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 57, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 58, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 59, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 60, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 61, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 62, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 63, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 64, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 65, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 66, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 67, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 68, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 51, lpattern(solid)lcolor(black)lwidth(vthick)) ///
	, xticks(2002(2)2013) xlabels(2002(2)2013) xtitle("") ytitle("Difference") ///
	legend(off) xline(2007,lpattern(dot)) yline(0,lpattern(dot))
*save as data\synth\epb_synth_evo_black.gph
	
*evolution graph (IMR Black)
forvalues cty = 1(1)68{
use data\synth\IMR_8k_new_`cty'_black.dta, clear
gen dif = _Y_t - _Y_s
rename _time year
drop if missing(year)
keep dif year
gen cty = `cty'
save data\synth\IMR_8k_new_`cty'_evo_black.dta
}

clear
forvalues cty = 1(1)68{
append using data\synth\IMR_8k_new_`cty'_evo_black.dta
}

preserve
keep if year < 2008
gen err_sq = dif^2
gen post = year > 2007
bysort cty: egen mspe = mean(err_sq)
gen rmspe = sqrt(mspe)
sum rmspe if cty == 51
scalar stl_rmspe = r(mean)
display stl_rmspe
gen limit = stl_rmspe * 1.5
drop if rmspe > limit
keep if year == 2002 
keep cty
tempfile counties
save `counties'
restore

tab year
merge m:1 cty using `counties'
keep if _merge == 3
tab year

twoway (line dif year if cty == 1, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 2, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 3, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 4, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 5, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 6, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 7, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 8, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 9, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 10, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 11, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 12, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 13, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 14, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 15, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 16, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 17, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 18, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 19, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 20, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 21, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 22, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 23, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 24, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 25, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 26, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 27, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 28, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 29, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 30, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 31, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 32, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 33, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 34, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 35, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 36, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 37, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 38, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 39, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 40, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 41, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 42, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 43, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 44, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 45, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 46, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 47, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 48, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 49, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 50, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 51, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 52, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 53, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 54, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 55, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 56, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 57, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 58, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 59, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 60, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 61, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 62, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 63, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 64, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 65, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 66, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 67, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 68, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 51, lpattern(solid)lcolor(black)lwidth(vthick)) ///
	, xticks(2002(2)2013) xlabels(2002(2)2013) xtitle("") ytitle("Difference") ///
	legend(off) xline(2007,lpattern(dot)) yline(0,lpattern(dot))
*save as data\synth\imr_synth_evo_black.gph

*now white mothers
use data\stl_data_new_race.dta, clear

merge m:1 countycode using data\counties_8k.dta
keep if _merge == 3

keep if mother_black == 0

*synth for St. Louis (EPB)
xtset countycode year
foreach x in EPB {
set more off
#delimit ; 
	synth `x' `x'(2007) `x'(2006) `x'(2005) `x'(2004) `x'(2003) `x'(2002), 
	nested trunit(29189) trperiod(2008) fig mspeperiod(2002(1)2007) resultsperiod(2002(1)2013)
	keep("data\synth\EPB_8k_new_white.dta", replace);
#delimit cr
*save as data\synth\synth_epb_white.gph
}	
	
*infant mortality
xtset countycode year
foreach x in IMR {
set more off
#delimit ; 
	synth `x' `x'(2007) `x'(2006) `x'(2005) `x'(2004) `x'(2003) `x'(2002), 
	nested trunit(29189) trperiod(2008) fig mspeperiod(2002(1)2007) resultsperiod(2002(1)2013)
	keep("data\synth\IMR_8k_new_white.dta", replace);
#delimit cr
*save as data\synth\synth_imr_white.gph
}

*Next, re-run for each possible placebo
sort countycode year
egen county_num = group(countycode)
tab county_num if st_louis == 1
*51
drop _merge
save data\stl_data_new8k_white.dta, replace
use data\stl_data_new8k_white.dta, clear

xtset county_num year

forvalues cty = 1(1)95 {
foreach x in EPB {
set more off
#delimit ; 
	cap synth `x' `x'(2007) `x'(2006) `x'(2005) `x'(2004) `x'(2003) `x'(2002), 
	nested trunit(`cty') trperiod(2008) fig mspeperiod(2002(1)2007) resultsperiod(2002(1)2013)
	keep("data\synth\EPB_8k_new_`cty'_white.dta", replace);
#delimit cr
}
}

forvalues cty = 1(1)95 {
foreach x in IMR {
set more off
#delimit ; 
	cap synth `x' `x'(2007) `x'(2006) `x'(2005) `x'(2004) `x'(2003) `x'(2002), 
	nested trunit(`cty') trperiod(2008) fig mspeperiod(2002(1)2007) resultsperiod(2002(1)2013)
	keep("data\synth\IMR_8k_new_`cty'_white.dta", replace);
#delimit cr
}
}
	
*Histogram of DiD Estimates
*EPB
forvalues cty = 1(1)95{
use "data\synth\EPB_8k_new_`cty'_white.dta", clear
rename _C county_num
rename _W weight
keep county_num weight
merge 1:m county_num using data\stl_data_new8k.dta
replace weight = 1 if county_num == `cty'
gen post_treat = county_num == `cty' & year > 2007
eststo: areg EPB post_treat i.year [pweight = weight], absorb(countycode) vce(cluster countycode)
parmest, saving(data\synth\EPB_`cty'_white, replace)
}

forvalues cty = 1(1)95{
use data\synth\EPB_`cty'_white, clear
keep if parm == "post_treat"
gen county_num = `cty'
save data\synth\EPB_`cty'_est_white, replace
}

clear
forvalues cty = 1(1)95{
append using data\synth\EPB_`cty'_est_white
}

set scheme s1mono
hist estimate, bin(30) xline(-1.82) xticks(-3(1)3) xlabels(-3(1)3)
*save as data\synth\epb_synth_evo_white.gph

*IMR
*Histogram of DiD Estimates
forvalues cty = 1(1)95{
use "data\synth\IMR_8k_new_`cty'_white.dta", clear
rename _C county_num
rename _W weight
keep county_num weight
merge 1:m county_num using data\stl_data_new8k_white.dta
replace weight = 1 if county_num == `cty'
gen post_treat = county_num == `cty' & year > 2007
eststo: areg IMR post_treat i.year [pweight = weight], absorb(countycode) vce(cluster countycode)
parmest, saving(data\synth\IMR_`cty'_white, replace)
}

forvalues cty = 1(1)95{
use data\synth\IMR_`cty'_white, clear
keep if parm == "post_treat"
gen county_num = `cty'
save data\synth\IMR_`cty'_est_white, replace
}

clear
forvalues cty = 1(1)95{
append using data\synth\IMR_`cty'_est_white
}

set scheme s1mono
hist estimate, bin(30) xline(-.93) xticks(-3(1)3) xlabels(-3(1)3)
*save as data\synth\placebo_imr_synth_white.gph
	
*evolution graph
forvalues cty = 1(1)95{
use data\synth\EPB_8k_new_`cty'_white.dta, clear
gen dif = _Y_t - _Y_s
rename _time year
drop if missing(year)
keep dif year
gen cty = `cty'
save data\synth\EPB_8k_new_`cty'_evo_white.dta
}

clear
forvalues cty = 1(1)95{
append using data\synth\EPB_8k_new_`cty'_evo_white.dta
}

preserve
keep if year < 2008
gen err_sq = dif^2
gen post = year > 2007
bysort cty: egen mspe = mean(err_sq)
gen rmspe = sqrt(mspe)
sum rmspe if cty == 51
scalar stl_rmspe = r(mean)
display stl_rmspe
gen limit = stl_rmspe * 80
drop if rmspe > limit
keep if year == 2002 
keep cty
tempfile counties
save `counties'
restore

tab year
merge m:1 cty using `counties'
keep if _merge == 3
tab year

twoway (line dif year if cty == 1, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 2, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 3, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 4, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 5, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 6, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 7, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 8, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 9, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 10, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 11, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 12, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 13, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 14, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 15, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 16, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 17, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 18, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 19, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 20, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 21, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 22, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 23, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 24, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 25, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 26, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 27, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 28, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 29, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 30, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 31, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 32, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 33, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 34, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 35, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 36, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 37, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 38, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 39, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 40, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 41, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 42, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 43, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 44, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 45, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 46, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 47, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 48, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 49, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 50, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 51, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 52, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 53, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 54, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 55, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 56, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 57, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 58, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 59, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 60, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 61, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 62, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 63, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 64, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 65, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 66, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 67, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 68, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 69, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 70, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 71, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 72, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 73, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 74, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 75, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 76, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 77, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 78, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 79, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 80, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 81, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 82, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 83, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 84, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 85, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 86, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 87, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 88, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 89, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 90, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 91, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 92, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 93, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 94, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 95, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 51, lpattern(solid)lcolor(black)lwidth(vthick)) ///
	, xticks(2002(2)2013) xlabels(2002(2)2013) xtitle("") ytitle("Difference") ///
	legend(off) xline(2007,lpattern(dot)) yline(0,lpattern(dot))
*save as data\synth\epb_synth_evo_white.gph
	
*evolution graph (infant mortality)
forvalues cty = 1(1)95{
use data\synth\IMR_8k_new_`cty'_white.dta, clear
gen dif = _Y_t - _Y_s
rename _time year
drop if missing(year)
keep dif year
gen cty = `cty'
save data\synth\IMR_8k_new_`cty'_evo_white.dta
}

clear
forvalues cty = 1(1)95{
append using data\synth\IMR_8k_new_`cty'_evo_white.dta
}

preserve
keep if year < 2008
gen err_sq = dif^2
gen post = year > 2007
bysort cty: egen mspe = mean(err_sq)
gen rmspe = sqrt(mspe)
sum rmspe if cty == 51
scalar stl_rmspe = r(mean)
display stl_rmspe
gen limit = stl_rmspe * 100
drop if rmspe > limit
keep if year == 2002 
keep cty
tempfile counties
save `counties'
restore

tab year
merge m:1 cty using `counties'
keep if _merge == 3
tab year

twoway (line dif year if cty == 1, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 2, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 3, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 4, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 5, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 6, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 7, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 8, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 9, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 10, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 11, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 12, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 13, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 14, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 15, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 16, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 17, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 18, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 19, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 20, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 21, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 22, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 23, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 24, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 25, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 26, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 27, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 28, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 29, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 30, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 31, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 32, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 33, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 34, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 35, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 36, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 37, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 38, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 39, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 40, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 41, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 42, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 43, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 44, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 45, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 46, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 47, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 48, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 49, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 50, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 51, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 52, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 53, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 54, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 55, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 56, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 57, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 58, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 59, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 60, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 61, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 62, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 63, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 64, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 65, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 66, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 67, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 68, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 69, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 70, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 71, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 72, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 73, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 74, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 75, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 76, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 77, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 78, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 79, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 80, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 81, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 82, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 83, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 84, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 85, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 86, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 87, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 88, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 89, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 90, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 91, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 92, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 93, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 94, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 95, lpattern(solid)lcolor(gs12)lwidth(vthin)) ///
	(line dif year if cty == 51, lpattern(solid)lcolor(black)lwidth(vthick)) ///
	, xticks(2002(2)2013) xlabels(2002(2)2013) xtitle("") ytitle("Difference") ///
	legend(off) xline(2007,lpattern(dot)) yline(0,lpattern(dot))
*save as data\synth\imr_synth_evo_white.gph
	
*Appendix Figure A.18	
graph combine data\synth\synth_epb_black.gph data\synth\synth_epb_white.gph data\synth\placebo_epb_synth_black.gph data\synth\placebo_epb_synth_white.gph data\synth\epb_synth_evo_black.gph data\synth\epb_synth_evo_white.gph, rows(3)

*Appendix Figure A.22	
graph combine data\synth\synth_imr_black.gph data\synth\synth_imr_white.gph data\synth\placebo_imr_synth_black.gph data\synth\placebo_imr_synth_white.gph data\synth\imr_synth_evo_black.gph data\synth\imr_synth_evo_white.gph, rows(3)
