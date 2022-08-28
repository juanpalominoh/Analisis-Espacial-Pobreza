
global dos     "/Users/juanpalomino/Documents/GitHub/Analisis Espacial Pobreza/1. Do Files"
global inputs  "/Users/juanpalomino/Documents/GitHub/Analisis Espacial Pobreza/2. Data"
global works   "/Users/juanpalomino/Documents/GitHub/Analisis Espacial Pobreza/3. Procesadas"
global results "/Users/juanpalomino/Documents/GitHub/Analisis Espacial Pobreza/6. Resultados"
cd "$inputs"

/Users/juanpalomino/Documents/GitHub/Analisis Espacial Pobreza/1. Do Files/6. Export resultados.do

spshape2dta "$inputs/columbus.shp"


* Spatial Models
*================
use "$inputs/columbus.dta", clear
rename *, lower

spset

spmatrix create contiguity W , replace

* Regresión OLS
eststo OLS: quietly reg crime hoval inc

* Modelo de Rezago Espacial (SLM)
eststo SLM: spregress crime hoval inc, dvarlag(W) ml
estat impact, vce(delta)
global i SLM 
do "$dos/6. Export resultados.do"


* Modelo de Error Espacial (SEM)
eststo SEM: spregress crime hoval inc, errorlag(W) ml 
estat impact, vce(delta)


* Modelo SARAR
eststo SARAR: spregress crime hoval inc, dvarlag(W) errorlag(W) ml
estat impact, vce(delta)
global i SARAR 
do "$dos/6. Export resultados.do"

* Modelo espacial de Durbin (SDM)
eststo SDM: spregress crime hoval inc, ivarlag(W: hoval inc) dvarlag(W) ml 
estat impact, vce(delta)
global i SDM 
do "$dos/6. Export resultados.do"

* Modelo de error espacial de Durbin (SDEM)
eststo SDEM: spregress crime hoval inc, ivarlag(W: hoval inc) errorlag(W) ml
estat impact, vce(delta)
global i SDEM 
do "$dos/6. Export resultados.do"

* Modelo SLX
eststo SLX: spregress crime hoval inc, ivarlag(W: hoval inc) ml
estat impact, vce(delta)
global i SLX
do "$dos/6. Export resultados.do"

* Modelo de Cliff-Ord
eststo SGN: spregress crime hoval inc, ivarlag(W: hoval inc) dvarlag(W) errorlag(W) ml 
eststo i_SGN: estat impact, vce(delta)
global i SGN
do "$dos/6. Export resultados.do"

esttab OLS SLX SLM SDM SEM SDEM SARAR SGN, stats(N ll aic bic)

esttab OLS SLX SLM SDM SEM SDEM SARAR SGN using "$results/Results.xls", type replace label title("Spatial Models") ///
        b(3) se(3) stats(N ll aic bic, /// 
        fmt(0 3 3 3) ///  
		labels("Observations" "Log-Likelihood" "AIC" "BIC")) ///
		star(* 0.10 ** 0.05 *** 0.01) ///
        mtitle("OLS" "SLX" "SLM" "SDM" "SEM" "SARAR" "SDEM" "Cliff-Ord") ///
		note("Standard errors in parentheses - ME: SE computed using Delta Method")	


* Crear matriz espacial de distancia (euclideana)
* Crear indicadores globales (Moran, Geary, Getis y Ord)
* Estimadores todos estos modelos espaciales y reportarlo en un excel. 

spmat idistance idmat_mmax x y, id(id) dfunction(euclidean) normalize(row) replace
spmat idistance idmat_spec x y, id(id) dfunction(euclidean) normalize(spectral) replace
