#packages <- c("shiny", "shinythemes", "markdown", "leaflet", "rgdal")
#new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
#if(length(new.packages)) install.packages(new.packages)
#lapply(packages,function(x){library(x,character.only=TRUE)}) 
#rm(packages, new.packages)

library(shiny)
library(markdown)
library(leaflet)
library(rgdal)

shinyServer(function(input, output, session) {
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Input: Convert Coordinate to Decimal - Single
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  coorInputS <- reactive({ 
    data.frame(
      Name      = c(input$name),
      Longitude = ifelse(input$londir == "W",
                         c(-1*(input$londeg + input$lonmin/60 + input$lonsec/3600)),
                         c(input$londeg + input$lonmin/60 + input$lonsec/3600)),
      Latitude  = ifelse(input$latdir == "S",
                         c(-1*(input$latdeg + input$latmin/60 + input$latsec/3600)),
                         c(input$latdeg + input$latmin/60 + input$latsec/3600)),
      stringsAsFactors=FALSE)
  })
  
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## [Function] Input Convert UTM to Decimal
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  utmconvert <- function(data,zone,datum){
    coordinates(data) <- c("easting","northing")
    crs <- paste0("+proj=utm+zone=",zone,"+datum=",datum)
    data@proj4string@projargs <- paste0("+proj=utm"," +zone=",zone," +datum=",datum)
    spTransform(data, CRS("+proj=longlat"))}
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Input: Convert UTM to Decimal - Single
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  utmInputSDefault <- data.frame(id = "aWhere", easting = 491067, northing = 4419468)
  utmInput <- reactive({ 
    data <- data.frame(id = input$utmname, easting = input$utme, northing = input$utmn,stringsAsFactors=FALSE)
    
    if (is.null(data))
      return(utmInputSDefault)
    
    zone = input$utmz
    datum = input$datum
    data.frame(utmconvert(data,zone,datum))
  })
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Input: Convert Coordinate to Decimal - Batch
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  coorInputSDefault <- data.frame(read.csv("./data/coor_template.csv",stringsAsFactors=FALSE))
  coorInputSDefaultC <- data.frame(ID = coorInputSDefault$ID,
                                   Longitude = ifelse(coorInputSDefault$longitude_hemisphere == "W", -1*(coorInputSDefault$longitude_degree + coorInputSDefault$longitude_minute/60 + coorInputSDefault$longitude_second/3600), coorInputSDefault$longitude_degree + coorInputSDefault$longitude_minute/60 + coorInputSDefault$longitude_second/3600),
                                   Latitude = ifelse(coorInputSDefault$latitude_hemisphere == "S", -1*(coorInputSDefault$latitude_degree + coorInputSDefault$latitude_minute/60 + coorInputSDefault$latitude_second/3600), coorInputSDefault$latitude_degree + coorInputSDefault$latitude_minute/60 + coorInputSDefault$latitude_second/3600),
                                   stringsAsFactors = FALSE)
  
  coorInputB <- reactive({
    inFileCoor <- input$coor_template_up
    
    if (is.null(inFileCoor))
      return(coorInputSDefaultC)
    
    data <- read.csv(inFileCoor$datapath,stringsAsFactors=FALSE)
    colnames(data) <- c("ID","latitude_hemisphere","latitude_degree","latitude_minute","latitude_second","longitude_hemisphere","longitude_degree","longitude_minute","longitude_second")
    
    data.frame(ID = data$ID,
               Longitude = ifelse(data$longitude_hemisphere == "W", -1*(data$longitude_degree + data$longitude_minute/60 + data$longitude_second/3600),data$longitude_degree + data$longitude_minute/60 + data$longitude_second/3600),
               Latitude = ifelse(data$latitude_hemisphere == "S", -1*(data$latitude_degree + data$latitude_minute/60 + data$latitude_second/3600),data$latitude_degree + data$latitude_minute/60 + data$latitude_second/3600),
               stringsAsFactors = FALSE)
  })
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Input Convert UTM to Decimal - Batch
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  utmInputDefault <- data.frame(utmconvert(read.csv("./data/utm_template.csv",stringsAsFactors=FALSE),13,"WGS84"))
  
  utmInputB <- reactive({
    inFile <- input$utm_template_up
    
    if (is.null(inFile))
      return(utmInputDefault)
    
    data <- read.csv(inFile$datapath,stringsAsFactors=FALSE)
    colnames(data) <- c("ID","easting","northing")
    zone = input$utmzB
    datum = input$datumB
    data.frame(utmconvert(data,zone,datum))
  })
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output - Table: Convert Coordinate to Decimal - Single
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$coor2decimal <- renderTable({
    coorInputS()
  }, include.rownames=FALSE)
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output - Table: Convert UTM to Decimal - Single
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$sutm2decimal <- renderTable({
    utmSingle <- utmInput()
    colnames(utmSingle) <- c("Name","Longitude","Latitude")
    utmSingle
  }, include.rownames=FALSE)
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output - Download Button for Batch Converting - Template
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  coor_template <- reactive({
    read.csv("./data/coor_template.csv", stringsAsFactors = FALSE)
  })
  
  output$coor_template <- downloadHandler(
    filename = function() {'coor_template.csv'},
    content = function(file) {write.csv(coor_template(), file, row.names = FALSE)}
  )
  
  utm_template <- reactive({
    read.csv("./data/utm_template.csv", stringsAsFactors = FALSE)
  })
  
  output$utm_template <- downloadHandler(
    filename = function() {'utm_template.csv'},
    content = function(file) {write.csv(utm_template(), file, row.names = FALSE)}
  )
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output - Table: Convert Coordinate to Decimal - Batch
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$coor2decimalB <- renderDataTable({
    coorOutputB <- coorInputB()
  })
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output - Table: Convert UTM to Decimal - Batch
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$utm2decimal <- renderDataTable({
    utmOutputB <- utmInputB()
    colnames(utmOutputB) <- c("ID","Longitude","Latitude")
    utmOutputB
  })
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output - Download Button for Batch Converting - Result
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  coor_result <- reactive({
    coorOutputB <- coorInputB()
  })
  
  output$coor_result <- downloadHandler(
    filename = function() {'coor_result.csv'},
    content = function(file) {write.csv(coor_result(), file, row.names = FALSE)}
  )
  
  utm_result <- reactive({
    utmOutputBD <- utmInputB()
    colnames(utmOutputBD) <- c("ID","Longitude","Latitude")
    utmOutputBD
  })
  
  output$utm_result <- downloadHandler(
    filename = function() {'utm_result.csv'},
    content = function(file) {write.csv(utm_result(), file, row.names = FALSE)}
  )
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Map - Convert Coordinate to Decimal - Single
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  map_coor <- createLeafletMap(session, 'map_coor')
  
  observe({
    pointData <- coorInputS()
    
    if (nrow(pointData) == 0)
      return()
    
    map_coor$setView(pointData$Latitude,pointData$Longitude,zoom=4)
    
  })
  
  observe({
    pointData <- coorInputS()
    map_coor$clearPopups()
    
    if (nrow(pointData) == 0)
      return()
    
    content <- as.character(tagList(
      tags$strong(pointData$Name),
      tags$br(),
      sprintf("Latitude: %s", pointData$Latitude),
      tags$br(),
      sprintf("Longitude: %s", pointData$Longitude)))
    
    map_coor$showPopup(pointData$Latitude,pointData$Longitude, content)
  })
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Map - Convert UTM to Decimal - Single
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  map_utm <- createLeafletMap(session, 'map_utm')
  
  observe({
    utmData <- utmInput()
    colnames(utmData) <- c("Name","Longitude","Latitude")
    
    if (nrow(utmData) == 0)
      return()
    
    map_utm$setView(utmData$Latitude,utmData$Longitude,zoom=4)
  })
  
  observe({
    utmData <- utmInput()
    colnames(utmData) <- c("Name","Longitude","Latitude")
    map_utm$clearPopups()
    
    if (nrow(utmData) == 0)
      return()
    
    content <- as.character(tagList(
      tags$strong(utmData$Name),
      tags$br(),
      sprintf("Latitude: %s", utmData$Latitude),
      tags$br(),
      sprintf("Longitude: %s", utmData$Longitude)))
    
    map_utm$showPopup(utmData$Latitude,utmData$Longitude, content)
  })
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Map - Convert Coordinate to Decimal - Batch
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  map_coorB <- createLeafletMap(session, 'map_coorB')
  observe({
    pointDataB <- coorInputB()
    clearBounds(map_coorB)
    if (nrow(pointDataB) == 0)
      return()
    map_coorB$fitBounds(max(pointDataB$Latitude),min(pointDataB$Longitude),min(pointDataB$Latitude),max(pointDataB$Longitude))
    
  })
  
  observe({
    pointDataB <- coorInputB()
    map_coorB$clearShapes()
    
    if (nrow(pointDataB) == 0)
      return()
    
    map_coorB$addMarker(pointDataB$Latitude,pointDataB$Longitude)
  })
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Map - Convert UTM to Decimal - Batch
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  map_utmB <- createLeafletMap(session, 'map_utmB')
  
  observe({
    utmOutputBM <- utmInputB()
    clearBounds(map_utmB)
    if (nrow(utmOutputBM) == 0)
      return()
    map_utmB$fitBounds(max(utmOutputBM$northing),min(utmOutputBM$easting),min(utmOutputBM$northing),max(utmOutputBM$easting))
  })
  
  observe({
    utmOutputBM <- utmInputB()
    map_utmB$clearShapes()
    
    if (nrow(utmOutputBM) == 0)
      return()
    
    map_utmB$addMarker(utmOutputBM$northing,utmOutputBM$easting)
  })
  
})