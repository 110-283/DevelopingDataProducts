Linear Regression Averaging
========================================================
author: Anton Sinev
date: 16 March 2018
autosize: true

Problem Description
========================================================

The purpose of the project is to demonstrate ability of the method of linear regression averaging method based on Bayesian Information Criterion (BIC). This method can be consideres as alternatve of traditional variable selection procedure. It selects a set of the model having the lowest BIC and averages their forecasts. The formula used to calculate weight of each forecast can be found [here](https://stats.stackexchange.com/questions/249888/use-bic-or-aic-as-approximation-for-bayesian-model-averaging).

To illustrate the method I chose the famous *mtcars* dataset. I try to predict miles peg gallon (mpg) parameter using the other ones.

To generate the set of the best models I used the *regsubsets* function from [*leaps*](https://cran.r-project.org/web/packages/leaps/leaps.pdf) package.

Application Description
========================================================

In the application you can set up the following parameters:

- Maximal number of variables that can be used by regression models;
- Number of best models used to calculate the final averaged output;
- Variable used as X-axis on the plot. The problem is multvariable, so it is impossible to illustrate the results without any simplifications. So I decided to gove an opportunity to select x-axis variable to illustrate single-factor dependencies. Also I added *loess* functions to make the dependencies more clear;
- In addition to the plot, the application also calculates two performance metrics: [RMSE](https://en.wikipedia.org/wiki/Root-mean-square_deviation)/Mean and [MAE](https://en.wikipedia.org/wiki/Mean_absolute_error)/Mean.

R Code: Regsubsets and Weights Calculation
========================================================


```r
N.Models <- input$N.Models
data("mtcars")
fit <- regsubsets(mpg~., data = mtcars, nbest = input$Max.Vars, nvmax = input$N.Models, method = "exhaustive", intercept = TRUE)
sum.fit <- summary(fit)
logical.Matrix <- data.frame(sum.fit$which[,-1], row.names = 1:nrow(sum.fit$which[,-1]))
bic.Matrix <- data.frame(cbind(logical.Matrix,bic = sum.fit$bic))
bic.Matrix <- bic.Matrix[order(bic.Matrix$bic),]
bic.Matrix <- bic.Matrix[1:N.Models,]
        
weights <- exp(-bic.Matrix$bic/2)
weights <- weights / sum(weights)
```

Plot Example: 3 variables + 2 best models + Weight as X-axis
========================================================

<img src="Course_Project-figure/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" style="display: block; margin: auto;" />
