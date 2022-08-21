

*========================
* INDICADORES DE POBREZA 
*========================

* Rutas
*-------
clear all
global main   "/Users/juanpalomino/Documents/GitHub/Analisis Espacial Pobreza"
global dos    "$main/1. Do Files"
global dta	  "$main/2. Data"
global works  "$main/3. Procesadas"
global graphs "$main/4. Gráficos"
global maps   "$main/5. Shapefiles"

global inei      "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/"
global inei_shp  "http://iinei.inei.gob.pe/iinei/srienaho/descarga/DocumentosZIP/2018-150/"
cd "$dta"

* Correr manualmente el do "1. do_descarga_sumaria". Luego correr esto:
do "$dos/2. do_cleaning.do"
do "$dos/3. do_pobreza.do"
do "$dos/4. do_lorenz_gini.do"













