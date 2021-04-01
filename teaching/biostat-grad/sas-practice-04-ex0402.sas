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

PROC LOGISTIC plots(only)=(effect);
FREQ count;
CLASS type trt;
MODEL outcome =type trt/SCALE=NONE AGGREGATE;
output out=pdata  predicted = pred_prob; 
RUN;
