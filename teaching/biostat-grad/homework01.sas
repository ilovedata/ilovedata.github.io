/* 연습문제 5장 1번 */;

data data1;
	input trt $ x y;
cards;
A  5 20
A 10 23
A 12 30
A 9 25
A 23 34
A 21 40
A 14 27
A 18 38
A 6 24
A 13 31
B 7 19
B 12 26
B 27 33
B 24 35
B 18 30
B 22 31
B 26 34
B 21 28
B 14 23
B 9 22
;

proc boxplot data=data1;
  plot y*trt;
run;
proc sgplot data=data1;
   scatter x=x y=y / group=trt;
run;

PROC GLM data=data1 ;
CLASS trt;
MODEL y=trt  /SOLUTION; 
LSMEANS trt/TDIFF;
RUN;

PROC GLM data=data1 ;
CLASS trt;
MODEL y=trt x /SOLUTION; 
LSMEANS trt/TDIFF;
RUN;
