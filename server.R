
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {

  beerTibble = reactive({
    abv <- input$abv / 100
    ibu <- input$ibu
    beer_recommendations <- craft_beer_app(abv, ibu)
    return(beer_recommendations)
  })
  
  output$beerTable <- renderTable({
    return(beerTibble())
  })
  
  output$beerPlot <- renderPlot({
    recommended_beers = beerTibble() %>%
      select(beer_name) %>%
      mutate(recommended = 'TOM')
      
    abv <- input$abv / 100
    ibu <- input$ibu
    
    input_pp = predict(model_pp, tibble(abv = abv, ibu = ibu))
    
    dat_joined = dat_class_unfiltered %>%
      left_join(recommended_beers, by = 'beer_name') %>%
      mutate(recommended = if_else(recommended == 'TOM', beer_name, ''))
      
    p = dat_joined %>%
      ggplot(aes(x = abv, y = ibu, col = Class)) + 
      geom_point() + 
      geom_label(aes(label = recommended)) + 
      geom_point(aes(x = input_pp$abv, y = input_pp$ibu), col = 'black', size = 5)
    return(p)
  })
  
  # output$scatterPlot = renderPlot({
  #   
  #   # Getting the apples-to-apples here...
  #   faithful_pp = preProcess(faithful, method = c('center', 'scale'))
  #   faithful_standardized = predict(faithful_pp, faithful)
  #   
  #   # Accepting input from numeric "waiting" and throwing 0 in (but can be anything, will not affect outcome) 
  #   dat = tibble(waiting = input$waiting, eruptions = 0)
  #   pp_data = predict(model_pp, dat)
  #   
  #   estimate = predict(model_lm, pp_data)
  #   
  #   dat_final = tibble(waiting = pp_data$waiting, eruptions = estimate) %>%
  #     mutate(type = 'predicted')
  #   
  #   dat_plot = faithful_standardized %>%
  #     mutate(type = 'actual') %>%
  #     bind_rows(dat_final)
  #     
  #   dat_plot %>%
  #     ggplot(aes(x = waiting, y = eruptions, col = type)) + 
  #     geom_point(aes(size = type)) #using size solely to show off, not a good idea for a discrete categorical variable
  # })

})
