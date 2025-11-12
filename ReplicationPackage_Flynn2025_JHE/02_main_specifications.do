
*set reps to 500 for all SDID specifications
global reps 500 
*set seed to 123 for replication purposes
global seed 123

*load cleaned data from "01_raw_data_clean.do"
use "data\stl_02_13.dta", clear 

*collapse rates and number of births at the county-year level
gen n = 1
collapse infant_mortality ext_preterm ext_pre2 (sum) n, by(countycode year)

*drop CO and IA because they have LARC interventions during sample window
drop if countycode > 8000 & countycode < 9000
drop if countycode > 19000 & countycode < 20000
gen st_louis = countycode == 29189 

*drop counties with missing years
bysort countycode: gen count = _N
drop if count < 12

*calculate minimum number of births for a county in the panel	
bysort countycode: egen min_births = min(n)

*create list of county codes with at least 10,000 births per year
preserve 
keep if min_births > 10000
collapse n, by(countycode)
keep countycode
save data\counties_10k.dta, replace
restore

*create list of county codes with at least 8,000 births per year
preserve 
keep if min_births > 8000
collapse n, by(countycode)
keep countycode
save data\counties_8k.dta, replace
restore

*create list of county codes with at least 6,000 births per year
preserve 
keep if min_births > 6000
collapse n, by(countycode)
keep countycode
save data\counties_6k.dta, replace
restore

*combine counties for R map
preserve
use counties_6k.dta
gen label = "6k"
merge 1:1 countycode using counties_8k.dta
replace label = "8k" if _merge == 3
drop _merge
merge 1:1 countcode using counties_10k.dta
replace label = "10k" if _merge ==3
drop _merge
save data\county_map_label.dta, replace
restore

gen IMR = infant_mortality * 1000
gen EPB = ext_preterm * 1000
gen log_epb = ln(EPB)
gen log_imr = ln(IMR)

****************
*SDID Estimates*
****************

xtset countycode year 

gen treat = st_louis == 1 & year > 2007

*Main SDID specifications for full sample
preserve
keep if min_births > 8000
#delimit ;
eststo epb1: sdid EPB countycode year treat, vce(placebo) reps($reps) seed($seed)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(2002(3)2013) ytitle("EPB") 
            xtitle("") scheme(s1mono))
    graph_export("plots\epb_new", .png);
*estimate with log DV
eststo epb_log1: sdid EPB countycode year treat, vce(placebo) reps($reps) seed($seed)
#delimit cr
#delimit ;
eststo imr1: sdid IMR countycode year treat, vce(placebo) reps($reps) seed($seed)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(2002(3)2013) ytitle("IMR") 
            xtitle("") scheme(s1mono))
    graph_export("plots\imr_new", .png);
eststo imr_log1: sdid IMR countycode year treat, vce(placebo) reps($reps) seed($seed)
#delimit cr
restore

*save county weights for sumstat table
preserve
keep if min_births > 8000
sdid EPB countycode year treat, vce(placebo) reps(1) seed($seed)
matrix weights = e(omega)
svmat double weights, names(weight)
keep weight1 weight2
rename weight1 weight_sdid
rename weight2 countycode
drop if missing(countycode)
save data\county_weights_new.dta, replace
restore

*coefficients with donor pool restriction at 10,000 births
preserve
keep if min_births > 10000
eststo epb1_10: sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)
eststo imr1_10:sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)
restore

*coefficients with donor pool restriction at 6,000 births
preserve
keep if min_births > 6000
eststo epb1_6:sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)
eststo imr1_6:sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)
restore

*************
*NOW BY RACE*
*************
use "data\stl_02_13.dta", clear 

gen n = 1

*only want births to Black or White mother
drop if mother_white == 0 & mother_black == 0

collapse infant_mortality ext_preterm (sum) n, by(countycode year mother_black)

*drop CO and IA
drop if countycode > 8000 & countycode < 9000
drop if countycode > 19000 & countycode < 20000
gen st_louis = countycode == 29189 

*drop counties with missing years
bysort countycode: gen count = _N
drop if count < 24

*want to drop counties with <1,000 births per year to Black mothers	
bysort countycode mother_black: egen min_births = min(n)

gen IMR = infant_mortality * 1000
gen EPB = ext_preterm * 1000
gen log_epb = ln(EPB)
gen log_imr = ln(IMR)

gen treat = st_louis == 1 & year > 2007

*Main estimates for Black mothers
preserve
keep if mother_black == 1
xtset countycode year 
keep if min_births > 1000
merge m:1 countycode using data\counties_8k.dta
keep if _merge == 3
#delimit ;
eststo epb2: sdid EPB countycode year treat, vce(placebo) reps($reps) seed($seed)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(2002(3)2013) ytitle("EPB") 
            xtitle("") scheme(s1mono))
    graph_export("plots\epb_black_new", .png);
eststo epb_log2: sdid EPB countycode year treat, vce(placebo) reps($reps) seed($seed)
#delimit cr
#delimit ;
eststo imr2: sdid IMR countycode year treat, vce(placebo) reps($reps) seed($seed)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(2002(3)2013) ytitle("IMR") 
            xtitle("") scheme(s1mono))
    graph_export("plots\imr_black_new", .png);
eststo imr_log2: sdid IMR countycode year treat, vce(placebo) reps($reps) seed($seed)
#delimit cr
restore

*coefficients with donor pool at 10,000
preserve
keep if mother_black == 1
xtset countycode year 
keep if min_births > 1000
merge m:1 countycode using data\counties_10k.dta
keep if _merge == 3
eststo epb2_10:sdid EPB countycode year treat, vce(placebo) reps($reps) seed($seed)
eststo imr2_10:sdid IMR countycode year treat, vce(placebo) reps($reps) seed($seed)
restore

*coefficients with donor pool at 6,000
preserve
keep if mother_black == 1
xtset countycode year 
keep if min_births > 1000
merge m:1 countycode using data\counties_6k.dta
keep if _merge == 3
eststo epb2_6: sdid EPB countycode year treat, vce(placebo) reps($reps) seed($seed)
eststo imr2_6: sdid IMR countycode year treat, vce(placebo) reps($reps) seed($seed)
restore

*Main estimates for White mothers
preserve
keep if mother_black == 0
xtset countycode year 
merge m:1 countycode using data\counties_8k.dta
keep if _merge == 3
#delimit ;
eststo epb3: sdid EPB countycode year treat, vce(placebo) reps($reps) seed($seed)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(2002(3)2013) ytitle("EPB") 
            xtitle("") scheme(s1mono))
    graph_export("plots\epb_white_new", .png);
eststo epb_log3: sdid EPB countycode year treat, vce(placebo) reps($reps) seed($seed)
#delimit cr
#delimit ;
eststo imr3: sdid IMR countycode year treat, vce(placebo) reps($reps) seed($seed)
	graph g1on g1_opt(xtitle("") scheme(s1mono))
     g2_opt(xlabel(2002(3)2013) ytitle("IMR") 
            xtitle("") scheme(s1mono))
    graph_export("plots\imr_white_new", .png);
eststo imr_log3: sdid IMR countycode year treat, vce(placebo) reps($reps) seed($seed)
#delimit cr
restore

*coefficients with donor pool at 10,000
preserve
keep if mother_black == 0
xtset countycode year 
merge m:1 countycode using data\counties_10k.dta
keep if _merge == 3
eststo epb3_10: sdid EPB countycode year treat, vce(placebo) reps($reps) seed($seed)
eststo imr3_10: sdid IMR countycode year treat, vce(placebo) reps($reps) seed($seed)
restore

*coefficients with donor pool at 6,000
preserve
keep if mother_black == 0
xtset countycode year 
merge m:1 countycode using data\counties_6k.dta
keep if _merge == 3
eststo epb3_6: sdid EPB countycode year treat, vce(placebo) reps($reps) seed($seed)
eststo imr3_6: sdid IMR countycode year treat, vce(placebo) reps($reps) seed($seed)
restore

*Create main table of coefficients (TABLE 2 in paper)
esttab epb1 epb2 epb3 imr1 imr2 imr3 using "tables\sdid_new.tex", replace star(* 0.10 ** 0.05 *** .01) se label title(Synthetic Difference-in-Differences Estimates) 

*Coefficient table with log DV (TABLE 3 in paper)
esttab epb1_6 epb2_6 epb3_6 imr1_6 imr2_6 imr3_6 using "tables\sdid_new_6k.tex", replace star(* 0.10 ** 0.05 *** .01) se label title(Synthetic Difference-in-Differences Estimates) 

*Coefficient table with donor pool at 10,000 (Appendix Table A.2)
esttab epb1_10 epb2_10 epb3_10 imr1_10 imr2_10 imr3_10 using "tables\sdid_new_10k.tex", replace star(* 0.10 ** 0.05 *** .01) se label title(Synthetic Difference-in-Differences Estimates) 

*Coefficient table with donor pool at 6,000 (Appendix Table A.1)
esttab epb1_6 epb2_6 epb3_6 imr1_6 imr2_6 imr3_6 using "tables\sdid_new_6k.tex", replace star(* 0.10 ** 0.05 *** .01) se label title(Synthetic Difference-in-Differences Estimates) 

*combine SDID graphs (FIGURE 3 in paper)
cd "plots"
graph combine epb_new.gph imr_new.gph epb_black_new.gph imr_black_new.gph epb_white_new.gph imr_white_new.gph, rows(3)