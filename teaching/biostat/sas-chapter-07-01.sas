
/* <표 7.3> 협심증자료의 생명표를 위한 SAS program */;

DATA angina;
  INPUT  time censor rep @@;
CARDS;
0.5  1 456   0.5 0  0    1.5  1  226  1.5 0  39
2.5  1 152   2.5 0  22   3.5  1 171   3.5 0  23
4.5  1 135   4.5 0  24   5.5  1 125   5.5 0 107
6.5  1  83   6.5 0 133   7.5  1  74   7.5 0 102
8.5  1  51   8.5 0  68   9.5  1  42   9.5 0  64
10.5  1  43  10.5 0  45  11.5  1  34  11.5 0  53
12.5  1  18  12.5 0  33  13.5  1   9  13.5 0  27
14.5  1   6  14.5 0  23  15.5  1   0  15.5 0  30
;

PROC LIFETEST data=angina METHOD=LIFE
    INTERVALS= 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
    PLOTS=(S, H)
    GRAPHICS;
   TIME time*censor(0);
   FREQ rep;
RUN;

/* <표 7.6> 신장이식환자자료의 누적한계추정법을 위한 SAS 프로그램 */;


DATA rem;
INPUT time censor @@;
CARDS;
 3.0  1    4.0  0    4.5  1    4.5  1
 5.5  1    6.0  1    6.4  1    6.5  1
 7.0  1    7.5  1    8.4  0   10.0  1
10.0  0   12.0  1   15.0  1
;

PROC LIFETEST data=rem  METHOD=KM PLOTS=survival ;
     ods select SurvivalPlot;
     TIME  time*censor(0); 
RUN;

/* <표 7.9> 흑색종환자들의 생존함수비교  SAS프로그램 */;

DATA M1;
INPUT time censor group @@ ;
CARDS;
33.7 0 1  3.9 1 1 10.5 1 1  5.4 1 1 19.5 1 1
23.8 0 1  7.9 1 1 16.9 0 1 16.6 0 1 33.7 0 1
17.1 0 1
 8.0 1 2 26.9 0 2 21.4 0 2 18.1 0 2 16.0 0 2
 6.9 1 2 11.0 0 2 24.8 0 2 23.0 0 2  8.3 1 2
10.8 0 2 12.2 0 2 12.5 0 2 24.4 1 2  7.7 1 2
14.8 0 2  8.2 0 2  8.2 0 2  7.8 0 2
;
PROC LIFETEST data=m1 PLOTS=(S) ;
     TIME  time*censor(0);
     STRATA group;
     SYMBOL1 V=NONE COLOR=BLACK LINE=1;
     SYMBOL2 V=NONE COLOR=BLACK LINE=2;
RUN;



