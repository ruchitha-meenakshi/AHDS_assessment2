This Shiny web application enables the user to investigate and visualise the connection between two BMX_DEMO variables. This 
application utilises the data-prep.R script to preprocess the dataset. The user may pick the X and Y variables from a drop-down 
menu, after which the programme will produce a bar chart and a summary table based on the specified data.

The application uses the following R libraries: shiny, ggplot2, dplyr, and fitdistrplus. The plot func function is used to 
construct the bar chart depending on the X and Y variables provided by the user. The summary table of the specified variables is 
generated using the summary_func function.

The programme has a download option that enables the user to save the current plot as a PDF file. The file's name will be x_var_y 
var.pdf.

To launch the programme, click the "Run App" button above. This will open the programme in Rstudio's viewer window.

This application is developed using the Shiny library; further information on developing apps with Shiny can be found at 
http://shiny.rstudio.com.
