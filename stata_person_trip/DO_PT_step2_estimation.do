/***********************************************************
** (C) KEISUKE KONDO
** FIRST UPLOADED: April 4, 2024
** 
** Kondo, K. (2023) "Measuring the Attractiveness of Trip Destinations: A Study of the Kansai Region of Japan," RIEB Discussion Paper Series No.2023-07
** URL: https://github.com/keisukekondokk/measuring-attractiveness-trip-destinations
***********************************************************/

** +++++++++++++++++++++++++++++++++++++++++
** DATA
** +++++++++++++++++++++++++++++++++++++++++

**	
use "dta_odflow/dta_step1_odflow_2010_kinki.dta", clear

** +++++++++++++++++++++++++++++++++++++++++
** Variables
** +++++++++++++++++++++++++++++++++++++++++

** GENERATE VARIABLES
gen cnt_trip_office = cnt_trip_train_office + cnt_trip_bus_office + cnt_trip_car_office + cnt_trip_gentsuki_office + cnt_trip_walk_office + cnt_trip_unknown_office
gen cnt_trip_school = cnt_trip_train_school + cnt_trip_bus_school + cnt_trip_car_school + cnt_trip_gentsuki_school + cnt_trip_walk_school + cnt_trip_unknown_school
gen cnt_trip_free = cnt_trip_train_free + cnt_trip_bus_free + cnt_trip_car_free + cnt_trip_gentsuki_free + cnt_trip_walk_free + cnt_trip_unknown_free
gen cnt_trip_business = cnt_trip_train_business + cnt_trip_bus_business + cnt_trip_car_business + cnt_trip_gentsuki_business + cnt_trip_walk_business + cnt_trip_unknown_business
gen cnt_trip_home = cnt_trip_train_home + cnt_trip_bus_home + cnt_trip_car_home + cnt_trip_gentsuki_home + cnt_trip_walk_home + cnt_trip_unknown_home
gen cnt_trip_unknown = cnt_trip_train_unknown + cnt_trip_bus_unknown + cnt_trip_car_unknown + cnt_trip_gentsuki_unknown + cnt_trip_walk_unknown + cnt_trip_unknown_unknown

** GROUP VARIABLES
gen temp_muni_code = muni_code_o - pref_code_o * 1000
gen grp_urban_rural_o = 0
replace grp_urban_rural = 1 if (muni_code_o >= 26100 & muni_code_o <= 26199) & grp_urban_rural == 0
replace grp_urban_rural = 2 if (muni_code_o >= 27100 & muni_code_o <= 27129) & grp_urban_rural == 0
replace grp_urban_rural = 3 if (muni_code_o >= 27140 & muni_code_o <= 27149) & grp_urban_rural == 0
replace grp_urban_rural = 4 if (muni_code_o >= 28100 & muni_code_o <= 28199) & grp_urban_rural == 0
replace grp_urban_rural = 5 if (temp_muni_code >= 200 & temp_muni_code <= 299) & grp_urban_rural == 0
replace grp_urban_rural = 6 if (temp_muni_code >= 300 & temp_muni_code <= 799) & grp_urban_rural == 0
drop temp_muni_code


** 
save "dta_odflow/dta_step2_odflow_2010_kinki.dta", replace


** +++++++++++++++++++++++++++++++++++++++++
** Estimation
** +++++++++++++++++++++++++++++++++++++++++

** Load Data 
use "dta_odflow/dta_step2_odflow_2010_kinki.dta", clear

** From Pref 25 ot Pref 30
forvalues i = 25(1)30 {

	** 
	tab id_destination if pref_code_d == `i'
	return list 

	** 
	matrix mDelta = J(r(r), 16, 0)
	matrix list mDelta

	** LIST
	levelsof id_destination if pref_code_d == `i', local(LIST_ODZONE)
	** 
	local idx = 0
	foreach K in `LIST_ODZONE' {

		** 
		disp "=========================================================="
		disp "PRFECTURE CODE: `i'"
		disp "ODZONE CODE: `K'"
		disp "=========================================================="
		
		** 
		local idx = `idx' + 1
		matrix mDelta[`idx', 1] = `i'
		matrix mDelta[`idx', 2] = `K'
		
		** Estimation: TOTAL
		** Not Estimate If non-zero flows are less than 10
		count if id_destination == `K' & cnt_trip_allmode_total != 0 & distance > diameter_internal_d
		local obs_nonzero = r(N)
		if( `obs_nonzero' >= 10 ) {
			**
			poisson cnt_trip_allmode_total lndist if id_destination == `K' & distance > diameter_internal_d, robust
			**
			matrix mDelta[`idx', 3] = _b[lndist]
			matrix mDelta[`idx', 4] = _se[lndist]
		}
		else {
			**
			matrix mDelta[`idx', 3] = .
			matrix mDelta[`idx', 4] = .
		}
		
		** Estimation: OFFICE
		** Not Estimate If non-zero flows are less than 10
		count if id_destination == `K' & cnt_trip_office != 0 & distance > diameter_internal_d
		local obs_nonzero = r(N)
		if( `obs_nonzero' >= 10 ) {
			**
			poisson cnt_trip_office lndist if id_destination == `K' & distance > diameter_internal_d, robust
			** 
			matrix mDelta[`idx', 5] = _b[lndist]
			matrix mDelta[`idx', 6] = _se[lndist]
		}
		else {
			matrix mDelta[`idx', 5] = .
			matrix mDelta[`idx', 6] = .
		}
		
		** Estimation: SCHOOL
		** Not Estimate If non-zero flows are less than 10
		count if id_destination == `K' & cnt_trip_school != 0 & distance > diameter_internal_d
		local obs_nonzero = r(N)
		if( `obs_nonzero' >= 10 ) {
			**
			poisson cnt_trip_school lndist if id_destination == `K' & distance > diameter_internal_d, robust
			** 
			matrix mDelta[`idx', 7] = _b[lndist]
			matrix mDelta[`idx', 8] = _se[lndist]
		}
		else {
			matrix mDelta[`idx', 7] = .
			matrix mDelta[`idx', 8] = .
		}
		
		** Estimation: FREE
		** Not Estimate If non-zero flows are less than 10
		count if id_destination == `K' & cnt_trip_free != 0 & distance > diameter_internal_d
		local obs_nonzero = r(N)
		if( `obs_nonzero' >= 10 ) {
			poisson cnt_trip_free lndist if id_destination == `K' & distance > diameter_internal_d, robust
			** 
			matrix mDelta[`idx', 9] = _b[lndist]
			matrix mDelta[`idx', 10] = _se[lndist]
		}
		else {
			** 
			matrix mDelta[`idx', 9] = .
			matrix mDelta[`idx', 10] = .
		}
		
		** Estimation: BUSINESS
		** Not Estimate If non-zero flows are less than 10
		count if id_destination == `K' & cnt_trip_business != 0 & distance > diameter_internal_d
		local obs_nonzero = r(N)
		if( `obs_nonzero' >= 10 ) {
			poisson cnt_trip_business lndist if id_destination == `K' & distance > diameter_internal_d, robust
			** 
			matrix mDelta[`idx', 11] = _b[lndist]
			matrix mDelta[`idx', 12] = _se[lndist]
		}
		else {
			** 
			matrix mDelta[`idx', 11] = .
			matrix mDelta[`idx', 12] = .
		}
		
		** Estimation: HOME
		** Not Estimate If non-zero flows are less than 10
		count if id_destination == `K' & cnt_trip_home != 0 & distance > diameter_internal_d
		local obs_nonzero = r(N)
		if( `obs_nonzero' >= 10 ) {
			**
			poisson cnt_trip_home lndist if id_destination == `K' & distance > diameter_internal_d, robust
			** 
			matrix mDelta[`idx', 13] = _b[lndist]
			matrix mDelta[`idx', 14] = _se[lndist]
		}
		else {
			** 
			matrix mDelta[`idx', 13] = .
			matrix mDelta[`idx', 14] = .
		}
		
		** Estimation: UNKNOWN
		** Not Estimate If non-zero flows are less than 10
		count if id_destination == `K' & cnt_trip_unknown != 0 & distance > diameter_internal_d
		local obs_nonzero = r(N)
		if( `obs_nonzero' >= 10 ) {
			poisson cnt_trip_unknown lndist if id_destination == `K' & distance > diameter_internal_d, robust
			** 
			matrix mDelta[`idx', 15] = _b[lndist]
			matrix mDelta[`idx', 16] = _se[lndist]
		}
		else {
			matrix mDelta[`idx', 15] = .
			matrix mDelta[`idx', 16] = .
		}
	}

	** 
	matrix list mDelta

	** 
	preserve

	clear
	svmat mDelta
	rename mDelta1 id_pref
	rename mDelta2 id_odzone
	rename mDelta3 b_delta_total
	rename mDelta4 se_delta_total
	rename mDelta5 b_delta_office
	rename mDelta6 se_delta_office
	rename mDelta7 b_delta_school
	rename mDelta8 se_delta_school
	rename mDelta9 b_delta_free
	rename mDelta10 se_delta_free
	rename mDelta11 b_delta_business
	rename mDelta12 se_delta_business
	rename mDelta13 b_delta_home
	rename mDelta14 se_delta_home
	rename mDelta15 b_delta_unknown
	rename mDelta16 se_delta_unknown

	** Save
	save "dta_odflow/dta_step2_estimation_delta_pref`i'.dta", replace

	restore
}


** ALL DATA in Kinki Region
clear
append using "dta_odflow/dta_step2_estimation_delta_pref25.dta"
append using "dta_odflow/dta_step2_estimation_delta_pref26.dta"
append using "dta_odflow/dta_step2_estimation_delta_pref27.dta"
append using "dta_odflow/dta_step2_estimation_delta_pref28.dta"
append using "dta_odflow/dta_step2_estimation_delta_pref29.dta"
append using "dta_odflow/dta_step2_estimation_delta_pref30.dta"

** SAVE
save "dta_odflow/dta_step2_estimation_delta_kinki.dta", replace
