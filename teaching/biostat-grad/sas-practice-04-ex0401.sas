/*==========================================================*/
/*���� �м� : ���� 4-1 [ǥ 4.3]*/


DATA liver;
INPUT trt $ remission y @@;
CARDS;
A 3 0 A 3 1
A 3 1 A 6 1
A 15 0 A 6 1
A 6 1 A 6 1
A 15 0 A 15 0
A 12 0 A 18 0
A 6 1 A 15 0
A 6 1 A 15 0
A 12 1 A 9 0
A 6 1 A 6 0
A 6 0 A 6 0
A 3 1 A 18 0
A 9 0 A 12 1
A 6 0 A 9 1
A 9 1 A 3 0
A 9 1 A 12 0
A 12 0 A 3 0
A 12 0 A 12 0
A 12 0 A 9 1
A 6 1 A 12 0
A 6 0 A 15 1
A 9 0 A 3 1
A 9 0 A 9 0
A 9 0 A 9 0
A 9 1 A 12 1
A 3 1 B 9 1
B 3 0 B 12 1
B 3 1 B 3 1
B 15 1 B 9 1
B 12 1 B 3 1
B 9 1 B 15 1
B 9 1 B 6 1
B 9 1 B 6 1
B 12 0 B 9 0
B 15 0 B 15 1
B 9 0 B 9 0
B 12 1 B 3 1
B 6 1 B 6 1
B 12 0 B 12 0
B 12 1 B 3 1
B 12 1 B 3 1
B 12 1 B 6 1
B 6 1 B 9 1
B 15 0 B 15 0
B 12 0 B 9 0
B 12 0 B 15 0
B 18 1 B 12 0
B   15 1 B 15 0
B 15 0 B 18 0
B 18 1 B 18 0
B 18 0 B 6 1
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

    

    ����:  MODEL ���� �� ���� option ���� �ִµ� ������ ������ �������� ����Ƿ� �����ϰ� ������ �ٿ��ش�. 
 
 			- AGGREGATE: show Pearson chi-square test statistic and the likelihood ratio chi-square test statistic 
 			- SCALE=NONE: specifies that no correction is needed for the dispersion parameter; that is, the dispersion parameter remains as 1

(4) PROC LOGISTIC�� �ƹ��� option�� �������� �ʴ´ٸ� ���������� ���ָ� ��������(ũ���)���� �����Ͽ� ���� ó���� ������ 
	���ָ� ����������� �����Ѵ�.  ���������� ���ָ� ������������ �����Ͽ� ������ ���ָ� ����������� �Ϸ��� DESCENDING ������
     PROC LOGISTIC �ڿ� �ٿ��ش�.

(5) ���ο� ����ġ�� ���� Ȯ���� ������ ������ ���� 
     (a) outmodel=predmodel �� option�� �߰��Ͽ� ����� �����ϰ� (noprint �� ����� ������� �ʴ´�)
     (b) ���������� �ִ� ���ο� SAS dataset new �� �����
     (c) PROC LOGISTIC �� score ���� ���ο� �ڷḦ �����Ͽ�(score data=new) ���� Ȯ����  ����� �� �ִ�. 


*/

PROC LOGISTIC data=liver  DESCENDING plots(only)=(effect) outmodel=predmodel;
CLASS trt;
MODEL y=trt remission/SCALE=NONE AGGREGATE;
output out=pdata  predicted = pred_prob; 
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
