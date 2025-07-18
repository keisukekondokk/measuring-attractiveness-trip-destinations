
/***********************************************************
** Data 
** 
** 
***********************************************************/

foreach PERIOD in "201509" "201510" "201511" "201512" "201601" "201602" "201603" "201604" "201605" "201606" "201607" "201608" {
	
	**
	disp "============================"
	disp "PERIOD: `PERIOD'"
	disp "============================"

	forvalues i = 2(1)2 {
		forvalues j = 1(1)2 {
			forvalues k = 0(1)3 {
			
				disp "============================"
				disp "PERIOD: `PERIOD'"
				disp "GENDER: `i'"
				disp "DAY: `j'"
				disp "AGE: `k'"
				disp "============================"

				**	
				use "dta_odflow_muni/dta_odflow_muni_distance.dta", clear
				
				** 
				gen citycoderesidence = code_pref_muni_origin
				gen citycodedestination = code_pref_muni_destination
				merge 1:1 citycoderesidence citycodedestination ///
					using "dta_odflow_muni/dta_odflow_muni_distance_ym`PERIOD'_day0`j'_gender0`i'_age0`k'.dta", keepusing(total_flow)
				drop if _merge == 2
				drop _merge

				**
				replace total_flow = 0 if total_flow == .

				** 
				gen lnflow = log(total_flow)

				** 
				*scatter lnflow lndist

				** 
				gen code_pref_origin = floor(code_pref_muni_origin / 1000)
				gen code_pref_destination = floor(code_pref_muni_destination / 1000)

				**
				save "dta_odflow_muni/dta_odflow_muni_distance_ym`PERIOD'_day0`j'_gender0`i'_age0`k'_for_estimation.dta", replace
			}
		}
	}
}
