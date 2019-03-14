## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----map1, warning=FALSE, message = FALSE--------------------------------
library(sp)
library(rgdal)
library(RColorBrewer)
library(dplyr)
library(tidyr)
library(tmap)
library(raster)


## ------------------------------------------------------------------------
load("seoulmap.RData")
seoul0


## ------------------------------------------------------------------------
longitude <- c(126.9768,127.0589, 127.0049)  # 경도
latitude <- c(37.5759, 37.5839, 37.5048)    # 위도
lonlat <- cbind(longitude, latitude) # 위도와 경도를 합친다.
lonlat


## ------------------------------------------------------------------------
ptr <- SpatialPoints(lonlat)
ptr


## ------------------------------------------------------------------------
coordinates(ptr)


## ------------------------------------------------------------------------
proj4string(ptr) = CRS("+init=epsg:4326")
ptr


## ------------------------------------------------------------------------
tm_shape(seoul0) +    # SpatialPolygonsDataFrame(서울지도)를 지정한다.      
tm_polygons(col = NA) +   # 서울지도를 그린다.
tm_shape(ptr)  +    # SpatialPoints(광화문,시립대,터미널)를 지정한다.
tm_dots(col="red",size = 0.5, alpha = 0.5) # 위치를 그린다.


## ------------------------------------------------------------------------
plg <- spPolygons(lonlat, crs=CRS("+init=epsg:4326"))
plg


## ------------------------------------------------------------------------
tm_shape(seoul0) +    # SpatialPolygonsDataFrame(서울지도)를 지정한다.      
tm_polygons(col = NA) +   # 서울지도를 그린다.
tm_shape(plg)  +    # SpatialPolygons  plg를 지정한다.
tm_borders(col = "red") # 다각형를 그린다.


## ------------------------------------------------------------------------
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
tm_shape(seoul0) +    # SpatialPolygonsDataFrame(서울지도)를 지정한다.      
tm_polygons(col = NA) +    # 서울지도를 그린다.
tm_text(text = "name",size=0.7)  # 구이름을 표시한다.   


## ------------------------------------------------------------------------
qtm(seoul0, text = "name", text.size = 0.7)


## ------------------------------------------------------------------------
house <- read.table("seoul-house-win.csv", sep=",", header = TRUE)
head(house, n=5)


## ------------------------------------------------------------------------
seoul0@data <- left_join(seoul0@data,house, by = "name")
head(seoul0@data, n=10)


## ------------------------------------------------------------------------
qtm (seoul0,  fill ="house", text = "name", title="2017년 서울시 구별 가구수", text.size = 0.7)

