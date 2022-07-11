### New col page


### database simple

add_col_page_ui <- function(id) {

  ns <- NS(id)

  tagList(

    fluidRow(  
      column(width = 6,
        fluidRow(
            textInput(ns("col_nme"), "Column Name"),
            selectInput(ns("dat_type"), "Type of Data", choices = c('TEXT','DECIMAL','DATE')),
            actionButton(ns("add_col"),"Add the Column")
        )
      ),
    ),
    tags$br(),
    tags$script(src = "sample_table_module.js"),
    tags$script(paste0("Database_js('", ns(''), "')")) 
  )
}

add_col_page_server <- function(id, disp, lines = NA, button) {

      ## display_col <- c('project','site1','site2','matrix','Type','collected_date','filtered_date')
      
      ## batch_updates <- c('collected_date', 'extracted_date', 'filtered_date', 'cut_in_half', 'modified_at', 'modified_by')

      sample_table_module("add_col_page")

}