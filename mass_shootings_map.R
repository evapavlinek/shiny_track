library(shiny)
library(dplyr)
library(leaflet)
library(shinythemes)
library(stringr)
library(tidyverse)

# mass_shootings <- as_tibble(read.csv("Mass Shootings Dataset Ver 4.csv")) %>% 
#  remove_missing(vars = c("Longitude", "Latitude"))

mass_shootings <- as_tibble(read.csv("mass-shootings.csv")) %>% 
  mutate(date = as.Date(date, tryFormats = "%m/%d/%y",))

text_about <- c("Mass Shootings in the United States of America (1966-2017). The US has witnessed 398 mass shootings in last 50 years that resulted in 1,996 deaths and 2,488 injured. The latest and the worst mass shooting of October 2, 2017 killed 58 and injured 515 so far. The number of people injured in this attack is more than the number of people injured in all mass shootings of 2015 and 2016 combined. The average number of mass shootings per year is 7 for the last 50 years that would claim 39 lives and 48 injured per year.")


ui <- bootstrapPage(
  theme = shinythemes::shinytheme('simplex'),
  leaflet::leafletOutput('map', width = '100%', height = '100%'),
  absolutePanel(top = 10, right = 10, id = 'controls',
                sliderInput('nb_fatalities', 'Minimum Fatalities', 1, 40, 10),
                dateRangeInput(
                  'date_range', 'Select Date', "2010-01-01", "2019-12-01"
                ),
                actionButton("show_about", "About")
  ),
  tags$style(type = "text/css", "
    html, body {width:100%;height:100%}     
    #controls{background-color:white;padding:20px;}
  ")
)

server <- function(input, output, session) {
  observeEvent(input$show_about, {
    showModal(modalDialog(text_about, title = 'About'))
  })
  
  ms_filtered <- reactive({
    mass_shootings %>% 
      filter(
        date >= input$date_range[1],
        date <= input$date_range[2],
        fatalities >= input$nb_fatalities
      ) 
  })
  
  output$map <- leaflet::renderLeaflet({
    ms_filtered() %>% 
      leaflet() %>% 
      setView(-98.58, 39.82, zoom = 5) %>% 
      addTiles() %>% 
      addCircleMarkers(
        lng = ms_filtered()$longitude, lat = ms_filtered()$latitude,
        popup = ~ ms_filtered()$summary, radius = ~ sqrt(ms_filtered()$fatalities)*3,
        fillColor = 'red', color = 'red', weight = 1
      )
  })
  
}

shinyApp(ui, server)