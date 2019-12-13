
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library('plotly')

shinyUI(fluidPage(

  # Application title
  titlePanel("Drunken Beer Buyer"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("abv",
                  "Input ABV %:",
                  min = 0,
                  max = 20,
                  step = 0.1,
                  value = 5.6),
      
      sliderInput("ibu",
                  "Input IBU:",
                  min = 0,
                  max = 100,
                  step = 1,
                  value = 35)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("beerPlot"),
      tableOutput("beerTable")
      # plotOutput("scatterPlot")
    )
  )
))
