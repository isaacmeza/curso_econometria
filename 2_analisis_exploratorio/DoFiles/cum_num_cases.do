

use "$directorio\DB\treatment_data.dta", clear
keep if date<=date(c(current_date) ,"DMY")

********************************************************************************

preserve
*Cumulative files
collapse (count) dow , by(date group)
sort group date
by group: gen cum=sum(dow)
tsset group date 

twoway (tsline cum if group==1,  graphregion(color(none)) ///
	xtitle("Date") ytitle("#") lwidth(thick) lcolor(red)) ///
	(tsline cum if group==2,  graphregion(color(none)) ///
	xtitle("Date") ytitle("#") lwidth(thick) lcolor(navy)) ///
	, scheme(s2mono) legend(order(1 "A" 2 "B") rows(1)) name(ab, replace)
	
	
	
restore	
*Cumulative files
collapse (count) dow , by(date main_treatment)
sort main_treatment date
by main_treatment: gen cum=sum(dow)
tsset main_treatment date 

twoway (tsline cum if main_treatment==1,  graphregion(color(none)) ///
	xtitle("Date") ytitle("#") lwidth(thick) lcolor(red)) ///
	(tsline cum if main_treatment==2,  graphregion(color(none)) ///
	xtitle("Date") ytitle("#") lwidth(thick) lcolor(navy)) ///
	(tsline cum if main_treatment==3,  graphregion(color(none)) ///
	xtitle("Date") ytitle("#") lwidth(thick) lcolor(dkgreen)) ///
	, scheme(s2mono) legend(order(1 "1" 2 "2" 3 "3") rows(1)) name(tr, replace)
graph combine tr ab, xcommon scheme(s2mono) graphregion(color(white))	
graph export "$directorio/Figuras/cum_num_cases_tr.pdf", replace 

collapse (sum) dow, by(date)
gen cum=sum(dow)

tsline cum, scheme(s2mono) graphregion(color(white)) ///
	xtitle("Date") ytitle("#") lwidth(thick)
graph export "$directorio/Figuras/cum_num_cases.pdf", replace 
	

