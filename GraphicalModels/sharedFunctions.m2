
--Take a matrix over ZZ and make it over QQ instead
matZZtoQQ = (M) -> (
E:=entries(M);    
return matrix apply(#E, i -> apply(#(E_i), j -> (1/1)*E_i_j))    
);


--Compute the sample covariance matrix
--See Bernd's notes, p. 44
--Assume data is entered as a list of matrices (row vectors)
sampleCovarianceMatrix = (L) -> (
n:=#L;
L=apply(#L, i -> if ring(L_i)===ZZ then matZZtoQQ(L_i) else L_i);
Xbar:=(1/n)*(sum L);
return (1/n)*(sum apply(n, i -> (transpose (L_i-Xbar))*(L_i-Xbar)) );    
);


JacobianMatrixOfRationalFunction = (F) -> (
f:=numerator(F);
g:=denominator(F);
R:=ring(f);
answer:=diff(vars(R), f) * g - diff(vars(R), g)*f;
answer=substitute(answer, ring(F));
matrix({{(1/g)^2}})*answer
);
