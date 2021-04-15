/*---------
6장 반복측정자료; 예제 6-2 심부전증 
-----------*/;

data hp0;
infile 'C:\Users\ylee19067\Dropbox\project\teaching\biostat-grad\sas\ex0602-2.txt' FIRSTOBS=1;
input    id  gender $  Trt1_Hr_1 Trt1_Hr_2 Trt1_Hr_3 Trt1_Hr_4 Trt1_Hr5 Trt1_Hr_6 Trt1_Hr_7 Trt1_Hr_8 
                         Trt2_Hr_1 Trt2_Hr_2 Trt2_Hr_3 Trt2_Hr_4   Trt2_Hr_5 Trt2_Hr_6  Trt2_Hr_7 Trt2_Hr_8 
                          Trt3_Hr_1 Trt3_Hr_2   Trt3_Hr_3  Trt3_Hr_4  Trt3_Hr5 Trt3_Hr_6 Trt3_Hr_7 Trt3_Hr_8;
run;

data hp01;
infile 'C:\Users\ylee19067\Dropbox\project\teaching\biostat-grad\sas\ex0602long.txt' FIRSTOBS=2;
   input id trt gender $ hour response;
run;

proc sort data=hp01; by  gender hour trt; run;

proc means data=hp01 noprint;
  by gender hour  trt;
  var response;
  output out=b mean=resbar;
  run;

 proc gplot data=b;
  axis1 length=4 in label=("Mean");
  axis2 length=6 in;
  by gender;
  plot resbar*hour=trt / vaxis=axis1 haxis=axis2;
  symbol1 v=J f=special h=2 i=join color=red;
  symbol2 v=K f=special h=2 i=join color=blue;
  symbol3 v=L f=special h=2 i=join color=green;
  run;



PROC GLM data=hp0;
  CLASS Gender;
  MODEL Trt1_Hr_1--Trt3_Hr_8 =Gender/NOUNI SS3;
   REPEATED Trt 3(1 2 3), Hr 8(1 2 3 4 5 6 7 8 ) /PRINTE;
 RUN;


proc mixed data=hp01;
class gender hour  trt id;
model response=gender hour trt gender*hour gender*trt  hour*trt  gender*trt*hour/ ddfm=kr;
random   int trt hour/ subject=id;
run;

