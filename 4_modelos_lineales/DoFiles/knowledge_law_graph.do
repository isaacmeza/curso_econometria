********************************************************************************
*								Phase 1										   *
********************************************************************************

use "$directorio\DB\pilot_casefiles_wod.dta", clear	
merge m:1 folio using  "$directorio/Raw/Append Encuesta Inicial Actor.dta" , keep(3)


	
* What employee asked
gen asked_indemconst=(A_7_2_1==1 | A_7_2_2==1 | A_7_2_3==1 | A_7_2_4==1 | A_7_2_5==1 | A_7_2_6==1 | A_7_2_7==1 | A_7_2_8==1 | A_7_2_9==1)
gen asked_sarimssinf=(A_7_2_1==2 | A_7_2_2==2 | A_7_2_3==2 | A_7_2_4==2 | A_7_2_5==2 | A_7_2_6==2 | A_7_2_7==2 | A_7_2_8==2 | A_7_2_9==2)
gen asked_reinstalacion=(A_7_2_1==3 | A_7_2_2==3 | A_7_2_3==3 | A_7_2_4==3 | A_7_2_5==3 | A_7_2_6==3 | A_7_2_7==3 | A_7_2_8==3 | A_7_2_9==3)
gen asked_rechrextrat=(A_7_2_1==4 | A_7_2_2==4 | A_7_2_3==4 | A_7_2_4==4 | A_7_2_5==4 | A_7_2_6==4 | A_7_2_7==4 | A_7_2_8==4 | A_7_2_9==4)
gen asked_primdom=(A_7_2_1==5 | A_7_2_2==5 | A_7_2_3==5 | A_7_2_4==5 | A_7_2_5==5 | A_7_2_6==5 | A_7_2_7==5 | A_7_2_8==5 | A_7_2_9==5)
gen asked_primavac=(A_7_2_1==6 | A_7_2_2==6 | A_7_2_3==6 | A_7_2_4==6 | A_7_2_5==6 | A_7_2_6==6 | A_7_2_7==6 | A_7_2_8==6 | A_7_2_9==6)
gen asked_nosabe=(A_7_2_1==.s)	


gen correct_indemconst=(asked_indemconst==indemconsttdummy)
gen correct_sarimssinf=(asked_sarimssinf==sarimssinf)
gen correct_reinstalacion=(asked_reinstalacion==reinstalaciont)
gen correct_rechrextrat=(asked_rechrextrat==rechrextra)
gen correct_primdom=(asked_primdom==prima_dom)
gen correct_primavac=(asked_primavac==prima_vac)


*Education
gen more_high_school=inlist(A_1_2, 3,4) if !missing(A_1_2)

*Severance pay
gen knows=A_7_1
gen knows_correctly=( A_7_1_O==90) 

*Trust in lawyer
gen trust_lawyer=(A_8_2==1) if !missing(A_8_2)
*Trust in people
gen trust_people=(A_8_1==1) if !missing(A_8_1)

********************************************************************************
*Regression

matrix results = J(16, 4, .)

local i=1
local j=1
foreach var of varlist knows_correctly correct_*  {	
	*NO CONTROLS
	reg `var' i.abogado_pub, robust
	local df = e(df_r)
	//Row
	matrix results[`i',1] = `j'
	// Beta 
	matrix results[`i',2] = _b[1.abogado_pub]
	// S.E.
	matrix results[`i',3] = _se[1.abogado_pub]
	// P-value
	matrix results[`i',4] = 2*ttail(`df', ///
		abs(_b[1.abogado_pub]/_se[1.abogado_pub]) ///
	)
	local ++i
	local ++j
	
	*CONTROLS
	reg `var' i.abogado_pub i.A_1_2 gen trabajador_base c_antiguedad salario_diario horas_sem, robust
	local df = e(df_r)
	//Row
	matrix results[`i',1] = `j'
	// Beta 
	matrix results[`i',2] = _b[1.abogado_pub]
	// S.E.
	matrix results[`i',3] = _se[1.abogado_pub]
	// P-value
	matrix results[`i',4] = 2*ttail(`df', ///
		abs(_b[1.abogado_pub]/_se[1.abogado_pub]) ///
	)	
	local ++i
	local j=`j'+10
	}

reg trust_lawyer i.abogado_pub trust_people i.A_1_2 gen trabajador_base c_antiguedad salario_diario horas_sem, r	
	local df = e(df_r)
	
	//Row
	matrix results[`i',1] = `j'
	// Constant
	matrix results[`i',2] = _b[_cons]
	// S.E.
	matrix results[`i',3] = _se[_cons]
	// P-value
	matrix results[`i',4] = 2*ttail(`df', ///
		abs(_b[_cons]/_se[_cons]) ///
	)	
	local ++i
	local ++j
	//Row
	matrix results[`i',1] = `j'	
	// Beta 
	matrix results[`i',2] = _b[1.abogado_pub]
	// S.E.
	matrix results[`i',3] = _se[1.abogado_pub]
	// P-value
	matrix results[`i',4] = 2*ttail(`df', ///
		abs(_b[1.abogado_pub]/_se[1.abogado_pub]) ///
	)	

	
	
matrix colnames results =  "row" "beta" "se" "p" 
matlist results


***************************
** GRAPH 				 **
***************************
// First, replace data in memory with results
clear
svmat results, names(col) 

// GRAPH FORMATTING
// For graphs:
local estimate_options_0  mcolor(gs12)   
local estimate_options_90 mcolor(gs7)   
local estimate_options_95 mcolor(gs0) 
local rcap_options_0  lcolor(gs12)   lwidth(thin)
local rcap_options_90 lcolor(gs7)   lwidth(thin)
local rcap_options_95 lcolor(gs0) lwidth(thin)


// Confidence intervals (95%)
local alpha = .05 // for 95% confidence intervals
gen rcap_lo = beta - invttail(`df',`=`alpha'/2')*se
gen rcap_hi = beta + invttail(`df',`=`alpha'/2')*se



// GRAPH
#delimit ;
twoway (bar beta row if p<0.05,           `estimate_options_95') 
	(bar beta row if p>=0.05 & p<0.10, `estimate_options_90') 
	(bar beta row if p>=0.10,          `estimate_options_0' ) 
	(rcap rcap_hi rcap_lo row if p<0.05,           `rcap_options_95')
	(rcap rcap_hi rcap_lo row if p>=0.05 & p<0.10, `rcap_options_90')
	(rcap rcap_hi rcap_lo row if p>=0.10,          `rcap_options_0' ),
	graphregion(color(white)) scheme(s2mono) ytitle("Effect" "Public Lawyer") title("Knowledge by type of lawyer")
	xtitle("") legend(off) xline(73, lwidth(thick) lcolor(black))
	xlabel( 1.5 `" "Knows" "Sev. Payment" "' 
		12.5 `" "Asked" "Sev. Payment" "'
		23.5 `" "Asked" "Reinstatement" "'
		34.5 `" "Asked" "Sev. Payment" "'
		45.6 `" "Asked" "Overtime" "'
		56.5 `" "Asked" "Sunday bonus" "'
		67.5 `" "Asked" "Soc. Sec." "'
		78 `" "Constant" "'
		79.5 `" "Beta" "'
		81.5 `" " " "Trust in lawyer" "'
		, noticks angle(vertical))
	
;
#delimit cr	
