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
library(catdata)
library(vcd)

source("~/Desktop/AHDS_assessment2_2331122/code/data-prep.R")

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

# create the Shiny app
shinyApp(
  ui = fluidPage(
    # Application title
    titlePanel("BMI Data Analysis"),
    selectInput("x_var", "X Variable", names(BMX_DEMO_new), selected = names(BMX_DEMO_new)[1]),
    selectInput("y_var", "Y Variable", names(BMX_DEMO_new), selected = names(BMX_DEMO_new)[2]),
    plotOutput("plot"),
    tableOutput("summary"),
    actionButton("go", "Calculate Cramer's V"),
    verbatimTextOutput("corr"),
    downloadButton("downloadPlot", "Download Plot")
  ),
  server = function(input, output) {
    output$plot <- renderPlot({
      plot_func(BMX_DEMO_new, input$x_var, input$y_var)
    })
    
    output$summary <- renderTable({
      summary_func(BMX_DEMO_new, input$x_var, input$y_var)
    })
    
    # Create a reactive function to calculate Cramer's 
    
    corr <- reactive({
      chi_sq <- chisq.test(table(BMX_DEMO_new[,input$x_var], BMX_DEMO_new[,input$y_var]))
      sqrt(chi_sq$statistic / (nrow(BMX_DEMO_new) * (min(ncol(BMX_DEMO_new), nrow(BMX_DEMO_new)) - 1)))
    })
    
    observeEvent(input$go, {
    output$corr <- renderText(paste("Cramer's V:", corr()))
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

