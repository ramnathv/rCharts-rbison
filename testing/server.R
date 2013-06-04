require(shiny)
require(plyr)
require(rgbif)
require(rCharts)
shinyServer(function(input, output){
  getData <- reactive({
    if (is.null(input$splist) || input$splist == ""){
      return(NULL)
    }
    splist <- strsplit(input$splist, ",")[[1]]
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
  })
  output$wrapper <- renderUI({
    mydata = getData()
    if (is.null(mydata)){
      return()
    }
    map2 = gbifmap2(mydata)$html('map')
    h = paste(c('<div id="map" class="rChart leaflet"></div>', map2), collapse = '\n')
    HTML(h)
  })
})
