library(shiny)
library(leaflet)
library(dplyr)
library(datasets)

pageWithSidebar(
  # Pithy Title
  headerPanel('K-means clustering and mapping of Earthquake Data'),
  
  # Create a sidebar panel to hold the user controls
  sidebarPanel(
    # Create a string selector for the X-axis using the column names of the quakes dataset
    h4("K-means Plots controls"),
    selectInput('xcol', 'X Variable', names(quakes)),
    # Create a string selector for the Y-axis using the column names of the quakes dataset
    selectInput('ycol', 'Y Variable', names(quakes),selected=names(quakes)[[2]]),
    # Create a numerical selector for the number of clusters to create. Default to 3. Set
    # minimum value to 1 and maximum value to 9.
    numericInput('clusters', 'Cluster count', 3, min = 1, max = 9),
    hr(),
    h4("Map control"),
    # Create a numerical selector for the number of quake locations to map. Default to 5. Set
    # minimum value to 1 and maximum value to 20.
    numericInput('location_count', 'Number of Locations to Map', 5, min=1, max=20),
    helpText("Check the Help tab for detailed usage information")
  ),
  mainPanel(
    # Create a set of tabs to show the K-means plot, the map of quake locations and the help data
    tabsetPanel(
      tabPanel("K-means Plot", plotOutput('kmeansPlot')),
      tabPanel("Map", leafletOutput('map')),
      tabPanel("Help",
               helpText(
                 tags$h1("Application Overview"),
                 "This simple Shiny application uses the quakes dataset and generates the following items:",
                 tags$ul(
                   tags$li("A K-means cluster plot generated from user-supplied values"),
                   tags$li("A map of n quake locations, where n is supplied by the user")
                 ),
                 tags$h1("K-means tab and controls"),
                 "The K-means tab shows a plot of K-means clusters.",
                 "This plot uses different colors for each cluster and marks the center of each cluster.",
                 br(),
                 br(),
                 "You can manipulate the following settings via the K-means Plot controls",
                 tags$ul(
                   tags$li("X Variable: selects the column of the quake data that will serve as the x-axis data"),
                   tags$li("Y Variable: selects the column of the quake data that will serve as the y-axis data"),
                   tags$li("Cluster count: specifies the number of clusters to create")
                 ),
                 br(),
                 "Manipulating any of these controls will reactively re-plot the K-means clusters.",
                 tags$h1("Map tab and controls"),
                 "The Map tab shows a Leaflet-generated map of the locations of earthquakes from the data set.",
                 "The marker icons on the map are color coded based upon the magnitude of the quake ",
                 " (green: minor, yellow: moderate, red: major).",
                 br(),
                 br(),
                 "You can manipulate the following setting via the Map control",
                 tags$ul(
                   tags$li("Number of Locations to Map: specifies the number of quake locations to map")
                 ),
                 br(),
                 "You may find it helpful to zoom out on the map as you increase the number of locations."
                 )
               )
    )
  )
)