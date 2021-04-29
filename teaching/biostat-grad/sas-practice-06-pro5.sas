/* exersice 6.5*/;

data pro65;
  input subject $ a $ b $ y;
 datalines;
 1 1 1 0
 1 1 2 0
 1 1 3 5
 1 1 4 3
 2 1 1 3
 2 1 2 1
 2 1 3 5
 2 1 4 4
 3 1 1 4
 3 1 2 4
 3 1 3 6
 3 1 4 2
 1 2 1 4
 1 2 2 2
 1 2 3 7
 1 2 4 8
 2 2 1 5
 2 2 2 4
 2 2 3 6
 2 2 4 6
 3 2 1 7
 3 2 2 5
 3 2 3 8
 3 2 4 9
 ;

 proc sort data=pro65; by a b; run;

proc means noprint;
  by a b;
  var y;
  output out=pro65m mean=ybar;
  run;

proc gplot;
  axis1 length=4 in label=("Mean");
  axis2 length=6 in;
  plot ybar*a=b / vaxis=axis1 haxis=axis2;
  symbol1 v=J f=special h=2 i=join color=red;
  symbol2 v=K f=special h=2 i=join color=blue;
  symbol3 v=J f=special h=2 i=join color=black;
  symbol4 v=K f=special h=2 i=join color=green;
  run;

 proc mixed data=pro65;
 	class subject a b;
	model y = a b a*b/ ddfm=kenwardroger;
	random subject;
run;



 proc mixed data=pro65;
 	class subject a b;
	model y = a b a*b/ ddfm=kenwardroger;
	repeated/ subject= subject type=cs;
run;