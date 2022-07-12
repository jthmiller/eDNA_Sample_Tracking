### extractions
extractions_page_ui <- function(id) {

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
      column(width = 8,
        actionButton(ns('edit_batch'),"Edit Batch")
      )
    ),
    tags$br(),
    tags$script(src = "sample_table_module.js"),
    tags$script(paste0("Database_js('", ns(''), "')"))
  )
}

extractions_page_server  <- function(id, disp) {


    display_col <- c('tube_label','batch','set_number','project','site1','site2','matrix','type','collected_date','filtered_date','extracted_date', 'cut_in_half')
    edit_col <- c('tube_label','project','site1','site2','matrix','type','collected_date','filtered_date','extracted_date', 'cut_in_half','extracted_initials')
    sample_table_module("extractions_page", display_col, edit_col)

}