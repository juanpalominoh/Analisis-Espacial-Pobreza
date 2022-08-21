

* Abrir Base de Datos
use "$dta/sumaria-2021.dta", replace

* Filtrar variables de interés
keep aÑo conglome vivienda hogar ubigeo dominio estrato mieperho inghog2d inghog1d gashog1d gashog2d linpe linea pobreza factor07

* Zona
recode dominio (1/3=1 "Costa") (4/6=2 "Sierra") (7/7=3 "Selva") (8/8=4 "Lima Metropolitana"), gen(zona)
label var zona "Zona" 

* Area
recode estrato (1/5=1 "urbano") (6/8=0 "rural"), gen(area) 
label var area "Area"

* Zona Geografica
g zona_geo= 1 if zona==1 & area==1 // Costa urbana
replace zona_geo= 2 if zona==1 & area==0 // Costa rural
replace zona_geo= 3 if zona==2 & area==1 // Sierra urbana
replace zona_geo= 4 if zona==2 & area==0 // Sierra rural
replace zona_geo= 5 if zona==3 & area==1 // Selva urbana
replace zona_geo= 6 if zona==3 & area==0 // Selva rural
replace zona_geo= 7 if zona==4 // Lima Metropolitana

label variable zona_geo "Zona Geográfica"
label define zona_geolbl 1 "Costa urbana" 2 "Costa rural" 3 "Sierra urbana" 4 "Sierra rural" 5 "Selva urbana" 6 "Selva rural" 7 "Lima Metropolitana"
label values zona_geo zona_geolbl

* Departamento
gen dpto=substr(ubigeo,1,2)
destring dpto, replace
label define dpto ///
1 "Amazonas" ///
2 "Ancash" ///
3 "Apurímac" ///
4 "Arequipa" ///
5 "Ayacucho" ///
6 "Cajamarca" ///
7 "Callao" ///
8 "Cusco" ///
9 "Huancavelica" ///
10 "Huánuco" ///
11 "Ica" ///
12 "Junín" ///
13 "La Libertad" ///
14 "Lambayeque" ///
15 "Lima" ///
16 "Loreto" ///
17 "Madre de Dios" ///
18 "Moquegua" ///
19 "Pasco" ///
20 "Piura" ///
21 "Puno" ///
22 "San Martín" ///
23 "Tacna" ///
24 "Tumbes" ///
25 "Ucayali"
label values dpto dpto

* Ingreso y Gasto per capita mensual
gen ypc= inghog2d/(12*mieperho)
gen gpc= gashog2d/(12*mieperho)

* Pobres y No Pobres
tab pobreza
recode pobreza (1/2=1 "Pobre") (3=0 "No Pobre"), gen(poverty) 
label var poverty "Pobreza"

order aÑo ubigeo dpto conglome-hogar dominio zona estrato area zona_geo
br
order pobreza poverty, a(gpc)
order factor07, last
destring aÑo, replace

* Generamos nuevo ponderador
gen facpob07=mieperho*factor07
gen facfw=round(facpob07)

save "$works/sumaria_2021.dta", replace



*=======
* Loop 
*=======

forvalues i=2019/2020 {

use "$dta/sumaria-`i'.dta", replace

* Filtrar variables de interés
keep aÑo conglome vivienda hogar ubigeo dominio estrato mieperho inghog2d inghog1d gashog1d gashog2d linpe linea pobreza factor07

* Zona
recode dominio (1/3=1 "Costa") (4/6=2 "Sierra") (7/7=3 "Selva") (8/8=4 "Lima Metropolitana"), gen(zona)
label var zona "Zona" 

* Area
recode estrato (1/5=1 "urbano") (6/8=0 "rural"), gen(area) 
label var area "Area"

* Zona Geografica
g zona_geo= 1 if zona==1 & area==1 // Costa urbana
replace zona_geo= 2 if zona==1 & area==0 // Costa rural
replace zona_geo= 3 if zona==2 & area==1 // Sierra urbana
replace zona_geo= 4 if zona==2 & area==0 // Sierra rural
replace zona_geo= 5 if zona==3 & area==1 // Selva urbana
replace zona_geo= 6 if zona==3 & area==0 // Selva rural
replace zona_geo= 7 if zona==4 // Lima Metropolitana

label variable zona_geo "Zona Geográfica"
label define zona_geolbl 1 "Costa urbana" 2 "Costa rural" 3 "Sierra urbana" 4 "Sierra rural" 5 "Selva urbana" 6 "Selva rural" 7 "Lima Metropolitana"
label values zona_geo zona_geolbl

* Departamento
gen dpto=substr(ubigeo,1,2)
destring dpto, replace
label define dpto ///
1 "Amazonas" ///
2 "Ancash" ///
3 "Apurímac" ///
4 "Arequipa" ///
5 "Ayacucho" ///
6 "Cajamarca" ///
7 "Callao" ///
8 "Cusco" ///
9 "Huancavelica" ///
10 "Huánuco" ///
11 "Ica" ///
12 "Junín" ///
13 "La Libertad" ///
14 "Lambayeque" ///
15 "Lima" ///
16 "Loreto" ///
17 "Madre de Dios" ///
18 "Moquegua" ///
19 "Pasco" ///
20 "Piura" ///
21 "Puno" ///
22 "San Martín" ///
23 "Tacna" ///
24 "Tumbes" ///
25 "Ucayali"
label values dpto dpto

* Ingreso y Gasto per capita mensual
gen ypc= inghog2d/(12*mieperho)
gen gpc= gashog2d/(12*mieperho)

* Pobres y No Pobres
tab pobreza
recode pobreza (1/2=1 "Pobre") (3=0 "No Pobre"), gen(poverty) 
label var poverty "Pobreza"

order aÑo ubigeo dpto conglome-hogar dominio zona estrato area zona_geo
br
order pobreza poverty, a(gpc)
order factor07, last
destring aÑo, replace

* Generamos nuevo ponderador
gen facpob07=mieperho*factor07
gen facfw=round(facpob07)

save "$works/sumaria_`i'.dta", replace

}


