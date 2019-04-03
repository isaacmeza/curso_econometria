*Treatment effects - EP CF with distance & time

********************************************************************************

use "$directorio\DB\sett_p1_p2.dta", clear


********************************************************************************
********************************************************************************
********************************************************************************
*REGRESSIONS
*
*Instrument
gen time_instrument=inlist(time_hr,1,2,7,8) if !missing(time_hr) 

*********************************************

eststo clear

*OLS (FS)
eststo: reg p_actor i.treatment time_instrument i.junta, r cluster(fecha)
qui  test 2.treatment=3.treatment
estadd scalar Pvalue_c=r(p)	

*Probit (FS)
eststo: probit p_actor i.treatment time_instrument i.junta, r cluster(fecha)
qui  test 2.treatment=3.treatment
estadd scalar Pvalue_c=r(p)	

cap drop xb
predict xb, xb
*Generalized residuals
gen gen_resid_pr = cond(p_actor == 1, normalden(xb)/normal(xb), -normalden(xb)/(1-normal(xb)))	

*CF
*Probit - Interaction
eststo: reg seconcilio i.treatment##i.p_actor i.junta gen_resid_pr, vce(bootstrap, reps(1000)) cluster(fecha)
qui su seconcilio if e(sample)
estadd scalar DepVarMean=r(mean)
qui su p_actor if e(sample)
estadd scalar IntMean=r(mean)
qui  test 2.treatment=3.treatment
estadd scalar Pvalue_c=r(p)	
qui  test 2.treatment#1.p_actor=3.treatment#1.p_actor
estadd scalar Pvalue=r(p)
	

*Now use dummy variables for time groups
tab time_hr, gen(time_hr)
foreach var of varlist time_hr2-time_hr8 {
	gen treat_`var'=treatment*`var'
	}
	
*Probit (FS)
eststo: probit p_actor i.treatment i.junta time_hr2-time_hr8, r cluster(fecha)
qui  test 2.treatment=3.treatment
estadd scalar Pvalue_c=r(p)	

cap drop xb
predict xb, xb
*Generalized residuals
gen gen_resid_pr8 = cond(p_actor == 1, normalden(xb)/normal(xb), -normalden(xb)/(1-normal(xb)))	

*CF
*Probit - Interaction
eststo: reg seconcilio i.treatment##i.p_actor i.junta  gen_resid_pr8, vce(bootstrap, reps(1000)) cluster(fecha)
qui su seconcilio if e(sample)
estadd scalar DepVarMean=r(mean)
qui su p_actor if e(sample)
estadd scalar IntMean=r(mean)
qui  test 2.treatment=3.treatment
estadd scalar Pvalue_c=r(p)	
qui  test 2.treatment#1.p_actor=3.treatment#1.p_actor
estadd scalar Pvalue=r(p)	

		*************************
		esttab using "$directorio/Tables/reg_results/treatment_effects_IV_CF.csv", se r2 star(* 0.1 ** 0.05 *** 0.01) b(a2) ///
		 scalars("DepVarMean DepVarMean" "IntMean InteractionVarMean" "Pvalue_c Pvalue_c" "Pvalue Pvalue" ) replace 
