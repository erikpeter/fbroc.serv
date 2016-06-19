library(shiny)
library(markdown)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "fbroc 0.3.1"),
  dashboardSidebar( sidebarMenu(
    menuItem("Data & About", tabName = "data", icon = icon("database")),
    menuItem("ROC curve", tabName = "roc", icon = icon("area-chart")),
    menuItem("ROC performance", tabName = "perf", icon = icon("bar-chart")),
    sliderInput("n.boot",
                "Number of bootstrap iterations:",
                min = 500,
                max = 50000,
                round = as.integer(2),
                step = 500,
                ticks = FALSE,
                value = 2000),
    sliderInput("conf.level",
                "Confidence levels:",
                min = 0.8,
                max = 1,
                round = as.integer(-2),
                step = 0.01,
                ticks = FALSE,
                value = 0.95),
    selectInput("which_metric", "Select metric",
                choices = c("none", "AUC", "TPR", "FPR", "Partial AUC"), selected = "none"),
    uiOutput("correct.pauc"),
    uiOutput("partial.AUC.over"),
    uiOutput("metric.param.slider")
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "data",
              h2("Data & About"),
              fluidRow(
                box(title = "Data settings", solidHeader = TRUE,
                    status = "primary", width = 12,
                  checkboxInput("useown", "Upload data", FALSE),
                  conditionalPanel(condition = "input.useown == true",
                                   fileInput("in.file", "Upload tab-delimited file", width = "300px",
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
                box(width = 12,  title = "Instructions", includeMarkdown("info.md"), solidHeader = TRUE,
                    status = "primary"),
                box(width = 12,  title = "About", includeMarkdown("about.md"), solidHeader = TRUE,
                    status = "primary")
                
              )),
      tabItem(tabName = "roc",
              h2("ROC Curve"),
              fluidRow(
                
                #box(width =12,  textOutput("status.msg")),
                infoBoxOutput("status.box"),
                box(width = 5,title = "ROC Curve", solidHeader = TRUE,
                #box(title = "ROC Curve", solidHeader = TRUE,
                    status = "primary",
                    plotOutput("roc.plot", height = "auto"), 
                    uiOutput("metric.text"),
                    uiOutput("show.area"))
                
              )
              ),
      tabItem(tabName = "perf",
              h2("Performance"),
              fluidRow(
                #box(width =12,  textOutput("status.msg2")),
                infoBoxOutput("status.box.perf"),
#                 box(width = 3, title = "Performance Table", solidHeader = TRUE,
#                     status = "primary", height = 200,
#                     tableOutput("perf.table")),
                box(width = 5, title = "Performance", solidHeader = TRUE,
                    status = "primary",
                    tableOutput("perf.table"),plotOutput("perf.plot", height = "auto"))
               
                )
              )
    )
    
  )
)

