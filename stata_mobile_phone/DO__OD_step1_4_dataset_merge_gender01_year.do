
/***********************************************************
** Data 
** 
** 
***********************************************************/


forvalues i = 1(1)1 {
	forvalues j = 1(1)2 {
		forvalues k = 0(1)3 {
		
						
			disp "============================"
			disp "GENDER: `i'"
			disp "DAY: `j'"	
			disp "AGE: `k'"
			disp "============================"

			** 
			local PERIOD_INI = "201509"
			local PERIOD_END = "201608"
			
			** 
			use "dta_odflow_muni/dta_odflow_muni_distance_ym`PERIOD_INI'_day0`j'_gender0`i'_age0`k'_for_estimation.dta", clear
			
			** 
			gen year = real(substr("`PERIOD_INI'", 1, 4)), before(code_pref_muni_origin)
			gen month = real(substr("`PERIOD_INI'", 5, 2)), after(year)
			
			** 
			foreach PERIOD in "201510" "201511" "201512" "201601" "201602" "201603" "201604" "201605" "201606" "201607" "201608" {

				** 
				append using "dta_odflow_muni/dta_odflow_muni_distance_ym`PERIOD'_day0`j'_gender0`i'_age0`k'_for_estimation.dta", gen(flag)
				
				** 
				replace year = real(substr("`PERIOD'", 1, 4)) if flag == 1 & year == .
				replace month = real(substr("`PERIOD'", 5, 2)) if flag == 1 & month == .
				
				** 
				drop flag
			}
			
			
			**
			by code_pref_muni_origin code_pref_muni_destination, sort: egen total_flow_year = total(total_flow)
			duplicates report code_pref_muni_origin code_pref_muni_destination
			duplicates drop code_pref_muni_origin code_pref_muni_destination, force
			drop year month

			**
			drop total_flow lnflow
			rename total_flow_year total_flow
			gen lnflow = log(total_flow)
			
			**
			save "dta_odflow_muni_year/dta_odflow_muni_distance_ym`PERIOD_INI'_ym`PERIOD_END'_day0`j'_gender0`i'_age0`k'_for_estimation.dta", replace
		}
	}
}
