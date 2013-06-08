require(shiny)
require(rCharts)

shinyServer(function(input, output){
  output$chart <- renderMap({
    require(rCharts)
    map3 <- Leaflet$new()
    map3$setView(c(51.505, -0.09), zoom = 13)
    map3$tileLayer(provider = input$provider, urlTemplate = NULL)
    map3$marker(c(51.5, -0.09), bindPopup = "<p> Hi. I am a popup </p>")
    map3$marker(c(51.495, -0.083), bindPopup = "<p> Hi. I am another popup </p>")
    # legend method accepts three arguments colors, position and labels.
    map3$legend(
     position = 'bottomright',
     colors = c('red', 'blue', 'green'),
     labels = c('Red', 'Blue', 'Green')
    )
    map3
  })
})


