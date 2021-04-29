/* problem 6.6 */;

data prob66;
input subject  drug $ time dist;
datalines;
1  N 0 190
2  N 0 98
3  N 0 155
4  N 0 245
5  N 0 182
6  N 0 140
7  N 0 196
8  N 0 162
9  N 0 195
10 N 0 167
11 N 0 123
12 N 0 105
13 N 0 161
14 N 0 255
15 N 0 144
16 N 0 180
17 N 0 126
18 N 0 175
19 N 0 227
1  N 1 212
2  N 1 137
3  N 1 145
4  N 1 228
5  N 1 205
6  N 1 138
7  N 1 185
8  N 1 176
9  N 1 232
10 N 1 187
11 N 1 165
12 N 1 144
13 N 1 177
14 N 1 242
15 N 1 195
16 N 1 218
17 N 1 145
18 N 1 155
19 N 1 218
1  N 2 213
2  N 2 185
3  N 2 196
4  N 2 280
5  N 2 218
6  N 2 187
7  N 2 185
8  N 2 192
9  N 2 199
10 N 2 228
11 N 2 145
12 N 2 119
13 N 2 162
14 N 2 330
15 N 2 180
16 N 2 224
17 N 2 173
18 N 2 154
19 N 2 245
1  N 3 195
2  N 3 215
3  N 3 189
4  N 3 274
5  N 3 194
6  N 3 195
7  N 3 227
8  N 3 230
9  N 3 185
10 N 3 192
11 N 3 185
12 N 3 168
13 N 3 185
14 N 3 284
15 N 3 184
16 N 3 165
17 N 3 175
18 N 3 164
19 N 3 235
1  N 4 248
2  N 4 225
3  N 4 176
4  N 4 260
5  N 4 193
6  N 4 205
7  N 4 180
8  N 4 215
9  N 4 200
10 N 4 210
11 N 4 215
12 N 4 165
13 N 4 192
14 N 4 319
15 N 4 213
16 N 4 200
17 N 4 140
18 N 4 154
19 N 4 257
20 P 0 187
21 P 0 205
22 P 0 165
23 P 0 256
24 P 0 197
25 P 0 134
26 P 0 196
27 P 0 167
28 P 0 98
29 P 0 167
30 P 0 123
31 P 0 95
32 P 0 181
33 P 0 237
34 P 0 144
35 P 0 182
36 P 0 165
37 P 0 196
38 P 0 175
20 P 1 177
21 P 1 230
22 P 1 142
23 P 1 232
24 P 1 182
25 P 1 115
26 P 1 166
27 P 1 144
28 P 1 102
29 P 1 175
30 P 1 136
31 P 1 102
32 P 1 177
33 P 1 232
34 P 1 172
35 P 1 202
36 P 1 140
37 P 1 195
38 P 1 197
20 P 2 200
21 P 2 172
22 P 2 195
23 P 2 252
24 P 2 160
25 P 2 150
26 P 2 166
27 P 2 176
28 P 2 89
29 P 2 122
30 P 2 147
31 P 2 154
32 P 2 140
33 P 2 245
34 P 2 163
35 P 2 254
36 P 2 153
37 P 2 204
38 P 2 195
20 P 3 190
21 P 3 196
22 P 3 185
23 P 3 326
24 P 3 210
25 P 3 165
26 P 3 188
27 P 3 155
28 P 3 128
29 P 3 162
30 P 3 130
31 P 3 105
32 P 3 212
33 P 3 193
34 P 3 158
35 P 3 185
36 P 3 180
37 P 3 188
38 P 3 182
20 P 4 206
21 P 4 232
22 P 4 170
23 P 4 292
24 P 4 185
25 P 4 170
26 P 4 205
27 P 4 185
28 P 4 130
29 P 4 125
30 P 4 135
31 P 4 112
32 P 4 230
33 P 4 245
34 P 4 188
35 P 4 173
36 P 4 155
37 P 4 178
38 P 4 193
;

proc sort data=prob66; by drug time; run;

proc means noprint;
  by drug time;
  var dist;
  output out=prob66m mean=distbar;
  run;

proc gplot;
  axis1 length=4 in label=("Mean");
  axis2 length=6 in;
  plot distbar*time=drug / vaxis=axis1 haxis=axis2;
  symbol1 v=J f=special h=2 i=join color=red;
  symbol2 v=K f=special h=2 i=join color=blue;
  run;


  
proc mixed data=prob66 ;
class subject drug time ;
model dist=drug time drug*time / ddfm=kr;
random  int / sub=subject;
run;


