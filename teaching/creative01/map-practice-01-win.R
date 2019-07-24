## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----map1----------------------------------------------------------------
library(sp)
library(rgdal)
library(RColorBrewer)
library(dplyr)
library(tidyr)
library(tmap)
library(knitr)
library(kableExtra)

## ------------------------------------------------------------------------
load("seoulmap.RData")
seoul0

## ------------------------------------------------------------------------
class(seoul0)

## ------------------------------------------------------------------------
slotNames(seoul0)

## ------------------------------------------------------------------------
head(seoul0@data,n=10)

## ------------------------------------------------------------------------
names(seoul0@data)

## ------------------------------------------------------------------------
head(seoul0@data) %>%   kable() %>%   kable_styling(bootstrap_options = "striped", full_width = F) 

## ------------------------------------------------------------------------
qtm(seoul0, text = 'name', text.size = 0.7)

## ------------------------------------------------------------------------
pop <- read.table("seoulpop-win.csv", sep=",", header = TRUE)

## ------------------------------------------------------------------------
head(pop, n=5)

## ------------------------------------------------------------------------
head(pop,n=30) %>%   kable() %>%   kable_styling(bootstrap_options = "striped", full_width = T, font_size = 7) 

## ------------------------------------------------------------------------
values <- pop %>% filter(year == 2017) %>% select(c("name","pop","old65"))
values <- values %>% filter( name != "합계" )
values

## ------------------------------------------------------------------------
values %>%   kable() %>%   kable_styling(bootstrap_options = "striped", full_width = F)

## ------------------------------------------------------------------------
seoul0@data <- left_join(seoul0@data,values, by = 'name')
seoul0@data %>%   kable() %>%   kable_styling(bootstrap_options = "striped", full_width = F)

## ------------------------------------------------------------------------
qtm (seoul0,  fill ="pop", text = 'name',text.size = 0.7)

## ------------------------------------------------------------------------
seoul0data <- st_as_sf(seoul0)
class(seoul0data)
seoul0data <- select(seoul0data, name,  geometry)

## ------------------------------------------------------------------------
head(seoul0data,n=2) %>%   kable() %>%   kable_styling(bootstrap_options = "striped", full_width = T, font_size = 10) 

## ------------------------------------------------------------------------
pop1 <- pop %>% select(year,name,pop, old65) %>%  filter(name != "합계", year %in% c(1992,1997,2002,2007,2012,2017))

## ------------------------------------------------------------------------
pop1_long <- left_join(pop1, seoul0data, by = 'name')
pop1_long <- st_as_sf(pop1_long)

## ------------------------------------------------------------------------
head(pop1_long,n=2) %>%   kable() %>%   kable_styling(bootstrap_options = "striped", full_width = T, font_size = 10) 

## ----dpi = 200-----------------------------------------------------------
tm_shape(pop1_long) +
tm_polygons("pop") +
tm_facets(by = "year") +
tm_text(text = 'name',size=0.3)+
tm_layout(title = "1992-2017년까지 서울시 구별 인구의 변화")  

## ----dpi = 200-----------------------------------------------------------
tm_shape(pop1_long) +
tm_polygons("old65") +
tm_facets(by = "year") +
tm_layout(title = "1992-2017년까지 서울시 구별 65세 이상 노인 인구의 변화")  

## ------------------------------------------------------------------------
pop1_long <- pop1_long %>% mutate(old65ratio = round(old65/pop*100, digit=2))
pop1_long

## ----dpi = 200-----------------------------------------------------------
tm_shape(pop1_long) +
tm_polygons("old65ratio") +
tm_facets(by = "year")  +
tm_layout(title = "1992-2017년까지 구별 65세 이상 노인인구 비율(%)의 변화")  

