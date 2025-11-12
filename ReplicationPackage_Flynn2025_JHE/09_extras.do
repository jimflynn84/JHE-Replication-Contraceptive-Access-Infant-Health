*this script creates additional figures from the paper


*provide evidence that a 'convex hull' exists
*these figures are combined into Appendix Figure 1
use data/stl_data_new.dta, clear
drop if min_births < 8000

egen county_num = group(countycode)

#delimit:
twoway
(line EPB year if county_num == 1,lp(solid)lw(vthin))
(line EPB year if county_num == 2,lp(solid)lw(vthin))
(line EPB year if county_num == 3,lp(solid)lw(vthin))
(line EPB year if county_num == 4,lp(solid)lw(vthin))
(line EPB year if county_num == 5,lp(solid)lw(vthin))
(line EPB year if county_num == 6,lp(solid)lw(vthin))
(line EPB year if county_num == 7,lp(solid)lw(vthin))
(line EPB year if county_num == 8,lp(solid)lw(vthin))
(line EPB year if county_num == 9,lp(solid)lw(vthin))
(line EPB year if county_num == 10,lp(solid)lw(vthin))
(line EPB year if county_num == 11,lp(solid)lw(vthin))
(line EPB year if county_num == 12,lp(solid)lw(vthin))
(line EPB year if county_num == 13,lp(solid)lw(vthin))
(line EPB year if county_num == 14,lp(solid)lw(vthin))
(line EPB year if county_num == 15,lp(solid)lw(vthin))
(line EPB year if county_num == 16,lp(solid)lw(vthin))
(line EPB year if county_num == 17,lp(solid)lw(vthin))
(line EPB year if county_num == 18,lp(solid)lw(vthin))
(line EPB year if county_num == 19,lp(solid)lw(vthin))
(line EPB year if county_num == 20,lp(solid)lw(vthin))
(line EPB year if county_num == 21,lp(solid)lw(vthin))
(line EPB year if county_num == 22,lp(solid)lw(vthin))
(line EPB year if county_num == 23,lp(solid)lw(vthin))
(line EPB year if county_num == 24,lp(solid)lw(vthin))
(line EPB year if county_num == 25,lp(solid)lw(vthin))
(line EPB year if county_num == 26,lp(solid)lw(vthin))
(line EPB year if county_num == 27,lp(solid)lw(vthin))
(line EPB year if county_num == 28,lp(solid)lw(vthin))
(line EPB year if county_num == 29,lp(solid)lw(vthin))
(line EPB year if county_num == 30,lp(solid)lw(vthin))
(line EPB year if county_num == 31,lp(solid)lw(vthin))
(line EPB year if county_num == 32,lp(solid)lw(vthin))
(line EPB year if county_num == 33,lp(solid)lw(vthin))
(line EPB year if county_num == 34,lp(solid)lw(vthin))
(line EPB year if county_num == 35,lp(solid)lw(vthin))
(line EPB year if county_num == 36,lp(solid)lw(vthin))
(line EPB year if county_num == 37,lp(solid)lw(vthin))
(line EPB year if county_num == 38,lp(solid)lw(vthin))
(line EPB year if county_num == 39,lp(solid)lw(vthin))
(line EPB year if county_num == 40,lp(solid)lw(vthin))
(line EPB year if county_num == 41,lp(solid)lw(vthin))
(line EPB year if county_num == 42,lp(solid)lw(vthin))
(line EPB year if county_num == 43,lp(solid)lw(vthin))
(line EPB year if county_num == 44,lp(solid)lw(vthin))
(line EPB year if county_num == 45,lp(solid)lw(vthin))
(line EPB year if county_num == 46,lp(solid)lw(vthin))
(line EPB year if county_num == 47,lp(solid)lw(vthin))
(line EPB year if county_num == 48,lp(solid)lw(vthin))
(line EPB year if county_num == 49,lp(solid)lw(vthin))
(line EPB year if county_num == 50,lp(solid)lw(vthin))
(line EPB year if county_num == 52,lp(solid)lw(vthin))
(line EPB year if county_num == 53,lp(solid)lw(vthin))
(line EPB year if county_num == 54,lp(solid)lw(vthin))
(line EPB year if county_num == 55,lp(solid)lw(vthin))
(line EPB year if county_num == 56,lp(solid)lw(vthin))
(line EPB year if county_num == 57,lp(solid)lw(vthin))
(line EPB year if county_num == 58,lp(solid)lw(vthin))
(line EPB year if county_num == 59,lp(solid)lw(vthin))
(line EPB year if county_num == 60,lp(solid)lw(vthin))
(line EPB year if county_num == 61,lp(solid)lw(vthin))
(line EPB year if county_num == 62,lp(solid)lw(vthin))
(line EPB year if county_num == 63,lp(solid)lw(vthin))
(line EPB year if county_num == 64,lp(solid)lw(vthin))
(line EPB year if county_num == 65,lp(solid)lw(vthin))
(line EPB year if county_num == 66,lp(solid)lw(vthin))
(line EPB year if county_num == 67,lp(solid)lw(vthin))
(line EPB year if county_num == 68,lp(solid)lw(vthin))
(line EPB year if county_num == 69,lp(solid)lw(vthin))
(line EPB year if county_num == 70,lp(solid)lw(vthin))
(line EPB year if county_num == 71,lp(solid)lw(vthin))
(line EPB year if county_num == 72,lp(solid)lw(vthin))
(line EPB year if county_num == 73,lp(solid)lw(vthin))
(line EPB year if county_num == 74,lp(solid)lw(vthin))
(line EPB year if county_num == 75,lp(solid)lw(vthin))
(line EPB year if county_num == 76,lp(solid)lw(vthin))
(line EPB year if county_num == 77,lp(solid)lw(vthin))
(line EPB year if county_num == 78,lp(solid)lw(vthin))
(line EPB year if county_num == 79,lp(solid)lw(vthin))
(line EPB year if county_num == 80,lp(solid)lw(vthin))
(line EPB year if county_num == 81,lp(solid)lw(vthin))
(line EPB year if county_num == 82,lp(solid)lw(vthin))
(line EPB year if county_num == 83,lp(solid)lw(vthin))
(line EPB year if county_num == 84,lp(solid)lw(vthin))
(line EPB year if county_num == 85,lp(solid)lw(vthin))
(line EPB year if county_num == 86,lp(solid)lw(vthin))
(line EPB year if county_num == 87,lp(solid)lw(vthin))
(line EPB year if county_num == 88,lp(solid)lw(vthin))
(line EPB year if county_num == 89,lp(solid)lw(vthin))
(line EPB year if county_num == 90,lp(solid)lw(vthin))
(line EPB year if county_num == 91,lp(solid)lw(vthin))
(line EPB year if county_num == 92,lp(solid)lw(vthin))
(line EPB year if county_num == 93,lp(solid)lw(vthin))
(line EPB year if county_num == 94,lp(solid)lw(vthin))
(line EPB year if county_num == 95,lp(solid)lw(vthin))
(line EPB year if st_louis == 1,lp(solid)lw(vthick)lcolor(black)), xline(2007)
xticks(2002(2)2013) xlabels(2002(2)2013) legend(off)
ytitle("EPBs per 1,000 Live Births") xtitle("");
#delimit cr
*save as plots\epb_ts_all.gph

#delimit:
twoway
(line IMR year if county_num == 1,lp(solid)lw(vthin))
(line IMR year if county_num == 2,lp(solid)lw(vthin))
(line IMR year if county_num == 3,lp(solid)lw(vthin))
(line IMR year if county_num == 4,lp(solid)lw(vthin))
(line IMR year if county_num == 5,lp(solid)lw(vthin))
(line IMR year if county_num == 6,lp(solid)lw(vthin))
(line IMR year if county_num == 7,lp(solid)lw(vthin))
(line IMR year if county_num == 8,lp(solid)lw(vthin))
(line IMR year if county_num == 9,lp(solid)lw(vthin))
(line IMR year if county_num == 10,lp(solid)lw(vthin))
(line IMR year if county_num == 11,lp(solid)lw(vthin))
(line IMR year if county_num == 12,lp(solid)lw(vthin))
(line IMR year if county_num == 13,lp(solid)lw(vthin))
(line IMR year if county_num == 14,lp(solid)lw(vthin))
(line IMR year if county_num == 15,lp(solid)lw(vthin))
(line IMR year if county_num == 16,lp(solid)lw(vthin))
(line IMR year if county_num == 17,lp(solid)lw(vthin))
(line IMR year if county_num == 18,lp(solid)lw(vthin))
(line IMR year if county_num == 19,lp(solid)lw(vthin))
(line IMR year if county_num == 20,lp(solid)lw(vthin))
(line IMR year if county_num == 21,lp(solid)lw(vthin))
(line IMR year if county_num == 22,lp(solid)lw(vthin))
(line IMR year if county_num == 23,lp(solid)lw(vthin))
(line IMR year if county_num == 24,lp(solid)lw(vthin))
(line IMR year if county_num == 25,lp(solid)lw(vthin))
(line IMR year if county_num == 26,lp(solid)lw(vthin))
(line IMR year if county_num == 27,lp(solid)lw(vthin))
(line IMR year if county_num == 28,lp(solid)lw(vthin))
(line IMR year if county_num == 29,lp(solid)lw(vthin))
(line IMR year if county_num == 30,lp(solid)lw(vthin))
(line IMR year if county_num == 31,lp(solid)lw(vthin))
(line IMR year if county_num == 32,lp(solid)lw(vthin))
(line IMR year if county_num == 33,lp(solid)lw(vthin))
(line IMR year if county_num == 34,lp(solid)lw(vthin))
(line IMR year if county_num == 35,lp(solid)lw(vthin))
(line IMR year if county_num == 36,lp(solid)lw(vthin))
(line IMR year if county_num == 37,lp(solid)lw(vthin))
(line IMR year if county_num == 38,lp(solid)lw(vthin))
(line IMR year if county_num == 39,lp(solid)lw(vthin))
(line IMR year if county_num == 40,lp(solid)lw(vthin))
(line IMR year if county_num == 41,lp(solid)lw(vthin))
(line IMR year if county_num == 42,lp(solid)lw(vthin))
(line IMR year if county_num == 43,lp(solid)lw(vthin))
(line IMR year if county_num == 44,lp(solid)lw(vthin))
(line IMR year if county_num == 45,lp(solid)lw(vthin))
(line IMR year if county_num == 46,lp(solid)lw(vthin))
(line IMR year if county_num == 47,lp(solid)lw(vthin))
(line IMR year if county_num == 48,lp(solid)lw(vthin))
(line IMR year if county_num == 49,lp(solid)lw(vthin))
(line IMR year if county_num == 50,lp(solid)lw(vthin))
(line IMR year if county_num == 52,lp(solid)lw(vthin))
(line IMR year if county_num == 53,lp(solid)lw(vthin))
(line IMR year if county_num == 54,lp(solid)lw(vthin))
(line IMR year if county_num == 55,lp(solid)lw(vthin))
(line IMR year if county_num == 56,lp(solid)lw(vthin))
(line IMR year if county_num == 57,lp(solid)lw(vthin))
(line IMR year if county_num == 58,lp(solid)lw(vthin))
(line IMR year if county_num == 59,lp(solid)lw(vthin))
(line IMR year if county_num == 60,lp(solid)lw(vthin))
(line IMR year if county_num == 61,lp(solid)lw(vthin))
(line IMR year if county_num == 62,lp(solid)lw(vthin))
(line IMR year if county_num == 63,lp(solid)lw(vthin))
(line IMR year if county_num == 64,lp(solid)lw(vthin))
(line IMR year if county_num == 65,lp(solid)lw(vthin))
(line IMR year if county_num == 66,lp(solid)lw(vthin))
(line IMR year if county_num == 67,lp(solid)lw(vthin))
(line IMR year if county_num == 68,lp(solid)lw(vthin))
(line IMR year if county_num == 69,lp(solid)lw(vthin))
(line IMR year if county_num == 70,lp(solid)lw(vthin))
(line IMR year if county_num == 71,lp(solid)lw(vthin))
(line IMR year if county_num == 72,lp(solid)lw(vthin))
(line IMR year if county_num == 73,lp(solid)lw(vthin))
(line IMR year if county_num == 74,lp(solid)lw(vthin))
(line IMR year if county_num == 75,lp(solid)lw(vthin))
(line IMR year if county_num == 76,lp(solid)lw(vthin))
(line IMR year if county_num == 77,lp(solid)lw(vthin))
(line IMR year if county_num == 78,lp(solid)lw(vthin))
(line IMR year if county_num == 79,lp(solid)lw(vthin))
(line IMR year if county_num == 80,lp(solid)lw(vthin))
(line IMR year if county_num == 81,lp(solid)lw(vthin))
(line IMR year if county_num == 82,lp(solid)lw(vthin))
(line IMR year if county_num == 83,lp(solid)lw(vthin))
(line IMR year if county_num == 84,lp(solid)lw(vthin))
(line IMR year if county_num == 85,lp(solid)lw(vthin))
(line IMR year if county_num == 86,lp(solid)lw(vthin))
(line IMR year if county_num == 87,lp(solid)lw(vthin))
(line IMR year if county_num == 88,lp(solid)lw(vthin))
(line IMR year if county_num == 89,lp(solid)lw(vthin))
(line IMR year if county_num == 90,lp(solid)lw(vthin))
(line IMR year if county_num == 91,lp(solid)lw(vthin))
(line IMR year if county_num == 92,lp(solid)lw(vthin))
(line IMR year if county_num == 93,lp(solid)lw(vthin))
(line IMR year if county_num == 94,lp(solid)lw(vthin))
(line IMR year if county_num == 95,lp(solid)lw(vthin))
(line IMR year if st_louis == 1,lp(solid)lw(vthick)lcolor(black)), xline(2007)
xticks(2002(2)2013) xlabels(2002(2)2013) legend(off)
ytitle("Infant Mortality Rate") xtitle("");
#delimit cr
*save as plots\imr_ts_all.gph

*Black mothers
use data/stl_data_new_race.dta, clear

merge m:1 countycode using data/counties_8k.dta
keep if _merge == 3

keep if mother_black == 1
drop if min_births < 1000

tab year
egen county_num = group(countycode)
tab county_num if st_louis == 1

sort countycode year
#delimit:
twoway
(line EPB year if county_num == 1,lp(solid)lw(vthin))
(line EPB year if county_num == 2,lp(solid)lw(vthin))
(line EPB year if county_num == 3,lp(solid)lw(vthin))
(line EPB year if county_num == 4,lp(solid)lw(vthin))
(line EPB year if county_num == 5,lp(solid)lw(vthin))
(line EPB year if county_num == 6,lp(solid)lw(vthin))
(line EPB year if county_num == 7,lp(solid)lw(vthin))
(line EPB year if county_num == 8,lp(solid)lw(vthin))
(line EPB year if county_num == 9,lp(solid)lw(vthin))
(line EPB year if county_num == 10,lp(solid)lw(vthin))
(line EPB year if county_num == 11,lp(solid)lw(vthin))
(line EPB year if county_num == 12,lp(solid)lw(vthin))
(line EPB year if county_num == 13,lp(solid)lw(vthin))
(line EPB year if county_num == 14,lp(solid)lw(vthin))
(line EPB year if county_num == 15,lp(solid)lw(vthin))
(line EPB year if county_num == 16,lp(solid)lw(vthin))
(line EPB year if county_num == 17,lp(solid)lw(vthin))
(line EPB year if county_num == 18,lp(solid)lw(vthin))
(line EPB year if county_num == 19,lp(solid)lw(vthin))
(line EPB year if county_num == 20,lp(solid)lw(vthin))
(line EPB year if county_num == 21,lp(solid)lw(vthin))
(line EPB year if county_num == 22,lp(solid)lw(vthin))
(line EPB year if county_num == 23,lp(solid)lw(vthin))
(line EPB year if county_num == 24,lp(solid)lw(vthin))
(line EPB year if county_num == 25,lp(solid)lw(vthin))
(line EPB year if county_num == 26,lp(solid)lw(vthin))
(line EPB year if county_num == 27,lp(solid)lw(vthin))
(line EPB year if county_num == 28,lp(solid)lw(vthin))
(line EPB year if county_num == 29,lp(solid)lw(vthin))
(line EPB year if county_num == 30,lp(solid)lw(vthin))
(line EPB year if county_num == 31,lp(solid)lw(vthin))
(line EPB year if county_num == 32,lp(solid)lw(vthin))
(line EPB year if county_num == 33,lp(solid)lw(vthin))
(line EPB year if county_num == 34,lp(solid)lw(vthin))
(line EPB year if county_num == 35,lp(solid)lw(vthin))
(line EPB year if county_num == 36,lp(solid)lw(vthin))
(line EPB year if county_num == 37,lp(solid)lw(vthin))
(line EPB year if county_num == 38,lp(solid)lw(vthin))
(line EPB year if county_num == 39,lp(solid)lw(vthin))
(line EPB year if county_num == 40,lp(solid)lw(vthin))
(line EPB year if county_num == 41,lp(solid)lw(vthin))
(line EPB year if county_num == 42,lp(solid)lw(vthin))
(line EPB year if county_num == 43,lp(solid)lw(vthin))
(line EPB year if county_num == 44,lp(solid)lw(vthin))
(line EPB year if county_num == 45,lp(solid)lw(vthin))
(line EPB year if county_num == 46,lp(solid)lw(vthin))
(line EPB year if county_num == 47,lp(solid)lw(vthin))
(line EPB year if county_num == 48,lp(solid)lw(vthin))
(line EPB year if county_num == 49,lp(solid)lw(vthin))
(line EPB year if county_num == 50,lp(solid)lw(vthin))
(line EPB year if county_num == 51,lp(solid)lw(vthin))
(line EPB year if county_num == 52,lp(solid)lw(vthin))
(line EPB year if county_num == 53,lp(solid)lw(vthin))
(line EPB year if county_num == 54,lp(solid)lw(vthin))
(line EPB year if county_num == 55,lp(solid)lw(vthin))
(line EPB year if county_num == 56,lp(solid)lw(vthin))
(line EPB year if county_num == 57,lp(solid)lw(vthin))
(line EPB year if county_num == 58,lp(solid)lw(vthin))
(line EPB year if county_num == 59,lp(solid)lw(vthin))
(line EPB year if county_num == 60,lp(solid)lw(vthin))
(line EPB year if county_num == 61,lp(solid)lw(vthin))
(line EPB year if county_num == 62,lp(solid)lw(vthin))
(line EPB year if county_num == 63,lp(solid)lw(vthin))
(line EPB year if county_num == 64,lp(solid)lw(vthin))
(line EPB year if county_num == 65,lp(solid)lw(vthin))
(line EPB year if county_num == 66,lp(solid)lw(vthin))
(line EPB year if county_num == 67,lp(solid)lw(vthin))
(line EPB year if county_num == 68,lp(solid)lw(vthin))
(line EPB year if st_louis == 1,lp(solid)lw(vthick)lcolor(black)), xline(2007)
xticks(2002(2)2013) xlabels(2002(2)2013) legend(off)
ytitle("EPBs per 1,000 Live Births") xtitle("");
#delimit cr
*save as plots\epb_ts_black.gph

#delimit:
twoway
(line IMR year if county_num == 1,lp(solid)lw(vthin))
(line IMR year if county_num == 2,lp(solid)lw(vthin))
(line IMR year if county_num == 3,lp(solid)lw(vthin))
(line IMR year if county_num == 4,lp(solid)lw(vthin))
(line IMR year if county_num == 5,lp(solid)lw(vthin))
(line IMR year if county_num == 6,lp(solid)lw(vthin))
(line IMR year if county_num == 7,lp(solid)lw(vthin))
(line IMR year if county_num == 8,lp(solid)lw(vthin))
(line IMR year if county_num == 9,lp(solid)lw(vthin))
(line IMR year if county_num == 10,lp(solid)lw(vthin))
(line IMR year if county_num == 11,lp(solid)lw(vthin))
(line IMR year if county_num == 12,lp(solid)lw(vthin))
(line IMR year if county_num == 13,lp(solid)lw(vthin))
(line IMR year if county_num == 14,lp(solid)lw(vthin))
(line IMR year if county_num == 15,lp(solid)lw(vthin))
(line IMR year if county_num == 16,lp(solid)lw(vthin))
(line IMR year if county_num == 17,lp(solid)lw(vthin))
(line IMR year if county_num == 18,lp(solid)lw(vthin))
(line IMR year if county_num == 19,lp(solid)lw(vthin))
(line IMR year if county_num == 20,lp(solid)lw(vthin))
(line IMR year if county_num == 21,lp(solid)lw(vthin))
(line IMR year if county_num == 22,lp(solid)lw(vthin))
(line IMR year if county_num == 23,lp(solid)lw(vthin))
(line IMR year if county_num == 24,lp(solid)lw(vthin))
(line IMR year if county_num == 25,lp(solid)lw(vthin))
(line IMR year if county_num == 26,lp(solid)lw(vthin))
(line IMR year if county_num == 27,lp(solid)lw(vthin))
(line IMR year if county_num == 28,lp(solid)lw(vthin))
(line IMR year if county_num == 29,lp(solid)lw(vthin))
(line IMR year if county_num == 30,lp(solid)lw(vthin))
(line IMR year if county_num == 31,lp(solid)lw(vthin))
(line IMR year if county_num == 32,lp(solid)lw(vthin))
(line IMR year if county_num == 33,lp(solid)lw(vthin))
(line IMR year if county_num == 34,lp(solid)lw(vthin))
(line IMR year if county_num == 35,lp(solid)lw(vthin))
(line IMR year if county_num == 36,lp(solid)lw(vthin))
(line IMR year if county_num == 37,lp(solid)lw(vthin))
(line IMR year if county_num == 38,lp(solid)lw(vthin))
(line IMR year if county_num == 39,lp(solid)lw(vthin))
(line IMR year if county_num == 40,lp(solid)lw(vthin))
(line IMR year if county_num == 41,lp(solid)lw(vthin))
(line IMR year if county_num == 42,lp(solid)lw(vthin))
(line IMR year if county_num == 43,lp(solid)lw(vthin))
(line IMR year if county_num == 44,lp(solid)lw(vthin))
(line IMR year if county_num == 45,lp(solid)lw(vthin))
(line IMR year if county_num == 46,lp(solid)lw(vthin))
(line IMR year if county_num == 47,lp(solid)lw(vthin))
(line IMR year if county_num == 48,lp(solid)lw(vthin))
(line IMR year if county_num == 49,lp(solid)lw(vthin))
(line IMR year if county_num == 50,lp(solid)lw(vthin))
(line IMR year if county_num == 52,lp(solid)lw(vthin))
(line IMR year if county_num == 53,lp(solid)lw(vthin))
(line IMR year if county_num == 54,lp(solid)lw(vthin))
(line IMR year if county_num == 55,lp(solid)lw(vthin))
(line IMR year if county_num == 56,lp(solid)lw(vthin))
(line IMR year if county_num == 57,lp(solid)lw(vthin))
(line IMR year if county_num == 58,lp(solid)lw(vthin))
(line IMR year if county_num == 59,lp(solid)lw(vthin))
(line IMR year if county_num == 60,lp(solid)lw(vthin))
(line IMR year if county_num == 61,lp(solid)lw(vthin))
(line IMR year if county_num == 62,lp(solid)lw(vthin))
(line IMR year if county_num == 63,lp(solid)lw(vthin))
(line IMR year if county_num == 64,lp(solid)lw(vthin))
(line IMR year if county_num == 65,lp(solid)lw(vthin))
(line IMR year if county_num == 66,lp(solid)lw(vthin))
(line IMR year if county_num == 67,lp(solid)lw(vthin))
(line IMR year if county_num == 68,lp(solid)lw(vthin))
(line IMR year if st_louis == 1,lp(solid)lw(vthick)lcolor(black)), xline(2007)
xticks(2002(2)2013) xlabels(2002(2)2013) legend(off)
ytitle("Infant Mortality Rate") xtitle("");
#delimit cr
*save as plots\imr_ts_black.gph

*White mothers
use data/stl_data_new_race.dta, clear

merge m:1 countycode using data/counties_8k.dta
keep if _merge == 3

keep if mother_black == 0

tab year
egen county_num = group(countycode)
tab county_num if st_louis == 1

sort countycode year

#delimit:
twoway
(line EPB year if county_num == 1,lp(solid)lw(vthin))
(line EPB year if county_num == 2,lp(solid)lw(vthin))
(line EPB year if county_num == 3,lp(solid)lw(vthin))
(line EPB year if county_num == 4,lp(solid)lw(vthin))
(line EPB year if county_num == 5,lp(solid)lw(vthin))
(line EPB year if county_num == 6,lp(solid)lw(vthin))
(line EPB year if county_num == 7,lp(solid)lw(vthin))
(line EPB year if county_num == 8,lp(solid)lw(vthin))
(line EPB year if county_num == 9,lp(solid)lw(vthin))
(line EPB year if county_num == 10,lp(solid)lw(vthin))
(line EPB year if county_num == 11,lp(solid)lw(vthin))
(line EPB year if county_num == 12,lp(solid)lw(vthin))
(line EPB year if county_num == 13,lp(solid)lw(vthin))
(line EPB year if county_num == 14,lp(solid)lw(vthin))
(line EPB year if county_num == 15,lp(solid)lw(vthin))
(line EPB year if county_num == 16,lp(solid)lw(vthin))
(line EPB year if county_num == 17,lp(solid)lw(vthin))
(line EPB year if county_num == 18,lp(solid)lw(vthin))
(line EPB year if county_num == 19,lp(solid)lw(vthin))
(line EPB year if county_num == 20,lp(solid)lw(vthin))
(line EPB year if county_num == 21,lp(solid)lw(vthin))
(line EPB year if county_num == 22,lp(solid)lw(vthin))
(line EPB year if county_num == 23,lp(solid)lw(vthin))
(line EPB year if county_num == 24,lp(solid)lw(vthin))
(line EPB year if county_num == 25,lp(solid)lw(vthin))
(line EPB year if county_num == 26,lp(solid)lw(vthin))
(line EPB year if county_num == 27,lp(solid)lw(vthin))
(line EPB year if county_num == 28,lp(solid)lw(vthin))
(line EPB year if county_num == 29,lp(solid)lw(vthin))
(line EPB year if county_num == 30,lp(solid)lw(vthin))
(line EPB year if county_num == 31,lp(solid)lw(vthin))
(line EPB year if county_num == 32,lp(solid)lw(vthin))
(line EPB year if county_num == 33,lp(solid)lw(vthin))
(line EPB year if county_num == 34,lp(solid)lw(vthin))
(line EPB year if county_num == 35,lp(solid)lw(vthin))
(line EPB year if county_num == 36,lp(solid)lw(vthin))
(line EPB year if county_num == 37,lp(solid)lw(vthin))
(line EPB year if county_num == 38,lp(solid)lw(vthin))
(line EPB year if county_num == 39,lp(solid)lw(vthin))
(line EPB year if county_num == 40,lp(solid)lw(vthin))
(line EPB year if county_num == 41,lp(solid)lw(vthin))
(line EPB year if county_num == 42,lp(solid)lw(vthin))
(line EPB year if county_num == 43,lp(solid)lw(vthin))
(line EPB year if county_num == 44,lp(solid)lw(vthin))
(line EPB year if county_num == 45,lp(solid)lw(vthin))
(line EPB year if county_num == 46,lp(solid)lw(vthin))
(line EPB year if county_num == 47,lp(solid)lw(vthin))
(line EPB year if county_num == 48,lp(solid)lw(vthin))
(line EPB year if county_num == 49,lp(solid)lw(vthin))
(line EPB year if county_num == 50,lp(solid)lw(vthin))
(line EPB year if county_num == 52,lp(solid)lw(vthin))
(line EPB year if county_num == 53,lp(solid)lw(vthin))
(line EPB year if county_num == 54,lp(solid)lw(vthin))
(line EPB year if county_num == 55,lp(solid)lw(vthin))
(line EPB year if county_num == 56,lp(solid)lw(vthin))
(line EPB year if county_num == 57,lp(solid)lw(vthin))
(line EPB year if county_num == 58,lp(solid)lw(vthin))
(line EPB year if county_num == 59,lp(solid)lw(vthin))
(line EPB year if county_num == 60,lp(solid)lw(vthin))
(line EPB year if county_num == 61,lp(solid)lw(vthin))
(line EPB year if county_num == 62,lp(solid)lw(vthin))
(line EPB year if county_num == 63,lp(solid)lw(vthin))
(line EPB year if county_num == 64,lp(solid)lw(vthin))
(line EPB year if county_num == 65,lp(solid)lw(vthin))
(line EPB year if county_num == 66,lp(solid)lw(vthin))
(line EPB year if county_num == 67,lp(solid)lw(vthin))
(line EPB year if county_num == 68,lp(solid)lw(vthin))
(line EPB year if county_num == 69,lp(solid)lw(vthin))
(line EPB year if county_num == 70,lp(solid)lw(vthin))
(line EPB year if county_num == 71,lp(solid)lw(vthin))
(line EPB year if county_num == 72,lp(solid)lw(vthin))
(line EPB year if county_num == 73,lp(solid)lw(vthin))
(line EPB year if county_num == 74,lp(solid)lw(vthin))
(line EPB year if county_num == 75,lp(solid)lw(vthin))
(line EPB year if county_num == 76,lp(solid)lw(vthin))
(line EPB year if county_num == 77,lp(solid)lw(vthin))
(line EPB year if county_num == 78,lp(solid)lw(vthin))
(line EPB year if county_num == 79,lp(solid)lw(vthin))
(line EPB year if county_num == 80,lp(solid)lw(vthin))
(line EPB year if county_num == 81,lp(solid)lw(vthin))
(line EPB year if county_num == 82,lp(solid)lw(vthin))
(line EPB year if county_num == 83,lp(solid)lw(vthin))
(line EPB year if county_num == 84,lp(solid)lw(vthin))
(line EPB year if county_num == 85,lp(solid)lw(vthin))
(line EPB year if county_num == 86,lp(solid)lw(vthin))
(line EPB year if county_num == 87,lp(solid)lw(vthin))
(line EPB year if county_num == 88,lp(solid)lw(vthin))
(line EPB year if county_num == 89,lp(solid)lw(vthin))
(line EPB year if county_num == 90,lp(solid)lw(vthin))
(line EPB year if county_num == 91,lp(solid)lw(vthin))
(line EPB year if county_num == 92,lp(solid)lw(vthin))
(line EPB year if county_num == 93,lp(solid)lw(vthin))
(line EPB year if county_num == 94,lp(solid)lw(vthin))
(line EPB year if county_num == 95,lp(solid)lw(vthin))
(line EPB year if st_louis == 1,lp(solid)lw(vthick)lcolor(black)), xline(2007)
xticks(2002(2)2013) xlabels(2002(2)2013) legend(off)
ytitle("EPBs per 1,000 Live Births") xtitle("");
#delimit cr
*save as plots\epb_ts_white.gph

#delimit:
twoway
(line IMR year if county_num == 1,lp(solid)lw(vthin))
(line IMR year if county_num == 2,lp(solid)lw(vthin))
(line IMR year if county_num == 3,lp(solid)lw(vthin))
(line IMR year if county_num == 4,lp(solid)lw(vthin))
(line IMR year if county_num == 5,lp(solid)lw(vthin))
(line IMR year if county_num == 6,lp(solid)lw(vthin))
(line IMR year if county_num == 7,lp(solid)lw(vthin))
(line IMR year if county_num == 8,lp(solid)lw(vthin))
(line IMR year if county_num == 9,lp(solid)lw(vthin))
(line IMR year if county_num == 10,lp(solid)lw(vthin))
(line IMR year if county_num == 11,lp(solid)lw(vthin))
(line IMR year if county_num == 12,lp(solid)lw(vthin))
(line IMR year if county_num == 13,lp(solid)lw(vthin))
(line IMR year if county_num == 14,lp(solid)lw(vthin))
(line IMR year if county_num == 15,lp(solid)lw(vthin))
(line IMR year if county_num == 16,lp(solid)lw(vthin))
(line IMR year if county_num == 17,lp(solid)lw(vthin))
(line IMR year if county_num == 18,lp(solid)lw(vthin))
(line IMR year if county_num == 19,lp(solid)lw(vthin))
(line IMR year if county_num == 20,lp(solid)lw(vthin))
(line IMR year if county_num == 21,lp(solid)lw(vthin))
(line IMR year if county_num == 22,lp(solid)lw(vthin))
(line IMR year if county_num == 23,lp(solid)lw(vthin))
(line IMR year if county_num == 24,lp(solid)lw(vthin))
(line IMR year if county_num == 25,lp(solid)lw(vthin))
(line IMR year if county_num == 26,lp(solid)lw(vthin))
(line IMR year if county_num == 27,lp(solid)lw(vthin))
(line IMR year if county_num == 28,lp(solid)lw(vthin))
(line IMR year if county_num == 29,lp(solid)lw(vthin))
(line IMR year if county_num == 30,lp(solid)lw(vthin))
(line IMR year if county_num == 31,lp(solid)lw(vthin))
(line IMR year if county_num == 32,lp(solid)lw(vthin))
(line IMR year if county_num == 33,lp(solid)lw(vthin))
(line IMR year if county_num == 34,lp(solid)lw(vthin))
(line IMR year if county_num == 35,lp(solid)lw(vthin))
(line IMR year if county_num == 36,lp(solid)lw(vthin))
(line IMR year if county_num == 37,lp(solid)lw(vthin))
(line IMR year if county_num == 38,lp(solid)lw(vthin))
(line IMR year if county_num == 39,lp(solid)lw(vthin))
(line IMR year if county_num == 40,lp(solid)lw(vthin))
(line IMR year if county_num == 41,lp(solid)lw(vthin))
(line IMR year if county_num == 42,lp(solid)lw(vthin))
(line IMR year if county_num == 43,lp(solid)lw(vthin))
(line IMR year if county_num == 44,lp(solid)lw(vthin))
(line IMR year if county_num == 45,lp(solid)lw(vthin))
(line IMR year if county_num == 46,lp(solid)lw(vthin))
(line IMR year if county_num == 47,lp(solid)lw(vthin))
(line IMR year if county_num == 48,lp(solid)lw(vthin))
(line IMR year if county_num == 49,lp(solid)lw(vthin))
(line IMR year if county_num == 50,lp(solid)lw(vthin))
(line IMR year if county_num == 52,lp(solid)lw(vthin))
(line IMR year if county_num == 53,lp(solid)lw(vthin))
(line IMR year if county_num == 54,lp(solid)lw(vthin))
(line IMR year if county_num == 55,lp(solid)lw(vthin))
(line IMR year if county_num == 56,lp(solid)lw(vthin))
(line IMR year if county_num == 57,lp(solid)lw(vthin))
(line IMR year if county_num == 58,lp(solid)lw(vthin))
(line IMR year if county_num == 59,lp(solid)lw(vthin))
(line IMR year if county_num == 60,lp(solid)lw(vthin))
(line IMR year if county_num == 61,lp(solid)lw(vthin))
(line IMR year if county_num == 62,lp(solid)lw(vthin))
(line IMR year if county_num == 63,lp(solid)lw(vthin))
(line IMR year if county_num == 64,lp(solid)lw(vthin))
(line IMR year if county_num == 65,lp(solid)lw(vthin))
(line IMR year if county_num == 66,lp(solid)lw(vthin))
(line IMR year if county_num == 67,lp(solid)lw(vthin))
(line IMR year if county_num == 68,lp(solid)lw(vthin))
(line IMR year if county_num == 69,lp(solid)lw(vthin))
(line IMR year if county_num == 70,lp(solid)lw(vthin))
(line IMR year if county_num == 71,lp(solid)lw(vthin))
(line IMR year if county_num == 72,lp(solid)lw(vthin))
(line IMR year if county_num == 73,lp(solid)lw(vthin))
(line IMR year if county_num == 74,lp(solid)lw(vthin))
(line IMR year if county_num == 75,lp(solid)lw(vthin))
(line IMR year if county_num == 76,lp(solid)lw(vthin))
(line IMR year if county_num == 77,lp(solid)lw(vthin))
(line IMR year if county_num == 78,lp(solid)lw(vthin))
(line IMR year if county_num == 79,lp(solid)lw(vthin))
(line IMR year if county_num == 80,lp(solid)lw(vthin))
(line IMR year if county_num == 81,lp(solid)lw(vthin))
(line IMR year if county_num == 82,lp(solid)lw(vthin))
(line IMR year if county_num == 83,lp(solid)lw(vthin))
(line IMR year if county_num == 84,lp(solid)lw(vthin))
(line IMR year if county_num == 85,lp(solid)lw(vthin))
(line IMR year if county_num == 86,lp(solid)lw(vthin))
(line IMR year if county_num == 87,lp(solid)lw(vthin))
(line IMR year if county_num == 88,lp(solid)lw(vthin))
(line IMR year if county_num == 89,lp(solid)lw(vthin))
(line IMR year if county_num == 90,lp(solid)lw(vthin))
(line IMR year if county_num == 91,lp(solid)lw(vthin))
(line IMR year if county_num == 92,lp(solid)lw(vthin))
(line IMR year if county_num == 93,lp(solid)lw(vthin))
(line IMR year if county_num == 94,lp(solid)lw(vthin))
(line IMR year if county_num == 95,lp(solid)lw(vthin))
(line IMR year if st_louis == 1,lp(solid)lw(vthick)lcolor(black)), xline(2007)
xticks(2002(2)2013) xlabels(2002(2)2013) legend(off)
ytitle("Infant Mortality Rate") xtitle("");
#delimit cr
*save as plots\imr_ts_white.gph

*combined figures into Appendix Figure 1
graph combine plots\epb_ts_all.gph plots\imr_ts_all.gph plots\epb_ts_black.gph plots\imr_ts_black.gph plots\epb_ts_white.gph plots\imr_ts_white.gph, rows(3)

****************************
*Check stability of weights*
****************************

*I don't care about standard errors, just want the weights
global reps 2

use data/stl_data_new.dta, clear

xtset countycode year 

gen treat = st_louis == 1 & year > 2007

keep if min_births > 8000

sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)

matrix weights = e(omega)
svmat double weights, names(weight)

preserve
keep weight1 weight2
drop if missing(weight2)
rename weight1 county_weight 
rename weight2 countycode
save data/county_weights_epb, replace
restore

drop weight*

sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)

matrix weights = e(omega)
svmat double weights, names(weight)

preserve
keep weight1 weight2
drop if missing(weight2)
rename weight1 county_weight 
rename weight2 countycode
save data/county_weights_imr, replace
restore

*iterate through and drop each year, then save weights
forvalues year = 2002(1)2007{
use data/stl_data_new.dta, clear

drop if year == `year'
xtset countycode year 
gen treat = st_louis == 1 & year > 2007
keep if min_births > 8000

sdid EPB countycode year treat, vce(placebo) reps($reps) seed(123)

matrix weights = e(omega)
svmat double weights, names(weight)

preserve
keep weight1 weight2
drop if missing(weight2)
rename weight1 county_weight 
rename weight2 countycode
save data/county_weights_epb_`year', replace
restore

drop weight*

sdid IMR countycode year treat, vce(placebo) reps($reps) seed(123)

matrix weights = e(omega)
svmat double weights, names(weight)

preserve
keep weight1 weight2
drop if missing(weight2)
rename weight1 county_weight 
rename weight2 countycode
save data/county_weights_imr_`year', replace
restore
}


*2002
clear
use data/county_weights_epb.dta
rename county_weight all_weight

merge 1:1 countycode using data/county_weights_epb_2002.dta
twoway scatter all_weight county_weight
reg all county_, robust
parmest, saving(data/epb_2002.dta,replace)

clear
use data/county_weights_imr.dta
rename county_weight all_weight

merge 1:1 countycode using data/county_weights_imr_2002.dta
twoway scatter all_weight county_weight
reg all county_, robust
parmest, saving(data/imr_2002.dta,replace)


*2003
clear
use data/county_weights_epb.dta
rename county_weight all_weight

merge 1:1 countycode using data/county_weights_epb_2003.dta
twoway scatter all_weight county_weight, xtitle("2002 and 2004-2007 weights") ytitle("2002-2007 weights")
reg all county_, robust
parmest, saving(data/epb_2003.dta,replace)

clear
use data/county_weights_imr.dta
rename county_weight all_weight

merge 1:1 countycode using data/county_weights_imr_2003.dta
twoway scatter all_weight county_weight, xtitle("2002 and 2004-2007 weights") ytitle("2002-2007 weights")
reg all county_, robust
parmest, saving(data/imr_2003.dta,replace)



clear
use data/county_weights_epb.dta
rename county_weight all_weight

merge 1:1 countycode using data/county_weights_epb_2004.dta
twoway scatter all_weight county_weight, xtitle("2002-2003 and 2005-2007 weights") ytitle("2002-2007 weights")
reg all county_, robust
parmest, saving(data/epb_2004.dta,replace)

clear
use data/county_weights_imr.dta
rename county_weight all_weight

merge 1:1 countycode using data/county_weights_imr_2004.dta
twoway scatter all_weight county_weight, xtitle("2002-2003 and 2005-2007 weights") ytitle("2002-2007 weights")
reg all county_, robust
parmest, saving(data/imr_2004.dta,replace)


*2005
clear
use data/county_weights_epb.dta
rename county_weight all_weight

merge 1:1 countycode using data/county_weights_epb_2005.dta
twoway scatter all_weight county_weight, xtitle("2002-2004 and 2006-2007 weights") ytitle("2002-2007 weights")
reg all county_, robust
parmest, saving(data/epb_2005.dta,replace)

clear
use data/county_weights_imr.dta
rename county_weight all_weight

merge 1:1 countycode using data/county_weights_imr_2005.dta
twoway scatter all_weight county_weight, xtitle("2002-2004 and 2006-2007 weights") ytitle("2002-2007 weights")
reg all county_, robust
parmest, saving(data/imr_2005.dta,replace)


*2006
clear
use data/county_weights_epb.dta
rename county_weight all_weight

merge 1:1 countycode using data/county_weights_epb_2006.dta
twoway scatter all_weight county_weight, xtitle("2002-2005 and 2007 weights") ytitle("2002-2007 weights")
reg all county_, robust
parmest, saving(data/epb_2006.dta,replace)

clear
use data/county_weights_imr.dta
rename county_weight all_weight

merge 1:1 countycode using data/county_weights_imr_2006.dta
twoway scatter all_weight county_weight, xtitle("2002-2005 and 2007 weights") ytitle("2002-2007 weights")
reg all county_, robust
parmest, saving(data/imr_2006.dta,replace)


*2007
clear
use data/county_weights_epb.dta
rename county_weight all_weight

merge 1:1 countycode using data/county_weights_epb_2007.dta
twoway scatter all_weight county_weight, xtitle("2002-2006 weights") ytitle("2002-2007 weights")
reg all county_, robust
parmest, saving(data/epb_2007.dta,replace)

clear
use data/county_weights_imr.dta
rename county_weight all_weight

merge 1:1 countycode using data/county_weights_imr_2007.dta
twoway scatter all_weight county_weight, xtitle("2002-2006 weights") ytitle("2002-2007 weights")
reg all county_, robust
parmest, saving(data/imr_2007.dta,replace)

clear
append using data/epb_2002.dta
drop if strpos(parm, "_cons")

gen year = 2002
gen spec = "EPB"

forvalues year = 2003(1)2006{
	append using data/epb_`year'.dta
	replace year = `year' if missing(year)
}
replace spec = "EPB" if missing(spec)

forvalues year = 2002(1)2006{
	append using data/imr_`year'.dta
	replace year = `year' if missing(year)
}
replace spec = "IMR" if missing(spec)

replace year = year + .1 if spec == "EPB"
replace year = year - .1 if spec == "IMR"
drop if strpos(parm, "_cons")

*Appendix Figure A.11
twoway (scatter year est if spec == "EPB",msymbol(circle)mcolor(black)) (rcap min max year if spec == "EPB", horizontal lcolor(black)) ///
	(scatter year est if spec == "IMR",msymbol(circle)mcolor(gs8)) (rcap min max year if spec == "IMR", horizontal lcolor(gs8)), ///
	xline(0,lpattern(solid)) xline(1,lpattern(dot)) xticks(-.2(.2)1.2) xlabels(-.2(.2)1.2)
	
cd "weight_regs\"

*Appendix Figure A.9
graph combine data/epb_all_2002.gph data/epb_all_2003.gph data/epb_all_2004.gph data/epb_all_2005.gph data/epb_all_2006.gph data/epb_all_2007.gph, rows(3)

*Appendix Figure A.10
graph combine data/imr_all_2002.gph data/imr_all_2003.gph data/imr_all_2004.gph data/imr_all_2005.gph data/imr_all_2006.gph data/imr_all_2007.gph, rows(3)


**************************
*Run SDID with covariates*
**************************

global reps 500

use "data/stl_02_13.dta", clear

gen n = 1
gen teen_mother = mother_age < 20

collapse infant_mortality ext_preterm mother_married gestation mother_white mother_black teen_mother mother_age (sum) n, by(countycode year)

*drop CO and IA
drop if countycode > 8000 & countycode < 9000
drop if countycode > 19000 & countycode < 20000
gen st_louis = countycode == 29189 

*drop counties with missing years
bysort countycode: gen count = _N
drop if count < 12

*want to keep counties with at least 10,000 births per year	
bysort countycode: egen min_births = min(n)

gen IMR = infant_mortality * 1000
gen EPB = ext_preterm * 1000

xtset countycode year 

gen treat = st_louis == 1 & year > 2007

preserve
keep if min_births > 8000
sdid EPB countycode year treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data/epb_main.dta, replace)
sdid IMR countycode year treat, vce(placebo) reps($reps) seed($seed)
parmest, saving(data/imr_main.dta, replace)
restore


*foreach var in mother_married gestation mother_white mother_black teen_mother{
local var mother_age
preserve
keep if min_births > 8000
sdid EPB countycode year treat, covariates(`var') vce(placebo) reps($reps) seed($seed)
parmest, saving(data/epb_`var'.dta, replace)
sdid IMR countycode year treat, covariates(`var') vce(placebo) reps($reps) seed($seed)
parmest, saving(data/imr_`var'.dta, replace)
restore
}

clear
foreach var in main mother_married mother_age mother_white mother_black teen_mother{
append using data/epb_`var'.dta
cap gen spec = "`var'"
replace spec = 	"`var'" if missing(spec)
}
gen dvar = "EPB"

foreach var in main mother_married mother_age mother_white mother_black teen_mother{
append using data/imr_`var'.dta
replace spec = 	"`var'" if missing(spec)
}
replace dvar = "IMR" if missing(dvar)

gen spec_num = 6
replace spec_num = 5 if spec == "mother_married" 
replace spec_num = 4 if spec == "mother_age" 
replace spec_num = 3 if spec == "teen_mother" 
replace spec_num = 2 if spec == "mother_white" 
replace spec_num = 1 if spec == "mother_black" 

replace spec_num = spec_num - .1 if dvar == "EPB"
replace spec_num = spec_num + .1 if dvar == "IMR"

*Appendix Figure A.8
twoway (scatter spec_num est if dvar == "EPB",msymbol(circle)mcolor(black)) (rcap min max spec_num if dvar == "EPB", horizontal lcolor(black)) ///
	(scatter spec_num est if dvar == "IMR",msymbol(circle)mcolor(gs8)) (rcap min max spec_num if dvar == "IMR", horizontal lcolor(gs8)), ///
	xline(0,lpattern(dot)) ylabel(6 "Main Spec" 5 "% Mother Married" 4 "Mother Age" 3 "% Teen Mother" 2 "% White Mother" 1 "% Black Mother", angle(horizontal)) ///
	ytitle("") xticks(-6(2)2) xlabels(-6(2)2)
	
**********************************************************************
*Comparison of distributions of annual births under different cutoffs*
**********************************************************************
use data/counties_8k.dta, clear

gen log_avg = ln(n)

set scheme s1mono
kdensity log_avg, xline(9.384) xtitle("Log of Average Annual Births") title("Minimum 8k Annual Births")
*save as plots\min8k.gph

use data/counties_6k.dta, clear

gen log_avg = ln(avg)

set scheme s1mono
kdensity log_avg, xline(9.384) xtitle("Log of Average Annual Births") title("Minimum 6k Annual Births")
*save as plots\min6k.gph

use data/counties_10k.dta, clear

gen log_avg = ln(avg)

set scheme s1mono
kdensity log_avg, xline(9.384) xtitle("Log of Average Annual Births") title("Minimum 10k Annual Births")
*save as plots\min10k.gph

*Appendix Figure A.2
graph combine plots\min6k.gph plots\min8k.gph plots\min10k.gph
