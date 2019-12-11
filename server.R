
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })
  
  output$scatterPlot = renderPlot({
    
    # Getting the apples-to-apples here...
    faithful_pp = preProcess(faithful, method = c('center', 'scale'))
    faithful_standardized = predict(faithful_pp, faithful)
    
    # Accepting input from numeric "waiting" and throwing 0 in (but can be anything, will not affect outcome) 
    dat = tibble(waiting = input$waiting, eruptions = 0)
    pp_data = predict(model_pp, dat)
    
    estimate = predict(model_lm, pp_data)
    
    dat_final = tibble(waiting = pp_data$waiting, eruptions = estimate) %>%
      mutate(type = 'predicted')
    
    dat_plot = faithful_standardized %>%
      mutate(type = 'actual') %>%
      bind_rows(dat_final)
      
    dat_plot %>%
      ggplot(aes(x = waiting, y = eruptions, col = type)) + 
      geom_point(aes(size = type)) #using size solely to show off, not a good idea for a discrete categorical variable
  })

})
