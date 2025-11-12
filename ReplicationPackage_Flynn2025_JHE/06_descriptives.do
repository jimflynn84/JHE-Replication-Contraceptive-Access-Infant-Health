*Create summary stats table (Table 1) and time series figure (Figure 2)

*load cleaned data from "01_raw_data_clean.do"
use "data\stl_00_13.dta", clear 

*Time-series figure, STL vs. US, 2002-2013
preserve
collapse EPB IMR [pweight=n], by(year st_louis)
twoway (line EPB year if st_louis == 1,lcolor(black)) ///
	(line IMR year if st_louis == 1,lpattern(dash) lcolor(black)) ///
	(line EPB year if st_louis == 0,lcolor(gs14)) ///
	(line IMR year if st_louis == 0,lcolor(gs14) lpattern(dash)), ///
	xtitle("") ytitle("Outcome per 1k Live Births") xline(2007, lpatter(dot)) ///
	xticks(2002(2)2012) xlabels(2002(2)2012)
restore

*now create summary stats table
rename yob year
keep if year == 2006

gen n = 1

gen white = mother_race == 1 
gen black = mother_race == 2
gen hispanic = mother_hispanic != 0
gen teen_birth = mother_age < 20
bysort countycode: gen births = _N

*treatment indicator
gen st_louis = countycode == 29189 

*merge with synthetic difference-in-differences method (SDID) weights
merge m:1 countycode using data\county_weights_new.dta 
gen sdid_wt = _merge == 3
replace weight_sdid = 1 if st_louis == 1

*merge with synthetic control method (SCM) weights
drop _merge
merge m:1 countycode using data\county_weights_synth_new.dta
gen synth_wt = _merge == 3
replace weight_synth = 1 if st_louis == 1

gen EPB = ext_preterm * 1000
gen IMR = infant_mortality * 1000

mat sumstat = J(9,7,.)
global descvars EPB IMR gestation mother_age teen_birth white black hispanic mother_married
local i = 1 
foreach var in $descvars { 
	
	quietly: summarize `var' if st_louis == 1
	mat sumstat[`i',1] = r(mean)
	
	quietly: summarize `var' if st_louis == 0
	mat sumstat[`i',2] = r(mean)

	quietly: mvtest means `var', by(st_louis)
	mat sumstat[`i',3] = r(p_F)

	quietly: summarize `var' if st_louis == 0 [aweight=weight_sdid]
	mat sumstat[`i',4] = r(mean)
	
	quietly: mvtest means `var' [aweight=weight_sdid], by(st_louis)
	mat sumstat[`i',5] = r(p_F)

	quietly: summarize `var' if st_louis == 0 [aweight=weight_synth]
	mat sumstat[`i',6] = r(mean)
	
	quietly: mvtest means `var' [aweight=weight_synth], by(st_louis)
	mat sumstat[`i',7] = r(p_F)

	local i = `i' + 1

	}

mat list sumstat

frmttable, statmat(sumstat) store(sumstat) sfmt(f,f,f,f,f,f,f)

outreg using "tables\balance.tex", ///
    replay(sumstat) tex nocenter note("") fragment plain replace ///
    ctitles("St. Louis", "U.S.", "p","SDID","p","Synth","p")

