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


/*==========================
<표 5.12> 약물 배출량 자료
============================*/;

DATA elimination;
INPUT type x1 x2 y @@ ;
CARDS;
1 1 37 61 11.3208
2 1 37 37 12.9151
3 1 45 53 18.8947
4 1 41 41 14.6739
5 1 57 41 8.6493
6 1 49 33 9.5238
7 2 49 49 7.6923
8 2 53 53 0.0017
9 2 53 45 8.0477
10 2 53 53 6.7358
11 2 61 37 6.1441
12 2 49 65 21.7939
13 3 53 45 4.2553
14 3 57 57 0.0017
15 3 49 49 11.0196
16 3 53 53 6.2762
17 3 53 45 13.2316
18 3 53 53 5.0676
19 4 57 57 5.6235
20 4 49 49 14.9893
21 4 53 53 13.7233
22 4 53 45 6.0669
23 4 53 53 8.1602
24 4 61 37 1.4423
25 5 45 45 6.9971
26 5 53 45 5.2308
27 5 57 57 8.256
28 5 49 49 14.5
29 5 53 53 20.7627
30 5 53 45 3.6115
31 6 53 53 11.3475
32 6 53 45 9.465
33 6 53 53 22.6103
34 6 61 37 0.002
35 6 49 65 20.5997
36 6 37 37 28.1828
;

run;

PROC GLM;
ClASS type;
MODEL y=type x1 x2 /solution; 
LSMEANS type/stderr;
RUN;

/*========================================================
       <표 5.19> 산소운반 능력 자료의 처리 간 공변량 효과의 동등성
==========================================================*/;

 DATA again;
 INPUT trt x y @@;
 CARDS;
 1 40 165 1 54 85
 1 85 9 1 95 43
 1 81 94 1 26 226
 1 90 7 1 95 9
 1 83 12 1 83 145
 2 85 11 2 83 6
 2 65 51 2 98 18
 2 47 189 2 74 90
 2 75 10 2 97 12
 2 79 35 2 91 27
 3 65 89 3 25 64
 3 34 87 3 20 45
 3 30 56 3 29 87
 3 100 59 3 85 39
 3 24 87  3 26 67
 ;
 RUN;

PROC GLM data=again;
 CLASS trt;
 MODEL y=trt x trt*x/solution ;
 RUN;   

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
