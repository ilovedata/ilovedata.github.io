/*비례 오즈 분석 : 예제 4-3 [표 4.14]*/


DATA improvement;
INPUT gender $ trt $ improvement $ count @@;
CARDS;
female A n 6
female A s 5
female A m 16
female P n 19
female P s 7
female P m 6
male A n 7
male A s 2
male A m 5
male P n 10
male P s 0
male P m 1
;


PROC LOGISTIC ORDER=DATA;
	FREQ count;
	CLASS gender trt;
	MODEL improvement=gender trt/SCALE=NONE AGGREGATE;
	OUTPUT OUT=prob pred=p;
RUN;

PROC PRINT data=prob(obs=10);
RUN;