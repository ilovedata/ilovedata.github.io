/*상대위험률과 오즈비의 신뢰구간 : 예제 3-2 [표 3.4] */

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

DATA test;
INPUT drug $ mi $ count;
CARDS;
1 1 73
1 2 18
2 1 141
2 2 196
;
PROC FREQ ;
TABLES drug*mi/MEASURES ;
WEIGHT count;
RUN;


/*카이제곱 검정 : 예제 3-3 [표 3.6] */
DATA test1;
INPUT treat $ mi $ count;
CARDS;
a yes 139 
a no 10898
p yes 239
p no 10795
;
PROC FREQ DATA=test;
WEIGHT count;
TABLE treat*mi/CHISQ ;
RUN;


/*맥니마 검정 : 예제 3-5 [표 3.14] */
DATA marriage;
INPUT before $ after $ count @@;
CARDS;
satisfy satisfy 23
satisfy unsatisfy 7
unsatisfy satisfy 18
unsatisfy unsatisfy 12
;

ODS SELECT McNemarsTest;
PROC FREQ order=data;
WEIGHT count;
TABLES before*after/AGREE;
RUN;


/*코크란-맨텔-핸젤 검정 : 예제 3-6 [표 3.18] */
DATA hospital;
INPUT hospital $ trt $ recovery $ count @@;
CARDS;
A old yes 9 A old no   5
A new yes 11 A new no  6
B old yes 7 B old no   5
B new yes 8 B new no   3
C old yes 4 C old no   6
C new yes 7 C new no   5
D old yes 18 D old no  11
D new yes 26 D new no  4
;
PROC FREQ;
WEIGHT count;
TABLES hospital*trt*recovery/CMH NOROW NOCOL;
RUN;
