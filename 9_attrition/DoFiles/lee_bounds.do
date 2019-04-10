*COMPUTATION OF LEE BOUNDS

args vardep t condvar condcond v


if "`t'"=="b" {
gen tratamiento=(group==2) if !missing(group)
drop if missing(group)
}

else {
keep if inlist(main_treatment,1,`t')
gen tratamiento=(main_treatment==`t')
}



*IMPUTATION
if "`condvar'"=="no_condition" {
	cap drop no_condition_aux
	gen no_condition_aux=1
	}
else {
	if "`condcond'"=="" {
		gen `condvar'_aux=`condvar'
		*PLM imputation
		reg `condvar'_aux  telefono* email  mujer na_prob na_cant *_coarse salario_diario antiguedad m_cp ///
				if tratamiento==1, r cluster(fecha_alta)
		cap drop predicted
		predict predicted 
		replace `condvar'_aux=(predicted>=0.6) if missing(`condvar'_aux) ///
					& tratamiento==1 
					
		reg `condvar'_aux  telefono* email  mujer na_prob na_cant *_coarse salario_diario antiguedad m_cp ///
				if tratamiento==0, r cluster(fecha_alta)
		cap drop predicted
		predict predicted 		
		replace `condvar'_aux=(predicted>=0.4) if missing(`condvar'_aux) ///
					& tratamiento==0 	
		}
		
	else {
		gen `condvar'_aux=`condvar'
		gen `condcond'_aux=`condcond'
		*PLM imputation
		reg `condcond'_aux  telefono* email  mujer na_prob na_cant *_coarse salario_diario antiguedad m_cp ///
				if tratamiento==1, r cluster(fecha_alta)
		cap drop predicted
		predict predicted 
		replace `condcond'=(predicted>=0.6) if missing(`condcond') ///
					& tratamiento==1 
					
		reg `condcond'  telefono* email  mujer na_prob na_cant *_coarse salario_diario antiguedad m_cp ///
				if tratamiento==0, r cluster(fecha_alta)
		cap drop predicted
		predict predicted 		
		replace `condcond'=(predicted>=0.4) if missing(`condcond') ///
					& tratamiento==0 	
					
					
		reg `condvar'_aux  telefono* email  mujer na_prob na_cant *_coarse salario_diario antiguedad m_cp ///
				if tratamiento==1, r cluster(fecha_alta)
		cap drop predicted
		predict predicted 
		replace `condvar'_aux=(predicted>=0.6) if missing(`condvar'_aux) ///
					& tratamiento==1 & `condcond'_aux==1
					
		reg `condvar'_aux  telefono* email  mujer na_prob na_cant *_coarse salario_diario antiguedad m_cp ///
				if tratamiento==0, r cluster(fecha_alta)
		cap drop predicted
		predict predicted 		
		replace `condvar'_aux=(predicted>=0.4) if missing(`condvar'_aux) ///
					& tratamiento==0 & `condcond'_aux==1	
		}	
	}

	
	
// Confidence intervals (90%)
local alpha = .1 // for 90% confidence intervals
*Point estimate
reg `vardep' tratamiento  mujer antiguedad salario_diario, robust cluster(fecha_alta)
local df = e(df_r)
matrix results[`v',1] = _b[tratamiento]
matrix results[`v',2] = _b[tratamiento] - invttail(`df',`=`alpha'/2')*_se[tratamiento]
matrix results[`v',3] = _b[tratamiento] + invttail(`df',`=`alpha'/2')*_se[tratamiento]



*BOUNDS	
cap drop nq_dw
xtile nq_dw=salario_diario, nq(3)
*Lee Bounds
cap leebounds `vardep' tratamiento if `condvar'_aux==1, cieffect tight(telefono_cel nq_dw)

if _rc!=0 {
	cap leebounds `vardep' tratamiento if `condvar'_aux==1, cieffect tight(telefono_cel)
	if _rc!=0 {
		leebounds `vardep' tratamiento if `condvar'_aux==1, cieffect vce(bootstrap)
		}
	else {	
		mat varlb=e(V)
		if varlb[1,1]==0 {
			leebounds `vardep' tratamiento if `condvar'_aux==1, cieffect tight(telefono_cel) vce(bootstrap)
			}
		}	
	}	
else {	
	mat varlb=e(V)
	if varlb[1,1]==0 {
		leebounds `vardep' tratamiento if `condvar'_aux==1, cieffect tight(telefono_cel nq_dw) vce(bootstrap)
		}		
	}
	
	
mat lb=e(b)
mat varlb=e(V)
matrix results[`v',4] = lb[1,1]
matrix results[`v',5] = lb[1,1] - invttail(e(Nsel)-1,`=`alpha'/2')*sqrt(varlb[1,1])
matrix results[`v',6] = lb[1,1] + invttail(e(Nsel)-1,`=`alpha'/2')*sqrt(varlb[1,1])

matrix results[`v',7] = lb[1,2]
matrix results[`v',8] = lb[1,2] - invttail(e(Nsel)-1,`=`alpha'/2')*sqrt(varlb[2,2])
matrix results[`v',9] = lb[1,2] + invttail(e(Nsel)-1,`=`alpha'/2')*sqrt(varlb[2,2])


*Manski-Imbens Bounds
cap matrix results[`v',10] =  e(cilower)
cap matrix results[`v',11] =  e(ciupper)

