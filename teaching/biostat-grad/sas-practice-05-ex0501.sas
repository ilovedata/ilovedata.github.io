/*���л�м� ���� 5.1 */

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
/*�ڽ��׸��� ��,������ ó��(trt)������ �ڷḦ �����ؾ��� */;
proc sort data=medicine; by trt; run;

/*�ڽ��׸� �׸���*/;
proc boxplot data=medicine;
  plot y*trt;
run;

/* ������ x�� �������� y �� ���� ������ */;
proc sgplot data=medicine;
   scatter x=x y=y / group=trt;
run;

/* ANOVA ���� */;
PROC GLM data=medicine ;
CLASS trt;
MODEL y=trt  /SOLUTION; 
LSMEANS trt/TDIFF;
RUN;

/* ANCOVA ���� */;
PROC GLM data=medicine ;
CLASS trt;
MODEL y=trt x /SOLUTION; 
LSMEANS trt/TDIFF;
RUN;

/*�ڽ��׸� �׸���*/;
proc boxplot data=medicine;
  plot x*trt;
run;
