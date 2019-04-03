
********************************************************************************

use "$directorio\DB\sett_p1_p2.dta", clear


********************************************************************************
********************************************************************************
********************************************************************************
*REGRESSIONS
*

*Instrument
gen time_instrument=inlist(time_hr,1,2,7,8) if !missing(time_hr) 

gen t2_ep=2.treatment*p_actor
gen t3_ep=3.treatment*p_actor

gen t2_iv=2.treatment*time_instrument
gen t3_iv=3.treatment*time_instrument



*Balance IV
local bvc abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem
foreach var of varlist `bvc' {	
	xi: reg `var' i.time_instrument i.junta , robust  cluster(fecha)
	}
		

*2SLS
ivregress 2sls seconcilio i.treatment i.junta ///
	(t2_ep t3_ep 1.p_actor = t2_iv t3_iv 1.time_instrument ) ///
		, robust  cluster(fecha) 

*FS		
reg  p_actor i.treatment i.junta t2_iv t3_iv 1.time_instrument ///
		if e(sample), robust  cluster(fecha) 
		
*Reduced Form		
*------------


