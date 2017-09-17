function(input, output, session) {
  
  # Create a new data frame based on the values supplied by the user
  selectedData <- reactive({
    quakes[, c(input$xcol, input$ycol)]
  })
  
  # Comute the number of k-means clusters based on count supplied by the user
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  # Create a new data frame of quake locations based on how many locations were chosen by the user
  quakeLocationData <- reactive({
    quakes[c(1,seq(input$location_count)),]
  })
  
  # Drum up the K-means plot
  output$kmeansPlot <- renderPlot({
    # Create a palette to work with. Align the number of chosen colors to the max clusters allowed.
    palette(c("coral", "aquamarine", "darkviolet", "goldenrod", "green", "red", "blue", "brown", "grey"))
    
    # Increase the morgins of the plot.
    par(mar = c(5.1, 4.1, 0, 1))
    
    # Plot the data points associated with the clusters
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 1,
         cex = 3)
    
    # Plot the cluster centers
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  # Create a leaflet map using the selected data
  mymap <- reactive({
    # Drum up a datafrom using the selected quake rows
    df <- quakeLocationData()
    
    # Create a function that will create colored marker icons based on the strength of the earthquake.
    # If magnitude of quake is at least 4, the icon will be green (minor quake)
    # If magnitude of quake is at least 5, the icon will be orange (medium quake)
    # If magnitude of quake is more than 5, the icon will be red (major quake)
    getColor <- function(quakes) {
      sapply(quakes$mag, function(mag) {
        if(mag <= 4) {
          "green"
        } else if(mag <= 5) {
          "orange"
        } else {
          "red"
        }
      })
    }
    
    # Make use of the awesome icons plug-in from Leaflet.
    icons <-
      awesomeIcons(
        icon = 'ios-close',
        iconColor = 'black',
        library = 'ion',
        markerColor = getColor(df))
  
    # Drum up the Leaflet map using the latitude and longitude
    leaflet(df) %>% addTiles() %>% addAwesomeMarkers(~long, ~lat, icon=icons, label=~as.character(mag))
    
  })
  
  # Reader the Leaflet map to the Shiny UI can display it.
  output$map <- renderLeaflet({
    mymap()
  })
}