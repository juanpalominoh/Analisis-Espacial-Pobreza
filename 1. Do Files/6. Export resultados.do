


*=================
* Export to excel
*=================

* Efectos Directos
*------------------
matrix b=r(b_direct)'
mata: b=st_matrix("b")

mat se=vecdiag(cholesky(diag(vecdiag(r(V_direct)))))'
mata: se=st_matrix("se")

mata: t=b:/se
mata: p=2*normal(-abs(t))

mata: t=st_matrix("t", t)
mata: p=st_matrix("p", p)

scalar N=sqrt(e(N))
mata: N=st_numscalar("N")

mata: st_matrix("upper_ci", st_matrix("b")+1.96045*(st_matrix("se")))
mata: st_matrix("lower_ci", st_matrix("b")-1.96045*(st_matrix("se")))

matrix stat = b, se, t, p, lower_ci, upper_ci

matrix colnames stat= "b" "se" "t" "P>|t|" "lower_ci" "upper_ci"
matlist stat

putexcel set "$results/Spatial Models.xlsx", sheet($i) modify
putexcel A1=("Direct Effects")  A3=matrix(stat) A2=("Coefficients") B2=("Standard Errors") C2=("z") D2=("P>|z|") E2=("lower_ci") F2=("upper_ci")


* Efectos Indirectos
*--------------------
matrix b=r(b_indirect)'
mata: b=st_matrix("b")
matlist b

mat se=vecdiag(cholesky(diag(vecdiag(r(V_indirect)))))'
mata: se=st_matrix("se")
matlist se

mata: t=b:/se
mata: p=2*normal(-abs(t))

mata: t= st_matrix("t", t)
mata: p= st_matrix("p", p)

scalar N=sqrt(e(N))
mata: N=st_numscalar("N")

mata: st_matrix("upper_ci", st_matrix("b")+1.96045*(st_matrix("se")))
mata: st_matrix("lower_ci", st_matrix("b")-1.96045*(st_matrix("se")))

matrix stat = b, se, t, p, lower_ci, upper_ci

matrix colnames stat= "b" "se" "t" "P>|t|" "lower_ci" "upper_ci"
matlist stat

putexcel A5=("Indirect Effects") A6=matrix(stat)


* Efectos Totales
*--------------------
matrix b=r(b_total)'
matlist b

mat se=vecdiag(cholesky(diag(vecdiag(r(V_total)))))'
mata: se=st_matrix("se")
matlist se

mata: t=b:/se
mata: p=2*normal(-abs(t))

mata: t= st_matrix("t", t)
mata: p= st_matrix("p", p)

scalar N=sqrt(e(N))
mata: N=st_numscalar("N")

mata: st_matrix("upper_ci", st_matrix("b")+1.96045*(st_matrix("se")))
mata: st_matrix("lower_ci", st_matrix("b")-1.96045*(st_matrix("se")))

matrix stat = b, se, t, p, lower_ci, upper_ci

matrix colnames stat= "b" "se" "t" "P>|t|" "lower_ci" "upper_ci"
matlist stat

putexcel A8=("Total Effects") A9=matrix(stat)
