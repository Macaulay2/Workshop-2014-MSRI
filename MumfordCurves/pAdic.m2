PAdicField = new Type of InexactField
PAdicFieldElement = new Type of HashTable

new PAdicField from List := (PAdicField, inits) -> new PAdicField of PAdicFieldElement from new HashTable from inits

valuation = method()
relativePrecision = method()

pAdicField = method()
pAdicField ZZ:=(p)->(
   R := ZZ;
   A := new PAdicField from {(symbol prime) => p};
   precision A := a->a#"precision";
   valuation A := a->(if #a#"expansion">0 then return min a#"expansion"_0;
	infinity);
   relativePrecision A:= a -> (precision a)-(valuation a);
   net A := a->(expans:=a#"expansion";
	keylist:=expans_0;
       	((concatenate apply(#keylist,i->
		  toString(expans_1_i)|"*"|toString p|"^"
		  |toString keylist_i|"+"))
		|"O("|toString p|"^"|toString(precision a)|")"));
   computeCarryingOver := (aKeys,aValues,prec) -> (
	newKeys := ();
	newValues := ();
	carryingOver := 0_R;
	aPointer := 0;
	while (aPointer<#aKeys and aKeys#aPointer<=prec) do (
	     currentKey := aKeys#aPointer;
	     currentValue := aValues#aPointer+carryingOver;
	     carryingOver = 0_R;
	     while currentValue!=0 do (
	     	  q := currentValue%p;
		  currentValue = (currentValue-q)//p;
		  if q!=0 then (
		       newKeys = (newKeys,currentKey);
		       newValues = (newValues,q);
		       );
		  currentKey = currentKey+1;
		  if (currentKey>=prec or 
		       ((aPointer+1<#aKeys) and 
			    (currentKey>=aKeys#(aPointer+1)))) then (
		       carryingOver = currentValue;
		       break;
		       );
	     	  );
	     aPointer = aPointer+1;
	     );
	new A from {"precision"=>prec,
	     "expansion"=>{toList deepSplice newKeys,
		  toList deepSplice newValues}}
	);
   A + A := (a,b) -> (
	newPrecision := min(a#"precision",b#"precision");
        aKeys := a#"expansion"_0;
	aValues := a#"expansion"_1;
	aTable := new HashTable from for i in 0..#aKeys-1 list (
	     if aKeys#i<newPrecision then {aKeys#i,aValues#i} else continue);
	bKeys := b#"expansion"_0;
	bValues := b#"expansion"_1;
	bTable := new HashTable from for i in 0..#bKeys-1 list (
	     if bKeys#i<newPrecision then {bKeys#i,bValues#i} else continue);
	s := merge(aTable,bTable,plus);
	newKeys := sort keys s;
	newValues := for i in newKeys list s#i;
	computeCarryingOver(newKeys,newValues,newPrecision)
	);
   A * A := (a,b)->(
	newPrecision := min(precision a+min(precision b,valuation b),
	     precision b+min(precision a,valuation a));
	aKeys := a#"expansion"_0;
	aValues := a#"expansion"_1;
	aTable := new HashTable from for i in 0..#aKeys-1 list {aKeys#i,aValues#i};
	bKeys := b#"expansion"_0;
	bValues := b#"expansion"_1;
	bTable := new HashTable from for i in 0..#bKeys-1 list {bKeys#i,bValues#i};
	combineFunction := (aKey,bKey)-> (
	     s := aKey+bKey;
	     if (s<newPrecision) then s else continue
	     );
	prod := combine(aTable,bTable,combineFunction,times,plus);
	newKeys := sort keys prod;
	newValues := for i in newKeys list prod#i;
	computeCarryingOver(newKeys,newValues,newPrecision)
	);
     A 
)



QQQ=new ScriptedFunctor
QQQ#subscript=i->(pAdicField i)



-- PAdicField Elements are hashtables with following keys:
-- precision (value ZZ)
-- expansion (hashtable, two entries: exponents, coefficients)




toPAdicFieldElement = method()

toPAdicFieldElement (List,PAdicField) := (L,S) -> (
   n:=#L;
   local expans;
   if all(L,i->i==0) then expans={{},{}}    
   else expans=entries transpose matrix select(apply(n,i->{i,L_i}),j->not j_1==0);
   new S from {"precision"=>n,"expansion"=>expans}
   )

end
----------------------------
--Qingchun's testing area
----------------------------
restart
load "/Users/qingchun/Desktop/M2Berkeley/Workshop-2014-Berkeley/MumfordCurves/pAdic.m2"
Q3 = pAdicField(3)
x = toPAdicFieldElement({1,2,0,1,0},Q3);
y = new Q3 from {"precision"=>3,"expansion"=>{{},{}}};
print(x+x)
print(x*x)
print(x+y)
print(x*y)
print(y*y)
end

----------------------------
--Nathan's testing area
----------------------------
restart
load "pAdic.m2"

Q3=QQQ_3
ZZ[x]===ZZ[x]
QQQ_3===QQQ_3
ZZ===ZZ
(QQQ_3)===Q3
x=toPAdicFieldElement({0,1,0,0,1,0},Q3)
x=toPAdicFieldElement({0,0,0,0,0,0},Q3)

valuation x
precision x
relativePrecision x
valuation x
f=x


ZZ[y]
f=y^2+y^6
jacobian f
help jacobian
diff(y,f)
help diff
