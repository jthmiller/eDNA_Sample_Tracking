
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

fmtInputType <- function(X){
  if(dbColNames_type[X] == 'dateInput' ){
    fmt_dates(input[[X]])
  } else if (dbColNames_type[X] == 'textInput')
    fmt_txt(input[[X]])
}

InputFunction <- function(display_col,display_col_type,ns) {

  if(display_col_type == 'dateInput'){
    dateInput(ns(display_col), label = display_col)
  } else if (display_col_type == 'textInput') {
    textInput(ns(display_col), label = display_col)
  }
} 






