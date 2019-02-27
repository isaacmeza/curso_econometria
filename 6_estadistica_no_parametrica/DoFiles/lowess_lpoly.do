*LOWESS

/*
LOWESS has over many other methods is the fact that it does not require the 
specification of a function to fit a model to all of the data in the sample
makes less efficient use of data than other least squares methods. 
However, it requires fairly large, densely sampled data sets in order to produce
good models. 
*/

use http://www.stata-press.com/data/r13/lowess1, clear
lowess h1 depth
lowess h1 depth, bwidth(.4)

********************************************************************************


*LPOLY
/*
In general case (p>1), one should minimize:

<math>\begin{align}
  & \hat{\beta }(X_{0})=\underset{\beta (X_{0})}{\mathop{\arg \min }}\,\sum\limits_{i=1}^{N}{K_{h_{\lambda }}(X_{0},X_{i})\left( Y(X_{i})-b(X_{i})^{T}\beta (X_{0}) \right)}^{2} \\ 
 & b(X)=\left( \begin{matrix}
   1, & X_{1}, & X_{2},... & X_{1}^{2}, & X_{2}^{2},... & X_{1}X_{2}\,\,\,...  \\
\end{matrix} \right) \\ 
 & \hat{Y}(X_{0})=b(X_{0})^{T}\hat{\beta }(X_{0}) \\ 
\end{align}</math>
*/

use http://www.stata-press.com/data/r13/motorcycle, clear

lpoly accel time, degree(1) kernel(epan2) bwidth(1) generate(at smooth1) nograph
lpoly accel time, degree(1) kernel(epan2) bwidth(7) at(at) generate(smooth2) nograph
label variable smooth1 "smooth: width = 1"
label variable smooth2 "smooth: width = 7"
lpoly accel time, degree(1) kernel(epan2) at(at) addplot(line smooth* at) legend(label(2 "smooth: width = 3.42 (ROT)")) note("kernel = epan2, degree = 1")
lpoly accel time, degree(3) kernel(epan2) ci
