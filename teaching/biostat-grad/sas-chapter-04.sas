�ܤ�;
/*==========================================================*/
/*���� �м� : ���� 4-1 [ǥ 4.3]*/

/* �ڷḦ �о�帮�� SAS ���� ����

����: SAS�� ��� ������ �����ݷ�(;)���� ������!!!!!!!!

(1) SAS dataset�� �̸� ����
	DATA �� ������  SAS dataset�� �̸��� �����Ѵ�. �Ʒ����� SAS dataset�� �̸��� liver�� �ȴ�.

(2) ������ ���� 
	INPUT �� �������� �о�帱 ������ �������  ����. ������������ �̸� �ڿ���  $�� ���δ�.
	���� �� �ٿ� �� �� �̻��� ���������� ���� ���� �������� @@�� ���δ�.

(3) �ڷ�
	�����ʹ� ó���� CARDS; �� �����ϰ� INPUT ���� ������ ������ ������� �ڷḦ ��ġ�Ѵ�.
    ������ �����͵ڿ� �����ݷ�(;)�� ���δ�. 
*/

DATA liver;
INPUT trt $ remission y @@;
CARDS;
A	3	0 A	3	1
A	3	1 A	6	1
A	15	0 A	6	1
A	6	1 A	6	1
A	15	0 A	15	0
A	12	0 A	18	0
A	6	1 A	15	0
A	6	1 A	15	0
A	12	1 A	9	0
A	6	1 A	6	0
A	6	0 A	6	0
A	3	1 A	18	0
A	9	0 A	12	1
A	6	0 A	9	1
A	9	1 A	3	0
A	9	1 A	12	0
A	12	0 A	3	0
A	12	0 A	12	0
A	12	0 A	9	1
A	6	1 A	12	0
A	6	0 A	15	1
A	9	0 A	3	1
A	9	0 A	9	0
A	9	0 A	9	0
A	9	1 A	12	1
A	3	1 B	9	1
B	3	0 B	12	1
B	3	1 B	3	1
B	15	1 B	9	1
B	12	1 B	3	1
B	9	1 B	15	1
B	9	1 B	6	1
B	9	1 B	6	1
B	12	0 B	9	0
B	15	0 B	15	1
B	9	0 B	9	0
B	12	1 B	3	1
B	6	1 B	6	1
B	12	0 B	12	0
B	12	1 B	3	1
B	12	1 B	3	1
B	12	1 B	6	1
B	6	1 B	9	1
B	15	0 B	15	0
B	12	0 B	9	0
B	12	0 B	15	0
B	18	1 B	12	0
B	15	1 B	15	0
B	15	0 B	18	0
B	18	1 B	18	0
B	18	0 B	6	1
;


/* LOGISTIC regression */
/*

(1) ������ƽ ȸ�͸� �����ϴ� ���νõ��� PROC LOGISTIC�̴�.

(2)  �������� ���Ǵ� �����߿� ������ ������ �����Ѵ�.

	 CLASS x1 ....;

(3) ������ ������ ����  �����Ѵ�.

	(a) �������� y�� ���׺����� ���(single-trial syntax) (���� 4-1)
 
		model y = x1 x2 ..../SCALE=NONE AGGREGATE;

    (b) ���������� ��� �������̰� ���������� ������ ���� ������ �־��� ��� (���� 4-2)

		FREQ count;
		MODEL y =x1 x2 .. /SCALE=NONE AGGREGATE;

         
    (c) ���������� ����ȸ��(n)�� ����ȸ��(r)�� ���(events/trials syntax) 
 
		model  r/n = x1 x2 ... /SCALE=NONE AGGREGATE;

    

    ����:  MODEL ���� �� ���� option ���� �ִ�.
 
 			- AGGREGATE: show Pearson chi-square test statistic and the likelihood ratio chi-square test statistic 
 			- SCALE=NONE: specifies that no correction is needed for the dispersion parameter; that is, the dispersion parameter remains as 1

(4) PROC LOGISTIC�� �ƹ��� option�� �������� �ʴ´ٸ� ���������� ���ָ� ��������(ũ���)���� �����Ͽ� ���� ó���� ������ 
	���ָ� ����������� �����Ѵ�.  ���������� ���ָ� ������������ �����Ͽ� ������ ���ָ� ����������� �Ϸ��� DESCENDING ������
     PROC LOGISTIC �ڿ� �ٿ��ش�.

*/

PROC LOGISTIC data=liver DESCENDING;
CLASS trt;
MODEL y=trt remission/SCALE=NONE AGGREGATE;
RUN;


/*  ���� Ȯ���� ����

  ������ƽ ȸ�ͺм����� ȸ�Ͱ���� ������ ������ �־��� ���������� ���� ����Ȯ���� ������ ���� �����Ѵ�.

   											exp(b0 + b1*x1 + b2*x2 + ... + bp*xp) 
      P(Y=1 | x1, x2 ... xp) =     ----------------------------------
                                  	    	1 +  exp(b0 + b1*x1 + b2*x2 + ... + bp*xp) 


  (a)  �׷��� ���� 
     �� ó���� ���Ͽ� remission(x) �� ���� Ȯ��(p(y=1|x))���� �Լ� ���踦 graph�� ��Ÿ������  PROC LOGISTIC .... ���� ����  
     ods graphics on; �� ����  option�� plots(only)=(effect) �� �߰��Ѵ�.

  (b) ������ȭ�� ���� 
     �ڷ��� �־��� ���������� ���Ͽ� ������ ������ Ȯ���� dataset���� ������ �� �ִ�. ������ ���� ������ �߰��ϸ� predprob ��� 
     dataset�� ���� ����� ������ Ȯ����  pred_prob������ �����Ѵ�.
 
*/

ods graphics on;
PROC LOGISTIC data=liver  DESCENDING plots(only)=(effect);;
CLASS trt;
MODEL y=trt remission/SCALE=NONE AGGREGATE;
output out=pdata  predicted = pred_prob; 
RUN;

PROC PRINT data = pdata; run; 
/*�ؽ�Ʈ ���Ϸ�  ����� ������ ������ �ҷ�����*/
data liver1;
infile 'C:\Users\UOS\Desktop\TA\liver.txt' dlm='09'x; /*�ؽ�Ʈ ���Ͽ��� tab�� �����ڷ� ���*/
input trt $ remission y;
run;


/*  ���ο� ����ġ�� ���� Ȯ���� ���� 

���࿡ ���� ���� �м��� ������ �� ���ο� ȯ�ڰ� ��Ÿ���� A ġ�Ḧ �ް�(trt=A) ȣ���Ⱓ�� 13�� �̶�� (remission=12)
��� Ȯ���� �󸶷� �����ϰڴ°�? 

���׼� ������ SAS�� ��� �� ȸ�Ͱ���� ������� (Analysis of Maximum Likelihood Estimates)�� �̿��ϸ� ������ ���� ����� �� �ִ�.

									          exp(2.0446 + -0.5887*1 + -0.1998 *13) 
      P(Y=1 | x1=A, x2=13) =     -------------------------------------
                                  	    	1 +  exp(2.0446 + -0.5887*1 + -0.1998 *13) 

�Ǵ� B ġ�Ḧ �ް�(trt=A) ȣ���Ⱓ�� 7�� �̶�� ��� Ȯ����?

�̷��� ���ο� ����ġ�� ���� Ȯ���� ������ ������ ���� 
     (a) outmodel=predmodel �� option�� �߰��Ͽ� ����� �����ϰ� (noprint �� ����� ������� �ʴ´�)
     (b) ���������� �ִ� ���ο� SAS dataset new �� �����
     (c) PROC LOGISTIC �� score ���� ���ο� �ڷḦ �����Ͽ�(score data=new) ���� Ȯ����  ����� �� �ִ�. 

*/

PROC LOGISTIC DESCENDING data=liver  outmodel=predmodel noprint   ;
CLASS trt;
MODEL y=trt remission/SCALE=NONE AGGREGATE;
RUN;

DATA new;
INPUT trt $ remission ;
CARDS;
A	13
B  7
;
run; 

PROC LOGISTIC inmodel=predmodel  ;
	score data=new out=newprob;
RUN;

proc print data=newprob; run;

/*=======================================================================*/
/*���� �м� : ���� 4-2 [ǥ 4.9]*/
DATA cure;
INPUT type $ trt $ outcome $ count @@;
CARDS;
T A cured 65  T A uncured 18
M B cured 100 M B uncured 13
T C cured 56  T C uncured 38
M A cured 80  M A uncured 15
T B cured 29  T B uncured 9
M C cured 78  M C uncured 22
;

PROC LOGISTIC;
FREQ count;
CLASS type trt;
MODEL outcome =type trt/SCALE=NONE AGGREGATE;
RUN;

/*==========================================================
 ������ ���׺���: Agresti's book example - Detecting trend in dose response
 =====================================================*/;

data trauma;
input dose outcome count @@;
datalines;
1 1 59 1 2 25 1 3 46 1 4 48 1 5 32
2 1 48 2 2 21 2 3 44 2 4 47 2 5 30
3 1 44 3 2 14 3 3 54 3 4 64 3 5 31
4 1 43 4 2 4 4 3 49 4 4 58 4 5 41
;
proc logistic; freq count; * proportional odds cumulative logit model;
model outcome = dose / aggregate scale=none;
OUTPUT OUT=outp pred=p;
RUN;

proc print data=outp;
run;

/*==========================================================*/;
/* ������ ���׺���: ���� 4-3 [ǥ 4.14]*/;

/* �ڷ� �Է� */;

DATA improvement;
 INPUT gender $ trt $ improvement $ count @@;
 CARDS;
 f a n 6  f a s 5 f a m 16
 f p n 19 f p s 7 f p m 6
 m a n 7  m a s 2 m a m 5
 m p n 10 m p s 0 m p m 1
 ;


 /*====================================================
-	 �Էµ� �ڷ��� ������� ������ �����ȴ�. n < s  < m 
 			f a n 6  f a s 5 f a m 16

- 	PROC LOGISTIC ���� ������ �ڷḦ �����ϴ� OPTION: ORDER=DATA
 =====================================================*/;

PROC LOGISTIC ORDER=DATA;
FREQ count;
CLASS gender trt;
MODEL improvement=gender trt/SCALE=NONE AGGREGATE;
OUTPUT OUT=prob pred=p;
RUN;

 /*====================================================
-	 Score Test for the Proportional Odds Assumption
	���ֿ� ���Ͽ� �������� ȿ���� ���������� ���� ����
    �͹������� ä���ϸ�  �������� ȿ���� ���ֿ� ���Ͽ� ����
	�͹������� �Ⱒ�ϸ� Proportional Odds Assumption �� ������ => �ٸ� ������ ���
- ���յ� ������ Testing Global Null Hypothesis: BETA=0
	ANOVA F -������ ����, p-���� ���Ǽ��� ���� ������ ������ �����ϴ�. 
 =====================================================*/;

 PROC PRINT data=prob;
RUN;

PROC PRINT data=prob(obs=10);
RUN;
                             
