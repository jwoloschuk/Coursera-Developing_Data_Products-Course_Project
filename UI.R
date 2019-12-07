# UI File
# mtcars
# Jordan Woloschuk
# 12/07/2019

# Load libraries 

library(shiny)
library(ggplot2)

# load data

data("mtcars")

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

# Define UI for application that draws a histogram
shinyUI(fluidPage(
        # Application title
        titlePanel("Impact and Realtionship between the Weight of a Car and Fuel Economy"),
        
        # Sidebar with a slider input for number of bins
        sidebarLayout(
                sidebarPanel(
                        h4("Car Variables"),
                        
                        selectInput("cyl",
                                    "Number of Cylinders",
                                    (sort(
                                            unique(mtcars_data$cyl), decreasing = T
                                    ))),
                        
                        selectInput("vs",
                                    "Engine Shape",
                                    (sort(
                                            unique(mtcars_data$vs)
                                    ))),
                        
                        selectInput("am",
                                    "Tramsmission Type",
                                    (sort(
                                            unique(mtcars_data$am)
                                    ))),
                        
                        actionButton("showall",
                                     "Show All Data"),
                        
                        actionButton("appfil",
                                     "Apply Selected Filters"),
                        
                        h4("MPG Summary"),
                        
                        verbatimTextOutput("summary"),
                        
                        sliderInput(
                                "lm",
                                "Weight (1,000 lbs)",
                                min = min(mtcars_data$wt),
                                max = max(mtcars_data$wt),
                                value = median(mtcars_data$wt),
                                step = 0.1
                        ),
                        
                        h4("Estimated MPG based on Select Weight and Configuration"),
                        
                        verbatimTextOutput("predict"),
                        
                        width = 4
                ),
                
                # Show a plot of the weight/mpg relationship
                
                mainPanel(tabsetPanel(
                        tabPanel("Plot", plotOutput("distPlot")),
                        
                        tabPanel(
                                "Documentation and How To",
                                br(),
                                
                                helpText(
                                        "This Shiny app enables you to display 
                                        various subsets of the mtcars data set 
                                        (included in the ggplot2 R-package) and 
                                        check determine the realtionship between
                                        various car factors on the weight and 
                                        fuel econmony (MPG) relationship."
                                ),
                                
                                br(),
                                
                                helpText(
                                        "A simple linear model is developed based 
                                        on the selected car characteristics and 
                                        fuel economy estimation is determined by
                                        selecting and modifiying the filter 
                                        settings and selecting a car weight."
                                ),
                                
                                br(),
                                
                                
                                helpText(
                                        "To remove the filter, press the button 
                                        Show All Data.To apply the desired filter,
                                        press Apply Selected Filters. 
                                        By default, filtermode is active."
                                ),
                                
                                br(),
                                
                                helpText(
                                        "A MPG summary is displayed and the fuel
                                        economy can be predicted by filtering the
                                        data and choosing a car weight.Simply 
                                        choose the number of engine cyclinders, 
                                        engine shape, transmission type and car 
                                        weight and a fuel economy value is estimated."
                                )),
                        
                        tabPanel(
                                "Data Description and Source",
                                
                                br(),
                                
                                helpText("The data was extracted from the 1974 
                                         Motor Trend US magazine, and comprises 
                                         fuel consumption and 10 aspects of 
                                         automobile design and performance for 
                                         32 automobiles (1973-74 models)."),
                                
                                br(),
                                
                                helpText("More information on this dataset is 
                                         available here:"),
                                
                                br(),
                                
                                tags$a(
                                        "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html",
                                        href = "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html"
                                )
                        )
                        
                ))
        )
))