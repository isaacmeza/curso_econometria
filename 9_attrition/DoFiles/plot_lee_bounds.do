*PLOT OF BOUNDS

********************************************************************************
************************************2M******************************************
use "$directorio\DB\survey_data_2m.dta", clear
merge 1:1 id_actor using "$directorio\DB\treatment_data.dta", keep(2 3)
qui su date
keep if inrange(date,`r(min)',date(c(current_date) ,"DMY")-70)
			
qui gen telefono_int=telefono_cel*telefono_fijo
matrix results = J(12, 11, .)

********************************************************************************

	
*COMPUTATION OF BOUNDS
local v=1
foreach vardep of varlist conflicto_arreglado entablo_demanda {
	foreach t in 2 3 b {
		preserve
		do "$directorio\9_attrition\DoFiles\lee_bounds.do" ///
				`vardep' `t' "no_condition" "" `v'
		restore
		local v=`v'+1
		}
	}

foreach t in 2 3 b {
	preserve
	do "$directorio\9_attrition\DoFiles\lee_bounds.do" ///
			demando_con_abogado_publico `t' entablo_demanda "" `v'
	restore
	local v=`v'+1
	}

foreach t in 2 3 b {
	preserve
	do "$directorio\9_attrition\DoFiles\lee_bounds.do" ///
			coyote `t' demando_con_abogado_privado entablo_demanda `v'
	restore
	local v=`v'+1
	}
		

***
clear
matrix colnames results = "t" "t_lo" "t_hi" ///
						"lb" "lb_lo" "lb_hi"  ///
						"ub" "ub_lo" "ub_hi" ///
 						"mil" "miu"
svmat results, names(col) 

cap drop k
gen k=_n
forvalues i=4(3)12 {
	replace k=k+6 if _n>=`i'
	}
	


twoway  (rcap ub lb k if inlist(k ,1,10,19, 28) ,   ///
				msize(huge) lwidth(thick) color(black) lpattern(dash)) ///
		(rcap ub lb k if inlist(k ,2,11,20, 29) ,   ///
				msize(huge) lwidth(thick) color(black) lpattern(solid))  ///
		(rcap ub lb k if inlist(k ,3,12,21, 30) ,   ///
				msize(huge) lwidth(thick) color(black) lpattern(dot))  ///		
		(scatter ub k, msize(medlarge) color(black) mfcolor(white) msymbol(circle)) ///	
		(scatter lb k, msize(medlarge) color(black) mfcolor(white) msymbol(circle)) ///	
		(rcap ub_hi ub_lo k, msize(small) color(gs9)) ///
		(rcap lb_hi lb_lo k, msize(small) color(gs9)) ///
		, scheme(s2mono) graphregion(color(white)) ///	
		legend(order (1 "T1/T2" 2 "T1/T3" 3 "A/B") cols(3)  symysize(.1)) ///
		 title("Lee Bounds") subtitle("2M") ytitle("ATE") xtitle("") ///
		 xlabel(2 "Solved conflict"	 11 "Sued" 20 "Sued w/public" 29 "Inf Lawyer" )
graph export "$directorio/Figuras/lee_bounds_2m.pdf", replace 		 
		 
		 
twoway  (rcap miu mil k if inlist(k ,1,10,19, 28) ,   ///
				msize(huge) lwidth(thick) color(black) lpattern(dash))  ///
		(rcap miu mil k if inlist(k ,2,11,20, 29) ,   ///
				msize(huge) lwidth(thick) color(black) lpattern(solid))  ///
		(rcap miu mil k if inlist(k ,3,12,21, 30) ,   ///
				msize(huge) lwidth(thick) color(black) lpattern(dot))  ///			
		(scatter miu k, msize(medlarge) color(black) mfcolor(white) msymbol(circle)) ///	
		(scatter mil k, msize(medlarge) color(black) mfcolor(white) msymbol(circle)) ///	
		, scheme(s2mono) graphregion(color(white)) ///	
		legend(order (1 "T1/T2" 2 "T1/T3" 3 "A/B") cols(3)  symysize(.1)) ///
		 title("Manski-Lee Bounds") subtitle("2M") ytitle("ATE") xtitle("") ///
		 xlabel(2 "Solved conflict"	 11 "Sued" 20 "Sued w/public" 29 "Inf Lawyer" )		 
graph export "$directorio/Figuras/manski_lee_bounds_2m.pdf", replace 		 



********************************************************************************	



********************************************************************************
