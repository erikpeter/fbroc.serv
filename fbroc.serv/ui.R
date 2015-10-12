library(shiny)
library(markdown)

shinyUI(fluidPage(

  # Application title
  titlePanel("fbroc ROC curve analysis"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      checkboxInput("useown", "Upload data", FALSE),
      conditionalPanel(condition = "input.useown == true",
                       fileInput("in.file", "Upload tab-delimited file",
                                 accept = c(
                                'text/csv',
                                'text/comma-separated-values',
                                'text/tab-separated-values',
                                'text/plain',
                                '.csv',
                                '.tsv'
                ))),
      uiOutput("select.pred"),
      uiOutput("select.class"),     
      uiOutput("boot.slider"),
      uiOutput("conf.slider"), 
      uiOutput("sel.metric"),
      uiOutput("metric.text"), 
      uiOutput("metric.param.slider"),
                       
      
      
      width = 3)
      ,
      
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("General information",
                 includeMarkdown("info.md")),
        tabPanel("ROC curve",
                 textOutput("status.msg"),
                 plotOutput("roc.plot")
        ),
        tabPanel("Performance analysis",
                 textOutput("status.msg2"),
                 tableOutput("perf.table"),
                 plotOutput("perf.plot")                
        )
      )
    )
  )
))
