*BALANCE
local depvar mujer salario_diario antiguedad mon_tue angry high_school prob_ganar na_prob prob_mayor na_prob_mayor cantidad_ganar na_cant  cant_mayor na_cant_mayor



********************************************************************************
*									2W								  		   *
********************************************************************************
use "$directorio\DB\survey_data_2w.dta", clear
merge 1:1 id_actor using "$directorio\DB\treatment_data.dta", keep(3)

********************************************************************************

qui gen esample=1	
qui gen nvals=.


	
*******************************
* 			   A-B			  *
*******************************
	
	
foreach var in `depvar'	{
	
	eststo: reg `var' i.group, robust cluster(fecha_alta)
	estadd scalar Erre=e(r2)
	estadd local Source="2w"
	forvalues i=1/2 {
		qui count if group==`i' & e(sample)
		local obs_`i'=r(N)
		}	
	estadd local obs_per_gr="`obs_1'/`obs_2'"
	
	}
	
	
	*************************
	esttab using "$directorio/Tables/reg_results/reg_balance_2w.csv", se star(* 0.1 ** 0.05 *** 0.01) b(a2) ///
	scalars("Erre R-squared"  "Source Source" "obs_per_gr Obs per group" ) replace 
	
	

********************************************************************************
*									2M								  		   *
********************************************************************************
use "$directorio\DB\survey_data_2m.dta", clear
merge 1:1 id_actor using "$directorio\DB\treatment_data.dta", keep(3)

********************************************************************************

qui gen esample=1	
qui gen nvals=.


	
*******************************
* 			   A-B			  *
*******************************
	
	
foreach var in `depvar'	{
	
	eststo: reg `var' i.group, robust cluster(fecha_alta)
	estadd scalar Erre=e(r2)
	estadd local Source="2m"
	forvalues i=1/2 {
		qui count if group==`i' & e(sample)
		local obs_`i'=r(N)
		}	
	estadd local obs_per_gr="`obs_1'/`obs_2'"
	
	}
	
	
	*************************
	esttab using "$directorio/Tables/reg_results/reg_balance_2m.csv", se star(* 0.1 ** 0.05 *** 0.01) b(a2) ///
	scalars("Erre R-squared"  "Source Source" "obs_per_gr Obs per group" ) replace 
		
		
