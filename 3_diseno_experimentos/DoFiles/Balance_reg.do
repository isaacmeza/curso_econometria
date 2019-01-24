

use "$directorio\DB\treatment_data.dta", clear

********************************************************************************
*Balance test of treatment assignment 




*Varlist 
local balance_all_vlist mujer prob_ganar na_prob prob_mayor na_prob_mayor ///
	cantidad_ganar na_cant  cant_mayor na_cant_mayor sueldo  salario_diario ///
	antiguedad retail outsourcing  mon_tue 
	
local balance_23_vlist	horas_sem dias_sal_dev ///
	 high_school angry diurno top_sue big_size ///
	reclutamiento dummy_confianza dummy_desc_sem ///
	dummy_prima_dom dummy_desc_ob dummy_sarimssinfo  carta_renuncia dummy_reinst 


orth_out `balance_all_vlist' , ///
				by(main_treatment)  vce(robust)   bdec(3)  
qui putexcel K5=matrix(r(matrix)) using "$directorio\Tables\Balance_reg.xlsx", sheet("Balance_reg") modify
		
local i=5		
foreach var of varlist  `balance_all_vlist' {
	di "`var'"
	*1-2 ttest
	mvtest means `var' if inlist(main_treatment, 1,2), by(main_treatment)
	local pval=round(`r(p_F)',.001)
	local pval : di %3.2f `pval'
	qui putexcel F`i'=(`pval') using "$directorio\Tables\Balance_reg.xlsx", sheet("Balance_reg") modify
	*1-3 ttest
	mvtest means `var' if inlist(main_treatment, 1,3), by(main_treatment)
	local pval=round(`r(p_F)',.001)
	local pval : di %3.2f `pval'
	qui putexcel G`i'=(`pval') using "$directorio\Tables\Balance_reg.xlsx", sheet("Balance_reg") modify	
	*2-3 ttest
	mvtest means `var' if inlist(main_treatment, 2,3), by(main_treatment)
	local pval=round(`r(p_F)',.001)
	local pval : di %3.2f `pval'
	qui putexcel H`i'=(`pval') using "$directorio\Tables\Balance_reg.xlsx", sheet("Balance_reg") modify
	*MV test
	mvtest means `var' , by(main_treatment) 
	local pval=round(`r(p_F)',.001)
	local pval : di %3.2f `pval'
	qui putexcel I`i'=(`pval') using "$directorio\Tables\Balance_reg.xlsx", sheet("Balance_reg") modify
	local i=`i'+1
	}

**********************************************	

keep if inrange(main_treatment,2,3)	

orth_out `balance_23_vlist' , ///
				by(main_treatment)  vce(robust)   bdec(3)  
qui putexcel L`i'=matrix(r(matrix)) using "$directorio\Tables\Balance_reg.xlsx", sheet("Balance_reg") modify
		
	
foreach var of varlist `balance_23_vlist' {
	di "`var'"
	*2-3 ttest
	mvtest means `var' if inlist(main_treatment, 2,3), by(main_treatment)
	local pval=round(`r(p_F)',.001)
	local pval : di %3.2f `pval'
	qui putexcel H`i'=(`pval') using "$directorio\Tables\Balance_reg.xlsx", sheet("Balance_reg") modify
	local i=`i'+1
	}

		
	
use "$directorio\DB\treatment_data.dta", clear

*Number of days each treatment occured
by main_treatment fecha_alta, sort: gen nvals = _n ==1
by main_treatment: egen num_days=sum(nvals)

*Number of days
qui su num_days if main_treatment==1 
qui putexcel K`i'=(`r(mean)') using "$directorio\Tables\Balance_reg.xlsx", sheet("Balance_reg") modify
qui su num_days if main_treatment==2		
qui putexcel L`i'=(`r(mean)') using "$directorio\Tables\Balance_reg.xlsx", sheet("Balance_reg") modify
qui su num_days if main_treatment==3	
qui putexcel M`i'=(`r(mean)') using "$directorio\Tables\Balance_reg.xlsx", sheet("Balance_reg") modify

local i=`i'+1
	
*Observations
qui count if main_treatment==1 
qui putexcel K`i'=(`r(N)') using "$directorio\Tables\Balance_reg.xlsx", sheet("Balance_reg") modify
qui count if main_treatment==2		
qui putexcel L`i'=(`r(N)') using "$directorio\Tables\Balance_reg.xlsx", sheet("Balance_reg") modify
qui count if main_treatment==3	
qui putexcel M`i'=(`r(N)') using "$directorio\Tables\Balance_reg.xlsx", sheet("Balance_reg") modify
	
		

********************************************************************************
********************************************************************************
********************************************************************************

