library(shiny)
library(markdown)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "fbroc 0.3.1"),
  dashboardSidebar( sidebarMenu(
    menuItem("Data & About", tabName = "data", icon = icon("database")),
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
      tabItem(tabName = "data",
              h2("Data & About"),
              fluidRow(
                box(title = "Data settings", solidHeader = TRUE,
                    status = "primary",
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
                            
                ),
                box(width = 12,  title = "About", includeMarkdown("info.md"), solidHeader = TRUE,
                    status = "info")
              )),
      tabItem(tabName = "roc",
              h2("ROC Curve"),
              fluidRow(
                box(width =12,  textOutput("status.msg")),
                
                box(width = 6,title = "ROC Curve", solidHeader = TRUE,
                #box(title = "ROC Curve", solidHeader = TRUE,
                    status = "primary",
                    plotOutput("roc.plot", height = "auto"))
              )
              ),
      tabItem(tabName = "perf",
              h2("Performance"),
              fluidRow(
                box(width =12,  textOutput("status.msg2")),
                box(width = 6, title = "Performance Histogram", solidHeader = TRUE,
                    status = "primary",
                    plotOutput("perf.plot", height = "auto")),
                box(width = 4, title = "Performance Table", solidHeader = TRUE,
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
