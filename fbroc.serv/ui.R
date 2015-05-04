
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("fbroc ROC curve analysis"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      fileInput("in.file", "Upload tab-delimited file",
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv'
                )),
      uiOutput("select.pred"),
      uiOutput("select.class"),     
      uiOutput("boot.slider"),
      uiOutput("conf.slider"), 
      uiOutput("sel.metric"),
      uiOutput("metric.text"), width = 3)
      ,
      
    # Show a plot of the generated distribution
    mainPanel(
      textOutput("status.msg"),
      plotOutput("roc.plot")
    )
  )
))
