/*---------
6장 반복측정자료; 예제 6-1 고혈압
-----------*/;

data bp;
infile 'C:\Users\ylee19067\Dropbox\project\teaching\biostat-grad\sas\ex0601.txt' FIRSTOBS=2;
input    id    trt $  time  bp;
run;

proc means noprint;
  by trt time;
  var bp;
  output out=a mean=bpbar;
  run;

proc gplot;
  axis1 length=4 in label=("Mean");
  axis2 length=6 in;
  plot bpbar*time=trt / vaxis=axis1 haxis=axis2;
  symbol1 v=J f=special h=2 i=join color=red;
  symbol2 v=K f=special h=2 i=join color=blue;
  run;



proc sort data=bp; by id; run;

proc transpose data=bp out=bp0  prefix=week;
   by id trt ;
  var bp ;
run; 

data blood_pressure;
   set bp0;
   drop _NAME_;
   rename  week1=week0 week2=week4 week3=week8;
 run;


 PROC GLM data=blood_pressure;
   CLASS trt;
   MODEL week0 week4 week8=trt/NOUNI SS3;
   REPEATED week 3(0 4 8 ) CONTRAST(3)/SUMMARY PRINTE ;
 RUN;


 proc mixed data=bp;
class trt time id;
model bp = trt time trt*time;
repeated / type=cs sub=id;
run;

proc mixed data=bp ;
class trt time id;
model bp=trt time trt*time / ddfm=kr;
random  int / sub=id;
run;
