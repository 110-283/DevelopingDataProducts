library(shiny)

shinyServer(function(input, output) {
    
    library(leaps)
    library(ggplot2)
    library(reshape2)
    library(Metrics)
    
    Results <- reactive({
        N.Models <- input$N.Models
        data("mtcars")
        fit <- regsubsets(mpg~., data = mtcars, nbest = input$Max.Vars, nvmax = input$N.Models, 
                          method = "exhaustive", intercept = TRUE)
        sum.fit <- summary(fit)
        logical.Matrix <- data.frame(sum.fit$which[,-1], row.names = 1:nrow(sum.fit$which[,-1]))
        bic.Matrix <- data.frame(cbind(logical.Matrix,bic = sum.fit$bic))
        bic.Matrix <- bic.Matrix[order(bic.Matrix$bic),]
        bic.Matrix <- bic.Matrix[1:N.Models,]
        
        weights <- exp(-bic.Matrix$bic/2)
        weights <- weights / sum(weights)
        
        result <- numeric(length = nrow(mtcars))
        
        for (i in 1:N.Models){
            reg.Data <- mtcars[,as.logical(cbind(TRUE,bic.Matrix[i,-ncol(bic.Matrix)]))]
            reg.Model <- lm (mpg~., data = reg.Data)
            result <- result + reg.Model$fitted.values * weights[i]
        }
        
        Final.Data <- cbind(mtcars, mpg.fitted = result)
        Final.Data.Melt <- melt(Final.Data, id.vars = input$x.var, measure.vars = c("mpg","mpg.fitted"), 
                                value.name = "mpg")
        
        p = ggplot(data = Final.Data.Melt, aes_string(x = input$x.var,y = "mpg", color = "variable")) + 
            geom_point() + geom_smooth(method = "loess")
        
        RMSE.Mean <- rmse(Final.Data$mpg, Final.Data$mpg.fitted)/mean(Final.Data$mpg)
        MAE.Mean <- mae(Final.Data$mpg, Final.Data$mpg.fitted)/mean(Final.Data$mpg)
        
        Results.List <- list("plot" = p, "RMSE" = RMSE.Mean, "MAE" = MAE.Mean)
    })
   
  output$plot <- renderPlot({
      Results()$plot
  })
  
  output$RMSE.Mean <- renderText({
      as.character(Results()$RMSE)
  })
  
  output$MAE.Mean <- renderText({
      as.character(Results()$MAE)
  })
  
})
