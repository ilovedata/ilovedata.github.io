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

ods graphics on;
PROC FREQ;
WEIGHT count;
TABLES hospital*trt*recovery/relrisk plots(only)=relriskplot(stats) CMH NOROW NOCOL;
RUN;
