
moduleServer <- function(id, module) {
  callModule(module, id)
}

button_ui <- function(id) {
  actionButton(NS(id, "btn"), label = "Go")
}

button_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(input$btn)
  })
}

buildInputs <- function(inputData) {
  inputs <- lapply(inputData, function(args) {
    do.call(sliderInput, args)
  })

  do.call(div, inputs)
}

fmt_dates <- function(X) {

  if (is.null(X)) 'NA' else as.character(as.Date(X))

}

fmt_txt <- function(X){

  if (is.null(X)) { 'NA' } else as.character(X)

}

fmtInputType <- function(X, input){
  if(dbColNames_type[X] == 'dateInput' ){
    fmt_dates(input[[X]])
  } else if (dbColNames_type[X] == 'textInput')
    fmt_txt(input[[X]])
}

InputFunction <- function(display_col, display_col_type, ns) {

  if(display_col_type == 'dateInput'){
    dateInput(ns(display_col), label = display_col)
  } else if (display_col_type == 'textInput') {
    textInput(ns(display_col), label = display_col)
  }
} 

getdb <- function(X){

  conn <- dbConnect(
    RSQLite::SQLite(),
    "/Users/jeffreymiller/Documents/projects/shiny_sample_database/eDNA_Sample_Tracking/shiny_app/data/filtersdb.sqlite3"
  )
  return( tibble(dbGetQuery(conn, paste0('SELECT * FROM filtersdb LIMIT ',X)) ))
}




	##### Callback functions for editDT
	my.insert.callback <- function(data, row) {
		mydata <- rbind(data, mydata)
		return(mydata)
	}

	my.update.callback <- function(data, olddata, row) {
		mydata[row,] <- data[1,]
		return(mydata)
	}

	my.delete.callback <- function(data, row) {
		mydata <- mydata[-row,]
		return(mydata)
	}
