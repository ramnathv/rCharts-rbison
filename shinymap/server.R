require(shiny)
require(rCharts)
renderMap = function(expr, env = parent.frame(), quoted = FALSE){
  func <- shiny::exprToFunction(expr, env, quoted)
  function() {
    rChart_ <- func()
    map_div = sprintf('<div id="%s" class="rChart leaflet"></div>', rChart_$params$dom)
    HTML(paste(c(map_div, rChart_$html()), collapse = '\n'))
  }
}

shinyServer(function(input, output){
  output$chart <- renderMap({
    require(rCharts)
    map3 <- Leaflet$new()
    map3$setView(c(51.505, -0.09), zoom = 13)
    map3$tileLayer(provider = input$provider, urlTemplate = NULL)
    map3$marker(c(51.5, -0.09), bindPopup = "<p> Hi. I am a popup </p>")
    map3$marker(c(51.495, -0.083), bindPopup = "<p> Hi. I am another popup </p>")
    map3
  })
})


