library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(d3wordcloud)
library(jsonlite)
library(tidyverse)
library(tidytext)

recipes <- fromJSON("train.json", flatten = TRUE, simplifyDataFrame = TRUE) %>% 
  unnest(ingredients) %>% 
  rename(ingredient = ingredients)

# Compute TFIDF (term frequency-inverse document frequency)
recipes_enriched <- recipes %>% 
  count(cuisine, ingredient, name = "nb_recipes") %>% 
  bind_tf_idf(ingredient, cuisine, nb_recipes)


ui <- fluidPage(
  titlePanel('Explore Cuisines'),
  sidebarLayout(
    sidebarPanel(
      selectInput('cuisine', 'Select Cuisine', unique(recipes$cuisine)),
      sliderInput('nb_ingredients', 'Select No. of Ingredients', 5, 100, 20),
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Word Cloud", d3wordcloudOutput("wc_ingredients")),
        tabPanel('Plot', plotly::plotlyOutput('plot_top_ingredients')),
        tabPanel('Table', DT::DTOutput('dt_top_ingredients'))
      )
    )
  )
)

server <- function(input, output, session){
  output$wc_ingredients <- d3wordcloud::renderD3wordcloud({
    d3wordcloud(
      words = rval_top_ingredients()$ingredient, 
      freqs = rval_top_ingredients()$nb_recipes,
      tooltip = TRUE
    )
  })
  
  rval_top_ingredients <- reactive({
    recipes_enriched %>% 
      filter(cuisine == input$cuisine) %>% 
      arrange(desc(tf_idf)) %>% 
      head(input$nb_ingredients) %>% 
      mutate(ingredient = forcats::fct_reorder(ingredient, tf_idf))
  })
  
  output$plot_top_ingredients <- plotly::renderPlotly({
    rval_top_ingredients() %>%
      ggplot(aes(x = ingredient, y = tf_idf)) +
      geom_col() +
      coord_flip()
  })
  
  output$dt_top_ingredients <- DT::renderDT({
    recipes %>% 
      filter(cuisine == input$cuisine) %>% 
      count(ingredient, name = 'nb_recipes') %>% 
      arrange(desc(nb_recipes)) %>% 
      head(input$nb_ingredients)
  })
}

shinyApp(ui = ui, server= server)