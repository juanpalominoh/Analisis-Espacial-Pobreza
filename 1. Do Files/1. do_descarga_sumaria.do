

* Descarga de Sumaria 
*---------------------

* 2021
copy "$inei/759-Modulo34.zip" "759-Modulo34.zip", replace
unzipfile "759-Modulo34.zip", replace
erase "759-Modulo34.zip"

* 2020
copy "$inei/737-Modulo34.zip" "737-Modulo34.zip", replace
*unzipfile "737-Modulo34.zip", replace
erase "737-Modulo34.zip"

* 2019
copy "$inei/687-Modulo34.zip" "687-Modulo34.zip", replace
unzipfile "687-Modulo34.zip", replace
erase "687-Modulo34.zip"


* Mover archivos a otra carpeta
foreach i of numlist 687 737 759 {
forvalues j=2019/2021 {  	
capture copy  "$dta/`i'-Modulo34/sumaria-`j'.dta" "$dta/sumaria-`j'.dta", replace
capture erase "$dta/`i'-Modulo34/sumaria-`j'.dta"
	}
}


* Traducir Base de Datos
*--------------------------
clear all
forvalues i=2019/2021 {
unicode analyze "sumaria-`i'.dta"
unicode encoding set "latin1"  				
unicode translate "sumaria-`i'.dta"
}


* Descargar Shapefiles
cd "$maps"
copy "$inei_shp/5_Informacion_Cartografica-Shape.zip" "5_Informacion_Cartografica-Shape.zip", replace
unzipfile "5_Informacion_Cartografica-Shape", replace
erase "5_Informacion_Cartografica-Shape.zip"





