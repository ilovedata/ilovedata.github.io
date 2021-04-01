/*==========================================================*/
/*로짓 분석 : 예제 4-1 [표 4.3]*/


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

(1) 로지스틱 회귀를 실행하는 프로시듀어는 PROC LOGISTIC이다.

(2)  모형에서 사용되는 변수중에 범주형 변수를 지정한다.

	 CLASS x1 ....;

(3) 모형은 다음과 같이  지정한다.

	(a) 반응변수 y가 이항변수인 경우(single-trial syntax) (예제 4-1)
 
		model y = x1 x2 ..../SCALE=NONE AGGREGATE;

    (b) 독립변수가 모두 범주형이고 반응변수의 성공과 실패 도수가 주어진 경우 (예제 4-2)

		FREQ count;
		MODEL y =x1 x2 .. /SCALE=NONE AGGREGATE;

         
    (c) 반응변수가 실행회수(n)와 성공회수(r)인 경우(events/trials syntax) 
 
		model  r/n = x1 x2 ... /SCALE=NONE AGGREGATE;

    

    참고:  MODEL 문에 두 개의 option 문이 있는데 설명은 과목의 범위에서 벗어나므로 생략하고 언제나 붙여준다. 
 
 			- AGGREGATE: show Pearson chi-square test statistic and the likelihood ratio chi-square test statistic 
 			- SCALE=NONE: specifies that no correction is needed for the dispersion parameter; that is, the dispersion parameter remains as 1

(4) PROC LOGISTIC에 아무런 option을 지정하지 않는다면 반응변수의 범주를 오름차순(크기순)으로 정렬하여 가장 처음에 나오는 
	범주를 성공사건으로 지정한다.  반응변수의 범주를 오름차순으로 정렬하여 마지막 범주를 성공사건으로 하려면 DESCENDING 문장을
     PROC LOGISTIC 뒤에 붙여준다.

(5) 새로운 관측치에 대한 확률의 추정을 다음과 같이 
     (a) outmodel=predmodel 을 option에 추가하여 결과를 저장하고 (noprint 는 결과를 출력하지 않는다)
     (b) 독립변수만 있는 새로운 SAS dataset new 을 만들고
     (c) PROC LOGISTIC 의 score 문에 새로운 자료를 지정하여(score data=new) 예측 확률을  계산할 수 있다. 


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
