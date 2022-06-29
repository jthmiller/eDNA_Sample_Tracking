### extractions
sample_extractions_module_ui <- function(id) {

  ns <- NS(id)

  tagList(

    fluidRow(
      column(
        width = 12,
        title = "Samples to add to the database",
        DTOutput(ns('sample_select'))
      )
    ),
    fluidRow(
      column(
        width = 12,
        DTOutput(ns('sample_selected'))
      )
    ),
    fluidRow(
      column(
        width = 8,
        fluidRow(
          box( 
            title = 'Dates',
            dateInput(inputId = "Collected", label = "Collected:"),
            dateInput(inputId = "Extracted", label = "Extracted:"),
            dateInput(inputId = "Filtered", label = "Filtered:"),
            dateInput(inputId = "Cut_Half", label = "Cut in Half:")
          )
        ),
        fluidRow(
          column(width = 8,
            actionButton("edit_samples","Edit Samples")
          )
        )
      )
    )
  )
}

sample_extractions_module  <- function(id, disp) {


  #selectedLines <- reactive({
  #  req(input$`extractions_module-table_rows_selected`)
  #  if (is.null(input$`extractions_module-table_rows_selected`)) {
  #    return(NULL)
  #  } else {
  #    rows_selected <- as.numeric(input$`extractions_module-table_rows_selected`) # we need to prefix dt_table_rows_selected with the ID of the UI function "my_ID" and a hyphen
  #  }
  #  sample_table_module("extractions_module", disp = display_col_pcr, lines = selectedLines)
  #})
#

    #smps <- reactive({
    #      df <- selectedLines()
    #      return(df)   
    #    })     

    # button <- button_server("mod1")
    sample_table_module("extractions_module", disp = display_col_pcr, lines = selectedLines)
}