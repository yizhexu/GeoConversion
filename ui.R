#packages <- c("shiny", "shinythemes", "markdown", "leaflet", "rgdal")
#new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
#if(length(new.packages)) install.packages(new.packages)
#lapply(packages,function(x){library(x,character.only=TRUE)}) 
#rm(packages, new.packages)

library(shiny)
library(markdown)
library(leaflet)
library(rgdal)

shinyUI(
  navbarPage(title = "Geoferenced Data Format Conversion",
             ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             ## HTML Layout Settings
             ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             #theme = shinytheme("flatly"),
             
             ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             ## Tab "About"
             ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             tabPanel("About", 
                      column(3,""),
                      column(6,includeMarkdown("./doc/intro.md")),
                      column(3,"")),
             ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             ## Tab "Single Value Conversion"
             ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             navbarMenu("Single Conversion",
                        ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        ## Page "Coordinates to Decimal"
                        ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-
                        tabPanel("Coordinates to Decimal",
                                 HTML("<center><h3>Convert Latitude and Longitude to Decimal Degrees</h3></center><br>"),
                                 HTML("<center><h4>Step 1. Input Point</h4></center><br>"),
                                 fixedRow(
                                   column(3,offset=5,textInput("name", "Name Your Point", "aWhere"))),
                                 fixedRow(
                                   column(2,offset=1,selectInput('latdir', 'Latitude: direction', c("S","N")), selectInput('londir', 'Longitude: direction', c("E","W"))), 
                                   column(2,offset=1,numericInput("latdeg", "Latitude: degree", "39"),numericInput("londeg", "Longitude: degree", "105")),
                                   column(2,offset=1,numericInput("latmin", "Latitude: minute", "55"),numericInput("lonmin", "Longitude: minute", "06")),
                                   column(2,offset=1,numericInput("latsec", "Latitude: second", "30.9742"),numericInput("lonsec", "Longitude: second", "16.3199"))),
                                 HTML("<center><h4>Step 2. Validate Your Point</h4></center><br>"),
                                 fixedRow(
                                   leafletMap("map_coor", "100%", 600, initialTileLayer = "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                              initialTileLayerAttribution = HTML('&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'),
                                              options=list(
                                                center = c(39,-105),
                                                zoom = 3
                                              ))),
                                 HTML("<br>"),
                                 HTML("<center><h4>Step 3. Copy Result</h4></center><br>"),
                                 fixedRow(column(3,offset=4,tableOutput("coor2decimal")))),
                        
                        ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        ## Page "UTM to Decimal"
                        ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-
                        tabPanel("UTM to Decimal",
                                 HTML("<center><h3>Convert UTM to Decimal Degrees</h3></center><br>"),
                                 HTML("<center><h4>Step 1. Input Point</h4></center><br>"),
                                 fluidRow(
                                   column(4,textInput("utmname", "Name Your Point", "aWhere")),
                                   column(4,numericInput("utmz","Zone","13"),selectInput("datum", "Select Datum", c(as.character(projInfo("datum")$name)))),
                                   column(4,numericInput("utme","Easting","491067"),numericInput("utmn","Northing","4419468"))),
                                 HTML("<center><h4>Step 2. Validate Your Point</h4></center><br>"),
                                 fixedRow(
                                   leafletMap("map_utm", "100%", 600, initialTileLayer = "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                              initialTileLayerAttribution = HTML('&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'),
                                              options=list(
                                                center = c(39,-105),
                                                zoom = 3))),
                                 HTML("<br>"),
                                 HTML("<center><h4>Step 3. Copy Result</h4></center><br>"),
                                 fixedRow(column(3,offset=4,tableOutput("sutm2decimal"))))),
             ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             ## Tab "Batch Value Conversion"
             ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             navbarMenu("Batch Conversion",
                        ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        ## Page "Coordinate to Decimal"
                        ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-
                        tabPanel("Coordinates to Decimal",
                                 HTML("<center><h4>Convert Coordinates to Decimal Degrees</h4></center><br>"),
                                 HTML("<center><h4>Step 1. Download a Template</h4></center>"),
                                 fluidRow(
                                   column(5,offset=5,"",downloadLink('coor_template', 'Download CSV')),
                                   column(5,offset=5,fileInput('coor_template_up', HTML('<br><center><h4>Step 2. Upload Your Data</h4></center>'),accept=c('text/csv','text/comma-separated-values,text/plain','.csv')))),
                                 HTML("<center><h4>Step 3. Validate Your Points</h4></center><br>"),
                                 leafletMap("map_coorB", "100%", 600, initialTileLayer = "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                            initialTileLayerAttribution = HTML('&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'),
                                            options=list(
                                              center = c(39,-105),
                                              zoom = 3)),
                                 HTML("<center><h4>Step 4. View Results</h4></center><br>"),
                                 fluidRow(column(10, offset = 1, dataTableOutput("coor2decimalB"))),
                                 HTML("<br><center><h4>Step 5. Download Results</h4></center>"),
                                 column(5, offset=5,"",downloadButton('coor_result', "Download Results"))),
                        
                        ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        ## Page "UTM to Decimal"
                        ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-
                        tabPanel("UTM to Decimal",
                                 HTML("<center><h4>Convert UTM to Decimal Degrees</h4></center><br>"),
                                 HTML("<center><h4>Step 1. Download a Template</h4></center>"),
                                 fluidRow(column(5,offset=5,"",downloadLink('utm_template', 'Download CSV')),
                                          column(5,offset=5,fileInput('utm_template_up', HTML('<br><center><h4>Step 2. Upload Your Data</h4></center>'),accept=c('text/csv','text/comma-separated-values,text/plain','.csv'))),
                                          column(4,offset = 3, numericInput("utmzB","Zone","13")),
                                          column(4,selectInput("datumB", "Select Datum", c(as.character(projInfo("datum")$name))))),
                                 HTML("<center><h4>Step 3. Validate Your Points</h4></center><br>"),
                                 leafletMap("map_utmB", "100%", 600, initialTileLayer = "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                            initialTileLayerAttribution = HTML('&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'),
                                            options=list(
                                              center = c(39,-105),
                                              zoom = 3)),
                                 HTML("<center><h4>Step 4. View Results</h4></center><br>"),
                                 fluidRow(column(10, offset = 1, dataTableOutput("utm2decimal"))),
                                 HTML("<br><center><h4>Step 5. Download Results</h4></center>"),
                                 column(5,offset=5,"",downloadButton('utm_result', 'Download Result')))),
             
             ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             ## Tab "Contact"
             ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             tabPanel("Contact", includeMarkdown("./doc/contact.md"))
  ))
