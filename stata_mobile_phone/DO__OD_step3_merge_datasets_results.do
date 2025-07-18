
/***********************************************************
** Data 
** 
** 
***********************************************************/

** ALL Data in Japan
** 
foreach PERIOD in "201509" "201510" "201511" "201512" "201601" "201602" "201603" "201604" "201605" "201606" "201607" "201608" {
	forvalues i = 0(1)2 {
		forvalues j = 1(1)2 {
			forvalues a = 0(1)3 {
			
				** 
				clear 
				forvalues k = 1(1)47 {
					
					**
					disp "============================"
					disp "PREFECTURE: `k'"
					disp "PERIOD: `PERIOD'"
					disp "GENDER: `i'"
					disp "DAY: `j'"
					disp "AGE: `a'"
					disp "============================"
					
					** 
					local ken = string(`k', "%02.0f")

					**
					append using "dta_odflow_delta/dta_estimation_delta_ym`PERIOD'_day0`j'_gender0`i'_age0`a'_pref`ken'.dta"
				}
				
				** 
				save "dta_odflow_delta/dta_estimation_delta_ym`PERIOD'_day0`j'_gender0`i'_age0`a'_pref00.dta", replace
			}
		}
	}
}


/***********************************************************
** Data 
** 
** 
***********************************************************/

** ALL Data in Japan
** 
forvalues i = 0(1)2 {
	forvalues j = 1(1)2 {
		forvalues a = 0(1)3 {
			forvalues k = 1(1)47 {
			
				** 
				clear 
				foreach PERIOD in "201509" "201510" "201511" "201512" "201601" "201602" "201603" "201604" "201605" "201606" "201607" "201608" {
					
					**
					disp "============================"
					disp "PREFECTURE: `k'"
					disp "PERIOD: `PERIOD'"
					disp "GENDER: `i'"
					disp "DAY: `j'"
					disp "AGE: `a'"
					disp "============================"
					
					** 
					local ken = string(`k', "%02.0f")

					**
					append using "dta_odflow_delta/dta_estimation_delta_ym`PERIOD'_day0`j'_gender0`i'_age0`a'_pref`ken'.dta"
				}
				
				** 
				save "dta_odflow_delta/dta_estimation_delta_pref`ken'_day0`j'_gender0`i'_age0`a'.dta", replace
			}
		}
	}
}



/***********************************************************
** Estimation 
** 
** 
***********************************************************/

forvalues i = 0(1)2 {
	forvalues j = 1(1)2 {
		forvalues a = 0(1)3 {

			clear
			forvalues k = 1(1)47 {
			
					**
					disp "============================"
					disp "GENDER: `i'"
					disp "DAY: `j'"
					disp "AGE: `a'"
					disp "============================"
					
					** 
					local ken = string(`k', "%02.0f")

					**
					append using "dta_odflow_delta/dta_estimation_delta_pref`ken'_day0`j'_gender0`i'_age0`a'.dta"
				
			}
			** 
			save "dta_odflow_delta/dta_estimation_delta_pref00_day0`j'_gender0`i'_age0`a'.dta", replace
		}
	}
}


/***********************************************************
** Data 
** 
** 
***********************************************************/

forvalues i = 0(1)2 {
	forvalues a = 0(1)3 {

		clear
		forvalues j = 1(1)2 {
	
			**
			disp "============================"
			disp "GENDER: `i'"
			disp "DAY: `j'"
			disp "AGE: `a'"
			disp "============================"

			**
			append using "dta_odflow_delta/dta_estimation_delta_pref00_day0`j'_gender0`i'_age0`a'.dta"
		
		}
		** 
		save "dta_odflow_delta/dta_estimation_delta_pref00_gender0`i'_age0`a'.dta", replace
	}
}

/***********************************************************
** Data 
** 
** 
***********************************************************/

forvalues a = 0(1)3 {

	clear
	forvalues i = 0(1)2 {
		**
		disp "============================"
		disp "GENDER: `i'"
		disp "AGE: `a'"
		disp "============================"

		**
		append using "dta_odflow_delta/dta_estimation_delta_pref00_gender0`i'_age0`a'.dta"
	
	}
	** 
	save "dta_odflow_delta/dta_estimation_delta_pref00_age0`a'.dta", replace
}


/***********************************************************
** Data 
** 
** 
***********************************************************/


clear
forvalues a = 0(1)3 {
	**
	disp "============================"
	disp "AGE: `a'"
	disp "============================"

	**
	append using "dta_odflow_delta/dta_estimation_delta_pref00_age0`a'.dta"

}
** 
save "dta_odflow_delta/dta_estimation_delta_pref00.dta", replace


/***********************************************************
** Data Panel
** 
** 
***********************************************************/

forvalues i = 0(1)2 {
	forvalues a = 0(1)3 {

		** 
		use "dta_odflow_delta/dta_estimation_delta_pref00_day01_gender0`i'_age0`a'.dta", clear
		
		** 
		rename b_delta_total b_delta_total_day1
		rename se_delta_total se_delta_total_day1 	
		rename obs_nonzero obs_nonzero_day1

		** 
		merge 1:1 year month gender age_group code_pref_muni ///
			using "dta_odflow_delta/dta_estimation_delta_pref00_day02_gender0`i'_age0`a'.dta", ///
			keepusing(b_delta_total se_delta_total obs_nonzero)
		drop _merge
		
		** 
		rename b_delta_total b_delta_total_day2
		rename se_delta_total se_delta_total_day2
		rename obs_nonzero obs_nonzero_day2
		
		** 
		gen week_holi_ratio_delta = b_delta_total_day1 / b_delta_total_day2
		gen week_holi_ratio_delta_inverse =  1 / week_holi_ratio_delta
		** 
		gen week_holi_ratio_obs_nonzero = obs_nonzero_day1 / obs_nonzero_day2
		
		
		** 
		gen code_pref_muni_2020 = code_pref_muni
		merge m:1 code_pref_muni_2020 ///
			using "dta_muni_area/r2ka01_47_muni_area.dta", ///
			keepusing(name_pref* name_muni_shigun*)
		drop if _merge == 2
		drop _merge code_pref_muni_2020
		
		** 
		rename name_pref_2020 name_pref
		rename name_muni_shigun_2020 name_muni
		
		** 
		order name_pref, after(code_pref_muni)
		order name_muni, after(name_pref)
		
		** 
		save "dta_odflow_delta/dta_estimation_delta_day_wide_pref00_gender0`i'_age0`a'.dta", replace
	}
}
