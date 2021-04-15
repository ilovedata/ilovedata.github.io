/* 2 x 2 crossover design 

Senn (2002, Chapter 3) discusses a study comparing the effectiveness of two bronchodilators, formoterol ("for") and salbutamol ("sal"),
in the treatment of childhood asthma. 

A total of 13 children are recruited for an AB/BA crossover design. A random sample of 7 of the children are assigned to the treatment sequence
for/sal, receiving a dose of formoterol upon an initial visit ("period 1") and then a dose of salbutamol upon a later visit ("period 2").

The other 6 children are assigned to the sequence sal/for, receiving the treatments in the reverse order but otherwise in a similar manner. 
Periods 1 and 2 are sufficiently spaced so that no carryover effects are suspected.
After a child inhales a dose of a bronchodilator, peak expiratory flow (PEF) is measured. 

Higher PEF indicates greater effectiveness.

The data are assumed to be approximately normally distributed.

The data set is generated with the following statements:
*/;

data asthma;
   input subject sequence period Drug $ PEF ;
   datalines;
1 1 1 for 310 
1 1 2 sal  270
2 1 1 for 310   
2 1 2 sal  260  
3 1 1 for  370 
3 1 2sal  300
4 1 1 for  410 
4 1 2sal  390 
5 1 1for  250 
5  1 2sal  210 
6 1 1 for  380 
6 1 2sal 350
7 1 1for  330 
7 1 2sal  365
8 2 1sal  370 
8  2 2 for 385 
9 2 1 sal 310 
9  2 2 for 400 
10 2 1 sal 380 
10 2 2 for  410
11 2 1 sal  290    
11 2 2 for  320   
12 2 1 sal  260   
12  2 2 for  340  
13 2 1 sal  90  
13  2 2 for  220
;
run;

PROC MIXED data=asthma;
CLASS SEQUENCE SUBJECT PERIOD DRUG;
MODEL PEF = DRUG  PERIOD;
RANDOM SUBJECT(SEQUENCE);
LSMEANS DRUG / PDIFF CL E;
run;



PROC MIXED data=asthma;
CLASS SEQUENCE SUBJECT PERIOD DRUG;
MODEL PEF = DRUG  PERIOD;
RANDOM SUBJECT;
LSMEANS DRUG / PDIFF CL E;
run;
