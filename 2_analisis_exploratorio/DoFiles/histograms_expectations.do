
*************************************2M*****************************************
use "$directorio\DB\survey_data_2m.dta", clear
merge 1:1 id_actor using "$directorio\DB\treatment_data.dta", keep(2 3)

*Amount normalized to days of salary
replace cantidad_ganar_treat=cantidad_ganar if main_treatment==1 & !missing(cantidad_ganar) 
replace cantidad_ganar_survey=cantidad_ganar_survey/salario_diario
replace cantidad_ganar=cantidad_ganar/salario_diario
replace cantidad_ganar_treat=cantidad_ganar_treat/salario_diario 

replace prob_ganar_treat=prob_ganar if main_treatment==1 & !missing(prob_ganar) 

gen diff_amt=cantidad_ganar_survey-cantidad_ganar
gen diff_amt_inm=cantidad_ganar_treat-cantidad_ganar
gen diff_prob= prob_ganar_survey-prob_ganar
gen diff_prob_inm= prob_ganar_treat-prob_ganar

gen ratio_amt_inm=(cantidad_ganar_treat-cantidad_ganar)/cantidad_ganar
gen ratio_prob_inm=(prob_ganar_treat-prob_ganar)/prob_ganar


foreach var of varlist cantidad_ganar_survey cantidad_ganar cantidad_ganar_treat ///
	diff_amt* update_comp_survey update_prob_survey ///
	ratio_amt_inm ratio_prob_inm {
	xtile perc_`var'=`var', nq(100)
	}

	
	
*Amount
hist cantidad_ganar_survey if perc_cantidad_ganar_survey<=90, scheme(s2mono) percent ///
	xtitle("Days of salary") title("Survey 2M") graphregion(color(white)) name(exp2m_amt, replace)
hist cantidad_ganar if perc_cantidad_ganar<=90, scheme(s2mono) percent ///
	xtitle("Days of salary") title("Baseline") graphregion(color(white))	name(baseline_amt, replace)
hist cantidad_ganar_treat if perc_cantidad_ganar_treat<=90, scheme(s2mono) percent ///
	xtitle("Days of salary") title("Immediate") graphregion(color(white))	name(inm_amt, replace)
hist diff_amt if inrange(perc_diff_amt,5,95), scheme(s2mono) percent ///
	xtitle("Days of salary") title("2M") graphregion(color(white))	name(diff2m_amt, replace)	
hist diff_amt_inm if inrange(perc_diff_amt_inm,5,95), scheme(s2mono) percent ///
	xtitle("Days of salary") title("Immediate") graphregion(color(white))	name(diffinm_amt, replace)	
hist ratio_amt_inm if inrange(perc_ratio_amt_inm,5,95), scheme(s2mono) percent ///
	xtitle("Ratio") title("Immediate") graphregion(color(white))	name(ratioinm_amt, replace)	
hist update_comp_survey if inrange(perc_update_comp_survey,5,95), scheme(s2mono) percent ///
	xtitle("Ratio") title("2M") graphregion(color(white))	name(ratio2m_amt, replace)
		
*Probability	
hist prob_ganar_survey , scheme(s2mono) percent ///
	xtitle("Probability") title("Survey 2M") graphregion(color(white)) name(exp2m_prob, replace)
hist prob_ganar , scheme(s2mono) percent ///
	xtitle("Probability") title("Baseline") graphregion(color(white))	name(baseline_prob, replace)
hist prob_ganar_treat , scheme(s2mono) percent ///
	xtitle("Probability") title("Immediate") graphregion(color(white))	name(inm_prob, replace)
hist diff_prob , scheme(s2mono) percent ///
	xtitle("Probability") title("2M") graphregion(color(white))	name(diff2m_prob, replace)
hist diff_prob_inm , scheme(s2mono) percent ///
	xtitle("Probability") title("2M") graphregion(color(white))	name(diffinm_prob, replace)
hist ratio_prob_inm if inrange(perc_ratio_prob_inm,5,95), scheme(s2mono) percent ///
	xtitle("Ratio") title("Immediate") graphregion(color(white))	name(ratioinm_prob, replace)
hist update_prob_survey if inrange(perc_update_prob_survey,5,95), scheme(s2mono) percent ///
	xtitle("Ratio") title("2M") graphregion(color(white))	name(ratio2m_prob, replace)
			
	
	
*************************************2W*****************************************
use "$directorio\DB\survey_data_2m.dta", clear
merge 1:1 id_actor using "$directorio\DB\treatment_data.dta", keep(2 3)

*Amount normalized to days of salary
replace cantidad_ganar_survey=cantidad_ganar_survey/salario_diario
replace cantidad_ganar=cantidad_ganar/salario_diario
gen diff_amt=cantidad_ganar_survey-cantidad_ganar
gen diff_prob= prob_ganar_survey-prob_ganar

foreach var of varlist cantidad_ganar_survey cantidad_ganar ///
	diff_amt update_comp_survey update_prob_survey {
	xtile perc_`var'=`var', nq(100)
	}
	
	
*Amount
hist cantidad_ganar_survey if perc_cantidad_ganar_survey<=90, scheme(s2mono) percent ///
	xtitle("Days of salary") title("Survey 2W") graphregion(color(white)) name(exp2w_amt, replace)
hist diff_amt if inrange(perc_diff_amt,5,95), scheme(s2mono) percent ///
	xtitle("Days of salary") title("2W") graphregion(color(white))	name(diff2w_amt, replace)
hist update_comp_survey if inrange(perc_update_comp_survey,5,95), scheme(s2mono) percent ///
	xtitle("Ratio") title("2W") graphregion(color(white))	name(ratio2w_amt, replace)
		
*Probability	
hist prob_ganar_survey , scheme(s2mono) percent ///
	xtitle("Probability") title("Survey 2W") graphregion(color(white)) name(exp2w_prob, replace)
hist diff_prob , scheme(s2mono) percent ///
	xtitle("Probability") title("2W") graphregion(color(white))	name(diff2w_prob, replace)
hist update_prob_survey if inrange(perc_update_prob_survey,5,95), scheme(s2mono) percent ///
	xtitle("Ratio") title("2W") graphregion(color(white))	name(ratio2w_prob, replace)
			
	
********************************************************************************
graph combine baseline_amt inm_amt exp2w_amt exp2m_amt, xcommon title("Amount/Daily wage") graphregion(color(white)) scheme(s2mono)
graph export "$directorio/Figuras/hist_exp_amt.pdf", replace 		 

graph combine baseline_prob inm_prob exp2w_prob exp2m_prob, xcommon title("Probability") graphregion(color(white)) scheme(s2mono)
graph export "$directorio/Figuras/hist_exp_prob.pdf", replace 		 

graph combine diff2m_amt diff2w_amt, xcommon title("Difference in Amount/Daily wage") graphregion(color(white)) scheme(s2mono)
graph export "$directorio/Figuras/hist_diff_amt.pdf", replace 		 

graph combine diff2m_prob diff2w_prob, xcommon title("Difference in Probabilty") graphregion(color(white)) scheme(s2mono)
graph export "$directorio/Figuras/hist_diff_prob.pdf", replace 		 

graph combine ratio2m_amt ratio2w_amt, xcommon title("Ratio in Amount") graphregion(color(white)) scheme(s2mono)
graph export "$directorio/Figuras/hist_ratio_amt.pdf", replace 		 

graph combine ratio2m_prob ratio2w_prob, xcommon title("Ratio in Probability") graphregion(color(white)) scheme(s2mono)
graph export "$directorio/Figuras/hist_ratio_prob.pdf", replace 		 
