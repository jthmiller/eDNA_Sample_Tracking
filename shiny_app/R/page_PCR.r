### PCR

### database simple

PCR_page_ui <- function(id) {

  ns <- NS(id)

  tagList(

    fluidRow(
      column(width = 12,
        title = "Samples to add to the database",
        DTOutput(ns('sample_select'))
      )
    ),
    fluidRow(
      column(width = 12,
        DTOutput(ns('sample_selected'))
      )
    ),
    fluidRow(  
      column(width = 6,
        fluidRow(
          actionButton(ns("edit_batch"),"Edit Batch")
        )
      ),
      column(width = 6,
        fluidRow(
          actionButton(ns("edit_pcr_qbit"),"Enter Qbit Values")
        )
      )
    ),
    tags$br(),
    tags$script(src = "sample_table_module.js"),
    tags$script(paste0("Database_js('", ns(''), "')")) 
  )
}

PCR_page_server <- function(id, disp, lines = NA, button) {

      display_col <- c('project','site1','site2','matrix','Type','collected_date','filtered_date')
      
      batch_updates <- c('collected_date', 'extracted_date', 'filtered_date', 'cut_in_half', 'modified_at', 'modified_by')

      sample_table_module("PCR_page", display_col, batch_updates)

}