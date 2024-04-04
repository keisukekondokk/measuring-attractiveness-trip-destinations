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
** Estimation
** +++++++++++++++++++++++++++++++++++++++++

** 
matrix mDeltaCoef = J(3, 3, .)
matrix mDeltaSe = J(3, 3, .)

** LIST
local LIST_ODZONE = "31230 51110 71230"
disp "`LIST_ODZONE'"

** 
local idx = 0
foreach K in `LIST_ODZONE' {
	** 
	disp "=========================================================="
	disp "ODZONE CODE: `K'"
	disp "=========================================================="
	
	** 
	local idx = `idx' + 1
	matrix mDeltaCoef[`idx', 1] = `K'
	matrix mDeltaSe[`idx', 1] = `K'

	** Estimation: TOTAL
	** ゼロフローが10以下は推定しない
	count if id_destination == `K' & cnt_trip_allmode_total != 0 & distance > diameter_internal_d
	local obs_nonzero = r(N)
	if( `obs_nonzero' >= 10 ) {
		** 
		gen b_delta_odzone`K' = .
		gen b_const_odzone`K' = .
		**
		poisson cnt_trip_allmode_total lndist if id_destination == `K' & distance > diameter_internal_d, robust
		**
		matrix mDeltaCoef[`idx', 2] = _b[_cons]
		matrix mDeltaCoef[`idx', 3] = _b[lndist]
		matrix mDeltaSe[`idx', 2] = _se[_cons]
		matrix mDeltaSe[`idx', 3] = _se[lndist]
		
		local b_delta = _b[lndist]
		local b_const = _b[_cons]
		disp "`b_delta'"
		disp "`b_const'"
		replace b_delta_odzone`K' = `b_delta'
		replace b_const_odzone`K' = `b_const'

		**
		sum cnt_trip_allmode_total if id_destination == `K' & distance >= diameter_internal_d
		
		** 
		gen text_y_odzone`K' = 35000
		gen text_x_odzone`K' = 5.5 if id_destination == `K' & distance >= diameter_internal_d

		**
		gen text_odzone`K' = ""
		replace text_odzone`K' = "Flow = exp(`:display %5.3f `b_const'' `:display %5.3f `b_delta'' * log(Dist))" if id_destination == `K' & distance >= diameter_internal_d
		
	}
}

** 
matrix list mDeltaCoef
matrix list mDeltaSe


** +++++++++++++++++++++++++++++++++++++++++
** Scatter Plot
** +++++++++++++++++++++++++++++++++++++++++


** Kyoto station, Kyoto
twoway ///
	(scatter cnt_trip_allmode_total lndist if id_destination == 31230 & distance > diameter_internal_d & id_origin != id_destination) ///
	(function y = exp(mDeltaCoef[1, 2] + mDeltaCoef[1, 3] * x), range(1 5) lwidth(thick)) ///
	(scatter text_y_odzone31230 text_x_odzone31230 if id_origin == 71130, mcolor(none) mlab(text_odzone31230) mlabcolor(black) mlabposition(9) mlabsize(large)) ///
	, ///
	ysize(2) ///
	xsize(5) ///
	ylabel(0(5000)35000, ang(h) labsize(large) grid gmin gmax) ///
	xlabel(0(1)5.5, labsize(large) grid gmin gmax) ///
	ytitle() ///
	xtitle() ///
	legend(off) ///
	title("Kyoto station area, Kyoto city", box bexpand bcolor(gs12)) ///
	graphregion(color(white) fcolor(white)) ///
	name(g1, replace)

** Osaka station, Osaka
twoway ///
	(scatter cnt_trip_allmode_total lndist if id_destination == 51110 & dist > diameter_internal_d & id_origin != id_destination) ///
	(function y = exp(mDeltaCoef[2, 2] + mDeltaCoef[2, 3] * x), range(0.5 5) lwidth(thick)) ///
	(scatter text_y_odzone51110 text_x_odzone51110 if id_origin == 71130, mcolor(none) mlab(text_odzone51110) mlabcolor(black) mlabposition(9) mlabsize(large)) ///
	, ///
	ysize(2) ///
	xsize(5) ///
	ylabel(0(5000)35000, ang(h) labsize(large) grid gmin gmax) ///
	xlabel(0(1)5.5, labsize(large) grid gmin gmax) ///
	ytitle() ///
	xtitle() ///
	legend(off) ///
	title("Osaka station area, Osaka city", box bexpand bcolor(gs12)) ///
	graphregion(color(white) fcolor(white)) ///
	name(g2, replace)

** Sannnomiya station, Kobe
twoway ///
	(scatter cnt_trip_allmode_total lndist if id_destination == 71230 & distance > diameter_internal_d & id_origin != id_destination) ///
	(function y = exp(mDeltaCoef[3, 2] + mDeltaCoef[3, 3] * x), range(1.0 5) lwidth(thick)) ///
	(scatter text_y_odzone71230 text_x_odzone71230 if id_origin == 71130, mcolor(none) mlab(text_odzone71230) mlabcolor(black) mlabposition(9) mlabsize(large)) ///
	, ///
	ysize(2) ///
	xsize(5) ///
	ylabel(0(5000)35000, ang(h) labsize(large) grid gmin gmax) ///
	xlabel(0(1)5.5, labsize(large) grid gmin gmax) ///
	ytitle() ///
	xtitle() ///
	legend(off) ///
	title("Sannomiya station area, Kobe city", box bexpand bcolor(gs12)) ///
	graphregion(color(white) fcolor(white)) ///
	name(g3, replace)

** GRAPH 
graph combine g1 g2 g3, col(3) ysize(6) xsize(15) ycommon imargin(zero) ///
	graphregion(color(white) fcolor(white)) l1("Number of Trips") b1("log(Distance), (km)")

** Save
graph export "figure/fIG_scatter_cnt_trip_lndist_kinki.eps", fontface("Palatino Linotype") replace
graph export "figure/fIG_scatter_cnt_trip_lndist_kinki.svg", replace

