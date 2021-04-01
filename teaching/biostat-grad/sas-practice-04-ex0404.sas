
/* 일반화 로짓 분석 : 예제 4-4 [표 4.20 ]*/

data;
INPUT gender race party $ count @@;
CARDS;
1 1 D 132 1 1 R 176  1 1 I 127
1 0 D 42  1 0 R  6   1 0 I 12
0 1 D 172 0 1 R 129  0 1 I 130
0 0 D 56  0 0 R 4    0 0 I 15
;

PROC CATMOD ORDER=DATA;
WEIGHT count;
MODEL party=gender race/PRED=PROB ;
RUN;