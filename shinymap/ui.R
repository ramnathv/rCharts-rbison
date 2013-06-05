require(shiny)
require(rCharts)

mapOutput = function(outputId){
  LIB <- get_lib('leaflet')
  suppressMessages(singleton(addResourcePath(LIB$name, LIB$url)))
  div(id = outputId, class = paste("shiny-html-output", basename(LIB$name)), 
      tagList(get_assets_shiny(LIB)))
}

shinyUI(pageWithSidebar(
  headerPanel('Leaflet Maps'),
  sidebarPanel(
    selectInput('provider', 'Provider', 
      choices = c('Stamen.Toner', 'MapQuestOpen.OSM'),
      selected = 'MapQuestOpen.OSM'
    )
  ),
  mainPanel(
    tags$style('.leaflet {height:400px; width:800px;}'),
    mapOutput('chart')
  )
))