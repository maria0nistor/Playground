# Instalarea pachetelor necesare
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(osmdata)) install.packages("osmdata")
if(!require(sf)) install.packages("sf")
if(!require(showtext)) install.packages("showtext")

# Incarcarea pachetelor necesare
library(tidyverse); library(osmdata)
library(sf); library(showtext); library(ggplot2)

#Extragerea componentelor hartii din OSM

strazi <- getbb("Moinesti Romania") %>% 
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("primary", "secondary", "tertiary")) %>%
  osmdata_sf()


strazi_m <- getbb("Moinesti Romania")%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("residential", "living_street",
                            #"unclassified",
                            "service", "footway")) %>%
  osmdata_sf()

baruri <- getbb("Moinesti Romania") %>% 
  opq() %>% 
  add_osm_feature(key= "amenity",
                  value = c("bar", "pub", "cafe", "fast_food", "casino")) %>% 
  osmdata_sf

ape <- getbb ("Moinesti Romania") %>% 
  opq() %>% 
  add_osm_feature(key= "water",
                  value = c("river", "lake", "pond", "stream_pool", "stream")) %>% 
  osmdata_sf()

# Creearea culorilor Componente

background_color<-'#1E212B'
street_color<-'#FAD399'
small_street_color<-'#D4B483'
river_color<-'#b0efff'
font_color<-'#FFFFFF'


font_add_google("sans", "Sansita")

#Creearea hartii

hrt_moin<-ggplot() +
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
  geom_sf(data = baruri$osm_p,
          inherit.aes = FALSE,
          color = river_color,
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
  coord_sf(ylim = c(46.4950, 46.4590 ), 
           xlim = c(26.4549, 26.5567 ), 
           expand = F) +
  
  labs(title = "Moinesti ROMANIA", 
       subtitle = '46.474281° N, 26.488400° E')

hrt_moin
