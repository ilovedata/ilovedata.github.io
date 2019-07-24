## ----setup---------------------------------------------------------------
options(scipen=999)  # turn off scientific notation like 1e+06
library(dplyr)
library(tidyr)
library(ggplot2)
data("diamonds", package = "ggplot2")  # load the data
head(diamonds)

## ------------------------------------------------------------------------
with(diamonds,hist(carat))

## ------------------------------------------------------------------------
ggplot(diamonds, aes(x = carat)) +  geom_histogram()

## ------------------------------------------------------------------------
ggplot(diamonds, aes(carat)) +geom_histogram(binwidth = 0.01)

## ------------------------------------------------------------------------
ggplot(diamonds, aes(price, colour = cut)) +
  geom_freqpoly(binwidth = 500)

## ------------------------------------------------------------------------
p <- ggplot(mpg, aes(class, hwy))
p + geom_boxplot()

## ------------------------------------------------------------------------
p + geom_boxplot() + coord_flip() + theme_linedraw()

## ------------------------------------------------------------------------
library(MVA)
head(USairpollution)

## ------------------------------------------------------------------------
g<- ggplot(USairpollution, aes(x=manu, y=popul)) + geom_point()
g

## ------------------------------------------------------------------------
xxlab <- "Manufacturing enterprises with 20 or more workers"
yylab <- "Population size (1970 census) in thousands"
g <- g +  ggtitle("Manufacturing vs. Population") + xlab(xxlab) + ylab(yylab)
g <- g +  coord_cartesian(xlim=c(0,1000), ylim=c(0, 2000))
g <- g +  geom_smooth(method="lm") 
g

## ------------------------------------------------------------------------
 p <- ggplot(mtcars, aes(wt, mpg))
 p + geom_point(aes(colour = factor(cyl)))

## ------------------------------------------------------------------------
 p + geom_point(aes(shape = factor(cyl)), size = 3) + scale_shape(solid = FALSE)

## ------------------------------------------------------------------------
xxlab <- "Manufacturing enterprises with 20 or more workers"
yylab <- "Population size (1970 census) in thousands"
g <- g +  ggtitle("Manufacturing vs. Population") + xlab(xxlab) + ylab(yylab)
g <- g +  coord_cartesian(xlim=c(0,1000), ylim=c(0, 2000))
g <- g +  geom_smooth(method="lm") 
g

## ------------------------------------------------------------------------
library("GGally")
ggpairs(USairpollution)

## ------------------------------------------------------------------------
library(lme4)
str(sleepstudy)
head(sleepstudy,n=20)

## ------------------------------------------------------------------------
coef_res <- lmList(Reaction ~ Days | Subject, sleepstudy)
coef_res

## ------------------------------------------------------------------------
ggplot(sleepstudy, aes(x=Days, y=Reaction,colour=Subject)) +
  geom_point() +
  geom_smooth(se = FALSE, method = "lm")

## ------------------------------------------------------------------------
ggplot(sleepstudy, aes(x=Days, y=Reaction)) +
    geom_point(size=0.5) +
    scale_x_continuous(breaks=0:9) +
    facet_wrap("Subject", labeller = label_both)

## ------------------------------------------------------------------------
ggplot(sleepstudy, aes(x=Days, y=Reaction)) +
     geom_point(size=0.5) +
     stat_smooth(method = "lm",se=F,size=0.5)+
     facet_wrap("Subject", labeller = label_both)+ 
     theme_bw()

## ------------------------------------------------------------------------
library(lattice)
print(xyplot(Reaction ~ Days | Subject, sleepstudy, aspect = "xy",
             layout = c(6,3), type = c("g", "p", "r"),
             index.cond = function(x,y) coef(lm(y ~ x))[1],
             xlab = "Days of sleep deprivation",
             ylab = "Average reaction time (ms)"))

