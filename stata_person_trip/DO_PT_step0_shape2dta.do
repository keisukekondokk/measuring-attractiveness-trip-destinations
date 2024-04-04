/***********************************************************
** (C) KEISUKE KONDO
** FIRST UPLOADED: April 4, 2024
** 
** Kondo, K. (2023) "Measuring the Attractiveness of Trip Destinations: A Study of the Kansai Region of Japan," RIEB Discussion Paper Series No.2023-07
** URL: https://github.com/keisukekondokk/measuring-attractiveness-trip-destinations
***********************************************************/

** +++++++++++++++++++++++++++++++++++++++++
** OD FLOWS
** +++++++++++++++++++++++++++++++++++++++++

**
cd "shp_odflow_line"

** ZIP
unzipfile "S05-b-12_KINKI_GML.zip", replace

** DELETE FILES
local list : dir . files "*.xml"
foreach f of local list {
    erase "`f'"
}

** SHP2DTA
spshape2dta "S05-b-12_KINKI-g_PersonTripODAmount.shp", replace

cd ".."


** +++++++++++++++++++++++++++++++++++++++++
** OD POINT
** +++++++++++++++++++++++++++++++++++++++++

** 
use "shp_odflow_line/S05-b-12_KINKI-g_PersonTripODAmount_shp.dta", clear


** Point of Origin
preserve
keep if shape_order == 2
rename _X lon_o
rename _Y lat_o
drop rec_header shape_order
save "dta_odflow/dta_step0_odflow_2010_kinki_lonlat_origin.dta", replace
restore

** Point of Destination
preserve
keep if shape_order == 3
rename _X lon_d
rename _Y lat_d
drop rec_header shape_order
save "dta_odflow/dta_step0_odflow_2010_kinki_lonlat_destination.dta", replace
restore

** 
clear



** +++++++++++++++++++++++++++++++++++++++++
** OD POLYGON
** +++++++++++++++++++++++++++++++++++++++++


cd "shp_odflow_poly"

** ZIP
unzipfile "S05-a-12_KINKI_GML.zip", replace

** DELETE FILES
local list : dir . files "*.xml"
foreach f of local list {
    erase "`f'"
}

** RENAME FILES
foreach ext in "dbf" "shp" "shx" {
    shell ren "S05-a-12_KINKI-g_Occurred_ConcentratedTrafficVolumeOfPersonTrip.`ext'" "shp_poly_odflow_kinki.`ext'"
}

** SHP2DTA
spshape2dta "shp_poly_odflow_kinki.shp", replace

cd ".."

