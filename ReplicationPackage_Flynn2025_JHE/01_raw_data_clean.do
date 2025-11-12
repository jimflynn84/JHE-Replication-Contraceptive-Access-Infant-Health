*clean raw data for each year with only the variables I place to use
*2002-2005 each have their own data dictionary and need to be processed separately
*2006-2013 share a data dictionary and can be processed in a loop
	
local year 2002
*import raw data - start with denominator
import delimited "data\LinkedCohort`year'\LKBC`year'USDenom.AllCnty.txt", clear

*year of birth
gen year = substr(v1, 7, 4)
destring year, replace

*birth state of residence fips code
gen birth_state_fips = substr(v1, 19, 2)
destring birth_state_fips, replace

*birth county of residence fips
gen county_res_fips = substr(v1, 21, 3)
destring county_res_fips, replace

gen countycode = (1000*birth_state_fips) + county_res_fips

*mother age (in years)
gen mother_age = substr(v1, 30, 2)
destring mother_age, replace

*mother race
gen mother_race_full = substr(v1, 36, 2)
destring mother_race_full, replace

*weeks of gestation
gen gestation = substr(v1, 74, 2)
destring gestation, replace
replace gestation = . if gestation == 99

*birth month
gen month = substr(v1, 205, 2)
destring month, replace

gen marital = substr(v1,43,1)
gen mother_married = marital == "1"

gen age_death = substr(v1,211,3)
gen infant_mortality = age != "   "

drop v1 
compress 

save "data\stl_`year'.dta", replace


local year 2003
*import raw data - start with denominator
import delimited "data\LinkedCohort`year'\LKBC`year'USDenom.AllCnty.txt", clear

*year of birth
gen year = substr(v1, 15, 4)
destring year, replace

gen month = substr(v1, 19, 2)
destring month, replace

gen mother_age = substr(v1,89,2)
destring mother_age, replace
replace mother_age = mother_age + 13

*mother race
gen mother_race = substr(v1, 143, 1)
destring mother_race, replace
label define mom_race_l 1 "White" 2 "Black" 3 "AIAN" 4 "AAPI"
label values mother_race mom_race_l

*weeks of gestation
gen gestation = substr(v1, 451, 2)
destring gestation, replace
replace gestation = . if gestation == 99

*birth state of residence fips code
gen birth_state_abbrev = substr(v1, 109, 2)
gen birth_state_fips = .
replace birth_state_fips = 1 if birth_state_abbrev == "AL"
replace birth_state_fips = 2 if birth_state_abbrev == "AK"
replace birth_state_fips = 4 if birth_state_abbrev == "AZ"
replace birth_state_fips = 5 if birth_state_abbrev == "AR"
replace birth_state_fips = 6 if birth_state_abbrev == "CA"
replace birth_state_fips = 8 if birth_state_abbrev == "CO"
replace birth_state_fips = 9 if birth_state_abbrev == "CT"
replace birth_state_fips = 10 if birth_state_abbrev == "DE"
replace birth_state_fips = 11 if birth_state_abbrev == "DC"
replace birth_state_fips = 12 if birth_state_abbrev == "FL"
replace birth_state_fips = 13 if birth_state_abbrev == "GA"
replace birth_state_fips = 15 if birth_state_abbrev == "HI"
replace birth_state_fips = 16 if birth_state_abbrev == "ID"
replace birth_state_fips = 17 if birth_state_abbrev == "IL"
replace birth_state_fips = 18 if birth_state_abbrev == "IN"
replace birth_state_fips = 19 if birth_state_abbrev == "IA"
replace birth_state_fips = 20 if birth_state_abbrev == "KS"
replace birth_state_fips = 21 if birth_state_abbrev == "KY"
replace birth_state_fips = 22 if birth_state_abbrev == "LA"
replace birth_state_fips = 23 if birth_state_abbrev == "ME"
replace birth_state_fips = 24 if birth_state_abbrev == "MD"
replace birth_state_fips = 25 if birth_state_abbrev == "MA"
replace birth_state_fips = 26 if birth_state_abbrev == "MI"
replace birth_state_fips = 27 if birth_state_abbrev == "MN"
replace birth_state_fips = 28 if birth_state_abbrev == "MS"
replace birth_state_fips = 29 if birth_state_abbrev == "MO"
replace birth_state_fips = 30 if birth_state_abbrev == "MT"
replace birth_state_fips = 31 if birth_state_abbrev == "NE"
replace birth_state_fips = 32 if birth_state_abbrev == "NV"
replace birth_state_fips = 33 if birth_state_abbrev == "NH"
replace birth_state_fips = 34 if birth_state_abbrev == "NJ"
replace birth_state_fips = 35 if birth_state_abbrev == "NM"
replace birth_state_fips = 36 if birth_state_abbrev == "NY"
replace birth_state_fips = 37 if birth_state_abbrev == "NC"
replace birth_state_fips = 38 if birth_state_abbrev == "ND"
replace birth_state_fips = 39 if birth_state_abbrev == "OH"
replace birth_state_fips = 40 if birth_state_abbrev == "OK"
replace birth_state_fips = 41 if birth_state_abbrev == "OR"
replace birth_state_fips = 42 if birth_state_abbrev == "PA"
replace birth_state_fips = 44 if birth_state_abbrev == "RI"
replace birth_state_fips = 45 if birth_state_abbrev == "SC"
replace birth_state_fips = 46 if birth_state_abbrev == "SD"
replace birth_state_fips = 47 if birth_state_abbrev == "TN"
replace birth_state_fips = 48 if birth_state_abbrev == "TX"
replace birth_state_fips = 49 if birth_state_abbrev == "UT"
replace birth_state_fips = 50 if birth_state_abbrev == "VT"
replace birth_state_fips = 51 if birth_state_abbrev == "VA"
replace birth_state_fips = 53 if birth_state_abbrev == "WA"
replace birth_state_fips = 54 if birth_state_abbrev == "WV"
replace birth_state_fips = 55 if birth_state_abbrev == "WI"
replace birth_state_fips = 56 if birth_state_abbrev == "WY"

*birth county of residence fips
gen county_res_fips = substr(v1, 114, 3)
destring county_res_fips, replace
gen countycode = (birth_state_fips*1000) + county_res_fips

gen mort_flag =  substr(v1, 868, 1)

gen marital = substr(v1,153,1)
gen mother_married = marital == "1"

gen cause_of_death = substr(v1,771,3)
gen infant_mortality = cause_of_death != "   "
drop cause_of_death

drop v1
compress

save "data\stl_`year'.dta", replace


local year 2004
*import raw data - start with denominator
import delimited "data\LinkedCohort`year'\LKBC`year'USDenom.AllCnty.txt", clear

*year of birth
gen year = substr(v1, 15, 4)
destring year, replace

gen month = substr(v1, 19, 2)
destring month, replace

gen mother_age = substr(v1,89,2)
destring mother_age, replace

*mother race
gen mother_race = substr(v1, 143, 1)
destring mother_race, replace
label define mom_race_l 1 "White" 2 "Black" 3 "AIAN" 4 "AAPI"
label values mother_race mom_race_l

*weeks of gestation
gen gestation = substr(v1, 451, 2)
destring gestation, replace
replace gestation = . if gestation == 99

*birth state of residence fips code
gen birth_state_abbrev = substr(v1, 109, 2)
gen birth_state_fips = .
replace birth_state_fips = 1 if birth_state_abbrev == "AL"
replace birth_state_fips = 2 if birth_state_abbrev == "AK"
replace birth_state_fips = 4 if birth_state_abbrev == "AZ"
replace birth_state_fips = 5 if birth_state_abbrev == "AR"
replace birth_state_fips = 6 if birth_state_abbrev == "CA"
replace birth_state_fips = 8 if birth_state_abbrev == "CO"
replace birth_state_fips = 9 if birth_state_abbrev == "CT"
replace birth_state_fips = 10 if birth_state_abbrev == "DE"
replace birth_state_fips = 11 if birth_state_abbrev == "DC"
replace birth_state_fips = 12 if birth_state_abbrev == "FL"
replace birth_state_fips = 13 if birth_state_abbrev == "GA"
replace birth_state_fips = 15 if birth_state_abbrev == "HI"
replace birth_state_fips = 16 if birth_state_abbrev == "ID"
replace birth_state_fips = 17 if birth_state_abbrev == "IL"
replace birth_state_fips = 18 if birth_state_abbrev == "IN"
replace birth_state_fips = 19 if birth_state_abbrev == "IA"
replace birth_state_fips = 20 if birth_state_abbrev == "KS"
replace birth_state_fips = 21 if birth_state_abbrev == "KY"
replace birth_state_fips = 22 if birth_state_abbrev == "LA"
replace birth_state_fips = 23 if birth_state_abbrev == "ME"
replace birth_state_fips = 24 if birth_state_abbrev == "MD"
replace birth_state_fips = 25 if birth_state_abbrev == "MA"
replace birth_state_fips = 26 if birth_state_abbrev == "MI"
replace birth_state_fips = 27 if birth_state_abbrev == "MN"
replace birth_state_fips = 28 if birth_state_abbrev == "MS"
replace birth_state_fips = 29 if birth_state_abbrev == "MO"
replace birth_state_fips = 30 if birth_state_abbrev == "MT"
replace birth_state_fips = 31 if birth_state_abbrev == "NE"
replace birth_state_fips = 32 if birth_state_abbrev == "NV"
replace birth_state_fips = 33 if birth_state_abbrev == "NH"
replace birth_state_fips = 34 if birth_state_abbrev == "NJ"
replace birth_state_fips = 35 if birth_state_abbrev == "NM"
replace birth_state_fips = 36 if birth_state_abbrev == "NY"
replace birth_state_fips = 37 if birth_state_abbrev == "NC"
replace birth_state_fips = 38 if birth_state_abbrev == "ND"
replace birth_state_fips = 39 if birth_state_abbrev == "OH"
replace birth_state_fips = 40 if birth_state_abbrev == "OK"
replace birth_state_fips = 41 if birth_state_abbrev == "OR"
replace birth_state_fips = 42 if birth_state_abbrev == "PA"
replace birth_state_fips = 44 if birth_state_abbrev == "RI"
replace birth_state_fips = 45 if birth_state_abbrev == "SC"
replace birth_state_fips = 46 if birth_state_abbrev == "SD"
replace birth_state_fips = 47 if birth_state_abbrev == "TN"
replace birth_state_fips = 48 if birth_state_abbrev == "TX"
replace birth_state_fips = 49 if birth_state_abbrev == "UT"
replace birth_state_fips = 50 if birth_state_abbrev == "VT"
replace birth_state_fips = 51 if birth_state_abbrev == "VA"
replace birth_state_fips = 53 if birth_state_abbrev == "WA"
replace birth_state_fips = 54 if birth_state_abbrev == "WV"
replace birth_state_fips = 55 if birth_state_abbrev == "WI"
replace birth_state_fips = 56 if birth_state_abbrev == "WY"

*birth county of residence fips
gen county_res_fips = substr(v1, 114, 3)
destring county_res_fips, replace
gen countycode = (birth_state_fips*1000) + county_res_fips

gen mort_flag =  substr(v1, 868, 1)

gen marital = substr(v1,153,1)
gen mother_married = marital == "1"

drop v1
compress

save "data\stl_`year'.dta", replace

local year 2005
*import raw data - start with denominator
import delimited "data\LinkedCohort`year'\LKBC`year'USDenom.AllCnty.txt", clear

*year of birth
gen year = substr(v1, 15, 4)
destring year, replace

gen month = substr(v1, 19, 2)
destring month, replace

gen mother_age = substr(v1,89,2)
destring mother_age, replace

*mother race
gen mother_race = substr(v1, 143, 1)
destring mother_race, replace
label define mom_race_l 1 "White" 2 "Black" 3 "AIAN" 4 "AAPI"
label values mother_race mom_race_l

*weeks of gestation
gen gestation = substr(v1, 451, 2)
destring gestation, replace
replace gestation = . if gestation == 99

*birth state of residence fips code
gen birth_state_abbrev = substr(v1, 109, 2)
gen birth_state_fips = .
replace birth_state_fips = 1 if birth_state_abbrev == "AL"
replace birth_state_fips = 2 if birth_state_abbrev == "AK"
replace birth_state_fips = 4 if birth_state_abbrev == "AZ"
replace birth_state_fips = 5 if birth_state_abbrev == "AR"
replace birth_state_fips = 6 if birth_state_abbrev == "CA"
replace birth_state_fips = 8 if birth_state_abbrev == "CO"
replace birth_state_fips = 9 if birth_state_abbrev == "CT"
replace birth_state_fips = 10 if birth_state_abbrev == "DE"
replace birth_state_fips = 11 if birth_state_abbrev == "DC"
replace birth_state_fips = 12 if birth_state_abbrev == "FL"
replace birth_state_fips = 13 if birth_state_abbrev == "GA"
replace birth_state_fips = 15 if birth_state_abbrev == "HI"
replace birth_state_fips = 16 if birth_state_abbrev == "ID"
replace birth_state_fips = 17 if birth_state_abbrev == "IL"
replace birth_state_fips = 18 if birth_state_abbrev == "IN"
replace birth_state_fips = 19 if birth_state_abbrev == "IA"
replace birth_state_fips = 20 if birth_state_abbrev == "KS"
replace birth_state_fips = 21 if birth_state_abbrev == "KY"
replace birth_state_fips = 22 if birth_state_abbrev == "LA"
replace birth_state_fips = 23 if birth_state_abbrev == "ME"
replace birth_state_fips = 24 if birth_state_abbrev == "MD"
replace birth_state_fips = 25 if birth_state_abbrev == "MA"
replace birth_state_fips = 26 if birth_state_abbrev == "MI"
replace birth_state_fips = 27 if birth_state_abbrev == "MN"
replace birth_state_fips = 28 if birth_state_abbrev == "MS"
replace birth_state_fips = 29 if birth_state_abbrev == "MO"
replace birth_state_fips = 30 if birth_state_abbrev == "MT"
replace birth_state_fips = 31 if birth_state_abbrev == "NE"
replace birth_state_fips = 32 if birth_state_abbrev == "NV"
replace birth_state_fips = 33 if birth_state_abbrev == "NH"
replace birth_state_fips = 34 if birth_state_abbrev == "NJ"
replace birth_state_fips = 35 if birth_state_abbrev == "NM"
replace birth_state_fips = 36 if birth_state_abbrev == "NY"
replace birth_state_fips = 37 if birth_state_abbrev == "NC"
replace birth_state_fips = 38 if birth_state_abbrev == "ND"
replace birth_state_fips = 39 if birth_state_abbrev == "OH"
replace birth_state_fips = 40 if birth_state_abbrev == "OK"
replace birth_state_fips = 41 if birth_state_abbrev == "OR"
replace birth_state_fips = 42 if birth_state_abbrev == "PA"
replace birth_state_fips = 44 if birth_state_abbrev == "RI"
replace birth_state_fips = 45 if birth_state_abbrev == "SC"
replace birth_state_fips = 46 if birth_state_abbrev == "SD"
replace birth_state_fips = 47 if birth_state_abbrev == "TN"
replace birth_state_fips = 48 if birth_state_abbrev == "TX"
replace birth_state_fips = 49 if birth_state_abbrev == "UT"
replace birth_state_fips = 50 if birth_state_abbrev == "VT"
replace birth_state_fips = 51 if birth_state_abbrev == "VA"
replace birth_state_fips = 53 if birth_state_abbrev == "WA"
replace birth_state_fips = 54 if birth_state_abbrev == "WV"
replace birth_state_fips = 55 if birth_state_abbrev == "WI"
replace birth_state_fips = 56 if birth_state_abbrev == "WY"

*birth county of residence fips
gen county_res_fips = substr(v1, 114, 3)
destring county_res_fips, replace
gen countycode = (birth_state_fips*1000) + county_res_fips

gen marital = substr(v1,153,1)
gen mother_married = marital == "1"

gen mort_flag =  substr(v1, 868, 1)

drop v1
compress

save "data\stl_`year'.dta", replace


*2006 - 2013 have the same data dictionary so I can process them in a loop
forvalues year = 2006(1)2013{
*import raw data - start with denominator
import delimited "data\LinkedCohort`year'\LKBC`year'USDenom.AllCnty.txt", clear

*year of birth
gen year = substr(v1, 15, 4)
destring year, replace

gen month = substr(v1, 19, 2)
destring month, replace

gen mother_age = substr(v1,89,2)
destring mother_age, replace

*mother race
gen mother_race = substr(v1, 143, 1)
destring mother_race, replace
label define mom_race_l 1 "White" 2 "Black" 3 "AIAN" 4 "AAPI"
label values mother_race mom_race_l

*weeks of gestation
gen gestation = substr(v1, 451, 2)
destring gestation, replace
replace gestation = . if gestation == 99

*birth state of residence fips code
gen birth_state_abbrev = substr(v1, 109, 2)
gen birth_state_fips = .
replace birth_state_fips = 1 if birth_state_abbrev == "AL"
replace birth_state_fips = 2 if birth_state_abbrev == "AK"
replace birth_state_fips = 4 if birth_state_abbrev == "AZ"
replace birth_state_fips = 5 if birth_state_abbrev == "AR"
replace birth_state_fips = 6 if birth_state_abbrev == "CA"
replace birth_state_fips = 8 if birth_state_abbrev == "CO"
replace birth_state_fips = 9 if birth_state_abbrev == "CT"
replace birth_state_fips = 10 if birth_state_abbrev == "DE"
replace birth_state_fips = 11 if birth_state_abbrev == "DC"
replace birth_state_fips = 12 if birth_state_abbrev == "FL"
replace birth_state_fips = 13 if birth_state_abbrev == "GA"
replace birth_state_fips = 15 if birth_state_abbrev == "HI"
replace birth_state_fips = 16 if birth_state_abbrev == "ID"
replace birth_state_fips = 17 if birth_state_abbrev == "IL"
replace birth_state_fips = 18 if birth_state_abbrev == "IN"
replace birth_state_fips = 19 if birth_state_abbrev == "IA"
replace birth_state_fips = 20 if birth_state_abbrev == "KS"
replace birth_state_fips = 21 if birth_state_abbrev == "KY"
replace birth_state_fips = 22 if birth_state_abbrev == "LA"
replace birth_state_fips = 23 if birth_state_abbrev == "ME"
replace birth_state_fips = 24 if birth_state_abbrev == "MD"
replace birth_state_fips = 25 if birth_state_abbrev == "MA"
replace birth_state_fips = 26 if birth_state_abbrev == "MI"
replace birth_state_fips = 27 if birth_state_abbrev == "MN"
replace birth_state_fips = 28 if birth_state_abbrev == "MS"
replace birth_state_fips = 29 if birth_state_abbrev == "MO"
replace birth_state_fips = 30 if birth_state_abbrev == "MT"
replace birth_state_fips = 31 if birth_state_abbrev == "NE"
replace birth_state_fips = 32 if birth_state_abbrev == "NV"
replace birth_state_fips = 33 if birth_state_abbrev == "NH"
replace birth_state_fips = 34 if birth_state_abbrev == "NJ"
replace birth_state_fips = 35 if birth_state_abbrev == "NM"
replace birth_state_fips = 36 if birth_state_abbrev == "NY"
replace birth_state_fips = 37 if birth_state_abbrev == "NC"
replace birth_state_fips = 38 if birth_state_abbrev == "ND"
replace birth_state_fips = 39 if birth_state_abbrev == "OH"
replace birth_state_fips = 40 if birth_state_abbrev == "OK"
replace birth_state_fips = 41 if birth_state_abbrev == "OR"
replace birth_state_fips = 42 if birth_state_abbrev == "PA"
replace birth_state_fips = 44 if birth_state_abbrev == "RI"
replace birth_state_fips = 45 if birth_state_abbrev == "SC"
replace birth_state_fips = 46 if birth_state_abbrev == "SD"
replace birth_state_fips = 47 if birth_state_abbrev == "TN"
replace birth_state_fips = 48 if birth_state_abbrev == "TX"
replace birth_state_fips = 49 if birth_state_abbrev == "UT"
replace birth_state_fips = 50 if birth_state_abbrev == "VT"
replace birth_state_fips = 51 if birth_state_abbrev == "VA"
replace birth_state_fips = 53 if birth_state_abbrev == "WA"
replace birth_state_fips = 54 if birth_state_abbrev == "WV"
replace birth_state_fips = 55 if birth_state_abbrev == "WI"
replace birth_state_fips = 56 if birth_state_abbrev == "WY"

*birth county of residence fips
gen county_res_fips = substr(v1, 114, 3)
destring county_res_fips, replace
gen countycode = (birth_state_fips*1000) + county_res_fips

gen mort_flag =  substr(v1, 868, 1)

gen marital = substr(v1,153,1)
gen mother_married = marital == "1"

drop v1
compress

save "data\stl_`year'.dta", replace
}

clear
forvalues year = 2002(1)2013 {
	append using data\stl_`year'.dta	
}

replace countycode = (1000*birth_state_fips) + county_res_fips if year < 2003

gen mother_white = mother_race == 1 | mother_race_full == 1
gen mother_black = mother_race == 2 | mother_race_full == 2

gen ext_preterm = gestation < 28
gen st_louis = countycode == 29189

replace infant_mortality = 1 if mort_flag == "1"
replace infant_mortality = 0 if mort_flag == "2"

*save cleaned raw data file
save "data\stl_02_13.dta", replace
