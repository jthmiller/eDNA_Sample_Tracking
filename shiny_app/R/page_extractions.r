### extractions
extractions_page_ui <- function(id) {

  ns <- NS(id)

  tagList(

    fluidRow(
      column(
        width = 12,
        title = "Samples to add to the database",
        DTOutput(ns('sample_view'))
      )
    ),
    fluidRow(
      column(
        width = 12,
        DTOutput(ns('sample_selected'))
      )
    ),
    fluidRow(
      column(width = 3,
       fluidRow(
        actionButton(ns('edit_batch'),"Edit Batch")
        )
      ),
      column(width = 3,
        fluidRow(
          actionButton(ns("edit_values"),"Enter Values")
        )
      ),
      column(width = 3,
        fluidRow(
          actionButton(ns("edit_extraction_notes"),"Edit Extraction Notes")
        )
      )
    ),
    tags$br(),
    tags$script(src = "sample_table_module.js"),
    tags$script(paste0("Database_js('", ns(''), "')"))
  )
}

extractions_page_server  <- function(id, disp) {


    display_col <- c('project','site1','site2','collected_date','filtered_date','extracted_date','tube_label','FID','replicate','batch','set_number')
    edit_col <- c('project','site1','site2','tube_label','FID','replicate','batch','set_number','matrix','type','collected_date','filtered_date','extracted_date','cut_in_half','extracted_initials')
    edit_values <- c('tube_label','FID','replicate','matrix','type')
    ## sample_table_module("extractions_page", display_col, edit_col)
    sample_table_module(id, display_col, edit_col, edit_values)
}