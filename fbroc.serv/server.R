
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(fbroc)

options(shiny.maxRequestSize = 50*1024^2)

shinyServer(function(input, output) {
  
  
  daten <- reactive({    
    if (is.null(input$in.file))
      return(NULL)
    read.delim(input$in.file$datapath)    
  })
  
  
  valid.pred <- reactive({
    if (is.null(daten())) return(NULL)
    if (is.null(input$pred.col)) return(NULL)
    
    if (class(daten()[, input$pred.col]) == "numeric") return(TRUE) 
      else return(FALSE)
  })
  
  valid.class <- reactive({
    if (is.null(daten())) return(NULL)
    if (is.null(input$class.col)) return(NULL)
    
    if (class(daten()[, input$class.col]) == "logical") return(TRUE) 
    else return(FALSE)
  })
  
  index.na <- reactive({
    if (is.null(valid.pred())) return(NULL)
    if (is.null(valid.class())) return(NULL)
    if (!(valid.class() & valid.pred())) return(NULL)
    index.na <- is.na(daten()[, input$class.col]) | 
                is.na(daten()[, input$pred.col])
    return(index.na)

  })
  
  roc.obj <- reactive({
    if (is.null(daten())) return(NULL)
    if (is.null(na.free.data())) return(NULL)
    if (is.null(input$n.boot)) return(NULL)
    if (is.null(input$which.metric)) return(NULL)
    daten <- na.free.data()
    
    boot.roc(daten[, input$pred.col], daten[, input$class.col], 
             n.boot = input$n.boot)    
  })
  
  na.free.data <- reactive({
    if (is.null(index.na())) return(NULL)
    return(daten()[!index.na(), ])
  })
  
  output$roc.plot <- renderPlot({
    ro <- roc.obj()
    if (is.null(ro)) return(NULL)
    metric <- NULL 
    if (input$which.metric == "AUC") metric <- "auc"
    plot(ro, conf.level = input$conf.level, show.metric = metric)
  }, height = 800, width = 800)
  
  class.n <- reactive({
    if (is.null(na.free.data())) return(NULL)
    pos <- sum(na.free.data()[, input$class.col])
    neg <- sum(!na.free.data()[, input$class.col])
    return(c(pos, neg))
  })
  
  output$status.msg <- renderText({
    if (is.null(daten())) return("Please load a dataset")
    if (is.null(input$pred.col)) return("Please select prediction column")
    if (is.null(input$class.col)) return("Please select class column")    
    if (!valid.pred()) return("Prediction column must be numeric")
    if (!valid.class()) return("Class column must be logical")
    if (any(class.n() == 0)) return("Positive or negative class is empty")
    msg <- paste("Data loaded and", class.n()[1],"positive and", class.n()[2],
                 "negative samples found.")    
  })
  
  output$select.class <- renderUI({
    if (is.null(daten())) return(NULL)
    selectInput("class.col", "Select class column",
                choices = names(daten()))
  })
  
  output$select.pred <- renderUI({
    if (is.null(daten())) return(NULL)
    selectInput("pred.col", "Select prediction column",
                choices = names(daten()))
  })
  
  output$boot.slider <- renderUI({
    if (is.null(daten())) return(NULL)
    if (is.null(class.n())) return(NULL)
    sliderInput("n.boot",
                "Number of bootstrap iterations:",
                min = 100,
                max = 10000,
                round = as.integer(2),
                step = 100,
                ticks = FALSE,
                value = 2000)
   
  })
  
  output$conf.slider <- renderUI({
    if (is.null(daten())) return(NULL)
    if (is.null(class.n())) return(NULL)
    sliderInput("conf.level",
                "Confidence levels:",
                min = 0.8,
                max = 1,
                round = as.integer(-2),
                step = 0.01,
                ticks = FALSE,
                value = 0.95)
    
  })
  
  output$sel.metric <- renderUI({
    if (is.null(daten())) return(NULL)
    if (is.null(class.n())) return(NULL)
    selectInput("which.metric", "Select metric",
                choices = c("none", "AUC"), selected = "none")
  })
  
  output$metric.text <- renderUI({
    return(NULL)
    if (is.null(daten())) return(NULL)
    if (is.null(class.n())) return(NULL)
    checkboxInput("metric.text", "Display metric in plot",
                  value = FALSE)
  })

})
