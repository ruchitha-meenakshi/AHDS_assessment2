#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)
library(ggplot2)
library(dplyr)
library(fitdistrplus)
library(gtools)

source("/Users/ruchithau/Desktop/AHDS_assessment2_2331122/code/data-prep.R")

# create a function to generate the plot based on user inputs
plot_func <- function(BMX_DEMO_new, x_var, y_var) {
  ggplot(BMX_DEMO_new, aes_string(x = x_var, fill = y_var, group = y_var, na.rm = TRUE)) +
    geom_bar(position = "dodge") +
    theme_classic() +
    xlab(x_var) +
    ylab("count") +
    ggtitle(paste(x_var, "by", y_var))
}

# create a function to generate the summary statistics based on user inputs
summary_func <- function(BMX_DEMO_new, x_var, y_var) {
  BMX_DEMO_new %>%
    group_by(!!rlang::sym(x_var)) %>%
    group_by(!!rlang::sym(y_var)) %>%
    summarize(count = n())
}

#Create a function to perform the chi-squared test of independence
  test_func <- function(BMX_DEMO_new, x_var, y_var) {
  BMX_DEMO_new_subset <- na.omit(BMX_DEMO_new[ , c(x_var, y_var)])
  if(nrow(BMX_DEMO_new_subset)<5){
   return("Not enough data to perform the test")
  }
  # convert columns to factors
  BMX_DEMO_new_subset[, x_var] <- as.factor(BMX_DEMO_new_subset[, x_var])
  BMX_DEMO_new_subset[, y_var] <- as.factor(BMX_DEMO_new_subset[, y_var])
  
  # perform the chi-squared test of independence
  chisq_test_result <- chisq.test(BMX_DEMO_new_subset[,x_var], BMX_DEMO_new_subset[,y_var], simulate.p.value = TRUE)
  
  # print the test result
  print(chisq_test_result)
}

# create the Shiny app
shinyApp(
  ui = fluidPage(
    # Application title
    titlePanel("BMI Data Analysis"),
    selectInput("x_var", "X Variable", names(BMX_DEMO_new), selected = names(BMX_DEMO_new)[1]),
    selectInput("y_var", "Y Variable", names(BMX_DEMO_new), selected = names(BMX_DEMO_new)[2]),
    plotOutput("plot"),
    tableOutput("summary"),
    verbatimTextOutput("chisq_test_result"),
    downloadButton("downloadPlot", "Download Plot")
  ),
  server = function(input, output) {
    output$plot <- renderPlot({
      plot_func(BMX_DEMO_new, input$x_var, input$y_var)
    })
    
    output$summary <- renderTable({
      summary_func(BMX_DEMO_new, input$x_var, input$y_var)
    })
    
    output$chisq_test_result <- renderPrint({
      test_func(BMX_DEMO_new, input$x_var, input$y_var)
    })
    
    output$downloadPlot <- downloadHandler(
      filename = function() {
        paste(input$x_var, input$y_var, ".pdf", sep = "_")
      },
      content = function(file) {
        ggsave(file, plot = last_plot(), device = "pdf")
      }
    )
  }
)
