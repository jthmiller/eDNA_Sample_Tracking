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
      column(width = 3,
        fluidRow(
          actionButton(ns("edit_batch"),"Edit Batch")
        )
      ),
      column(width = 3,
        fluidRow(
          actionButton(ns("edit_pcr_qbit"),"Enter Qbit Values")
        )
      ),
      column(width = 3,
        fluidRow(
          actionButton(ns("edit_pcr_notes"),"Edit PCR Notes")
        )
      )
    ),
    tags$br(),
    tags$script(src = "sample_table_module.js"),
    tags$script(paste0("Database_js('", ns(''), "')")) 
  )
}

PCR_page_server <- function(id, disp, lines = NA, button) {

      display_col <- c('tube_label','project','site1','site2','matrix','type','collected_date','filtered_date')
      edit_col <- c('tube_label','qbited_date','qbit_conc','cut_in_half_date','PCR_Step_1_date','dil_1_10_date','given_to_HCGS_date','sequenced_date','storage')
      sample_table_module("PCR_page", display_col, edit_col)

}