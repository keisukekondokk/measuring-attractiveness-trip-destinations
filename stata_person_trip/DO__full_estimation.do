/***********************************************************
** (C) KEISUKE KONDO
** FIRST UPLOADED: April 4, 2024
** 
** Kondo, K. (2023) "Measuring the Attractiveness of Trip Destinations: A Study of the Kansai Region of Japan," RIEB Discussion Paper Series No.2023-07
** URL: https://github.com/keisukekondokk/measuring-attractiveness-trip-destinations
** 
** [PACKAGES]
** ssc install moransi, replace
** ssc install spgen, replace
** net install st0446_1.pkg, replace
***********************************************************/

** 
do "DO_PT_step0_shape2dta.do"

** 
do "DO_PT_step1_dataset.do"

** 
do "DO_PT_step2_estimation.do"

** 
do "DO_PT_step3_spatial_analysis.do"

** 
do "DO_PT_step3_spatial_analysis.do"

** 
do "DO_PT_step9_figure_map_delta.do"

** 
do "DO_PT_step9_figure_scatterline_flow_distance.do"

** 
do "DO_PT_step9_table_delta.do"

** 
do "DO_PT_step9_table_descriptive_statistics.do"
