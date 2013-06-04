require(rgbif)
toGeoJSON = function(list_, lat = 'latitude', lon = 'longitude'){
  x = lapply(list_, function(l){
    if (is.null(l[[lat]]) || is.null(l[[lon]])){
      return(NULL)
    }
    list(
      type = 'Feature',
      geometry = list(
        type = 'Point',
        coordinates = as.numeric(c(l[[lon]], l[[lat]]))
      ),
      properties = l[!(names(l) %in% c(lat, lon))]
    )
  })
  setNames(Filter(function(x) !is.null(x), x), NULL)
}

gbifmap2 <- function(input = NULL, map_provider = 'MapQuestOpen.OSM', map_zoom = 2){
  require(rCharts)
  input <- Filter(function(x) !is.na(x$decimalLatitude), input)
  L1 <- Leaflet$new()
  L1$tileLayer(provider = map_provider, urlTemplate = NULL)
  L1$set(height = 800, width = 1600)
  L1$setView(c(30, -73.90), map_zoom)
  L1$geoJson(toGeoJSON(input, lat = 'decimalLatitude', lon = 'decimalLongitude'), 
             onEachFeature = '#! function(feature, layer){
      layer.bindPopup(feature.properties.popup || feature.properties.taxonName)
    } !#',
             pointToLayer =  "#! function(feature, latlng){
       return L.circleMarker(latlng, {
        radius: 4,
        fillColor: feature.properties.fillColor || 'red',    
        color: '#000',
        weight: 1,
        fillOpacity: 0.8
      })
    } !#"
  )
  return(L1)
}