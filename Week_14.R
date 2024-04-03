#task 1
leaflet() %>%
  addTiles() %>%                              
  addProviderTiles("Esri.WorldImagery",      
                   options = providerTileOptions(opacity=0.5)) %>%     
  setView(lng = 9.0344728 , lat = 56.5695813 , zoom = 10)              

#more complicated
leaflet() %>% 
  setView(9.0344728, 56.5695813, zoom = 8) %>%
  addTiles()  # checking I am in the right area

#background
DANmap <- leaflet() %>%   # assign the base location to an object
  setView(9.0344728, 56.5695813 , zoom = 10)

#selecting backgrounds
esri <- grep("^Esri", providers, value = TRUE)

for (provider in esri) {
  DANmap <- DANmap %>% addProviderTiles(provider, group = provider)
}

DKmap <- DANmap %>%
  addLayersControl(baseGroups = names(esri),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(tiles = esri[[1]], toggleDisplay = TRUE,
             position = "bottomright") %>%
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>% 
  htmlwidgets::onRender("
                        function(el, x) {
                        var myMap = this;
                        myMap.on('baselayerchange',
                        function (e) {
                        myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
                        })
                        }") %>% 
  addControl("", position = "topright")

# run this to see your product
DKmap

# Libraries
library(tidyverse)
library(googlesheets4)
library(leaflet)

#Read google sheet file converted to csv
trplaces <- read.csv("DKkoordinater.csv")

# load the coordinates in the map and check: are any points missing? Why?
leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = trplaces$Longitude, 
             lat = trplaces$Latitude,
             popup = trplaces$Description)

#########################################

#Task 2: Read in the googlesheet data you and your colleagues 
# populated with data into the DANmap object you created in Task 1.
#We did this in the code above

# Task 3: Can you cluster the points in Leaflet? Google "clustering options in Leaflet"
leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = trplaces$Longitude, 
             lat = trplaces$Latitude,
             popup = trplaces$Description,
             clusterOptions = markerClusterOptions())

#task 4: Look at the map and consider what it is good for and what not.
#The map is useful to mark and visualize places to go in Denmark and creates an overview of attractions in the map
#However the map doesnt specify how to come there 

#task 5: Find out how to display notes and classifications in the map
leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = trplaces$Longitude, 
             lat = trplaces$Latitude,
             popup = trplaces$Placename,
             label = trplaces$Type,
             clusterOptions = markerClusterOptions()) 

saveWidget(DKmap, "DKmap.html", selfcontained = TRUE)
  





