* TREATMENT EFFECTS - ITT

********************************************************************************

use "$directorio\DB\sett_p1_p2.dta", clear

********************************************************************************

	eststo clear

	*********************************
	*			PHASE 1				*
	*********************************
	
	*Same day conciliation
	eststo: reg seconcilio i.treatment i.junta if treatment!=0 & phase==1, robust  cluster(fecha)
	estadd scalar Erre=e(r2)
	qui su seconcilio if e(sample)
	estadd scalar DepVarMean=r(mean)

	
	*Interaction employee was present
	eststo: reg seconcilio i.treatment##i.p_actor i.junta if treatment!=0 & phase==1 , robust  cluster(fecha)
	estadd scalar Erre=e(r2)
	qui su seconcilio if e(sample)
	estadd scalar DepVarMean=r(mean)
	qui su p_actor if e(sample)
	estadd scalar IntMean=r(mean)
	qui  test 2.treatment#1.p_actor=3.treatment#1.p_actor
	estadd scalar Pvalue=r(p)

	
	*********************************
	*			PHASE 2				*
	*********************************
	
	*Same day conciliation
	eststo: reg seconcilio i.treatment i.junta if treatment!=0 & phase==2, robust  cluster(fecha)
	estadd scalar Erre=e(r2)
	qui su seconcilio if e(sample)
	estadd scalar DepVarMean=r(mean)

	
	*Interaction employee was present
	eststo: reg seconcilio i.treatment##i.p_actor i.junta if treatment!=0 & phase==2 , robust  cluster(fecha)
	estadd scalar Erre=e(r2)
	qui su seconcilio if e(sample)
	estadd scalar DepVarMean=r(mean)
	qui su p_actor if e(sample)
	estadd scalar IntMean=r(mean)
	
	
	
	*********************************
	*			POOLED				*
	*********************************
	
	*Interaction employee was present
	eststo: reg seconcilio i.treatment##i.p_actor i.junta if treatment!=0, robust  cluster(fecha)
	estadd scalar Erre=e(r2)
	qui su seconcilio if e(sample)
	estadd scalar DepVarMean=r(mean)
	qui su p_actor if e(sample)
	estadd scalar IntMean=r(mean)
	qui  test 2.treatment#1.p_actor=3.treatment#1.p_actor
	estadd scalar Pvalue=r(p)

	
	*Interaction employee was present PROBIT SPECIFICATION
	eststo: probit seconcilio i.treatment##i.p_actor i.junta if treatment!=0, robust  cluster(fecha)
	estadd scalar Erre=e(r2)
	qui su seconcilio if e(sample)
	estadd scalar DepVarMean=r(mean)
	qui su p_actor if e(sample)
	estadd scalar IntMean=r(mean)
	qui  test 2.treatment#1.p_actor=3.treatment#1.p_actor
	estadd scalar Pvalue=r(p)

	
	*2 months
	eststo: reg convenio_2m i.treatment##i.p_actor i.junta if treatment!=0, robust  cluster(fecha)
	estadd scalar Erre=e(r2)
	qui su convenio_2m if e(sample)
	estadd scalar DepVarMean=r(mean)
	qui su p_actor if e(sample)
	estadd scalar IntMean=r(mean)
	qui  test 2.treatment#1.p_actor=3.treatment#1.p_actor
	estadd scalar Pvalue=r(p)

	
	*5 months
	eststo: reg convenio_5m i.treatment##i.p_actor i.junta if treatment!=0, robust  cluster(fecha)
	estadd scalar Erre=e(r2)
	qui su convenio_5m if e(sample)
	estadd scalar DepVarMean=r(mean)
	qui su p_actor if e(sample)
	estadd scalar IntMean=r(mean)
	qui  test 2.treatment#1.p_actor=3.treatment#1.p_actor
	estadd scalar Pvalue=r(p)

	

	*Long run
	eststo: reg convenio_m5m i.treatment##i.p_actor i.junta if treatment!=0, robust  cluster(fecha)
	estadd scalar Erre=e(r2)
	qui su convenio_m5m if e(sample)
	estadd scalar DepVarMean=r(mean)
	qui su p_actor if e(sample)
	estadd scalar IntMean=r(mean)
	qui  test 2.treatment#1.p_actor=3.treatment#1.p_actor
	estadd scalar Pvalue=r(p)

	
	
	
	

	
