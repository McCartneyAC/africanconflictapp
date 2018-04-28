library(shiny)
library(tidyverse)
library(ggmap)
library(ggthemes)
library(forcats)
library(lubridate)
library(shinythemes)
library(rsconnect)
library(DT)

acled<-read_csv("ACLED-Africa_1997-2018.csv")

ui <- fluidPage( theme = shinytheme ("sandstone"), 
                 
                 titlePanel("Conflict in Africa"),
                 
                 sidebarLayout(
                   sidebarPanel(
                     textInput("maparea", "Map Area - Type Any Location in Africa", "Central African Republic"),
                     sliderInput("zoom", "Zoom Level",
                                 min = 3, max = 21, value = 4),
                     sliderInput("yr", "Select Year",
                                 min= 1997, max = 2018, value = 2018),
                     selectInput("type", "Map Type", 
                                 c("Points Map" = "points",
                                   "Heat Map" = "heatmap",
                                   "Map Only" = "")), 
                     checkboxGroupInput("event_type", "Event Type:", 
                                        choices = unique(acled$EVENT_TYPE),
                                        selected = "Violence against civilians")
                   ),
                   mainPanel(
                     tabsetPanel(
                       tabPanel("plots", 
                                tags$br(),
                                tags$p("Select points to browse data. If you receive an error, try toggling options on the left panel."),
                                plotOutput(
                                  outputId="africa", 
                                  width = 700, 
                                  height = 700, 
                                  brush = brushOpts(id = "mapbrush",
                                                    delay = 50))
                                ), 
                       tabPanel("Browse Selection",
                                DTOutput('dt')),
                       tabPanel("about",
                                
                                tags$div(class="header", checked=NA,
                                         tags$h3("ACLED's African Conflict Data" ),
                                         tags$h4("From ACLEDs' Website"),
                                         tags$p("ACLED (Armed Conflict Location & Event Data Project) is the most comprehensive public collection of political violence and protest data for developing states. This data and analysis project produces information on the specific dates and locations of political violence and protest, the types of event, the groups involved, fatalities, and changes in territorial control. Information is recorded on the battles, killings, riots, and recruitment activities of rebels, governments, militias, armed groups, protesters and civilians. "),
                                         tags$p("ACLED has recorded close to 200,000 individual events, with ongoing data collection focused on Africa and ten countries in South and Southeast Asia. These data can be used for immediate and long-term analysis and mapping of political violence and protest across developing countries through use of historical data from 1997, as well as informing humanitarian and development work in crisis and conflict-affected contexts through realtime data updates and reports. ACLED data show that political violence rates have remained relatively high and stable in the recent years, despite the waning of civil wars across the developing world. ACLED seeks to support research and work devoted to understanding, predicting and reducing levels of political violence."),
                                         tags$p(tags$a(href="https://www.acleddata.com/", "ACLED's Main Page"))
                                         )
                                )
                       )
                     )
                   )
                 )









server<-function(input, output){
  

  acled_selected <- reactive ({
    acled %>% 
    select(EVENT_DATE, EVENT_TYPE, YEAR, ACTOR1, ACTOR2,COUNTRY, LOCATION, SOURCE, FATALITIES, NOTES, LONGITUDE, LATITUDE) %>% 
    mutate(EVENT_DATE=as_date(dmy(EVENT_DATE))) %>% 
    filter(YEAR==input$yr)
  })
  
  map <- reactive({
    get_map(location = input$maparea, zoom = input$zoom, color="bw")
  })
  
  
  
  
  
  output$africa<-renderPlot({
    
    if (input$type == "heatmap") {
      
      
      ggmap(map(), legend = "topleft") + stat_density2d(
        aes(x = LONGITUDE, y = LATITUDE, fill = ..level.., alpha=..level..),
        size = 1, bins = 10, data = filter(acled_selected(), EVENT_TYPE==input$event_type), geom = "polygon") +
        guides(fill=FALSE, alpha=FALSE) + 
        labs(x="longitude",
             y="latitude",
             title="Conflict in Africa",
             subtitle="")+
        theme_few()
      
    }
    else if (input$type == "points"){
      
      ggmap(map(), legend = "topleft") + 
        geom_point(
          aes(x = LONGITUDE, 
              y = LATITUDE, 
              color = EVENT_TYPE, 
              size = FATALITIES, 
              alpha = 0.8), 
          data = filter(acled_selected(), 
                        EVENT_TYPE==input$event_type)) +
        labs(x="longitude",
             y="latitude",
             title="Conflict in Africa",
             subtitle="")+
        guides(alpha=FALSE) + 
        theme_few()
      
    }
    
    else ggmap(map())
    
    
    
    
  })
  
  
  brushd <- reactive({
    user_brush <- input$mapbrush
    brushedPoints(acled_selected(), user_brush, xvar = "LONGITUDE", yvar = "LATITUDE")
    })
  output$dt<-DT::renderDataTable({DT::datatable(brushd(), options=list(columnDefs = list(list(visible=FALSE, targets=c(3, 11, 12)))))})


  
}
shinyApp(ui, server)



