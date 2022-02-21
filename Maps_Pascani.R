# Instalarea pachetelor necesare
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(osmdata)) install.packages("osmdata")
if(!require(sf)) install.packages("sf")
if(!require(showtext)) install.packages("showtext")

# Incarcarea pachetelor necesare
library(tidyverse); library(osmdata)
library(sf); library(showtext); library(ggplot2)

#Extragerea componentelor hartii din OSM

strazi <- getbb("Pascani Romania") %>% 
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("primary", "secondary", "tertiary")) %>%
  osmdata_sf()

strazi_m <- getbb("Pascani Romania")%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("residential", "living_street",
                            #"unclassified",
                            "service", "footway")) %>%
  osmdata_sf()

baruri <- getbb("Pascani Romania") %>% 
  opq() %>% 
  add_osm_feature(key= "amenity",
                  value = c("bar", "pub", "cafe", "fast_food", "casino")) %>% 
  osmdata_sf

ape <- getbb ("Pascani Romania") %>% 
  opq() %>% 
  add_osm_feature(key= "water",
                  value = c("river", "lake", "pond", "stream_pool", "stream")) %>% 
  osmdata_sf()

scoli <- getbb("Pascani Romania") %>% 
  opq() %>% 
  add_osm_feature(key= "amenity",
                  value = c("college", "library", "kindergarten", "school")) %>% 
  osmdata_sf

# Creearea culorilor Componente

background_color<-'#224f48'
street_color<-'#fa9b99'
small_street_color<-'#d69f78'
river_color<-'#4a9eed'
font_color<-'#FFFFFF'


font_add_google("calibri")


#Creearea hartii

hrt_pasc<-ggplot() +
  geom_sf(data = strazi$osm_lines,
          inherit.aes = FALSE,
          color = street_color,
          size = .9,
          alpha = .9,) +
  
  geom_sf(data = strazi_m$osm_lines,
          inherit.aes = FALSE,
          color = street_color,
          size = .7,
          alpha = .6) +
  geom_sf(data = ape$osm_polygons,
          inherit.aes = F,
          color = river_color,
          alpha=.9,
          size = .9) +
  geom_sf(data = baruri$osm_points,
          inherit.aes = FALSE,
          color = 'red',
          size = 1.3,
          alpha = .9) +
  geom_sf(data = scoli$osm_points,
          inherit.aes = FALSE,
          color = 'green',
          size = 1.3,
          alpha = .9) +
  
  theme_void() +
  theme(plot.title = element_text(family = 'sans',
                                  color=font_color,
                                  size = 18, face="bold", hjust=.5,
                                  vjust=2.5),
        panel.border = element_rect(colour = "white", fill=NA, size=3),
        plot.margin=unit(c(0.6,1.6,1,1.6),"cm"),
        plot.subtitle = element_text(color=font_color,
                                     family = 'sans',
                                     vjust=0.1,
                                     size = 12, hjust=.5, margin=margin(2, 0, 5, 0)),
        plot.background = element_rect(fill = "#282828")) +
  coord_sf(ylim = c(47.2658, 47.2308 ), 
           xlim = c(26.6810, 26.7682 ), 
           expand = F) +
  
  labs(title = "Pascani ROMANIA", 
       subtitle = ' 47.2480765° N, 26.7256423° E')

hrt_pasc 
