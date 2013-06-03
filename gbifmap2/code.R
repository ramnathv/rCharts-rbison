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
  L1$tileLayer(provider = map_provider)
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

## Example 1


out1<- occurrencelist(scientificname = 'Puma concolor', 
  coordinatestatus = TRUE, maxresults = 100)
mycolors = c('red', 'blue', 'green')
out1 <- mutate(out1, 
  taxonName = as.factor(taxonName),
  fillColor = mycolors[as.numeric(taxonName)]
)
out_list1 <- apply(out1, 1, as.list) 
map1 = gbifmap2(out_list1)
map1$save('gbifmap2/index.html', cdn = TRUE)


## Example 2
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
out2 <- occurrencelist_many(splist, coordinatestatus = TRUE, 
  maxresults = 20, format="darwin") 
out2 <- out2[,c("taxonName","county","decimalLatitude","decimalLongitude",
    "institutionCode","collectionCode","catalogNumber","basisOfRecordString","collector")] 
out2$taxonName <- capwords(out2$taxonName, onlyfirst=TRUE)



mycolors = c('red', 'blue', 'green')
out2 <- mutate(out2, 
  taxonName = as.factor(taxonName),
  fillColor = mycolors[as.numeric(taxonName)]
)

out_list2 <- apply(out2, 1, as.list) 

# add popup
out_list2 <- lapply(out_list2, function(l){
  l$popup = paste(paste("<b>", names(l), ": </b>", l, "<br/>"), collapse = '\n')
  return(l)
})

map2 = gbifmap2(out_list2)
map2$save('gbifmap2/example2.html', cdn = TRUE)

