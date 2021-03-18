겨ㅜ;
/*==========================================================*/
/*로짓 분석 : 예제 4-1 [표 4.3]*/

/* 자료를 읽어드리는 SAS 문장 설명

주의: SAS의 모든 문장은 세미콜론(;)으로 끝난다!!!!!!!!

(1) SAS dataset의 이름 지정
	DATA 문 다음에  SAS dataset의 이름을 지정한다. 아래에서 SAS dataset의 이름은 liver가 된다.

(2) 변수명 지정 
	INPUT 문 다음에는 읽어드릴 변수를 순서대로  쓴다. 범주형변수의 이름 뒤에는  $를 붙인다.
	만약 한 줄에 두 개 이상의 관측단위가 나올 경우는 마지막에 @@을 붙인다.

(3) 자료
	데이터는 처음에 CARDS; 로 시작하고 INPUT 문에 지정된 변수의 순서대로 자료를 배치한다.
    마지막 데이터뒤에 세미콜론(;)을 붙인다. 
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

    

    참고:  MODEL 문에 두 개의 option 문이 있다.
 
 			- AGGREGATE: show Pearson chi-square test statistic and the likelihood ratio chi-square test statistic 
 			- SCALE=NONE: specifies that no correction is needed for the dispersion parameter; that is, the dispersion parameter remains as 1

(4) PROC LOGISTIC에 아무런 option을 지정하지 않는다면 반응변수의 범주를 오름차순(크기순)으로 정렬하여 가장 처음에 나오는 
	범주를 성공사건으로 지정한다.  반응변수의 범주를 오름차순으로 정렬하여 마지막 범주를 성공사건으로 하려면 DESCENDING 문장을
     PROC LOGISTIC 뒤에 붙여준다.

*/

PROC LOGISTIC data=liver DESCENDING;
CLASS trt;
MODEL y=trt remission/SCALE=NONE AGGREGATE;
RUN;


/*  성공 확률의 추정

  로지스틱 회귀분석에서 회귀계수를 추정한 다음에 주어진 독립변수에 대한 성공확률은 다음과 같이 추정한다.

   											exp(b0 + b1*x1 + b2*x2 + ... + bp*xp) 
      P(Y=1 | x1, x2 ... xp) =     ----------------------------------
                                  	    	1 +  exp(b0 + b1*x1 + b2*x2 + ... + bp*xp) 


  (a)  그래프 생성 
     각 처리에 대하여 remission(x) 과 성공 확률(p(y=1|x))과의 함수 관계를 graph로 나타내려면  PROC LOGISTIC .... 문장 전에  
     ods graphics on; 을 쓰고  option에 plots(only)=(effect) 를 추가한다.

  (b) 데이터화일 생성 
     자료의 주어진 독립변수에 대하여 추정된 성공의 확률을 dataset으로 저정할 수 있다. 다음과 같은 문장을 추가하면 predprob 라는 
     dataset이 새로 생기고 추정된 확률을  pred_prob변수에 저장한다.
 
*/

ods graphics on;
PROC LOGISTIC data=liver  DESCENDING plots(only)=(effect);;
CLASS trt;
MODEL y=trt remission/SCALE=NONE AGGREGATE;
output out=pdata  predicted = pred_prob; 
RUN;

PROC PRINT data = pdata; run; 
/*텍스트 파일로  저장된 백혈병 데이터 불러오기*/
data liver1;
infile 'C:\Users\UOS\Desktop\TA\liver.txt' dlm='09'x; /*텍스트 파일에서 tab을 구분자로 사용*/
input trt $ remission y;
run;


/*  새로운 관측치에 대한 확률의 추정 

만약에 위와 같은 분석을 시행한 후 새로운 환자가 나타나서 A 치료를 받고(trt=A) 호전기간이 13일 이라면 (remission=12)
재발 확률은 얼마로 추정하겠는가? 

위네서 실행한 SAS의 결과 중 회귀계수의 추정결과 (Analysis of Maximum Likelihood Estimates)를 이용하면 다음과 같이 계산할 수 있다.

									          exp(2.0446 + -0.5887*1 + -0.1998 *13) 
      P(Y=1 | x1=A, x2=13) =     -------------------------------------
                                  	    	1 +  exp(2.0446 + -0.5887*1 + -0.1998 *13) 

또는 B 치료를 받고(trt=A) 호전기간이 7일 이라면 재발 확률은?

이러한 새로운 관측치에 대한 확률의 추정을 다음과 같이 
     (a) outmodel=predmodel 을 option에 추가하여 결과를 저장하고 (noprint 는 결과를 출력하지 않는다)
     (b) 독립변수만 있는 새로운 SAS dataset new 을 만들고
     (c) PROC LOGISTIC 의 score 문에 새로운 자료를 지정하여(score data=new) 예측 확률을  계산할 수 있다. 

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
/*로짓 분석 : 예제 4-2 [표 4.9]*/
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
 순서형 다항변수: Agresti's book example - Detecting trend in dose response
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
/* 순서형 다항변수: 예제 4-3 [표 4.14]*/;

/* 자료 입력 */;

DATA improvement;
 INPUT gender $ trt $ improvement $ count @@;
 CARDS;
 f a n 6  f a s 5 f a m 16
 f p n 19 f p s 7 f p m 6
 m a n 7  m a s 2 m a m 5
 m p n 10 m p s 0 m p m 1
 ;


 /*====================================================
-	 입력된 자료의 순서대로 순위가 지정된다. n < s  < m 
 			f a n 6  f a s 5 f a m 16

- 	PROC LOGISTIC 에서 순서형 자료를 지정하는 OPTION: ORDER=DATA
 =====================================================*/;

PROC LOGISTIC ORDER=DATA;
FREQ count;
CLASS gender trt;
MODEL improvement=gender trt/SCALE=NONE AGGREGATE;
OUTPUT OUT=prob pred=p;
RUN;

 /*====================================================
-	 Score Test for the Proportional Odds Assumption
	범주에 대하여 설명변수의 효과가 동일한지에 대한 검정
    귀무가설을 채택하면  설명변수의 효과가 범주에 대하여 동일
	귀무가설을 기각하면 Proportional Odds Assumption 이 부적절 => 다른 모형을 사용
- 적합도 검정은 Testing Global Null Hypothesis: BETA=0
	ANOVA F -검정과 유사, p-값이 유의수준 보다 작으면 모형이 유의하다. 
 =====================================================*/;

 PROC PRINT data=prob;
RUN;

PROC PRINT data=prob(obs=10);
RUN;
                             
