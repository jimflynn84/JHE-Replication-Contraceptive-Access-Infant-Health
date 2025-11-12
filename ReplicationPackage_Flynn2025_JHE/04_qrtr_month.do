*Reestimate main specifications using quarterly and monthly data instead of annual data

global reps 500
global seed 123

*load cleaned data from "01_raw_data_clean.do"
use "data\stl_02_13.dta", clear 

gen qrtr = .
replace qrtr = 1 if month == 1 | month == 2 | month == 3
replace qrtr = 2 if month == 4 | month == 5 | month == 6
replace qrtr = 3 if month == 7 | month == 8 | month == 9
replace qrtr = 4 if month == 10 | month == 11 | month == 12

gen n = 1

*drop CO and IA
drop if countycode > 8000 & countycode < 9000
drop if countycode > 19000 & countycode < 20000

*save separately by race
preserve
keep if mother_black == 1 |  mother_white == 1
collapse infant_mortality ext_preterm (sum) n, by(countycode year qrtr mother_black)
*drop counties with missing months
bysort countycode: gen count = _N
tab count
drop if count < 96
save data/stl_qrtrly_race_data.dta, replace
restore

collapse infant_mortality ext_preterm (sum) n, by(countycode qrtr year)

*drop counties with missing years
bysort countycode: gen count = _N
tab count
drop if count < 48

*want to keep counties with at least 10,000 births per year	
bysort countycode year: egen annual_births = total(n)
bysort countycode: egen min_births = min(annual_births)

egen year_qrtr = group(year qrtr)

xtset countycode year_qrtr
gen st_louis = countycode == 29189
gen treat = st_louis == 1 & year_qrtr > 23

gen IMR = infant_mortality * 1000
gen EPB = ext_preterm * 1000

save data/stl_data_new_qrtr.dta, replace
use data/stl_data_new_qrtr.dta, clear

****************
*SDID Estimates*
****************

preserve
keep if min_births > 8000
#delimit;
eststo epb1: sdid EPB countycode year_qrtr treat, vce(placebo) reps($reps) seed($seed)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(0(4)48) ytitle("EPB") 
            xtitle("") scheme(s1mono))
    graph_export("plots\epb_qrtr", .png);
#delimit cr
#delimit ;
eststo imr1: sdid IMR countycode year_qrtr treat, vce(placebo) reps($reps) seed($seed)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(0(4)48) ytitle("IMR") 
            xtitle("") scheme(s1mono))
    graph_export("plost\imr_qrtr", .png);
#delimit cr
restore

*BY RACE
clear
use data/stl_qrtrly_race_data.dta

bysort countycode year: egen annual_births = total(n)
bysort countycode: egen min_births = min(annual_births)

merge m:1 countycode using data\counties_8k.dta
keep if _merge == 3

egen year_qrtr = group(year qrtr)

gen st_louis = countycode == 29189
gen treat = st_louis == 1 & year_qrtr > 23

gen IMR = infant_mortality * 1000
gen EPB = ext_preterm * 1000

preserve
keep if mother_black == 1
cap drop count
bysort countycode: gen count = _N
tab count
drop if count < 48
*keep counties with at least 1,000 births to black mothers
bysort countycode year: egen black_births = total(n)
bysort countycode: egen min_black = min(black_births)
keep if min_black > 1000
xtset countycode year_qrtr

#delimit ;
eststo imr2: sdid IMR countycode year_qrtr treat, vce(placebo) reps($reps) seed($seed)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(0(4)48) ytitle("IMR") 
            xtitle("") scheme(s1mono))
    graph_export("plots\imr_qrtr_black", .png);
#delimit cr

#delimit ;
eststo epb2: sdid EPB countycode year_qrtr treat, vce(placebo) reps($reps) seed($seed)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(0(4)48) ytitle("EPB") 
            xtitle("") scheme(s1mono))
    graph_export("plots\epb_qrtr_black", .png);
#delimit cr
restore

preserve
keep if mother_black == 0
cap drop count
bysort countycode: gen count = _N
tab count
drop if count < 48
xtset countycode year_qrtr

#delimit ;
eststo epb3: sdid EPB countycode year_qrtr treat, vce(placebo) reps($reps) seed($seed)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(0(4)48) ytitle("EPB") 
            xtitle("") scheme(s1mono))
    graph_export("plots\epb_qrtr_white", .png);
#delimit cr
#delimit ;
eststo imr3: sdid IMR countycode year_qrtr treat, vce(placebo) reps($reps) seed($seed)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(0(4)48) ytitle("IMR") 
            xtitle("") scheme(s1mono))
    graph_export("plots\imr_qrtr_white", .png);
#delimit cr
restore

*Appendix Table A.3 
esttab epb1 epb2 epb3 imr1 imr2 imr3 using "tables\sdid_qrtr.tex", replace star(* 0.10 ** 0.05 *** .01) se label title(Synthetic Difference-in-Differences Estimates)

*Appendix Figure A.6
graph combine plots\epb_all_qrtr.gph plots\imr_all_qrtr.gph plots\epb_black_qrtr.gph plots\imr_black_qrtr.gph plots\epb_white_qrtr.gph plots\imr_white_qrtr.gph, rows(3)


*****************************
*Repeat at the monthly level*
*****************************

use "data\stl_data_00_13.dta", clear 

gen n = 1
drop if year < 2002

*drop CO and IA
drop if countycode > 8000 & countycode < 9000
drop if countycode > 19000 & countycode < 20000

*save separately by race
preserve
keep if mother_black == 1 |  mother_white == 1
collapse infant_mortality ext_preterm (sum) n, by(countycode year month mother_black)
*drop counties with missing months
bysort countycode: gen count = _N
tab count
drop if count < 288
save data/stl_monthly_race_data.dta, replace
restore

collapse infant_mortality ext_preterm (sum) n, by(countycode year month)

*drop counties with missing years
bysort countycode: gen count = _N
tab count
drop if count < 144

*want to keep counties with at least 10,000 births per year	
bysort countycode year: egen annual_births = total(n)
bysort countycode: egen min_births = min(annual_births)

egen year_month = group(year month)

xtset countycode year_month
gen st_louis = countycode == 29189
gen treat = st_louis == 1 & year_month > 70

gen IMR = infant_mortality * 1000
gen EPB = ext_preterm * 1000

save data/stl_data_new_mnth.dta, replace
use data/stl_data_new_mnth.dta, clear

****************
*SDID Estimates*
****************

preserve
keep if min_births > 8000
#delimit ;
eststo epb1: sdid EPB countycode year_month treat, vce(placebo) reps($reps) seed(123)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(0(12)144) ytitle("EPB") 
            xtitle("") scheme(s1mono))
    graph_export("plots\epb_mnth", .png);
eststo imr1: sdid IMR countycode year_month treat, vce(placebo) reps($reps) seed(123)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(0(12)144) ytitle("IMR") 
            xtitle("") scheme(s1mono))
    graph_export("plots\imr_mnth", .png);
#delimit cr
restore

*BY RACE
clear
use data/stl_monthly_race_data.dta

*want to keep counties with at least 10,000 births per year	
bysort countycode year: egen annual_births = total(n)
bysort countycode: egen min_births = min(annual_births)
keep if min_births > 8000

egen year_month = group(year month)

gen st_louis = countycode == 29189
gen treat = st_louis == 1 & year_month > 70

gen IMR = infant_mortality * 1000
gen EPB = ext_preterm * 1000

preserve
keep if mother_black == 1
cap drop count
bysort countycode: gen count = _N
tab count
drop if count < 144
*keep counties with at least 1,000 births to black mothers
bysort countycode year: egen black_births = total(n)
bysort countycode: egen min_black = min(black_births)
keep if min_black > 1000
xtset countycode year_month
#delimit ;
eststo epb2: sdid EPB countycode year_month treat, vce(placebo) reps($reps)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(0(12)144) ytitle("EPB") legend(off)
            xtitle("") scheme(s1mono))
    graph_export("plots\epb_mnth_black", .png);
eststo imr2: sdid IMR countycode year_month treat, vce(placebo) reps($reps)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(0(12)144) ytitle("IMR") legend(off)
            xtitle("") scheme(s1mono))
    graph_export("plots\imr_mnth_black", .png);
#delimit cr
restore

preserve
keep if mother_black == 0
cap drop count
bysort countycode: gen count = _N
tab count
drop if count < 144
xtset countycode year_month
#delimit ;
eststo epb3: sdid EPB countycode year_month treat, vce(placebo) reps($reps) seed(123)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(none) ytitle("EPB") legend(off) title("White Mothers") 
            xtitle("") scheme(s1mono))
    graph_export("plots\epb_mnth_white", .png);
eststo imr3: sdid IMR countycode year_month treat, vce(placebo) reps($reps) seed(123)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(none) ytitle("IMR") legend(off) title("White Mothers") 
            xtitle("") scheme(s1mono))
    graph_export("plots\imr_mnth_white", .png);
#delimit cr
restore

*Appendix Table A.4
esttab epb1 epb2 epb3 imr1 imr2 imr3 using "tables\sdid_mnth.tex", replace star(* 0.10 ** 0.05 *** .01) se label title(Synthetic Difference-in-Differences Estimates) 

*Appendix Figure A.7
graph combine plots\epb_all_mnth.gph plots\imr_all_mnth.gph plots\epb_black_mnth.gph plots\imr_black_mnth.gph plots\epb_white_mnth.gph plots\imr_white_mnth.gph, rows(3)

*********************************************
*Placebo simulations for donor pool counties*
*********************************************

*set reps at 100
global reps 100

use data\stl_data_new_qrtr.dta, clear

drop if st_louis == 1
keep if min_births > 8000
egen cty_num = group(countycode)
xtset cty_num year_qrtr

forvalues cty = 1(1)94{
preserve
drop treat 
gen treat = cty_num == `cty' & year_qrtr > 23
keep if min_births > 8000
sdid EPB countycode year_qrtr treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data\sdid_compare\epb_qrtr_`cty')
sdid IMR countycode year_qrtr treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data\sdid_compare\imr_qrtr_`cty')
restore
}

*MONTHLY PLACEBOS 
use data\stl_data_new_mnth.dta, clear

drop if st_louis == 1
keep if min_births > 8000
egen cty_num = group(countycode)
xtset cty_num year_month

forvalues cty = 1(1)94{
preserve
keep if min_births > 8000
drop treat 
gen treat = cty_num == `cty' & year_month > 70
keep if min_births > 8000
cap sdid EPB countycode year_month treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data\sdid_compare\epb_mnth_`cty', replace)
cap sdid IMR countycode year_month treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data\sdid_compare\imr_mnth_`cty', replace)
restore
}

*QUARTERLY PLACEBOS BY RACE
clear
use data\stl_qrtrly_race_data.dta

merge m:1 countycode using data\counties_8k.dta
keep if _merge == 3

egen year_qrtr = group(year qrtr)

gen st_louis = countycode == 29189
drop if st_louis == 1

gen IMR = infant_mortality * 1000
gen EPB = ext_preterm * 1000

keep if mother_black == 1
cap drop count
bysort countycode: gen count = _N
tab count
drop if count < 48
*keep counties with at least 1,000 births to black mothers
bysort countycode year: egen black_births = total(n)
bysort countycode: egen min_black = min(black_births)
keep if min_black > 1000
egen cty_num = group(countycode)
xtset cty_num year_qrtr


forvalues cty = 1(1)67{
cap	drop treat
gen treat = cty_num == `cty' & year_qrtr > 23
sdid EPB countycode year_qrtr treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data\sdid_compare\epb_qrtr_`cty'_black, replace)
sdid IMR countycode year_qrtr treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data\sdid_compare\imr_qrtr_`cty'_black, replace)
}


clear
use data\stl_qrtrly_race_data.dta

merge m:1 countycode using data\counties_8k.dta
keep if _merge == 3

egen year_qrtr = group(year qrtr)

gen st_louis = countycode == 29189
drop if st_louis == 1

gen IMR = infant_mortality * 1000
gen EPB = ext_preterm * 1000

keep if mother_black == 0
cap drop count
bysort countycode: gen count = _N
tab count
drop if count < 48
egen cty_num = group(countycode)
xtset cty_num year_qrtr

forvalues cty = 1(1)94{
cap drop treat
gen treat = cty_num == `cty' & year_qrtr > 23
sdid EPB countycode year_qrtr treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data\sdid_compare\epb_qrtr_`cty'_white, replace)
sdid IMR countycode year_qrtr treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data\sdid_compare\imr_qrtr_`cty'_white, replace)
}

***MONTHLY PLACEBOS BY RACE
*iterate through each donor pool and run SDID regression
*first Black mothers then White mothers
clear
use data\stl_monthly_race_data.dta

merge m:1 countycode using data\counties_8k.dta
keep if _merge == 3

egen year_month = group(year month)

gen st_louis = countycode == 29189
drop if st_louis == 1

gen IMR = infant_mortality * 1000
gen EPB = ext_preterm * 1000

keep if mother_black == 1
cap drop count
bysort countycode: gen count = _N
tab count
drop if count < 144
*keep counties with at least 1,000 births to black mothers
bysort countycode year: egen black_births = total(n)
bysort countycode: egen min_black = min(black_births)
keep if min_black > 1000
egen cty_num = group(countycode)
xtset cty_num year_month

forvalues cty = 1(1)67{
cap	drop treat
gen treat = cty_num == `cty' & year_month > 70
sdid EPB countycode year_month treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data\sdid_compare\epb_month_`cty'_black, replace)
sdid IMR countycode year_month treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data\sdid_compare\imr_month_`cty'_black, replace)
}


*iterate through each donor pool and run SDID regression
clear
use data\stl_monthly_race_data.dta

merge m:1 countycode using data\counties_8k.dta
keep if _merge == 3

egen year_month = group(year month)

gen st_louis = countycode == 29189
drop if st_louis == 1

gen IMR = infant_mortality * 1000
gen EPB = ext_preterm * 1000

keep if mother_black == 0
cap drop count
bysort countycode: gen count = _N
tab count
drop if count < 144
egen cty_num = group(countycode)
xtset cty_num year_month

forvalues cty = 1(1)94{
cap drop treat
gen treat = cty_num == `cty' & year_month > 70
sdid EPB countycode year_month treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data\sdid_compare\epb_month_`cty'_white, replace)
sdid IMR countycode year_month treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data\sdid_compare\imr_month_`cty'_white, replace)
}

*Now compare distributions
**ALL EPB
clear
forvalues cty = 1(1)95{
append using data\sdid_placebo\epb_8k_`cty'
cap gen county = `cty'
replace county = `cty' if missing(county)
}
drop if county == 51
replace county = county - 1 if county > 51

gen type = "year"

forvalues cty = 1(1)94{
append using data\sdid_compare\epb_mnth_`cty'
replace type = "month" if missing(type)
append using data\sdid_compare\epb_qrtr_`cty'
replace county = `cty' if missing(county)
replace type = "quarter" if missing(type)
}

*save as epb_all_dist.gph
twoway (kdensity est if type == "year", lpattern(solid)) ///
	(kdensity est if type == "quarter", lpattern(dash)lwidth(thick)) ///
	(kdensity est if type == "month", lpattern(dot)lwidth(vthick)), ///
	legend(label(1 "Annual") label(2 "Quarterly") label(3 "Monthly") rows(1)) ///
	ytitle("Kernel Density") xtitle("Placebo Estimates") xline(0,lpattern(dot))

gen version = "EPB - All"
gen v_num = 1
save data\sdid_placebo\epb_est_all.dta, replace
	
**ALL IMR
clear
forvalues cty = 1(1)95{
append using data\sdid_placebo\imr_8k_`cty'
cap gen county = `cty'
replace county = `cty' if missing(county)
}
drop if county == 51
replace county = county - 1 if county > 51

gen type = "year"

forvalues cty = 1(1)94{
append using data\sdid_compare\imr_mnth_`cty'
replace type = "month" if missing(type)
append using data\sdid_compare\imr_qrtr_`cty'
replace county = `cty' if missing(county)
replace type = "quarter" if missing(type)
}

*save as imr_all_dist.gph
twoway (kdensity est if type == "year", lpattern(solid)) ///
	(kdensity est if type == "quarter", lpattern(dash)lwidth(thick)) ///
	(kdensity est if type == "month", lpattern(dot)lwidth(vthick)), ///
	legend(label(1 "Annual") label(2 "Quarterly") label(3 "Monthly") rows(1)) ///
	ytitle("Kernel Density") xtitle("Placebo Estimates") xline(0,lpattern(dot))
	
gen version = "IMR - All"
gen v_num = 4
save data\sdid_placebo\imr_est_all.dta, replace
	
**White EPB
clear
forvalues cty = 1(1)95{
append using data\sdid_placebo\epb_8k_`cty'_white
cap gen county = `cty'
replace county = `cty' if missing(county)
}
drop if county == 51
replace county = county - 1 if county > 51

gen type = "year"

forvalues cty = 1(1)92{
append using data\sdid_compare\epb_month_`cty'_white
replace type = "month" if missing(type)
}

forvalues cty = 1(1)94{
append using data\sdid_compare\epb_qrtr_`cty'_white
replace county = `cty' if missing(county)
replace type = "quarter" if missing(type)
}

*save as epb_white_dist.gph
twoway (kdensity est if type == "year", lpattern(solid)) ///
	(kdensity est if type == "quarter", lpattern(dash)lwidth(thick)) ///
	(kdensity est if type == "month", lpattern(dot)lwidth(vthick)), ///
	legend(label(1 "Annual") label(2 "Quarterly") label(3 "Monthly") rows(1)) ///
	ytitle("Kernel Density") xtitle("Placebo Estimates") xline(0,lpattern(dot))

gen version = "EPB - White"
gen v_num = 3
save data\sdid_placebo\epb_est_white.dta, replace
	
**WHITE IMR
clear
forvalues cty = 1(1)95{
append using data\sdid_placebo\imr_8k_`cty'_white
cap gen county = `cty'
replace county = `cty' if missing(county)
}
drop if county == 51
replace county = county - 1 if county > 51

gen type = "year"

forvalues cty = 1(1)92{
append using data\sdid_compare\imr_month_`cty'_white
replace type = "month" if missing(type)
}

forvalues cty = 1(1)94{
append using data\sdid_compare\imr_qrtr_`cty'_white
replace county = `cty' if missing(county)
replace type = "quarter" if missing(type)
}

*save as imr_white_dist.gph
twoway (kdensity est if type == "year", lpattern(solid)) ///
	(kdensity est if type == "quarter", lpattern(dash)lwidth(thick)) ///
	(kdensity est if type == "month", lpattern(dot)lwidth(vthick)), ///
	legend(label(1 "Annual") label(2 "Quarterly") label(3 "Monthly") rows(1)) ///
	ytitle("Kernel Density") xtitle("Placebo Estimates") xline(0,lpattern(dot))

gen version = "IMR - White"
gen v_num = 6
save data\sdid_placebo\imr_est_white.dta, replace

	
**Black EPB
clear
forvalues cty = 1(1)68{
append using data\sdid_placebo\epb_8k_`cty'_black
cap gen county = `cty'
replace county = `cty' if missing(county)
}
drop if county == 51
replace county = county - 1 if county > 51

gen type = "year"

forvalues cty = 1(1)67{
append using data\sdid_compare\epb_month_`cty'_black
replace type = "month" if missing(type)
}

forvalues cty = 1(1)67{
append using data\sdid_compare\epb_qrtr_`cty'_black
replace county = `cty' if missing(county)
replace type = "quarter" if missing(type)
}
*save as epb_black_dist.gph
twoway (kdensity est if type == "year", lpattern(solid)) ///
	(kdensity est if type == "quarter", lpattern(dash)lwidth(thick)) ///
	(kdensity est if type == "month", lpattern(dot)lwidth(vthick)), ///
	legend(label(1 "Annual") label(2 "Quarterly") label(3 "Monthly") rows(1)) ///
	ytitle("Kernel Density") xtitle("Placebo Estimates") xline(0,lpattern(dot))

gen version = "EPB - Black"
gen v_num = 2
save data\sdid_placebo\epb_est_black.dta, replac

**Black IMR
clear
forvalues cty = 1(1)68{
append using data\sdid_placebo\imr_8k_`cty'_black
cap gen county = `cty'
replace county = `cty' if missing(county)
}
drop if county == 51
replace county = county - 1 if county > 51

gen type = "year"

forvalues cty = 1(1)67{
append using data\sdid_compare\imr_month_`cty'_black
replace type = "month" if missing(type)
}

forvalues cty = 1(1)67{
append using data\sdid_compare\imr_qrtr_`cty'_black
replace county = `cty' if missing(county)
replace type = "quarter" if missing(type)
}

*save as imr_black_dist.gph
twoway (kdensity est if type == "year", lpattern(solid)) ///
	(kdensity est if type == "quarter", lpattern(dash)lwidth(thick)) ///
	(kdensity est if type == "month", lpattern(dot)lwidth(vthick)), ///
	legend(label(1 "Annual") label(2 "Quarterly") label(3 "Monthly") rows(1)) ///
	ytitle("Kernel Density") xtitle("Placebo Estimates") xline(0,lpattern(dot))

gen version = "IMR - Black"
gen v_num = 5
save data\sdid_placebo\imr_est_black.dta, replace

clear
append using data\sdid_placebo\epb_est_all.dta
append using data\sdid_placebo\imr_est_all.dta
append using data\sdid_placebo\epb_est_white.dta
append using data\sdid_placebo\imr_est_white.dta
append using data\sdid_placebo\epb_est_black.dta
append using data\sdid_placebo\imr_est_black.dta

save data\sdid_placebo\est_combined.dta, replace

gen reject = p < .05
gen n = 1

egen t_num = group(type)

replace v_num = v_num - .1 if type == "year"
replace v_num = v_num + .1 if type == "month"

gen ver_type = version + type

collapse est stderr min max p reject (sum) n, by(type version v_num)

*Appendix Figure A.4 (confidence intervals on placebos)
twoway (scatter est v_num if type == "year",mcolor(black)) (rcap max min v_num if type == "year", lcolor(black)) ///
	   (scatter est v_num if type == "quarter",mcolor(gs7)msymbol(triangle)) (rcap max min v_num if type == "quarter",lcolor(gs7)lpattern(dash)) ///
	   (scatter est v_num if type == "month",mcolor(gs13)msymbol(square)) (rcap max min v_num if type == "month",lcolor(gs13)lpattern(dash)), ///
	   yline(0,lpattern(dot)) xlabel(1 "EPB All" 2 "EPB B" 3 "EPB W" 4 "IMR All" 5 "IMR B" 6 "IMR W") xtitle("")

*combine into Appendix Figure A.3	   
grc1leg epb_all_dist.gph epb_black_dist.gph epb_white_dist.gph imr_all_dist.gph imr_black_dist.gph imr_white_dist.gph, rows(2)