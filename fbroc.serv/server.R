
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(devtools)
library(fbroc)

options(shiny.maxRequestSize = 50*1024^2)

shinyServer(function(input, output, session) {
  
  
  daten <- reactive({    
    if (input$useown == FALSE) {
      data(roc.examples)
      return(roc.examples)
    }
    if (is.null(input$in.file))
      return(NULL)
    read.delim(input$in.file$datapath)    
  })
  
  
  valid.pred <- reactive({
    if (!input$useown) return(TRUE)
    if (is.null(daten())) return(NULL)
    if (is.null(input$pred.col)) return(NULL)
    
    if (class(daten()[, input$pred.col]) %in% c("numeric", "integer")) return(TRUE) 
      else return(FALSE)
  })
  
  valid.class <- reactive({
    if (!input$useown) return(TRUE)
    if (is.null(daten())) return(NULL)
    if (is.null(input$class.col)) return(NULL)
    
    if (class(daten()[, input$class.col]) == "logical") return(TRUE) 
    else return(FALSE)
  })
  
  index.na <- reactive({
    if (!input$useown) return(rep(FALSE, length(daten()$True.Class)))
    if (is.null(valid.pred())) return(NULL)
    if (is.null(valid.class())) return(NULL)
    if (!(valid.class() & valid.pred())) return(NULL)
    index.na <- is.na(daten()[, input$class.col]) | 
                is.na(daten()[, input$pred.col])
    return(index.na)

  })
  
  prediction.col <- reactive({
    if (!input$useown) {
      if (input$pred.col == "Continuous predictor") return("Cont.Pred")
      if (input$pred.col == "Continuous with outlier") return("Cont.Pred.Outlier")   
      if (input$pred.col == "Discrete predictor") return("Disc.Pred")
      if (input$pred.col == "Discrete with outlier") return("Disc.Pred.Outlier")
    } else {
        if (is.null(daten())) return(NULL)
        return(input$pred.col)
    }
  })
  
  prediction <- reactive({
    if (is.null(daten())) return(NULL)
    if (is.null(prediction.col())) return(NULL)
    return(na.free.data()[, prediction.col()])
  })
  
  roc.obj <- reactive({
    if (is.null(daten())) return(NULL)
    if (is.null(na.free.data())) return(NULL)
    if (is.null(input$n.boot)) return(NULL)
    if (is.null(isolate(input$which_metric))) return(NULL)
    daten <- na.free.data()
    if (input$useown) pc <- input$class.col else pc <- "True.Class"
    boot.roc(prediction(), daten[, pc], use.cache = TRUE,
             n.boot = input$n.boot)    
  })
  
  na.free.data <- reactive({
    if (is.null(index.na())) return(NULL)
    return(daten()[!index.na(), ])
  })
  
  perf.obj <- reactive({
    ro <- roc.obj()
    if (is.null(ro)) return(NULL)
    if (is.null(input$which_metric)) return(NULL)
    if (input$which_metric == "none") return(NULL)
    metric <- tolower(input$which_metric)
    call.param <- list(roc = ro, metric = metric, conf.level = input$conf.level)
    if (metric == "fpr") {
      if (is.null(input$metric.param)) return(NULL)
      call.param <- c(call.param, list(tpr = as.numeric(input$metric.param)))
    }
    if (metric == "tpr") {
      if (is.null(input$metric.param)) return(NULL)
      call.param <- c(call.param, list(fpr = as.numeric(input$metric.param)))
    }
    perf.obj <- do.call(perf, call.param)
    return(perf.obj)
  })
  
  output$perf.plot <- renderPlot({
    if (is.null(perf.obj())) return(NULL)
    plot(perf.obj())
  }, height = function() {session$clientData$output_perf.plot_width})
  
  output$perf.table <- renderTable({
    if (is.null(perf.obj())) return(NULL)
    p.o <- perf.obj()
    output <- data.frame(input$which_metric,
                         input$n.boot,
                         p.o$Observed.Performance,
                         sd(p.o$boot.results),
                         p.o$CI.Performance[1],
                         p.o$CI.Performance[2])
    ci.lev <- round(100* p.o$conf.level , 0)
    ci.labels <- paste(ci.lev, "% CI ", c("lower", "upper"), sep = "")
    names(output) <- c("Metric", "N.Boot", "Est.", "SE", ci.labels)
    print(output)
    return(output)    
  }, include.rownames=FALSE)
  

  
  output$roc.plot <- renderPlot({
    if (is.null(roc.obj())) return(NULL)
    ro <- roc.obj()
    
  
    metric <- tolower(input$which_metric)  
    metric2 <- metric
    if (is.null(input$which_metric)) metric2 <- NULL
    else {
      metric <- tolower(input$which_metric)  
      metric2 <- metric
      if (metric2 == "none") metric2 <- NULL
    }
   
    call.param <- list(x = ro, conf.level = input$conf.level, show.metric = metric2)
    
    if (metric == "fpr") {
      if (is.null(input$metric.param)) return(NULL)
      call.param <- c(call.param, list(tpr = as.numeric(input$metric.param)))
    }
    if (metric == "tpr") {
      if (is.null(input$metric.param)) return(NULL)
      call.param <- c(call.param, list(fpr = as.numeric(input$metric.param)))
    }

    graph <- do.call(plot, call.param)
    
  },  height = function() {session$clientData$output_roc.plot_width})
  
  
  class.n <- reactive({
    
    if (!input$useown) return(c(sum(daten()$True.Class), sum(!daten()$True.Class)))
    if (is.null(na.free.data())) return(NULL)
    pos <- sum(na.free.data()[, input$class.col])
    neg <- sum(!na.free.data()[, input$class.col])
    return(c(pos, neg))
  })
  

  
  status.message <- reactive({
   
    if (is.null(input$pred.col)) return("Setup data first")
    if (is.null(input$class.col) & input$useown) return("Setup data first")
    if (!valid.pred()) return("Prediction column must be numeric")
    if (!valid.class()) return("Class column must be logical")
    if (any(class.n() == 0)) return("Positive or negative class is empty")
    msg <- paste("Data loaded and", class.n()[1],"positive and", class.n()[2],
                 "negative samples found.")    
  })
  output$status.msg <- renderText(status.message())
  output$status.msg2 <- renderText(status.message())
  
  output$select.class <- renderUI({
    if (is.null(daten())) return(NULL)
    if (!input$useown) return(NULL)
    selectInput("class.col", "Select class column",
                choices = names(daten()), width = "300px")
  })
  
  output$status.box <- renderInfoBox({
    if (substr(status.message(),1,4) != "Data") {
      out <- infoBox("Not ready", status.message(), icon = icon("warning"), color = "orange")
    }
    else {
      n.pos <- class.n()[1]
      n.neg <- class.n()[2]
      msg <- paste(n.pos, "positive and", n.neg, "negative samples")
      out <- infoBox("Data loaded", msg, icon = icon("check"), color = "green")
    }
    print(str(out))
    return(out)
  }) 
  
  output$status.box.perf <- renderInfoBox({
    if (substr(status.message(),1,4) != "Data") {
      out <- infoBox("Not ready", status.message(), icon = icon("warning"), color = "orange")
    }
    else {
      if (input$which_metric == "none") {
        msg <- paste("Select a metric")
        out <- infoBox("Data loaded", msg, icon = icon("cog"), color = "yellow")
      }
      else {
        n.pos <- class.n()[1]
        n.neg <- class.n()[2]
        msg <- paste(n.pos, "positive and", n.neg, "negative samples")
        out <- infoBox("Data loaded", msg, icon = icon("check"), color = "green")
      }
    }
    print(str(out))
    return(out)
  }) 
  
  output$select.pred <- renderUI({
    if (is.null(daten())) return(NULL)
    if (!input$useown) {
      selectInput("pred.col", "Select prediction column",
                  choices = c("Continuous predictor", "Continuous with outlier",
                              "Discrete predictor", "Discrete with outlier"),
                  selected = "Continuous predictor", width = "300px")  
    } else {
    selectInput("pred.col", "Select prediction column",
                choices = names(daten()), width = "300px")
    }
  })
  
  output$metric.param.slider <- renderUI({
    if (is.null(daten())) return(NULL)
    if (is.null(input$which_metric)) return(NULL)
    if (input$which_metric %in% c("none", "AUC")) return(NULL)
    if (input$which_metric == "TPR") text = "Fix FPR"
    if (input$which_metric == "FPR") text = "Fix TPR"
    sliderInput("metric.param",
                text,
                min = 0,
                max = 1,
                round = as.integer(-2),
                step = 0.01,
                ticks = FALSE,
                value = 0.5)
  })
  
  output$metric.text <- renderUI({
    if (is.null(daten())) return(NULL)
    if (is.null(class.n())) return(NULL)
    checkboxInput("metric.text", "Display metric in plot",
                  value = FALSE)
  })

})
