## ui.R ##
library(shinydashboard)
library(leaflet)
library(htmlwidgets)
library(leaflet)
library(ggmap)
library(weatherData)
library(quantmod)

dashboardPage(
  dashboardHeader(title = "Beer Dashboard", dropdownMenuOutput("messageMenu")),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Customer Segmentation", tabName = "customer", icon = icon("users")), 
      menuItem("Finance", tabName = "finance", icon = icon("money")),
      menuItem("Environment", tabName = "environment", icon = icon("leaf")),
      menuItem("Widgets", icon = icon("beer"), tabName = "widgets",
               badgeLabel = "new", badgeColor = "green") #, 
      
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                box(title = "CT Craft Beer Ranking via BeerAdvocate", status = "primary", solidHeader = TRUE, 
                    leafletOutput("map")) , 
                box(title = "Beer Box1", status = "info", solidHeader = TRUE, collapsible = TRUE,
                    plotOutput("box1"))
              ),
              fluidRow(
                box(title = "Other box", status = "success", collapsible = TRUE, width = 12, 
                    textOutput("demotext1"))
              )
              
      ), 
      tabItem(tabName = "customer", 
              fluidRow(
                box(title = "Wine Settings", status = "danger", width = 6, collapsible = TRUE,
                    selectInput('xcol', 'X Variable', names(red_wine), selected = "ash"),
                    selectInput('ycol', 'Y Variable', names(red_wine), selected = "hue"),
                    numericInput('clusters', 'Cluster count', 3,
                                 min = 1, max = 9)   ) ,
                box(title = "Red Wine Clustering", status = "danger", width = 6, 
                    plotOutput("wine")
                )
             # )
              )  ),
      
      tabItem(tabName = "finance", 
              fluidRow(
                box(title = "Beer Stocks", status = "info", solidHeader = TRUE, 
                    plotOutput("plot"))
              ), 
              fluidRow(
                box(title = "Controls", status = "info", collapsible = TRUE, collapsed = TRUE,
                           textInput("symb", "Symbol", "BUD"),
                           dateRangeInput("dates", 
                                          "Date range",
                                          start = "2015-01-01", 
                                          end = as.character(Sys.Date())),
                           checkboxInput("log", "Plot y axis on log scale", 
                                         value = FALSE),
                           checkboxInput("adjust", 
                                         "Adjust prices for inflation", value = FALSE), 
                           actionButton("go", "Go!"))
                )
              ), 
      
      tabItem(tabName = "environment", 
              fluidRow(
                infoBoxOutput("temp") #, 
#                 box(title = "Weather", status = "success", solidHeader = TRUE, 
#                     dataTableOutput("temperature")) 
                
                
              )   ), 
      tabItem(tabName = "widgets")
    ) # end of tabItems
    
    
    
  )
)