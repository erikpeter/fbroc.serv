library(shiny)
library(markdown)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "fbroc 0.3.1"),
  dashboardSidebar( sidebarMenu(
    menuItem("About", tabName = "about", icon = icon("book")),
    menuItem("Data", tabName = "data", icon = icon("database")),
    menuItem("ROC curve", tabName = "roc", icon = icon("area-chart")),
    menuItem("ROC performance", tabName = "perf", icon = icon("bar-chart")),
    uiOutput("boot.slider"),
    uiOutput("conf.slider"),
    uiOutput("sel.metric"),
    uiOutput("metric.text"), 
    uiOutput("metric.param.slider")
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "about",
              h2("About"),
              fluidRow(box(includeMarkdown("info.md")))
              ),
      tabItem(tabName = "data",
              h2("Data"),
              fluidRow(
                box(
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
                                  uiOutput("select.class")
                )
              )),
      tabItem(tabName = "roc",
              h2("ROC Curve"),
              fluidRow(
                box(width = 6,height = 850, title = "ROC Curve", solidHeader = TRUE,
                    status = "primary",
                    plotOutput("roc.plot"))
              )
              ),
      tabItem(tabName = "perf",
              h2("Performance"),
              fluidRow(
                box(width = 4, height = 700, title = "Performance Histogram", solidHeader = TRUE,
                    status = "primary",
                    plotOutput("perf.plot")),
                box(width = 3, title = "Performance Table", solidHeader = TRUE,
                    status = "info",
                    tableOutput("perf.table"))
                )
              )
    )
    
  )
)

# shinyUI(fluidPage(
# 
#   # Application title
#   titlePanel("fbroc ROC curve analysis"),
# 
#   # Sidebar with a slider input for number of bins
#   sidebarLayout(
#     sidebarPanel(
#       checkboxInput("useown", "Upload data", FALSE),
#       conditionalPanel(condition = "input.useown == true",
#                        fileInput("in.file", "Upload tab-delimited file",
#                                  accept = c(
#                                 'text/csv',
#                                 'text/comma-separated-values',
#                                 'text/tab-separated-values',
#                                 'text/plain',
#                                 '.csv',
#                                 '.tsv'
#                 ))),
#       uiOutput("select.pred"),
#       uiOutput("select.class"),     
#       uiOutput("boot.slider"),
#       uiOutput("conf.slider"), 
#       uiOutput("sel.metric"),
#       uiOutput("metric.text"), 
#       uiOutput("metric.param.slider"),
#                        
#       
#       
#       width = 3)
#       ,
#       
#     # Show a plot of the generated distribution
#     mainPanel(
#       tabsetPanel(
#         tabPanel("General information",
#                  includeMarkdown("info.md")),
#         tabPanel("ROC curve",
#                  textOutput("status.msg"),
#                  plotOutput("roc.plot")
#         ),
#         tabPanel("Performance analysis",
#                  textOutput("status.msg2"),
#                  tableOutput("perf.table"),
#                  plotOutput("perf.plot")                
#         )
#       )
#     )
#   )
# ))
