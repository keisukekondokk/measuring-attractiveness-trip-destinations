
**LOG
log using "_log/LOG_DO__OD_step2_estimation_pref10.smcl", smcl replace

/***********************************************************
** Estimation 
** 
** 
***********************************************************/

foreach PERIOD in "201509" "201510" "201511" "201512" "201601" "201602" "201603" "201604" "201605" "201606" "201607" "201608" {
	
	**
	disp "============================"
	disp "PERIOD: `PERIOD'"
	disp "============================"

	forvalues i = 0(1)2 {
		forvalues j = 1(1)2 {
			forvalues t = 0(1)3 {

				disp "============================"
				disp "PERIOD: `PERIOD'"
				disp "GENDER: `i'"
				disp "DAY: `j'"
				disp "AGE: `t'"
				disp "============================"
				
				** 
				use "dta_odflow_muni/dta_odflow_muni_distance_ym`PERIOD'_day0`j'_gender0`i'_age0`t'_for_estimation.dta", clear

				**
				drop if code_pref_muni_origin == code_pref_muni_destination
				
				**
				replace total_flow = 0 if total_flow == .
				
				** +++++++++++++++++++++++++++++++++++++++++
				** Estimation
				** +++++++++++++++++++++++++++++++++++++++++

				** Prefecture
				forvalues k = 10(1)10 {

					** 
					tab code_pref_muni_destination if code_pref_destination == `k'
					return list 

					** 
					matrix mDelta = J(r(r), 11, 0)
					matrix list mDelta

					** Municipality LIST
					levelsof code_pref_muni_destination if code_pref_destination == `k', local(LIST_MUNI)
					** 
					local idx = 0
					foreach m in `LIST_MUNI' {
						
						** 
						local idx = `idx' + 1

						** 
						disp "============================"
						disp "PERIOD: `PERIOD'"
						disp "GENDER: `i'"
						disp "DAY: `j'"
						disp "AGE: `t'"
						disp "PRFECTURE CODE: `k'"
						disp "MUNICIPALITY CODE: `m'"
						disp "============================"
						
						** 
						matrix mDelta[`idx', 1] = real(substr("`PERIOD'", 1, 4))
						matrix mDelta[`idx', 2] = real(substr("`PERIOD'", 5, 2))
						matrix mDelta[`idx', 3] = `j'
						matrix mDelta[`idx', 4] = `i'
						matrix mDelta[`idx', 5] = `t'
						
						** 
						matrix mDelta[`idx', 6] = `k'
						matrix mDelta[`idx', 7] = `m'
						
						** ゼロフローが10以下は推定しない
						count if code_pref_muni_destination == `m' & total_flow != 0
						count if code_pref_muni_destination == `m' & total_flow != 0 & distance >= diameter_d
						local obs_nonzero = r(N)
						
						if( `obs_nonzero' >= 10 ){
							** Estimation: TOTAL
							poisson total_flow lndist if code_pref_muni_destination == `m' & distance >= diameter_d, robust
							matrix mDelta[`idx', 8] = _b[lndist]
							matrix mDelta[`idx', 9] = _se[lndist]
							matrix mDelta[`idx', 10] = e(r2_p)
							matrix mDelta[`idx', 11] = `obs_nonzero'
						} 
						else {
							matrix mDelta[`idx', 8] = .
							matrix mDelta[`idx', 9] = .
							matrix mDelta[`idx', 10] = .
							matrix mDelta[`idx', 11] = `obs_nonzero'
						}
					}

					** 
					matrix list mDelta

					** 
					preserve

					** 
					clear
					svmat mDelta
					rename mDelta1 year
					rename mDelta2 month
					rename mDelta3 day
					rename mDelta4 gender
					rename mDelta5 age_group
					rename mDelta6 code_pref
					rename mDelta7 code_pref_muni
					rename mDelta8 b_delta_total
					rename mDelta9 se_delta_total
					rename mDelta10 pseudo_r2
					rename mDelta11 obs_nonzero

					** 
					local ken = string(`k', "%02.0f")
					save "dta_odflow_delta/dta_estimation_delta_ym`PERIOD'_day0`j'_gender0`i'_age0`t'_pref`ken'.dta", replace

					restore
				}
			}
		}
	}
}

** ALL Data in Japan
foreach PERIOD in "201509" "201510" "201511" "201512" "201601" "201602" "201603" "201604" "201605" "201606" "201607" "201608" {
	**
	disp "PERIOD: `PERIOD'"

	**
	forvalues i = 0(1)2 {
		forvalues j = 1(1)2 {
			forvalues t = 0(1)3 {
			
				** Prefecture
				clear
				forvalues k = 10(1)10 {
					local ken = string(`k', "%02.0f")
					append using "dta_odflow_delta/dta_estimation_delta_ym`PERIOD'_day0`j'_gender0`i'_age0`t'_pref`ken'.dta"
				}

				**
				save "dta_odflow_delta/dta_estimation_delta_ym`PERIOD'_day0`j'_gender0`i'_age0`t'_pref00.dta", replace
			}
		}
	}
}

** 
log close
