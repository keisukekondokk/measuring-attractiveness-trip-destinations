/***********************************************************
** (C) KEISUKE KONDO
** FIRST UPLOADED: April 4, 2024
** 
** Kondo, K. (2023) "Measuring the Attractiveness of Trip Destinations: A Study of the Kansai Region of Japan," RIEB Discussion Paper Series No.2023-07
** URL: https://github.com/keisukekondokk/measuring-attractiveness-trip-destinations
***********************************************************/

** LOAD DATA
use "dta_odflow/dta_step2_odflow_2010_kinki.dta", clear

** DESCRIPTIVE STATISTICS
tabstat ///
	cnt_trip_allmode_total ///
	cnt_trip_office ///
	cnt_trip_school ///
	cnt_trip_free ///
	cnt_trip_business ///
	cnt_trip_home ///
	cnt_trip_unknown ///
	distance ///
	if id_origin != id_destination ///
	& distance > diameter_internal_d ///
	, ///
	c(stat) ///
	stat(n mean sd min p10 p50 p90 max) ///
	save

** Table
matrix mStat = r(StatTotal)' 
matrix list mStat

** Nonzero Flows
count if cnt_trip_allmode_total != 0 & distance > diameter_internal_d
matrix NONZERO1 = r(N)
count if cnt_trip_office != 0 & distance > diameter_internal_d
matrix NONZERO2 = r(N)
count if cnt_trip_school != 0 & distance > diameter_internal_d
matrix NONZERO3 = r(N)
count if cnt_trip_free != 0 & distance > diameter_internal_d
matrix NONZERO4 = r(N)
count if cnt_trip_business != 0 & distance > diameter_internal_d
matrix NONZERO5 = r(N)
count if cnt_trip_home != 0 & distance > diameter_internal_d
matrix NONZERO6 = r(N)
count if cnt_trip_unknown != 0 & distance > diameter_internal_d
matrix NONZERO7 = r(N)
count if distance != 0 & distance > diameter_internal_d
matrix NONZERO8 = r(N)

**
matrix NONZERO = NONZERO1 \ NONZERO2 \ NONZERO3 \ NONZERO4 \ NONZERO5 \ NONZERO6 \ NONZERO7 \ NONZERO8
matrix list NONZERO
	
**
matrix mTable = mStat[1..., 1], NONZERO, mStat[1..., 2...]
matrix list mTable
		

** EXPORT TO EXCEL
putexcel set "table/tab_descriptive_statistics.xlsx", replace
putexcel B2 = matrix(mTable), names
putexcel clear
