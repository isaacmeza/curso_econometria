*SUMMARY STATISTICS TABLE

local ss_vars_bvc mujer salario_diario antiguedad   /*BVC*/
local ss_vars_exp	prob_ganar  prob_mayor cantidad_ganar   cant_mayor  /*Baseline survey*/
local ss_vars_y	hablo_con_abogado conflicto_arreglado ///
	entablo_demanda demando_con_abogado_publico /*Dep vars*/
	

use "$directorio\DB\treatment_data.dta", clear
merge 1:1 id_actor using "$directorio\DB\survey_data_2w.dta", nogen keep(1 3) keepusing(hablo_con_abogado)
merge 1:1 id_actor using "$directorio\DB\survey_data_2m.dta", nogen keep(1 3) 


*SS
orth_out `ss_vars_bvc' , ///
				by(main_treatment) se vce(robust)   bdec(2)  
qui putexcel I6=matrix(r(matrix)) using "$directorio\Tables\SS.xlsx", sheet("SS") modify
		
local i=6	
foreach var of varlist `ss_vars_bvc' {
	qui putexcel H`i'=("`var'") using "$directorio\Tables\SS.xlsx", sheet("SS") modify
	local i=`i'+2
	}
*******
orth_out `ss_vars_exp' , ///
				by(main_treatment) se vce(robust)   bdec(2)  
qui putexcel I13=matrix(r(matrix)) using "$directorio\Tables\SS.xlsx", sheet("SS") modify
		
local i=13	
foreach var of varlist `ss_vars_exp' {
	qui putexcel H`i'=("`var'") using "$directorio\Tables\SS.xlsx", sheet("SS") modify
	local i=`i'+2
	}
*******
orth_out `ss_vars_y' , ///
				by(main_treatment) se vce(robust)   bdec(2)  
qui putexcel I23=matrix(r(matrix)) using "$directorio\Tables\SS.xlsx", sheet("SS") modify
		
local i=23	
foreach var of varlist `ss_vars_y' {
	qui putexcel H`i'=("`var'") using "$directorio\Tables\SS.xlsx", sheet("SS") modify
	local i=`i'+2
	}
	
***************************************

*SS
orth_out `ss_vars_bvc' , ///
				by(group) se vce(robust)   bdec(2)  
qui putexcel I39=matrix(r(matrix)) using "$directorio\Tables\SS.xlsx", sheet("SS") modify
		
local i=39	
foreach var of varlist `ss_vars_bvc' {
	qui putexcel H`i'=("`var'") using "$directorio\Tables\SS.xlsx", sheet("SS") modify
	local i=`i'+2
	}
*******
orth_out `ss_vars_exp' , ///
				by(group) se vce(robust)   bdec(2)  
qui putexcel I46=matrix(r(matrix)) using "$directorio\Tables\SS.xlsx", sheet("SS") modify
		
local i=46	
foreach var of varlist `ss_vars_exp' {
	qui putexcel H`i'=("`var'") using "$directorio\Tables\SS.xlsx", sheet("SS") modify
	local i=`i'+2
	}
*******
orth_out `ss_vars_y' , ///
				by(group) se vce(robust)   bdec(2)  
qui putexcel I56=matrix(r(matrix)) using "$directorio\Tables\SS.xlsx", sheet("SS") modify
		
local i=56	
foreach var of varlist `ss_vars_y' {
	qui putexcel H`i'=("`var'") using "$directorio\Tables\SS.xlsx", sheet("SS") modify
	local i=`i'+2
	}

	***********************************************************************
								*Observations*
	
use "$directorio\DB\treatment_data.dta", clear


*Observations
qui count if main_treatment==1 
qui putexcel I21=(`r(N)') using "$directorio\Tables\SS.xlsx", sheet("SS") modify
qui count if main_treatment==2		
qui putexcel J21=(`r(N)') using "$directorio\Tables\SS.xlsx", sheet("SS") modify
qui count if main_treatment==3	
qui putexcel K21=(`r(N)') using "$directorio\Tables\SS.xlsx", sheet("SS") modify


*Observations A/B
qui count if group==1 
qui putexcel I54=(`r(N)') using "$directorio\Tables\SS.xlsx", sheet("SS") modify
qui count if group==2		
qui putexcel J54=(`r(N)') using "$directorio\Tables\SS.xlsx", sheet("SS") modify


merge 1:1 id_actor using "$directorio\DB\survey_data_2w.dta", nogen keep(3)
merge 1:1 id_actor using "$directorio\DB\survey_data_2m.dta", nogen keep(3) force

*Observations survey
qui count if main_treatment==1 
qui putexcel I31=(`r(N)') using "$directorio\Tables\SS.xlsx", sheet("SS") modify
qui count if main_treatment==2		
qui putexcel J31=(`r(N)') using "$directorio\Tables\SS.xlsx", sheet("SS") modify
qui count if main_treatment==3	
qui putexcel K31=(`r(N)') using "$directorio\Tables\SS.xlsx", sheet("SS") modify


*Observations survey A/B
qui count if group==1 
qui putexcel I64=(`r(N)') using "$directorio\Tables\SS.xlsx", sheet("SS") modify
qui count if group==2		
qui putexcel J64=(`r(N)') using "$directorio\Tables\SS.xlsx", sheet("SS") modify
