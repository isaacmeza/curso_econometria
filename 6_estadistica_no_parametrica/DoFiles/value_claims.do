* There are many small claims that should not be sueing.
* Expected compensation in npv distributions


******** Global variables 
global int=3.43			/* Interest rate */
global perc_pag=.30		/* Percentage of payment to private lawyer */
global pago_pub=0		/* Payment to public lawyer */
global pago_pri=2000	/* Payment to private lawyer */


*******************************PILOT 1 DATA*************************************
use "$directorio/DB/pilot_operation.dta" , clear	
merge m:1 folio using "$directorio\DB\pilot_casefiles_wod.dta" , nogen  keep(1 3)

*Not in experiment
drop if tratamientoquelestoco==0


*Outliers
cap drop perc
xtile perc=comp_esp, nq(100)
replace comp_esp=. if perc>=95

	
*Date imputation
replace fechadem=fecha if missing(fechadem)


*NPV
gen months=(fecha-fechadem)/30
gen npv=.
replace npv=(comp_esp/(1+(${int})/100)^months)*(1-${perc_pag})-${pago_pri} if abogado_pub==0
replace npv=(comp_esp/(1+(${int})/100)^months)-${pago_pub} if abogado_pub==1


*Homologation
cap drop anio 
cap drop mes
gen mes=month(fecha)
gen anio=year(fecha)

merge m:1 mes anio using "$directorio/Raw/inpc.dta", nogen keep(1 3) 

*NPV at constant prices (June 2016)
*replace npv=(npv/inpc)*118.901

*Trimming
cap drop perc
xtile perc=npv, nq(100)
replace npv=. if perc>=90

keep npv abogado_pub
gen pilot=1
tempfile temp_p1
save `temp_p1'

*******************************PILOT 2 DATA*************************************
use "$directorio/DB/scaleup_operation.dta" , clear	
rename ao anio
rename expediente exp
merge m:1 junta exp anio using "$directorio\DB\scaleup_casefiles_wod.dta" , nogen  keep(1 3)
merge m:1 junta exp anio using "$directorio\DB\scaleup_predictions.dta", nogen keep (1 3)


*Expected compensation
gen comp_esp=liq_total_laudo_avg


*Outliers
cap drop perc
xtile perc=comp_esp, nq(100)
replace comp_esp=. if perc>=95


*Date 
gen fecha_tr=date(fecha_lista, "YMD")
gen fechadem=date(fecha_demanda, "YMD")
replace fechadem=fecha_tr if missing(fechadem)


*NPV
gen months=(fecha_tr-fechadem)/30
gen npv=.
replace npv=(comp_esp/(1+(${int})/100)^months)*(1-${perc_pag})-${pago_pri} if abogado_pub==0
replace npv=(comp_esp/(1+(${int})/100)^months)-${pago_pub} if abogado_pub==1


*Homologation
rename fecha_tr fecha
cap drop anio 
cap drop mes
gen mes=month(fecha)
gen anio=year(fecha)

merge m:1 mes anio using "$directorio/Raw/inpc.dta", nogen keep(1 3) 

*NPV at constant prices (June 2016)
*replace npv=(npv/inpc)*118.901

*Trimming
cap drop perc
xtile perc=npv, nq(100)
replace npv=. if perc>=90


********************************************************************************
keep npv abogado_pub
gen pilot=2
append using `temp_p1'

*Thousand pesos
replace npv=npv/1000

***DISTRIBUTION
	*Width of bins
local width=3

	*Subsamples
cap drop esample
gen esample=.
replace esample=(pilot==1) 
cap drop esample_pub
gen esample_pub=.
replace esample_pub=(pilot==1 & abogado_pub==1) 
cap drop esample_pri
gen esample_pri=.
replace esample_pri=(pilot==1 & abogado_pub==0) 


do "$directorio\6_estadistica_no_parametrica\DoFiles\yaxis_kdensity.do" ///
 "npv" "`width'" "esample_pub" "publico"
do "$directorio\6_estadistica_no_parametrica\DoFiles\yaxis_kdensity.do" ///
 "npv" "`width'" "esample_pri" "privado"
twoway (hist npv if esample==1, yaxis(1) w(`width') percent lcolor(black) fcolor(none) lwidth(medthick)) ///
	   (kdensity npv if esample_pub==1, yaxis(2) ylab(${publico}, notick nolab axis(2)) ///
				ytitle(" ", axis(2))  lcolor(navy) lwidth(thick) lpattern(dash)) ///
	   (kdensity npv if esample_pri==1, yaxis(2) ylab(${privado}, notick nolab axis(2)) ///
				ytitle(" ", axis(2))  lcolor(black) lwidth(thick) lpattern(solid)) ///
		, scheme(s2mono) graphregion(color(white)) ytitle("Percent") ///
		xtitle("Pesos (thousands)") legend(order( 2 "Pub lawyer" 3 "Pvte lawyer") cols(3)) ///
		title("Experiment") name(pilot, replace)

	*Subsamples
cap drop esample
gen esample=.
replace esample=(pilot==2) 
cap drop esample_pub
gen esample_pub=.
replace esample_pub=(pilot==2 & abogado_pub==1) 
cap drop esample_pri
gen esample_pri=.
replace esample_pri=(pilot==2 & abogado_pub==0) 


do "$directorio\6_estadistica_no_parametrica\DoFiles\yaxis_kdensity.do" ///
 "npv" "`width'" "esample_pub" "publico"
do "$directorio\6_estadistica_no_parametrica\DoFiles\yaxis_kdensity.do" ///
 "npv" "`width'" "esample_pri" "privado"
twoway (hist npv if esample==1, yaxis(1) w(`width') percent lcolor(black) fcolor(none) lwidth(medthick)) ///
	   (kdensity npv if esample_pub==1, yaxis(2) ylab(${publico}, notick nolab axis(2)) ///
				ytitle(" ", axis(2))  lcolor(navy) lwidth(thick) lpattern(dash)) ///
	   (kdensity npv if esample_pri==1, yaxis(2) ylab(${privado}, notick nolab axis(2)) ///
				ytitle(" ", axis(2))  lcolor(black) lwidth(thick) lpattern(solid)) ///
		, scheme(s2mono) graphregion(color(white)) ytitle("Percent") ///
		xtitle("Pesos (thousands)") legend(order( 2 "Pub lawyer" 3 "Pvte lawyer") cols(3)) ///
		title("Scale Up") name(scaleup, replace)	
		
		
graph combine pilot scaleup, scheme(s2mono) graphregion(color(white))		
graph export "$directorio\Figuras\value_claims.pdf", replace 
 
