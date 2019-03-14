## ----loadpackages, message=FALSE-----------------------------------------
library(dplyr)
library(tidyr)
library(ggplot2)

## ----data1---------------------------------------------------------------
sales <- data.frame(
  person = c("John", "Mary", "Steve"),
  tv = c(2, 1, 3),
  cellphone = c(20, 25, 30),
  computer = c(4, 4, 4)
)
sales

## ----gather1-------------------------------------------------------------
gathered_sales <- gather(sales, item, quantity, tv, cellphone,computer)
gathered_sales

## ----spread--------------------------------------------------------------
spread_sales <- spread(gathered_sales, item, quantity)
spread_sales

## ----data2---------------------------------------------------------------
library(hflights)
data(hflights)
head(hflights)

## ------------------------------------------------------------------------
head(select(hflights, DepTime, ArrTime, FlightNum))

## ------------------------------------------------------------------------
head(select(hflights, Year:Month, contains("time")))

## ------------------------------------------------------------------------
head(filter(hflights, Month==12, DayofMonth==25))

## ------------------------------------------------------------------------
filter(hflights, UniqueCarrier=="AA" | UniqueCarrier=="UA") %>% head()

## ------------------------------------------------------------------------
filter(hflights, Month==12, DayofMonth==25) %>% select(DepTime, ArrTime, FlightNum, contains("Month")) %>% head()

## ------------------------------------------------------------------------
t1 <- filter(hflights, Month==12, DayofMonth==25) 
t2 <- select(t1, DepTime, ArrTime, FlightNum, contains("Month")) 
head(t2)

## ------------------------------------------------------------------------
hflights %>% select(TailNum, ArrDelay) %>%
    arrange(ArrDelay) %>% head()

## ------------------------------------------------------------------------
hflights %>% select(TailNum, ArrDelay) %>%
    arrange(desc(ArrDelay)) %>% head()

## ------------------------------------------------------------------------
mutate(hflights, Speed = Distance/AirTime*69, SpeedKM = Speed*1.60934) %>% head()

## ------------------------------------------------------------------------
transmute(hflights, Speed = Distance/AirTime*69, SpeedKM = Speed*1.60934) %>% head()

## ------------------------------------------------------------------------
groupdata <- group_by(hflights, Dest)
summarise(groupdata, avg_delay = mean(ArrDelay, na.rm=TRUE))

## ------------------------------------------------------------------------
hflights %>%
    group_by(Dest) %>%
     summarise(avg_delay = mean(ArrDelay, na.rm=TRUE))

## ------------------------------------------------------------------------
summarise(hflights,avg_delay = mean(ArrDelay, na.rm=TRUE))

## ------------------------------------------------------------------------
groupdata <- group_by(hflights, Dest)
summarise(groupdata, avg_delay = mean(ArrDelay, na.rm=TRUE), 
  count = n(),
  dist = mean(Distance, na.rm = TRUE),
  delay = mean(ArrDelay, na.rm = TRUE))

## ------------------------------------------------------------------------
group_by(hflights, Dest)  %>%  summarise_at( c("ArrDelay", "DepDelay"), funs(mean(., na.rm=TRUE), min (., na.rm=TRUE),   max(., na.rm=TRUE)))

## ----two data------------------------------------------------------------
Ldata <- data.frame(ID=c("A","B","C"), x=c(1,2,3))
Rdata <- data.frame(ID=c("A","B","D"),  y=c(T,F,T))

## ------------------------------------------------------------------------
Ldata

## ------------------------------------------------------------------------
Rdata

## ------------------------------------------------------------------------
left_join(Ldata,Rdata,by="ID")
right_join(Ldata,Rdata,by="ID")
inner_join(Ldata,Rdata,by="ID")
full_join(Ldata,Rdata,by="ID")

