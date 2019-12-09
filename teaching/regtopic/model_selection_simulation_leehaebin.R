#package preparation
library(dplyr)

##----------------------Linear regression----------------------##

ft1 = function(data){
  
  m_fit = list() #fitting 결과 저장
  t_pred = list() #prediction for train data
  m_pred = list() #prediction for vaild data
  mmm <- 1:(length(Model)+4) #후보모델 + 평균화방법4개 MSE 저장
  AIC <- 1:length(Model) #후보모델의 AIC
  BIC_ <- 1:length(Model) #후보모델의 BIC 
  
  #divide data
  idx = sample(x = c("train","valid"), size = nrow(data), replace = T, prob = c(8,2))
  train = data[idx=="train",]
  valid = data[idx=="valid",]
  
  tranrow <- dim(train)[1]
  
  #---------------1. Model Selection------------------#
  for(i in 1:length(Model)){
    m_fit[[i]]=lm(Model[[i]], data=train) #train 데이터로 모델피팅
    AIC[i]=AIC(m_fit[[i]],k=2) #그 모델피팅의 AIC
    BIC_[i]=AIC(m_fit[[i]],k=log(nrow(train))) #그 모델피팅의 BIC
    t_pred[[i]] = predict(m_fit[[i]], train) #train 데이터 예측결과
    m_pred[[i]] = predict(m_fit[[i]], valid) #valid 데이터 예측결과
    mmm[i] <- mean((valid$y-m_pred[[i]])^2) #valid 데이터 기준 MSE
  } 
  
  #----------------2. model averaging_1-----------------#
  AS = 1:length(Model)
  sig = 1:length(Model)
  weight = 1:length(Model)
  upper = 0 
  
  for(i in 1:length(Model)){
    AS[i] = sum((train$y-t_pred[[i]])^2)/(tranrow-varnum[i]) #train기준
    sig[i] = sqrt((tranrow-varnum[i])*AS[i]/tranrow) #train기준
    weight[i] = exp(-tranrow*log(sig[i])) #train기준
    
    upper = upper + weight[i]*m_pred[[i]] #train기준가중치 * valid예측값
  }
  
  averaged = upper/sum(weight)
  mmm[length(Model)+1] <- mean((valid$y-averaged)^2)
  
  
  #----------------2. model averaging_2-----------------#
  weight = 1:length(Model)
  upper = 0
  
  for(i in 1:length(Model)){
    weight[i] = exp((1/2)*(AIC[i]-max(AIC)))
    
    upper = upper + weight[i]*m_pred[[i]]
  }
  
  averaged2 = upper/sum(weight)
  mmm[length(Model)+2] <- mean((valid$y-averaged2)^2)

 
  #----------------2. model averaging_3-----------------#
  weight = 1:length(Model)
  upper = 0

  for(i in 1:length(Model)){
    weight[i] = exp((1/2)*(BIC_[i]-max(BIC_)))
  
    upper = upper + weight[i]*m_pred[[i]]
  }
  
  averaged3 = upper/sum(weight)
  mmm[length(Model)+3] <- mean((valid$y-averaged3)^2)


  #----------------2. model averaging_4-----------------#
  pred = 0
  
  for(i in 1:length(Model)){
    pred = pred + m_pred[[i]]
  }
  
  averaged4 = pred/length(Model)
  mmm[length(Model)+4] <- mean((valid$y-averaged4)^2)
  
  
  return (list(AIC=AIC, BIC=BIC_, mmm=mmm))
} 

#---------------------------(n, Beta)에 따른 결과 비교---------------------------#

compare_ft1 = function(Beta, n_data) {
  
  res = list()
  
  for (i in 1:B) {
    #data creation
    data_1 = matrix(nrow = n_data, ncol = 1, 1)
    data_x = matrix(nrow = n_data, ncol = max(varnum), rnorm(max(varnum)*n_data, mean=0, sd=1))
    X = cbind(data_1, data_x)
    mu0 = X%*%Beta
    Epsilon = rnorm(n_data, mean=0, sd=1)
    y = mu0 + Epsilon
    data = data.frame(y, X)
    names(data)=c("y","x0","x1","x2","x3","x4","x5","x6","x7","x8")

    res[[i]] = ft1(data)
  }

  #----------result summary----------#
  res_dat = data.frame(matrix((unlist(res)), nrow = B, byrow=T))
  colnames(res_dat) = names(unlist(res))[1:(length(Model)*3+4)]

  AIC = select(res_dat, contains("AIC"))
  BIC = select(res_dat, contains("BIC"))
  MSE = select(res_dat, contains("mmm"))

  AIC_i = apply(AIC[1:(length(Model))],1,which.min)
  BIC_i = apply(BIC[1:(length(Model))],1,which.min)
  
  AIC_MSE=1:B
  BIC_MSE=1:B
  for(j in 1:B){
    AIC_MSE[j]=MSE[j,AIC_i[j]]
    BIC_MSE[j]=MSE[j,BIC_i[j]]
  }  

  result = cbind(AIC_i, BIC_i, AIC_MSE, BIC_MSE, MSE[length(Model)+1], MSE[length(Model)+2], MSE[length(Model)+3], MSE[length(Model)+4])
  colnames(result)[5]="Bayesian_Ave"
  colnames(result)[6]="AIC_Ave"
  colnames(result)[7]="BIC_Ave"
  colnames(result)[8]="Equ_Ave"

  #Table1
  mean_sd = data.frame(rbind(apply(result[-(1:2)], 2, mean), apply(result[-(1:2)], 2, sd)))
  rownames(mean_sd)=c("mean","sd")

  #Table2
  sel_ind = result[c(1:2)]
  sel_ind$AIC_i=as.factor(sel_ind$AIC_i)
  sel_ind$BIC_i=as.factor(sel_ind$BIC_i)
  sel_ind = data.frame(summary(sel_ind))

  return (list(tb1 = mean_sd, tb2 = sel_ind))
}

#candidate Model

Model = list()
Model[[1]] = y ~ x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 
Model[[2]] = y ~ x1 + x2 + x3 + x5 + x6 + x7 + x8 
Model[[3]] = y ~ x1 + x2 + x3 + x6 + x7 + x8
Model[[4]] = y ~ x1 + x2 + x3 + x7 + x8 
Model[[5]] = y ~ x1 + x2 + x3 + x8
Model[[6]] = y ~ x1 + x2 + x3 + x4 + x6 + x8  #true/oracle model

# can do same thing in loop by using p=length(coef(fit))-1  
varnum = 1:length(Model)
for(i in 1:length(Model)){
  varnum[i] = length(all.vars(Model[[i]]))-1
}

B = 1000 #시뮬레이션 반복 횟수


res1 <- compare_ft1(Beta = c(0.3, 0.3, 0.5, 0.1, 0.5, 0.0, 0.6, 0.0, 0.1), n_data = 100)


#-------------------------Logistic regression-----------------------------#

ft2 = function(data){
  
  m_fit = list() #fitting 결과 저장
  
  t_y_pred = list() #predict prob for train data
  t_m_pred = list() #1 or 0 for train data
  
  y_pred = list() #predict prob for valid data
  m_pred = list() #1 or 0 for valid data
  
  mmm <- 1:(length(Model)+4) #후보모델 + 평균화방법4개 MSE 저장
  AIC <- 1:length(Model) #후보모델의 AIC
  BIC_ <- 1:length(Model) #후보모델의 BIC 
  
  #divide data
  #idx = sample(x = c("train","valid"), size = nrow(data), replace = T, prob = c(8,2))
  #train = data[idx=="train",]
  #valid = data[idx=="valid",]
  # use 80% for train set and 20% for validation
  nn = round(nrow(data)*0.8) 
  train = data[1:nn,]
  valid = data[(nn+1):nrow(data),]
  
  tranrow <- dim(train)[1]

  #---------------1. Model Selection------------------#
  for(i in 1:length(Model)){
    m_fit[[i]] = glm(Model[[i]], data=train, family="binomial") #train 데이터로 모델피팅
    AIC[i] = AIC(m_fit[[i]],k=2) #그 모델피팅의 AIC
    BIC_[i] = AIC(m_fit[[i]],k=log(nrow(train))) #그 모델피팅의 BIC
    
    t_y_pred[[i]] = predict(m_fit[[i]], train, type="response") #train 데이터 예측결과
    t_m_pred[[i]] = ifelse(t_y_pred[[i]]>0.5, 1, 0) #1 or 0
    
    y_pred[[i]] = predict(m_fit[[i]], valid, type="response") #valid 데이터 예측결과
    m_pred[[i]] = ifelse(y_pred[[i]]>0.5, 1, 0) #1 or 0
    
    mmm[i] <- mean((valid$y-m_pred[[i]])^2) #valid 데이터 기준 MSE
  }
  
  #----------------2. model averaging-----------------#
  AS = 1:length(Model)
  sig = 1:length(Model)
  weight = 1:length(Model)
  upper = 0
  
  for(i in 1:length(Model)){
    AS[i] = sum((train$y-t_m_pred[[i]])^2)/(tranrow-varnum[i]) #train기준
    sig[i] = sqrt((tranrow-varnum[i])*AS[i]/tranrow) #train기준
    #valnrowt = valnrow*0.01
    weight[i] = exp(-tranrow*log(sig[i])) #train기준
    
    upper = upper + weight[i]*m_pred[[i]] #train기준가중치 * valid예측값
  }
  
  averaged_p = upper/sum(weight)
  averaged = ifelse(averaged_p>0.5, 1, 0)
  mmm[length(Model)+1] <- mean((valid$y-averaged)^2)
  
  
  #----------------2. model averaging_2-----------------#
  weight = 1:length(Model)
  upper = 0
  
  for(i in 1:length(Model)){
    weight[i] = exp((1/2)*(AIC[i]-max(AIC)))
    
    upper = upper + weight[i]*m_pred[[i]]
  }
  
  averaged2_p = upper/sum(weight)
  averaged2 = ifelse(averaged2_p>0.5, 1, 0)
  mmm[length(Model)+2] <- mean((valid$y-averaged2)^2)
  

  #----------------2. model averaging_3-----------------#
  weight = 1:length(Model)
  upper = 0
  
  for(i in 1:length(Model)){
    weight[i] = exp((1/2)*(BIC_[i]-max(BIC_)))
    
    upper = upper + weight[i]*m_pred[[i]]
  }
  
  averaged3_p = upper/sum(weight)
  averaged3 = ifelse(averaged3_p>0.5, 1, 0)
  mmm[length(Model)+3] <- mean((valid$y-averaged3)^2)
  
  
  #----------------2. model averaging_4-----------------#
  pred = 0
  
  for(i in 1:length(Model)){
    pred = pred + m_pred[[i]]
  }
  
  averaged4_p = pred/length(Model)
  averaged4 = ifelse(averaged4_p>0.5, 1, 0)
  mmm[length(Model)+4] <- mean((valid$y-averaged4)^2)
  
  return (list(AIC=AIC, BIC=BIC_, mmm=mmm))
}  



#---------------------------(n, Beta)에 따른 결과 비교---------------------------#

compare_ft2 = function(Beta, n_data) {
  
  res = list()

  for (i in 1:B) {
    #data creation
    data_1 = matrix(nrow = n_data, ncol = 1, 1)
    data_x = matrix(nrow = n_data, ncol = max(varnum), rnorm(max(varnum)*n_data, mean=0, sd=1))
    X = cbind(data_1, data_x)
    mu0 = X%*%Beta
    p = 1/(1+exp(-mu0))
    #------- should draw random variable from Bernoulli dist with probability p
    y = rbinom(n_data,1,p)
  
    data = data.frame(y, X)
    names(data)=c("y","x0","x1","x2","x3","x4","x5", "x6")
  
    res[[i]] = ft2(data)
  }

  
  #----------result summary----------#
  res_dat = data.frame(matrix((unlist(res)), nrow = B, byrow=T))
  colnames(res_dat) = names(unlist(res))[1:(length(Model)*3+4)]

  AIC = select(res_dat, contains("AIC"))
  BIC = select(res_dat, contains("BIC"))
  MSE = select(res_dat, contains("mmm"))

  AIC_i = apply(AIC[1:(length(Model))],1,which.min)
  BIC_i = apply(BIC[1:(length(Model))],1,which.min)

  AIC_MSE=1:B
  BIC_MSE=1:B
  for(j in 1:B){
    AIC_MSE[j]=MSE[j,AIC_i[j]]
    BIC_MSE[j]=MSE[j,BIC_i[j]]
  }  

  result = cbind(AIC_i, BIC_i, AIC_MSE, BIC_MSE, MSE[length(Model)+1], MSE[length(Model)+2], MSE[length(Model)+3], MSE[length(Model)+4])
  colnames(result)[5]="Bayesian_Ave"
  colnames(result)[6]="AIC_Ave"
  colnames(result)[7]="BIC_Ave"
  colnames(result)[8]="Equ_Ave"

  #Table1
  mean_sd = data.frame(rbind(apply(result[-(1:2)], 2, mean), apply(result[-(1:2)], 2, sd)))
  rownames(mean_sd)=c("mean","sd")

  #Table2
  sel_ind = result[c(1:2)]
  sel_ind$AIC_i=as.factor(sel_ind$AIC_i)
  sel_ind$BIC_i=as.factor(sel_ind$BIC_i)
  sel_ind = data.frame(summary(sel_ind))

  return (list(tb1 = mean_sd, tb2 = sel_ind))
}



#candidate Model

Model = list()
Model[[1]] = y ~ x1 + x2 + x3 + x4 + x5 + x6
Model[[2]] = y ~ x1 + x2 + x3 + x4 + x5
Model[[3]] = y ~ x1 + x2 + x3 + x4 
Model[[4]] = y ~ x1 + x2 + x3
Model[[5]] = y ~ x1 + x2 
Model[[6]] = y ~ x1 + x2 + x4 + x6 #true/oracle model

# can do same thing in loop by using p=length(coef(fit))-1  
varnum = 1:length(Model)
for(i in 1:length(Model)){
  varnum[i] = length(all.vars(Model[[i]]))-1
}

B = 1000 #시뮬레이션 반복 횟수

res2 <- compare_ft2(Beta = c(0.5, 1, -0.5, 0, -1.2, 0, 0.25), n_data = 100)
