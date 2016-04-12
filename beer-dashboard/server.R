## server.R ##

source("helpers.R", local=TRUE)
server <- function(input, output, session) {

  #####################
  ## dashboard tab ###  
  ####################   
  output$map <- renderLeaflet({
    # beer_advocate <- read.csv("BULK - beeradvocate.com API 28th Dec 10-29.csv")
    # # remove duplicate columns with unimportant info
    # beer_advocate$bottomdark_links._text <- NULL
    # beer_advocate$bottomdark_links._source <- NULL
    # beer_advocate$pageUrl <- NULL
    # beer_advocate$image <- NULL
    # beer_advocate$bottomdark_content_numbers._source <- NULL
    # beer_advocate$bottomlight_number <- NULL
    # beer_advocate$link._source <- NULL
    # # change the column names
    # colnames(beer_advocate) <- c("address", "brewery_website", "beer_advocate_website", "number_of_reviews","beer_avg", "number_of_beers", "place_type", "brewery_rating", "brewery_name", "phone_number")
    # # get our missing values as NA
    # beer_advocate[beer_advocate == "-"] = NA
    # # clean up some of the columns and remove extra data
    # beer_advocate$address <- as.character(beer_advocate$address) # change into character data type
    # beer_advocate$address <- gsub(" official website", "", beer_advocate$address)
    # # extract the phone number from the address column
    # # http://stackoverflow.com/questions/21007607/extract-phone-number-regex
    # library(stringr)
    # beer_advocate$phone_number <- str_extract_all(beer_advocate$address, "\\(?\\d{3}\\)?[.-]? *\\d{3}[.-]? *[.-]?\\d{4}")
    # beer_advocate$phone_number[beer_advocate$phone_number == "character(0)"] = NA
    # # remove the phone number tag from the address field for geocoding
    # beer_advocate$address <- gsub(" phone: \\(?\\d{3}\\)?[.-]? *\\d{3}[.-]? *[.-]?\\d{4}", "", beer_advocate$address)
    # # change the factor for average beer rating into a numeric
    # # http://stackoverflow.com/questions/3418128/how-to-convert-a-factor-to-an-integer-numeric-without-a-loss-of-information
    # beer_advocate$beer_avg <- as.numeric(levels(beer_advocate$beer_avg))[beer_advocate$beer_avg]
    # # GEOCODE
    # geo <- geocode(location = beer_advocate$address, output="latlon", source="google")
    # beer_advocate$lon <- geo$lon
    # beer_advocate$lat <- geo$lat
    #
    # 3/27/2016 change
    ## load dataset with geo attached to prevent constant calls to google API
    load("beer_advocate.rds")
    # leaflet map
    # create the pop-up info
    beer_advocate$pop_up_content <- paste(sep = "<br/>", 
                                          "<b><a href='", beer_advocate$beer_advocate_website, "'>", beer_advocate$brewery_name, "</a></b>",    beer_advocate$address,
                                          beer_advocate$phone_number, paste("Average beer rating: ", beer_advocate$beer_avg,"/5.0"))
    # add colors corresponding to the average beer ratings  
    pal <- colorNumeric("YlOrRd", beer_advocate$beer_avg, n = 6) 
    m <- leaflet(data = beer_advocate) %>% 
      addTiles() %>%
      setView(lng =-72.70190, lat=41.75798, zoom = 8) %>% 
      addCircleMarkers(~lon, ~lat, popup = ~as.character(pop_up_content), color = ~pal(beer_avg)) %>%
      addLegend("topright", pal = pal, values = ~beer_avg,
                title = "Average Beer Ratings at Brewery",
                opacity = 1
      )
    m
  })
 
  #####################
  ## Environment tab ##
  #####################
  temp_reactive <- reactive({ 
    a = getCurrentTemperature("BDL")
    a$TemperatureF
    })
  
  output$temp <- renderInfoBox({
    infoBox(
      "Temperature", paste0(temp_reactive()), icon = icon("sun-o"),
      color = "orange"
    )
  })
  
#   output$temperature <- renderDataTable({
#     a = getCurrentTemperature("BDL")
#     a$TemperatureF
#   })
#   
  ##################
  ## Finance tab ###  
  ##################  
  dataInput <- reactive({ 
    #symbols = c("SAM", "BUD", "STZ", "DEO", "HEINY")
    getSymbols(input$symb, src = "yahoo", 
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = F)
    #a = get(a)
  })
  
  finalInput <- reactive({
    if (!input$adjust) return(dataInput())
    adjust(dataInput())
  })
  
  output$plot <- renderPlot({
    input$go
    isolate({
    chartSeries(finalInput(), theme = chartTheme("white"), name = paste0("beer: ", input$symb),
                type = "line", log.scale = input$log)
    })
  })
  
  ######################
  ## header messages ###  
  ######################   
  output$messageMenu <- renderMenu({
    # Code to generate each of the messageItems here, in a list. This assumes
    # that messageData is a data frame with two columns, 'from' and 'message'.
    messageData = data.frame("from" = c("Jasmine", "Jenna", "Fiona"), "message" = c("Feed Me", "Feed Me", "Feed Me"))
    msgs <- apply(messageData, 1, function(row) {
      messageItem(from = row[["from"]], message = row[["message"]])
    })
    
    # This is equivalent to calling:
    #   dropdownMenu(type="messages", msgs[[1]], msgs[[2]], ...)
    dropdownMenu(type = "messages", .list = msgs)
  })
} # end of server function