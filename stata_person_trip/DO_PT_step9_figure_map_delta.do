/***********************************************************
** (C) KEISUKE KONDO
** FIRST UPLOADED: April 4, 2024
** 
** Kondo, K. (2023) "Measuring the Attractiveness of Trip Destinations: A Study of the Kansai Region of Japan," RIEB Discussion Paper Series No.2023-07
** URL: https://github.com/keisukekondokk/measuring-attractiveness-trip-destinations
***********************************************************/

** LOAD DATA
cd "shp_odflow_poly_simplify"
dir
use "shp_poly_odflow_kinki.dta", clear
		
** SPSET
spset

** MERGE ESTIMATION RESULTS
merge m:1 id_odzone using "../dta_odflow/dta_step2_estimation_delta_kinki.dta"
drop if _merge == 2
drop _merge


** FORMAT
foreach k in "total" "office" "school" "free" "business" "home" "unknown" {
	format b_delta_`k' %4.2f
}


** DESCRIPTIVE STATISTICS
sum /// 
	b_delta_total ///
	b_delta_office ///
	b_delta_school ///
	b_delta_free ///
	b_delta_business ///
	b_delta_home ///
	b_delta_unknown


** ++++++++++++++++++++++++++++++++
** GRMAP
** ++++++++++++++++++++++++++++++++

** 
grmap b_delta_total,  ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	clmethod(custom) ///
	clbreaks(-7 -5 -3 -2.75 -2.5 -2.25 -2 -1.5 -1) ///
	ndfcolor(white) ///
	ndsize(none) ///
	fcolor(Oranges) /// 
	osize(none...none) ///
	title("Total Trips", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount
** Save
graph export "../figure/fig_persontrip_map_delta_total_kinki.svg", replace
graph export "../figure/fig_persontrip_map_delta_total_kinki.eps", fontface("Palatino Linotype") replace

** 
grmap b_delta_office,  ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	clmethod(custom) ///
	clbreaks(-7 -5 -3 -2.75 -2.5 -2.25 -2 -1.5 -1) ///
	ndfcolor(white) ///
	ndsize(none) ///
	fcolor(Oranges) /// 
	osize(none...none) ///
	title("(a) Commuting Trips, Office", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount
** Save
graph export "../figure/fig_persontrip_map_delta_office_kinki.svg", replace
graph export "../figure/fig_persontrip_map_delta_office_kinki.eps", fontface("Palatino Linotype") replace

** 
grmap b_delta_school,  ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	clmethod(custom) ///
	clbreaks(-7 -5 -3 -2.75 -2.5 -2.25 -2 -1.5 -1) ///
	ndfcolor(white) ///
	ndsize(none) ///
	fcolor(Oranges) /// 
	osize(none...none) ///
	title("(b) Commuting Trips, School", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount
** Save
graph export "../figure/fig_persontrip_map_delta_school_kinki.svg", replace
graph export "../figure/fig_persontrip_map_delta_school_kinki.eps", fontface("Palatino Linotype") replace

** 
grmap b_delta_business,  ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	clmethod(custom) ///
	clbreaks(-7 -5 -3 -2.75 -2.5 -2.25 -2 -1.5 -1) ///
	ndfcolor(white) ///
	ndsize(none) ///
	fcolor(Oranges) /// 
	osize(none...none) ///
	title("(c) Business Trips", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount
** Save
graph export "../figure/fig_persontrip_map_delta_business_kinki.svg", replace
graph export "../figure/fig_persontrip_map_delta_business_kinki.eps", fontface("Palatino Linotype") replace

** 
grmap b_delta_free,  ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	clmethod(custom) ///
	clbreaks(-7 -5 -3 -2.75 -2.5 -2.25 -2 -1.5 -1) ///
	ndfcolor(white) ///
	ndsize(none) ///
	fcolor(Oranges) /// 
	osize(none...none) ///
	title("(d) Free Trips", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount
** Save
graph export "../figure/fig_persontrip_map_delta_free_kinki.svg", replace
graph export "../figure/fig_persontrip_map_delta_free_kinki.eps", fontface("Palatino Linotype") replace

** 
grmap b_delta_home,  ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	clmethod(custom) ///
	clbreaks(-7 -5 -3 -2.75 -2.5 -2.25 -2 -1.5 -1) ///
	ndfcolor(white) ///
	ndsize(none) ///
	fcolor(Oranges) /// 
	osize(none...none) ///
	title("(e) Returning Home Trips", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount
** Save
graph export "../figure/fig_persontrip_map_delta_home_kinki.svg", replace
graph export "../figure/fig_persontrip_map_delta_home_kinki.eps", fontface("Palatino Linotype") replace

** 
grmap b_delta_unknown, ///
	polygon(data("../shp_odflow_poly_simplify/shp_poly_pref_kinki_shp.dta") osize(medthick)) ///
	line(data("../shp_odflow_poly_simplify/shp_poly_muni_kinki_shp.dta") size(vvthin)) ///
	clmethod(custom) ///
	clbreaks(-7 -5 -3 -2.75 -2.5 -2.25 -2 -1.5 -1) ///
	ndfcolor(white) ///
	ndsize(none) ///
	fcolor(Oranges) /// 
	osize(none...none) ///
	title("(f) Unknown Trips", position(6) size(large)) ///
	legend(position(7) size(medsmall)) ///
	legcount
** Save
graph export "../figure/fig_persontrip_map_delta_unknown_kinki.svg", replace
graph export "../figure/fig_persontrip_map_delta_unknown_kinki.eps", fontface("Palatino Linotype") replace

**
cd ..
