
/***********************************************************
** ODフロー属性別 
** 
** 
***********************************************************/

foreach PERIOD in "201509" "201510" "201511" "201512" "201601" "201602" "201603" "201604" "201605" "201606" "201607" "201608" {
	
	**
	disp "============================"
	disp "PERIOD: `PERIOD'"
	disp "============================"

	forvalues j = 1(1)2 {

		** 
		use "dta_odflow_muni/CSV_od_flows_muni_by_gender_age_ym`PERIOD'_day0`j'_time14.dta", clear

		** ====================
		** Total
		** ====================

		** 
		preserve

		**
		by citycodedestination citycoderesidence, sort: egen total_flow = total(value)

		** 
		duplicates drop citycodedestination citycoderesidence, force

		**
		duplicates report citycodedestination citycoderesidence
		
		** 
		sort citycodedestination citycoderesidence gender age

		**	
		save "dta_odflow_muni/dta_odflow_muni_distance_ym`PERIOD'_day0`j'_gender00_age00.dta", replace

		** 
		restore

		
		** ====================
		** Total Age 15-39
		** ====================

		** 
		preserve
		
		** 
		keep if age == 15 | age == 20 | age == 30 

		**
		by citycodedestination citycoderesidence, sort: egen total_flow = total(value)

		** 
		duplicates drop citycodedestination citycoderesidence, force

		**
		duplicates report citycodedestination citycoderesidence
		
		** 
		sort citycodedestination citycoderesidence gender age

		**	
		save "dta_odflow_muni/dta_odflow_muni_distance_ym`PERIOD'_day0`j'_gender00_age01.dta", replace

		** 
		restore
		
		** ====================
		** Total Age 40-60
		** ====================

		** 
		preserve

		** 
		keep if age == 40 | age == 50

		**
		by citycodedestination citycoderesidence, sort: egen total_flow = total(value)

		** 
		duplicates drop citycodedestination citycoderesidence, force

		**
		duplicates report citycodedestination citycoderesidence
		
		** 
		sort citycodedestination citycoderesidence gender age

		**	
		save "dta_odflow_muni/dta_odflow_muni_distance_ym`PERIOD'_day0`j'_gender00_age02.dta", replace

		** 
		restore

		** ====================
		** Total Age 60over
		** ====================

		** 
		preserve

		** 
		keep if age == 60 | age == 70

		**
		by citycodedestination citycoderesidence, sort: egen total_flow = total(value)

		** 
		duplicates drop citycodedestination citycoderesidence, force

		**
		duplicates report citycodedestination citycoderesidence
		
		** 
		sort citycodedestination citycoderesidence gender age

		**	
		save "dta_odflow_muni/dta_odflow_muni_distance_ym`PERIOD'_day0`j'_gender00_age03.dta", replace

		** 
		restore
	}
}

