*NLLS
/*
Fit the CES production function
\ln Q = \beta_0 -1/\rho * (\ln [\delta K_i^{-\rho}+(1-\delta)\ln L_i^{-\rho}])+\epsilon_i
*/

use http://www.stata-press.com/data/r13/production, clear
nl (lnoutput = {b0} - 1/{rho=1}*ln({delta=0.5}*capital^(-1*{rho}) + (1 - {delta})*labor^(-1*{rho})))



********************************************************************************

use "$directorio\DB\calculadora.dta", clear


/*			end_mode 1 "Settlement" ///
						2 "Drop" ///
						3 "Court ruling zero" ///
						4 "Expiry" ///
						5 "Court ruling positive"
						
*/						
********************************************************************************
********************************************************************************
********************************************************************************


*Cross-validation LASSO
cvlasso end_mode_1 gen horas_sem salario_diario abogado_pub c_antiguedad trabajador_base indem sal_caidos prima_antig prima_vac hextra prima_dom desc_sem desc_ob sarimssinf utilidades nulidad codem reinst c_indem c_prima_antig c_rec20 c_ag c_vac c_hextra c_prima_vac c_prima_dom c_desc_sem c_desc_ob c_utilidades c_recsueldo c_total  min_ley dw_scian giro_empresa i.junta ///
		, lopt seed(823) 
*lopt = the lambda that minimizes MSPE.
local lambda_opt=e(lopt)
*Variable selection
lasso2 end_mode_1 gen horas_sem salario_diario abogado_pub c_antiguedad trabajador_base indem sal_caidos prima_antig prima_vac hextra prima_dom desc_sem desc_ob sarimssinf utilidades nulidad codem reinst c_indem c_prima_antig c_rec20 c_ag c_vac c_hextra c_prima_vac c_prima_dom c_desc_sem c_desc_ob c_utilidades c_recsueldo c_total  min_ley dw_scian giro_empresa i.junta ///
		, lambda( `lambda_opt'  ) 
*Variable selection
local regressors = e(selected)
di "`regressors'"	
/*
gen horas_sem trabajador_base sal_caidos prima_antig prima_vac hextra desc_sem desc_ob sarimssinf utilidades nulidad codem 7.junta 11.junta 16.junta
*/	

*PLM MODEL
/*
When used with a binary response variable, this model is known as a linear 
probability model and can be used as a way to describe conditional probabilities. 

However, the errors (i.e., residuals) from the linear probability model
violate the homoskedasticity and normality of errors assumptions of OLS
regression, resulting in invalid standard errors and hypothesis tests. 
*/
reg end_mode_1  `regressors', robust
reg end_mode_1  i.gen horas_sem salario_diario trabajador_base sal_caidos prima_antig ///
	prima_vac hextra desc_sem desc_ob sarimssinf utilidades nulidad codem ///
	i.junta, robust


*PROBIT MODEL 
probit end_mode_1  i.gen horas_sem salario_diario trabajador_base sal_caidos prima_antig ///
	prima_vac hextra desc_sem desc_ob sarimssinf utilidades nulidad codem ///
	i.junta, robust
margins gen, atmeans
margins , at(salario_diario=(500(1000)4500)) vsquish


*LOGIT MODEL 
logit end_mode_1  i.gen horas_sem salario_diario trabajador_base sal_caidos prima_antig ///
	prima_vac hextra desc_sem desc_ob sarimssinf utilidades nulidad codem ///
	i.junta, robust
logit , or
margins gen, atmeans
margins , at(salario_diario=(500(1000)4500)) vsquish

********************************************************************************
********************************************************************************
********************************************************************************


*QUANTILE REGRESSION

	*OLS
reg liq_total_tope  i.gen horas_sem salario_diario trabajador_base sal_caidos prima_antig ///
	prima_vac hextra desc_sem desc_ob sarimssinf utilidades nulidad codem ///
	i.junta, robust	

	*Quantile  robust	
qreg liq_total_tope  i.gen horas_sem salario_diario trabajador_base sal_caidos prima_antig ///
	prima_vac hextra desc_sem desc_ob sarimssinf utilidades nulidad codem ///
	i.junta, q(0.5)	 vce(robust)

	*Quantile bootstrap
set seed 2939848
bsqreg liq_total_tope  i.gen horas_sem salario_diario trabajador_base sal_caidos prima_antig ///
	prima_vac hextra desc_sem desc_ob sarimssinf utilidades nulidad codem ///
	i.junta, q(0.5)	 reps(200)	
	
	
