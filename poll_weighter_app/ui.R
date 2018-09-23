#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

source("scripts/get_data.R")

pollsters <- c(unique(dta_flat$provider), "All")


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Poll Explorer"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       selectInput(inputId = "pollster", 
          label = "Select pollster",
          choices = pollsters, 
          selected = "All", 
          multiple = TRUE
          ),
       checkboxInput(inputId = "add_gam",
                     label = "Check to add smoother",
                     value = FALSE
       )
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotlyOutput("pollplot"),
       verbatimTextOutput("rawhover"),
       verbatimTextOutput("rawclick")
    )
  )
))
