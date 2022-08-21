
*=================
* Curva de Lorenz
*=================

clear all
forvalues i=2019/2021 {
append using "$works/sumaria_`i'.dta"
}

* Generar curva de lorenz
ssc install glcurve

* Graficamos solamente una curva
* h glcurve
glcurve ypc [w=facfw], lorenz by(aÑo) split graphregion(color(white))

/* 
Se genera una curva para los tres años pero guardamos como variables la información de:
glvar: Coordenadas de y
pvar : Coordenadas de X
*/
glcurve ypc [w=facfw], lorenz glvar(y_ord) pvar(rank) by(aÑo) split nograph replace 
gen igualdad=rank
save "$works/base ingresos lorenz.dta", replace

* Generamos un gráfico más didáctico
#delimit;
graph twoway 
(line y_ord_2019 rank, sort lcolor(blue)      lwidth(thin) lpattern(solid))
(line y_ord_2020 rank, sort lcolor(cranberry) lwidth(thin) lpattern(dash))
(line y_ord_2021 rank, sort lcolor(green)     lwidth(thin) lpattern(solid))
(line igualdad rank,   sort clwidth(medthin) clcolor(red)), 
ytitle("Proporción acum. de ingreso del hogar per cápita", margin(r=1)) 
xtitle("Proporción acum. de población", margin(t=1))
ylabel(, angle(0) format(%4.2fc) labsize(small) nogrid) 
xlabel(0(0.2)1, format(%4.2fc) labsize(small) nogrid)
legend(pos(10) ring(0) cols(1) size(vsmall) bmargin(t=-2) region(lstyle(none) fcolor(none)))
title("Perú: Curvas de Lorenz: 2019, 2020 y 2021", tstyle(subheading))
scheme(s1mono) graphregion(fcolor(white)) plotregion(margin(zero));
#delimit cr
graph export "$graphs/lorenz2.png", replace


* Índice de Gini
*================ 
*ssc install ineqdeco
* h ineqdeco
ineqdeco ypc [w=facfw] , by(aÑo)
ineqdeco ypc [w=facfw] , by(area)
ineqdeco ypc [w=facfw] if aÑo==2020, by(dpto)

ineqdeco gpc [w=factor07] , by(aÑo)
