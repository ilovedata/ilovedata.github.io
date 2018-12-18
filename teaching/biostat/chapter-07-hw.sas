DATA chap0702;
  INPUT  time censor rep ;
CARDS;
0.5 1 82  
0.5 0 0 
1.5 1 30 
1.5 0 8 
2.5  1 27 
2.5 0 8 
3.5 1 22
3.5 0 7 
4.5 1  26
4.5 0 7 
5.5 1  25
5.5 0 28 
6.5 1 20
6.5 0 31 
7.5 1 11
7.5 0 32 
8.5 1 14
8.5 0 24
9.5 1 13 
9.5 0 27 
10.5 1 5 
10.5 0 22 
11.5 1 5 
11.5 0 23 
12.5 1 5
12.5 0 18 
13.5 1 2
13.5 9 
14.5 1 3 
14.5 0 7 
15.5 1 3
15.5 0 11
;

PROC LIFETEST data=chap0702 METHOD=LIFE
    INTERVALS= 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
    PLOTS=(S, H)
    GRAPHICS;
   TIME time*censor(0);
   FREQ rep;
RUN;

DATA chap0703;
INPUT time censor @@;
CARDS;
 2 1 4 1 5 1 
10 1 10 0 12 1 
12 0 14 1 14 1
15 1 16 1 18 1
19 1 23 1 25 1 
26 0 27 1 30 0
31 1 34 1 35 1
37 0 38 1 39 1
42 0 43 0 46 1
47 0 49 1 50 1
53 0 54 0
;


PROC LIFETEST data=chap0703  METHOD=KM PLOTS=survival outsurv=res;
     TIME  time*censor(0); 
RUN;

proc print data=res;
run;


DATA chap0704;
INPUT time censor group  ;
CARDS;
1 1 1
2 1 1
5 1 1
5 1 1
5 1 1
7 1 1
9 1 1
11 1 1
11 1 1
13 1 1
13 1 1
16 1 1
20 1 1
21 1 1
22 0 1
22 1 1
31 0 1
33 0 1
37 0 1
43 1 1
1 1 2
3 1 2
4 1 2
4 1 2
5 1 2
7 1 2
7 1 2
9 1 2
9 1 2
14 0 2
17 1 2
19 0 2
27 0 2
30 0 2
41 0 2 
;
PROC LIFETEST data=chap0704 PLOTS=(S) ;
     TIME  time*censor(0);
     STRATA group;
     SYMBOL1 V=NONE COLOR=BLACK LINE=1;
     SYMBOL2 V=NONE COLOR=BLACK LINE=2;
RUN;
