/***********************************************************
** (C) KEISUKE KONDO
** FIRST UPLOADED: April 4, 2024
** 
** Kondo, K. (2023) "Measuring the Attractiveness of Trip Destinations: A Study of the Kansai Region of Japan," RIEB Discussion Paper Series No.2023-07
** URL: https://github.com/keisukekondokk/measuring-attractiveness-trip-destinations
***********************************************************/

** LOAD DATA
use "dta_odflow/dta_step2_estimation_delta_kinki.dta", clear

** FORMAT
format b_delta_total %4.2f
format b_delta_office %4.2f
format b_delta_school %4.2f
format b_delta_free %4.2f
format b_delta_business %4.2f
format b_delta_home %4.2f
format b_delta_unknown %4.2f

** DESCRIPTIVE STATISTICS
tabstat ///
	b_delta_total ///
	b_delta_office ///
	b_delta_school ///
	b_delta_free ///
	b_delta_business ///
	b_delta_home ///
	b_delta_unknown ///
	, ///
	c(stat) ///
	stat(n mean sd min p10 p25 p50 p75 p90 max) ///
	save
	
mat Stat = r(StatTotal)'
mat list Stat

** EXPORT TO EXCEL
putexcel set "table/tab_delta.xlsx", replace
putexcel B2 = matrix(Stat), names
putexcel close
