data dat51;
  input trt $ x y;
  cards;
A 5 10
A 10 23 
A 12 30
A 9 25
A 23 34
A 21 40
A 14 27
A 18 38 
A 6 24
A 13 31
B 7 19
B 12 26 
B 27 33
B 24 35
B 18 30
B 22 31
B 26 34
B 21 28
B 14 23
B 9 22
;


proc means data=dat51;
  var y x;
run;


proc glm data=dat51;
  class trt;
  model y=trt x / solution;
  lsmeans trt /tdiff;
  run;

data dat52;
  input trt $ x y;
  cards;
M1 29 39 
M1 4 34
M1 18 36 
M2 17 35 
M2 35 38 
M2 3 32
M3 1 38 
M3 15 43
M3 32 44
;

proc means data=dat52;
  var y x;
run;

proc glm data=dat52;
  class trt;
  model y=trt x / solution;
  lsmeans trt /tdiff;
run;

data dat53;
  input trt $ x y;
  cards;
A 11 6
A 8 0
A 5 2
A 14 8
A 19 11
A 6 4
A 10 13
A 6 1
A 11 8
A 3 0
B 6 0
B 6 2
B 7 3
B 8 1
B 18 18
B 8 4
B 19 14
B 8 9
B 5 1
B 15 9
C 16 13
C 13 10
C 11 18
C 9 5
C 21 23
C 16 12
C 12 5
C 12 16
C 7 1
C 12 20
;

proc means data=dat53;
  var y x;
run;

proc glm data=dat53;
  class trt;
  model y=trt x / solution;
  lsmeans trt /tdiff;
run;

data dat54;
  input trt $ x y;
  cards;
S1 38 21
S1 29 26 
S1 36 22
S1 45 28 
S1 33 19
S2 43 34
S2 38 26
S2 38 29
S2 27 18
S2 34 28
S3 24 23
S3 32 29
S3 31 30
S3 21 16
S3 28 29
;

proc means data=dat54;
  var y x;
run;
proc glm data=dat54;
  class trt;
  model y=trt x / solution;
  lsmeans trt /tdiff;
run;
 
