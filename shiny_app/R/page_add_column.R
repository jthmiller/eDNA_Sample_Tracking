### New col page


### database simple

add_col_page_ui <- function(id) {

  ns <- NS(id)

  
  tagList(
    tags$br(),
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
    tags$br(),
    fluidRow(  
      column(width = 6,
        fluidRow(
            actionButton(ns("backup_database"),"Backup Database")
        )
      ),
    ),
    tags$script(src = "sample_table_module.js"),
    tags$script(paste0("Database_js('", ns(''), "')")) 
  )
}

add_col_page_server <- function(id) {

      sample_table_module("add_col_page")

}