
*========================
* Indicadores de pobreza
*========================

use "$works/sumaria_2021.dta", clear

tab pobreza [iw=facpob07]
tab poverty [iw=facpob07]
tab area poverty [iw=facpob07], nofreq row

* Las líneas de pobreza extrema se estiman para cada zona geográfica
table zona area [fweight=facfw], c(mean linpe)

* Condiciones de vida de la población en zonas urbanas y rurales
tab zona poverty [fweight=facfw], row nofreq


* https://www.inei.gob.pe/media/cifras_de_pobreza/informe_pobreza2019.pdf (pagina 37)

* Conteo de pobreza (FGT0)
*==========================
tab poverty [fw=facfw]	  // fweight es el adecuado

table area [fw=facfw], c(mean poverty) format(%5.3fc) // es el adecuado

tab dpto poverty [iw=facpob07], nofreq row


* Seteamos la base de datos considerando el muestreo por cluster en conglomerados y viviendas
svyset conglome [w=facpob07], strata(estrato) || vivienda		

* Proporción de personas pobres
svy: proportion poverty							
svy: proportion poverty, over(area)		


* Brecha de pobreza (FGT1)
*==========================
gen brecha=(linea- gpc)/linea   if (pobreza==1 | pobreza==2)
replace brecha=0 if pobreza==3
sum brecha [iw= factor07]


* Severidad de pobreza (FGT2)
*============================
gen severidad=((linea- gpc)/linea)^2 if (pobreza==1 | pobreza==2)
replace severidad=0 if pobreza==3
sum severidad [iw= factor07]


* Resumen de indicadores seteados
svy: mean poverty brecha severidad


* Podemos generar el resultado directamente
*findit sepov
*help sepov
sepov gpc [iw= facfw], p(linea) psu(conglome) strata(estrato)


*ssc install apoverty
*help apoverty
apoverty gpc [w= facfw ] , varpl(linea) all


*ssc install povdeco					
povdeco gpc [w=facfw], varpl(linea)




* Exportar base a nivel departamental
forvalues i=2019/2021 {
use "$works/sumaria_`i'.dta", clear
collapse (mean) pobreza_`i'=poverty [iw=facpob07], by(CCDD dpto)
save "$works/pobreza_dpto_`i'.dta", replace
}

use "$works/pobreza_dpto_2019.dta", clear
merge 1:1 dpto using "$works/pobreza_dpto_2020.dta", nogen
merge 1:1 dpto using "$works/pobreza_dpto_2021.dta", nogen
gen CCDD=dpto
tostring CCDD, replace
replace CCDD="0"+CCDD if length(CCDD)==1
order CCDD
export excel "$works/pobreza_dpto.xls", replace firstrow(variable)
