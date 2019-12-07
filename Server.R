# Server File
# mtcars
# Jordan Woloschuk
# 12/07/2019


## Load libraries

library(shiny)
library(ggplot2)
library(tidyverse)
library(curl)

shinyServer(function(input, output) {
        
        ## load the mt cars data
        
        data(mtcars)
        
        
        ## Basic data modification
        
        mtcars_data <- mtcars # creating a new mtcars dataframe to be modified
        mtcars_data$cyl <- as.factor(mtcars_data$cyl)
        
        mtcars_data$vs <- as.factor(mtcars_data$vs)
        # Set levels for the engine shape (V-shaped or Straight)
        levels(mtcars_data$vs) <- c("V-shaped", "Straight")
        
        mtcars_data$am <- as.factor(mtcars_data$am)
        # Convert 0 = Automatic and 1 = Manual
        levels(mtcars_data$am) <- c("Automatic", "Manual")
        
        mtcars_data$gear <- as.factor(mtcars_data$gear)


        ## create the initial output
        
        output$distPlot <- renderPlot({
                
                # Subset the date based on the factors - cyl, am, vs
                
                mtcars_data_sub <-
                        subset(
                                mtcars_data,
                                cyl == input$cyl &
                                        vs == input$vs &
                                        am == input$am
                        )
                
                # Plot the mtcars_data data and its influence regarding wt and mpg
                
                p <-
                        ggplot(data = mtcars_data_sub, aes(x = wt, y = mpg)) + geom_point()
                p <-
                        p + geom_smooth(method = "lm") + xlab("Weight") + ylab("MPG")
                p <- p + xlim(0, 6) + ylim (0, 40)
                p
        }, height = 700)
        
        # MPG summary
        
        output$summary <- renderPrint({
                mtcars_data_sub <-
                        subset(
                                mtcars_data,
                                cyl == input$cyl &
                                        vs == input$vs &
                                        am == input$am
                        )
                
                summary(mtcars_data_sub$mpg)
        })
        
        # Lnear model
        
        output$predict <- renderPrint({
                mtcars_data_sub <-
                        subset(
                                mtcars_data,
                                cyl == input$cyl &
                                        vs == input$vs &
                                        am == input$am
                        )
                
                fit <- lm(mpg~wt,data=mtcars_data_sub)
                
                unname(predict(fit, data.frame(wt = input$lm)))
        })
        
        # Filter Reset
        
        observeEvent(input$showall, {
                distPlot <<- NULL
                
                output$distPlot <- renderPlot({
                        p <-
                                ggplot(data = mtcars_data, aes(x = wt, y = mpg)) + geom_point()
                        p <-
                                p + geom_smooth(method = "lm") + xlab("Weight") + ylab("MPG")
                        p <- p + xlim(0, 6) + ylim (0, 40)
                        p
                }, height = 700)
                
                # show the mpg summary
                
                output$summary <- renderPrint(summary(mtcars_data$mpg))
                
                # create linear model
                
                output$predict <- renderPrint({
                        
                        fit <- lm(mpg~wt,data=mtcars_data)
                        
                        unname(predict(fit, data.frame(wt = input$lm)))
                })
                
                
        })
        
        # Apply the filter
        
        observeEvent(input$appfil, {
                distPlot <<- NULL
                
                output$distPlot <- renderPlot({
                        # subset the date based on the inputs
                        
                        mtcars_data_sub <-
                                subset(
                                        mtcars_data,
                                        cyl == input$cyl &
                                                vs == input$vs &
                                                am == input$am
                                )
                        
                        # draw the mtcars_data data and its influence regarding wt and mpg
                        p <-
                                ggplot(data = mtcars_data_sub, aes(x = wt, y = mpg)) + geom_point()
                        p <-
                                p + geom_smooth(method = "lm") + xlab("Weight") + ylab("MPG")
                        p <- p + xlim(0, 6) + ylim (0, 40)
                        p
                }, height = 700)
                
                # show the mpg summary
                
                output$summary <- renderPrint({
                        mtcars_data_sub <-
                                subset(
                                        mtcars_data,
                                        cyl == input$cyl &
                                                vs == input$vs &
                                                am == input$am
                                )
                        
                        summary(mtcars_data_sub$mpg)
                })
                
                # Linear model
                
                output$predict <- renderPrint({
                        mtcars_data_sub <-
                                subset(
                                        mtcars_data,
                                        cyl == input$cyl &
                                                vs == input$vs &
                                                am == input$am
                                )
                        
                        fit <- lm(mpg~wt,data=mtcars_data_sub)
                        
                        unname(predict(fit, data.frame(wt = input$lm)))
                })
                
        })
        
})
