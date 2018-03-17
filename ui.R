library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  titlePanel("Selection and averaging of linear regression models using \"leaps\" package"),
  
  sidebarLayout(
    sidebarPanel(
       sliderInput("Max.Vars",
                   "Maximal number of regression variables:",
                   min = 2,
                   max = 8,
                   value = 4),
       sliderInput("N.Models",
                   "Number of best models:",
                   min = 1,
                   max = 15,
                   value = 5),
       selectInput("x.var","X axis on the plot:",
                   c("Displacement" = "disp",
                     "Gross horsepower" = "hp",
                     "Rear axle ratio" = "drat",
                     "Weight (1000 lbs)" = "wt",
                     "1/4 mile time" = "qsec")
                   )
       
    ),
    
    mainPanel(
       plotOutput("plot"),
       h4("RMSE/Mean"),
       textOutput("RMSE.Mean"),
       h4("MAE/Mean"),
       textOutput("MAE.Mean")
    )
  )
))
