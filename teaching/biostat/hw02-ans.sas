data dat41;
input live  exp arrest $ count @@;
cards;
0 1 Y 42  0 1 N 109
0 0 Y 17  0 0 N 75
1 1 Y 33  1 1 N 175
1 0 Y 53  1 0 N  359
;

proc logistic data=dat41;
	freq count;
	class live(ref='0') exp(ref='0');
	model arrest(event='Y') = live exp/scale=none aggregate ;
	output out=dat41p  p=p;
run;

data cancer1;
 input cancer $ smoke $ count;
 cards;
 1 1 9
 1 0 5
 0 1 46
 0 0 40
;

 proc logistic data= cancer1  ;
 freq count;
 class  smoke(ref='0') cancer;
 model cancer(event='1')= smoke/ scale =none aggregate;
 run;

data cars;
input  x1 x2 y;
cards;
45 2 0
40 4 1
60 3 0
50 2 0
55 2 0
50 5 1
35 7 1
65 10 1
53 2 0
48 1 0
37 5 1
31 7 1
40 4 0
75 8 1
43 9 1
49 2 0
37.5 4 1
71 11 1
34 5 0
27 6 1
;
proc logistic data= cars ;
  class y;
 model y(event='1')= x1 x2/scale =none aggregate;
 run;

Data oring; 
input trial failed temp ; 
cards;
6 0 66 
6 1 70 
6 0 69 
6 0 68 
6 0 67 
6 0 72 
6 0 73 
6 0 70 
6 1 57 
6 1 63 
6 1 70 
6 0 78 
6 0 67 
6 2 53 
6 0 67 
6 0 75 
6 0 70 
6 0 81 
6 0 76 
6 0 79 
6 2 75 
6 0 76 
6 1 58 
; 
run;

proc logistic data=oring plots(only)=(effect) outmodel=predmodel;
  model failed/trial = temp ; 
  output out=pdata  predicted = pred_prob; 
run; 

DATA new;
INPUT  temp;
CARDS;
 30
40
 50
;
run; 

PROC LOGISTIC inmodel=predmodel  ;
    score data=new out=newprob;
RUN;

proc print data=newprob; run;
