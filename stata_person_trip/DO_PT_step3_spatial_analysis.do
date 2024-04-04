/***********************************************************
** (C) KEISUKE KONDO
** FIRST UPLOADED: April 4, 2024
** 
** Kondo, K. (2023) "Measuring the Attractiveness of Trip Destinations: A Study of the Kansai Region of Japan," RIEB Discussion Paper Series No.2023-07
** URL: https://github.com/keisukekondokk/measuring-attractiveness-trip-destinations
***********************************************************/

** LOAD DATA
use "dta_odflow_zonecode/zonecode_odflow_muni_code.dta", clear


** MERGE ESTIMATION RESULTS
merge 1:1 id_odzone using "dta_odflow/dta_step2_estimation_delta_kinki.dta"
drop if _merge == 2
drop _merge


** ++++++++++++++++++++++++++++++++
** Moran's I
** ++++++++++++++++++++++++++++++++

**
foreach VAR in "b_delta_total" "b_delta_office" "b_delta_school" "b_delta_free" "b_delta_business" "b_delta_home" "b_delta_unknown"  {
	moransi `VAR', swm(pow 1.5) lon(lon) lat(lat) dist(.) dunit(km)
}


** ++++++++++++++++++++++++++++++++
** Getis-Ord Stat
** ++++++++++++++++++++++++++++++++

** 
foreach VAR in "b_delta_total" "b_delta_office" "b_delta_school" "b_delta_free" "b_delta_business" "b_delta_home" "b_delta_unknown"  {
	getisord `VAR', lon(lon) lat(lat) swm(bin) dist(10) dunit(km)
}

** Save
save "dta_odflow/dta_step3_estimation_delta_kinki.dta", replace


** ++++++++++++++++++++++++++++++++
** FIGURE
** ++++++++++++++++++++++++++++++++

** LOAD DATA
cd "shp_odflow_poly_simplify"
dir
use "shp_poly_odflow_kinki.dta", clear
		
** SPSET
spset

** MERGE ESTIMATION RESULTS
merge m:1 id_odzone using "../dta_odflow/dta_step3_estimation_delta_kinki.dta"
drop if _merge == 2
drop _merge


** FORMAT
format go_z_b_delta_total_b %4.2f
format go_z_b_delta_office %4.2f
format go_z_b_delta_school %4.2f
format go_z_b_delta_free %4.2f
format go_z_b_delta_business %4.2f
format go_z_b_delta_home %4.2f
format go_z_b_delta_unknown %4.2f


** DESCRIPTIVE STATISTICS
sum /// 
	go_z_b_delta_total ///
	go_z_b_delta_office ///
	go_z_b_delta_school ///
	go_z_b_delta_free ///
	go_z_b_delta_business ///
	go_z_b_delta_home ///
	go_z_b_delta_unknown


** ++++++++++++++++++++++++++++++++
** GRMAP
** ++++++++++++++++++++++++++++++++

** 
sum go_z_b_delta_total_b
local go_max = round(r(max),0.001)
local go_min = round(r(min),0.001)
**
grmap go_z_b_delta_total_b,  ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	ndfcolor(white) ///
	ndsize(none) ///
	clmethod(custom) ///
	clbreaks(`go_min' -2.576 -1.960 1.960 2.576 `go_max') ///
	fcolor(ebblue eltblue white orange red) ///
	osize(none...none) ///
	title("Total Trips", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount 
** Save
graph export "../figure/fig_getisord_delta_total_kinki.svg", replace
graph export "../figure/fig_getisord_delta_total_kinki.eps", fontface("Palatino Linotype") replace



** 
sum go_z_b_delta_office
local go_max = round(r(max),0.001)
local go_min = round(r(min),0.001)
**
grmap go_z_b_delta_office,  ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	ndfcolor(white) ///
	ndsize(none) ///
	clmethod(custom) ///
	clbreaks(`go_min' -2.576 -1.960 1.960 2.576 `go_max') ///
	fcolor(ebblue eltblue white orange red) ///
	osize(none...none) ///
	title("(a) Commuting Trips, Office", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount 
** Save
graph export "../figure/fig_getisord_delta_office_kinki.svg", replace
graph export "../figure/fig_getisord_delta_office_kinki.eps", fontface("Palatino Linotype") replace




** 
sum go_z_b_delta_school
local go_max = round(r(max),0.001)
local go_min = round(r(min),0.001)
**
grmap go_z_b_delta_school,  ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	ndfcolor(white) ///
	ndsize(none) ///
	clmethod(custom) ///
	clbreaks(`go_min' -2.576 -1.960 1.960 2.576 `go_max') ///
	fcolor(ebblue eltblue white orange red) ///
	osize(none...none) ///
	title("(b) Commuting Trips, School", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount 
** Save
graph export "../figure/fig_getisord_delta_school_kinki.svg", replace
graph export "../figure/fig_getisord_delta_school_kinki.eps", fontface("Palatino Linotype") replace



** 
sum go_z_b_delta_business
local go_max = round(r(max),0.001)
local go_min = round(r(min),0.001)
**
grmap go_z_b_delta_business,  ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	ndfcolor(white) ///
	ndsize(none) ///
	clmethod(custom) ///
	clbreaks(`go_min' -2.576 -1.960 1.960 2.576 `go_max') ///
	fcolor(ebblue eltblue white orange red) ///
	osize(none...none) ///
	title("(c) Business Trips", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount 
** Save
graph export "../figure/fig_getisord_delta_business_kinki.svg", replace
graph export "../figure/fig_getisord_delta_business_kinki.eps", fontface("Palatino Linotype") replace


** 
sum go_z_b_delta_free
local go_max = round(r(max),0.001)
local go_min = round(r(min),0.001)
**
grmap go_z_b_delta_free,  ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	ndfcolor(white) ///
	ndsize(none) ///
	clmethod(custom) ///
	clbreaks(`go_min' -2.576 -1.960 1.960 2.576 `go_max') ///
	fcolor(ebblue eltblue white orange red) ///
	osize(none...none) ///
	title("(d) Free Trips", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount 
** Save
graph export "../figure/fig_getisord_delta_free_kinki.svg", replace
graph export "../figure/fig_getisord_delta_free_kinki.eps", fontface("Palatino Linotype") replace



** 
sum go_z_b_delta_home
local go_max = round(r(max),0.001)
local go_min = round(r(min),0.001)
**
grmap go_z_b_delta_home,  ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	ndfcolor(white) ///
	ndsize(none) ///
	clmethod(custom) ///
	clbreaks(`go_min' -2.576 -1.960 1.960 2.576 `go_max') ///
	fcolor(ebblue eltblue white orange red) ///
	osize(none...none) ///
	title("(e) Returning Home Trips", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount 
** Save
graph export "../figure/fig_getisord_delta_home_kinki.svg", replace
graph export "../figure/fig_getisord_delta_home_kinki.eps", fontface("Palatino Linotype") replace




** 
sum go_z_b_delta_unknown
local go_max = round(r(max),0.001)
local go_min = round(r(min),0.001)
**
grmap go_z_b_delta_unknown,  ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	ndfcolor(white) ///
	ndsize(none) ///
	clmethod(custom) ///
	clbreaks(`go_min' -2.576 -1.960 1.960 2.576 `go_max') ///
	fcolor(ebblue eltblue white orange red) ///
	osize(none...none) ///
	title("(f) Unknown Trips", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount 
** Save
graph export "../figure/fig_getisord_delta_unknown_kinki.svg", replace
graph export "../figure/fig_getisord_delta_unknown_kinki.eps", fontface("Palatino Linotype") replace


**
cd ..
