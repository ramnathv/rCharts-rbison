require(shiny)
require(rCharts)

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