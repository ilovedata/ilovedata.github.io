/*=================================================*/;
/*교과서 예제 5.1 */

DATA medicine;
INPUT trt x y @@ ;
CARDS;
1 27.2 32.6 1 22.0 36.6 
1 33.0 37.7 1 26.8 31.0
2 28.6 33.8 2 26.8 31.7
2 26.5 30.7 2 26.8 30.4
3 28.6 35.2 3 22.4 29.1 
3 23.2 28.9 3 24.4 30.2
4 29.3 35.0 4 21.8 27.0
4 30.3 36.4 4 24.3 30.5
5 20.4 24.6 5 19.6 23.4
5 25.1 30.3 5 18.1 21.8
                     ;
/*박스그림을 ㄱ,리려면 처리(trt)순으로 자료를 정렬해야함 */;
proc sort data=medicine; by trt; run;

/*박스그림 그리기*/;
proc boxplot data=medicine;
  plot y*trt;
run;

/* 공변량 x와 반응변수 y 의 관계 산포도 */;
proc sgplot data=medicine;
   scatter x=x y=y / group=trt;
run;

/* ANOVA 실행 */;
PROC GLM data=medicine ;
CLASS trt;
MODEL y=trt  /SOLUTION; 
LSMEANS trt/TDIFF;
RUN;

/* ANCOVA 실행 */;
PROC GLM data=medicine ;
CLASS trt;
MODEL y=trt x /SOLUTION; 
LSMEANS trt/TDIFF;
RUN;

/*박스그림 그리기*/;
proc boxplot data=medicine;
  plot x*trt;
run;

/*=========================================*/;

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
