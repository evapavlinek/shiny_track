library(shiny)
library(shinydashboard)

body <- dashboardBody(
  tags$head(
    tags$style(
      HTML('
        h3 {
          font-weight: bold;
        }
      ')
    )
  ),
  fluidRow(
    box(
      width = 12,
      title = "Regular Box, Row 1",
      "Star Wars, nothing but Star Wars"
    )
  ),
  fluidRow(
    column(width = 6,
           infoBox(
             width = NULL,
             title = "Regular Box, Row 2, Column 1",
             subtitle = "Gimme those Star Wars"
           )
    ),
    column(width = 6,
           infoBox(
             width = NULL,
             title = "Regular Box, Row 2, Column 2",
             subtitle = "Don't let them end"
           )
    )
  )
)

ui <- dashboardPage(
  skin = "purple",
  header = dashboardHeader(),
  sidebar = dashboardSidebar(),
  body = body)

server <- function(input, output, session) {}

shinyApp(ui, server)



# 
# # CSS file saved in another file:
# body <- dashboardBody(
#   tags$head(
#     tags$link(
#       rel = "stylesheet",
#       type = "text/css"
#       href = "my_style.css"
#     )
#   ),
#   fluidRow(
#     box(
#       width = 12,
#       title = "Regular Box, Row 1",
#       "Star Wars, nothing but Star Wars"
#     )
#   ),
#   fluidRow(
#     column(width = 6,
#            infoBox(
#              width = NULL,
#              title = "Regular Box, Row 2, Column 1",
#              subtitle = "Gimme those Star Wars"
#            )
#     ),
#     column(width = 6,
#            infoBox(
#              width = NULL,
#              title = "Regular Box, Row 2, Column 2",
#              subtitle = "Don't let them end"
#            )
#     )
#   )
# )

