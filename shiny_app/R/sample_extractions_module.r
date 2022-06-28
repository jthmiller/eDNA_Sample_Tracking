### extractions


sample_extractions_module_ui <- function(id) {
  
  ns <- NS(id)

  tagList(
    
    fluidRow(
      column(
        width = 2,
        actionButton(
          ns("edit_samples"),
          "Edit Samples",
          class = "btn-success",
          style = "color: #fff;",
          width = '100%'
        ),
        tags$br(),
        tags$br()
      )
    ),  
    fluidRow(
      column(
        width = 12,
        title = "Samples",
        DTOutput(ns('table')) %>%
          withSpinner(),
        tags$br(),
        tags$br()
      )
    ),
    fluidRow( 
      actionButton("browser", "browser")
    ),
    
    tags$script("$('#browser').hide();"),
    ##includeScript(path = "sample_table_module.js"),
    tags$script(src = "sample_table_module.js"),
    tags$script(paste0("Database_js('", ns(''), "')"))
  )
}



sample_extractions_module  <- function(id, disp) {


  selectedLines <- reactive({
    req(input$`extractions_module-table_rows_selected`)
    if (is.null(input$`extractions_module-table_rows_selected`)) {
      return(NULL)
    } else {
      rows_selected <- as.numeric(input$`extractions_module-table_rows_selected`) # we need to prefix dt_table_rows_selected with the ID of the UI function "my_ID" and a hyphen
    }
    sample_table_module("extractions_module", disp = display_col_pcr, lines = selectedLines)
  })


    #smps <- reactive({
    #      df <- selectedLines()
    #      return(df)   
    #    })     


    sample_table_module("extractions_module", disp = display_col_pcr, lines = selectedLines)

}