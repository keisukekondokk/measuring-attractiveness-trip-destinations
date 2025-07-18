/***********************************************************
** OD Flows from RESAS
** 
** 
***********************************************************/

foreach PERIOD in "201509" "201510" "201511" "201512" "201601" "201602" "201603" "201604" "201605" "201606" "201607" "201608" {
	
	**
	disp "============================"
	disp "PERIOD: `PERIOD'"
	disp "============================"


	forvalues j = 1(1)2 {

		disp "============================"
		disp "DAY: `j'"
		disp "============================"

		** 
		** 政令指定都市内の区データ
		**

		** 
		import delimited "csv_resas_muni_seirei/CSV_od_flows_muni_by_gender_age_ym`PERIOD'_day0`j'_time14.csv", clear encoding("utf-8")
		
		** 
		replace citycoderesidence = 4423 if citycoderesidence == 4216
		replace citycoderesidence = 40305 if citycoderesidence == 40231
		** 
		replace citycodedestination = 4423 if citycodedestination == 4216
		replace citycodedestination = 40305 if citycodedestination == 40231

		**
		save "dta_resas_muni_seirei/CSV_od_flows_muni_by_gender_age_ym`PERIOD'_day0`j'_time14.dta", replace



		** 
		** 市区町村別（政令指定都市の除去し、区単位に差し替え）
		**
		
		** 
		import delimited "csv_resas_muni/CSV_od_flows_muni_by_gender_age_ym`PERIOD'_day0`j'_time14.csv", clear encoding("utf-8")

		**
		drop if citycodedestination == 1100
		drop if citycodedestination == 4100
		drop if citycodedestination == 11100
		drop if citycodedestination == 12100
		drop if citycodedestination == 14100
		drop if citycodedestination == 14130
		drop if citycodedestination == 14150
		drop if citycodedestination == 15100
		drop if citycodedestination == 22100
		drop if citycodedestination == 22130
		drop if citycodedestination == 23100
		drop if citycodedestination == 26100
		drop if citycodedestination == 27100
		drop if citycodedestination == 27140
		drop if citycodedestination == 28100
		drop if citycodedestination == 33100
		drop if citycodedestination == 34100
		drop if citycodedestination == 40100
		drop if citycodedestination == 40130
		drop if citycodedestination == 43100
		
		** 
		replace citycoderesidence = 4423 if citycoderesidence == 4216
		replace citycoderesidence = 40305 if citycoderesidence == 40231
		** 
		replace citycodedestination = 4423 if citycodedestination == 4216
		replace citycodedestination = 40305 if citycodedestination == 40231

		** 
		sort citycodedestination citycoderesidence year month gender agerange
		** 
		save "dta_resas_muni/CSV_od_flows_muni_by_gender_age_ym`PERIOD'_day0`j'_time14.dta", replace

		
		** 
		** 統合する
		**
		
		** 
		use "dta_resas_muni/CSV_od_flows_muni_by_gender_age_ym`PERIOD'_day0`j'_time14.dta", clear
		
		** 
		append using "dta_resas_muni_seirei/CSV_od_flows_muni_by_gender_age_ym`PERIOD'_day0`j'_time14.dta"

		** 
		sort citycodedestination citycoderesidence year month gender agerange

		** 
		save "dta_odflow_muni/CSV_od_flows_muni_by_gender_age_ym`PERIOD'_day0`j'_time14.dta", replace

	}
}


/***********************************************************
** ODフローのベースデータセット
** 
** 
***********************************************************/


** 
use "dta_muni_lonlat/r2ka01_47_muni_point_lonlat.dta", clear

** 除去
gen temp = code_pref_muni_2020 - floor(code_pref_muni_2020 / 1000) * 1000
drop if temp == 999
drop if temp == 199

** 
putmata code_pref_muni_2020, replace
mata: vOne = J(rows(code_pref_muni_2020), 1, 1)

** 
mata: code_pref_muni_origin = code_pref_muni_2020 # vOne
mata: code_pref_muni_destination = vOne # code_pref_muni_2020 

** 
clear
getmata code_pref_muni_origin code_pref_muni_destination



** Origin
gen code_pref_muni_2020 = code_pref_muni_origin
merge m:1 code_pref_muni_2020 using "dta_muni_lonlat/r2ka01_47_muni_point_lonlat.dta", keepusing(X_CODE Y_CODE name_pref* name_muni_shigun*)
drop if _merge == 2
drop _merge code_pref_muni_2020
rename X_CODE lon_d
rename Y_CODE lat_d
rename name_pref_2020 name_pref_d
rename name_muni_shigun_2020 name_muni_d


** Destination
gen code_pref_muni_2020 = code_pref_muni_destination
merge m:1 code_pref_muni_2020 using "dta_muni_lonlat/r2ka01_47_muni_point_lonlat.dta", keepusing(X_CODE Y_CODE name_pref* name_muni_shigun*)
drop if _merge == 2
drop _merge code_pref_muni_2020
rename X_CODE lon_o
rename Y_CODE lat_o
rename name_pref_2020 name_pref_o
rename name_muni_shigun_2020 name_muni_o


** Distance
geodist lat_o lon_o lat_d lon_d, gen(distance)


** Area and Intra-Municipal Distance
gen code_pref_muni_2020 = code_pref_muni_destination
merge m:1 code_pref_muni_2020 using "dta_muni_area/r2ka01_47_muni_area.dta", keepusing(total_area)
rename total_area total_area_d
drop if _merge == 2
drop _merge code_pref_muni_2020
gen distance_internal_d = 2/3 * sqrt(total_area_d / _pi)
gen radius_d = sqrt(total_area_d / _pi)
gen diameter_d = 2 * radius_d


** Variable
replace distance = distance_internal if code_pref_muni_origin == code_pref_muni_destination
gen lndist = log(distance)
*browse if lndist == .

**	
save "dta_odflow_muni/dta_odflow_muni_distance.dta", replace
