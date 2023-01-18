data-prep:
	Rscript code/data-prep.R

run-shiny-app: data-prep 
	Rscript code/run-shiny-app.R
