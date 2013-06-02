toGeoJSON = function(list_){
  x = lapply(list_, function(l){
    if (is.null(l$latitude) || is.null(l$longitude)){
      return(NULL)
    }
    list(
      type = 'Feature',
      geometry = list(
        type = 'Point',
        coordinates = as.numeric(c(l$longitude, l$latitude))
      ),
      properties = l[!(names(l) %in% c('latitude', 'longitude'))]
    )
  })
  Filter(function(x) !is.null(x), x)
}

bisonmap2 <- function(input = NULL, map_provider = 'MapQuestOpen.OSM', map_zoom = 4){
  require(rCharts)
  L1 <- Leaflet$new()
  L1$tileLayer(provider = map_provider)
  L1$set(height = 800, width = 1600)
  L1$setView(c(40.73, -73.90), map_zoom)
  L1$geoJson(toGeoJSON(input$data), 
      onEachFeature = '#! function(feature, layer){
        layer.bindPopup(feature.properties.common_name)
      } !#',
      pointToLayer =  "#! function(feature, latlng){
        return L.circleMarker(latlng, {
          radius: 4,
          fillColor: 'red',    
          color: '#000',
          weight: 1,
          fillOpacity: 0.8
        })
      } !#"
  )
  return(L1)
}


require(rbison)
out1 <- bison(species = "Bison bison", count = 600)
b1 <- bisonmap2(out1)
b1$save('bison.html', cdn = T)


out2 <- bison(species = "Aquila chrysaetos", count = 600)
b2 <- bisonmap2(out2, map_provider = 'Stamen.Toner')
b2$save('aquila.html', cdn = T)
