
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

options(shiny.maxRequestSize = 50*1024^2)

shinyServer(function(input, output) {
  
  
  daten <- reactive({
    
    if (is.null(input$in.file))
      return(NULL)
    read.delim(input$in.file)    
  })
  
  output$boot.slider <- renderUI({
    if (is.null(daten())) return(NULL)
    sliderInput("n.boot",
                "Number of bootstrap iterations:",
                min = 100,
                max = 10000,
                round = as.integer(2),
                step = 100,
                ticks = FALSE,
                value = 2000)
   
  })
  
  
  output$distPlot <- renderPlot({

    return(NULL)

  })

})
