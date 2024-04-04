/***********************************************************
** OD FLOWS
** 
** 
***********************************************************/


** Load Data
use "shp_odflow_area/shp_poly_odflow_kinki_area.dta", clear

** 
rename S05a_004 id_odzone
drop S05a_* 
replace area = area / 1000000
destring *, replace

** AREA FROM QGIS
gen lnarea = log(area)

** 
gen radius_internal = sqrt( area/ _pi )
gen diameter_internal = 2 * radius_internal

** 
sort id_odzone
duplicates drop id_odzone, force

** SAVE
save "dta_odflow_zonecode/zonecode_odflow_muni_area.dta", replace


/***********************************************************
** OD FLOWS
** 
** 
***********************************************************/


** Load Data
use "shp_odflow_line/S05-b-12_KINKI-g_PersonTripODAmount.dta", clear


** Variable Name
rename S05b_001 id_urban_area
rename S05b_002 year
rename S05b_003 id_origin
rename S05b_004 id_destination
rename S05b_005 cnt_trip_train_office
rename S05b_006 cnt_trip_train_school
rename S05b_007 cnt_trip_train_free
rename S05b_008 cnt_trip_train_business
rename S05b_009 cnt_trip_train_home
rename S05b_010 cnt_trip_train_unknown
rename S05b_011 cnt_trip_train_total
rename S05b_012 cnt_trip_bus_office
rename S05b_013 cnt_trip_bus_school
rename S05b_014 cnt_trip_bus_free
rename S05b_015 cnt_trip_bus_business
rename S05b_016 cnt_trip_bus_home
rename S05b_017 cnt_trip_bus_unknown
rename S05b_018 cnt_trip_bus_total
rename S05b_019 cnt_trip_car_office
rename S05b_020 cnt_trip_car_school
rename S05b_021 cnt_trip_car_free
rename S05b_022 cnt_trip_car_business
rename S05b_023 cnt_trip_car_home
rename S05b_024 cnt_trip_car_unknown
rename S05b_025 cnt_trip_car_total
rename S05b_026 cnt_trip_gentsuki_office
rename S05b_027 cnt_trip_gentsuki_school
rename S05b_028 cnt_trip_gentsuki_free
rename S05b_029 cnt_trip_gentsuki_business
rename S05b_030 cnt_trip_gentsuki_home
rename S05b_031 cnt_trip_gentsuki_unknown
rename S05b_032 cnt_trip_gentsuki_total
rename S05b_033 cnt_trip_walk_office
rename S05b_034 cnt_trip_walk_school
rename S05b_035 cnt_trip_walk_free
rename S05b_036 cnt_trip_walk_business
rename S05b_037 cnt_trip_walk_home
rename S05b_038 cnt_trip_walk_unknown
rename S05b_039 cnt_trip_walk_total
rename S05b_040 cnt_trip_unknown_office
rename S05b_041 cnt_trip_unknown_school
rename S05b_042 cnt_trip_unknown_free
rename S05b_043 cnt_trip_unknown_business
rename S05b_044 cnt_trip_unknown_home
rename S05b_045 cnt_trip_unknown_unknown
rename S05b_046 cnt_trip_unknown_total
rename S05b_047 cnt_trip_allmode_total


** Destring
destring id*, replace


** Origin
merge 1:1 _ID using "dta_odflow/dta_step0_odflow_2010_kinki_lonlat_origin.dta", keepusing(lon* lat*)
drop _merge


** Destination
merge 1:1 _ID using "dta_odflow/dta_step0_odflow_2010_kinki_lonlat_destination.dta", keepusing(lon* lat*)
drop _merge


** Municipal Codes: Origin
gen id_odzone = id_origin
merge m:1 id_odzone using "dta_odflow_zonecode/zonecode_odflow_muni_code.dta", keepusing(pref* muni*)
drop _merge id_odzone
rename pref_code pref_code_o
rename muni_code muni_code_o
rename pref_name pref_name_o
rename muni_name muni_name_o

** Municipal Codes: Destination
gen id_odzone = id_destination
merge m:1 id_odzone using "dta_odflow_zonecode/zonecode_odflow_muni_code.dta", keepusing(pref* muni*)
drop _merge id_odzone
rename pref_code pref_code_d
rename muni_code muni_code_d
rename pref_name pref_name_d
rename muni_name muni_name_d

** Municipal Area: Origin
gen id_odzone = id_origin
merge m:1 id_odzone using "dta_odflow_zonecode/zonecode_odflow_muni_area.dta", keepusing(area radius_internal diameter_internal)
drop _merge id_odzone
rename area area_o
rename radius_internal radius_internal_o
rename diameter_internal diameter_internal_o

** Municipal Area: Destination
gen id_odzone = id_destination
merge m:1 id_odzone using "dta_odflow_zonecode/zonecode_odflow_muni_area.dta", keepusing(area radius_internal diameter_internal)
drop _merge id_odzone
rename area area_d
rename radius_internal radius_internal_d
rename diameter_internal diameter_internal_d

** Order Variables
order lon_o lat_o lon_d lat_d, after(_CY)

** Order Variables
order pref_code_o muni_code_o pref_name_o muni_name_o, after(id_origin)
order pref_code_d muni_code_d pref_name_d muni_name_d, after(id_destination)

** Distance
geodist lat_o lon_o lat_d lon_d, gen(distance)
replace distance = 0 if id_origin == id_destination
gen lndist = log(distance)


** SAVE
save "dta_odflow/dta_step1_odflow_2010_kinki.dta", replace
