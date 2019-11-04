regressogram = function(x,y,left,right,k,plotit,xlab="",ylab="",sub=""){
  ### assumes the data are on the interval [left,right]
  n = length(x)
  B = seq(left,right,length=k+1)
  WhichBin = findInterval(x,B)
  N = tabulate(WhichBin)
  m.hat = rep(0,k)
  for(j in 1:k){
    if(N[j]>0)m.hat[j] = mean(y[WhichBin == j])
  }
  if(plotit==TRUE){
    a = min(c(y,m.hat))
    b = max(c(y,m.hat))
    plot(B,c(m.hat,m.hat[k]),lwd=3,type="s",
         xlab=xlab,ylab=ylab,ylim=c(a,b),col="blue",sub=sub)
    points(x,y)
  }
  return(list(bins=B,m.hat=m.hat))
}
# pdf("regressogram.pdf") # print to pdf file
par(mfrow=c(2,2))
### simulated example
n = 100
x = runif(n)
y = 3*sin(8*x) + rnorm(n,0,.3)
plot(x,y,pch=20)
out = regressogram(x,y,left=0,right=1,k=5,plotit=TRUE)
out = regressogram(x,y,left=0,right=1,k=10,plotit=TRUE)
out = regressogram(x,y,left=0,right=1,k=20,plotit=TRUE)



par(mfrow=c(2,2))
#install.packages("ElemStatLearn") 
library(ElemStatLearn)
attach(bone)
age.male = age[gender == "male"]
density.male = spnbmd[gender == "male"]
out = regressogram(age.male,density.male,left=9,right=26,k=10,plotit=TRUE,
                   xlab="Age",ylab="Density",sub="Male")
out = regressogram(age.male,density.male,left=9,right=26,k=20,plotit=TRUE,
                   xlab="Age",ylab="Density",sub="Male")
age.female = age[gender == "female"]
density.female = spnbmd[gender == "female"]
out = regressogram(age.female,density.female,left=9,right=26,k=10,plotit=TRUE,xlab="Age",ylab="Density",sub="Female")
out = regressogram(age.female,density.female,left=9,right=26,k=20,plotit=TRUE,xlab="Age",ylab="Density",sub="Female")


kernel = function(x,y,grid,h){
  ### kernel regression estimator at a grid of values
  n = length(x)
  k = length(grid)
  m.hat = rep(0,k)
  for(i in 1:k){
    w = dnorm(grid[i],x,h)
    m.hat[i] = sum(y*w)/sum(w)
  }
  return(m.hat)
}
kernel.fitted = function(x,y,h){
  ### fitted values and diaginal of smoothing matrix
  n = length(x)
  m.hat = rep(0,n)
  S = rep(0,n)
  for(i in 1:n){
    w = dnorm(x[i],x,h)
    w = w/sum(w)
    m.hat[i] = sum(y*w)
    S[i] = w[i]
  }
  return(list(fitted=m.hat,S=S))
}
CV = function(x,y,H){
  ### H is a vector of bandwidths
  n = length(x)
  k = length(H)
  cv = rep(0,k)
  nu = rep(0,k)
  gcv = rep(0,k)
  for(i in 1:k){
    tmp = kernel.fitted(x,y,H[i])
    cv[i] = mean(((y - tmp$fitted)/(1-tmp$S))^2)
    nu[i] = sum(tmp$S)
    gcv[i] = mean((y - tmp$fitted)^2)/(1-nu[i]/n)^2
  }
  return(list(cv=cv,gcv=gcv,nu=nu))
}

#pdf("crossval.pdf")
par(mfrow=c(2,2))
#bone = read.table("BoneDensity.txt",header=TRUE)
attach(bone)
age.female = age[gender == "female"]
density.female = spnbmd[gender == "female"]
H = seq(.1,5,length=20)
out = CV(age.female,density.female,H)
plot(H,out$cv,type="l",lwd=3,xlab="Bandwidth",ylab="Cross-validation Score")
lines(H,out$gcv,lty=2,col="red",lwd=3)
plot(out$nu,out$cv,type="l",lwd=3,xlab="Effective Degrees of Freedom",ylab="Cross-validation score")
lines(out$nu,out$gcv,lty=2,col="red",lwd=3)
j = which.min(out$cv)
h = H[j]
grid = seq(min(age.female),max(age.female),length=100)
m.hat = kernel(age.female,density.female,grid,h)
plot(age.female,density.female,xlab="Age",ylab="Density")
lines(grid,m.hat,lwd=3,col="blue")




boot = function(x,y,grid,h,B){
  ### pointwise standard error for kernel regression using the bootstrap
  k = length(grid)
  n = length(x)
  M = matrix(0,k,B)
  for(j in 1:B){
    I = sample(1:n,size=n,replace=TRUE)
    xx = x[I]
    yy = y[I]
    M[,j] = kernel(xx,yy,grid,h)
  }
  s = sqrt(apply(M,1,var))
  return(s)
}
#bone = read.table("BoneDensity.txt",header=TRUE)
par(mfrow=c(1,1))
attach(bone)
age.female = age[gender == "female"]
density.female = spnbmd[gender == "female"]
h = .7
grid = seq(min(age.female),max(age.female),length=100)
plot(age.female,density.female)
mhat = kernel(age.female,density.female,grid,h)
lines(grid,mhat,lwd=3)
B = 1000
se = boot(age.female,density.female,grid,h,B)
lines(grid,mhat+2*se,lwd=3,lty=2,col="red")
lines(grid,mhat-2*se,lwd=3,lty=2,col="red")



library(mgcv)
library(rpart)
D = car90
D = D[,c("Price", "Mileage", "Weight" , "Disp", "HP")]
D =na.omit(D)
##data from Consumer Reports (1990)
attach(D)
names(D)
pairs(D)
out = gam(Price ~ s(Mileage) + s(Weight) + s(Disp) + s(HP))
summary(out)

par(mfrow=c(2,2))
plot(out,lwd=3)

par(mfrow=c(2,2))
r = resid(out)
plot(Mileage,r);abline(h=0)
plot(Weight,r);abline(h=0)
plot(Disp,r);abline(h=0)
plot(HP,r);abline(h=0)

outlm = lm(Price ~ Mileage + Weight + Disp + HP, data=D)
plot(outlm)
rlm =  resid(outlm)
plot(Mileage,rlm);abline(h=0)
plot(Weight,rlm);abline(h=0)
plot(Disp,rlm);abline(h=0)
plot(HP,rlm);abline(h=0)


x <- seq(0, pi * 2, 0.1)
sin_x <- sin(x)
y <- sin_x + rnorm(n = length(x), mean = 0, sd = sd(sin_x / 2))
Sample_data <- data.frame(y,x)

library(ggplot2)
ggplot(Sample_data, aes(x, y)) + geom_point()

lm_y <- lm(y ~ x, data = Sample_data)
ggplot(Sample_data, aes(x, y)) + geom_point() + geom_smooth(method = lm)
plot(lm_y)

gam_y <- gam(y ~ s(x), method = "REML")
x_new <- seq(0, max(x), length.out = 100)
y_pred <- predict(gam_y, data.frame(x = x_new))
ggplot(Sample_data, aes(x, y)) + geom_point() + geom_smooth(method = "gam", formula = y ~s(x))

par(mfrow = c(2,2))
gam.check(gam_y)
