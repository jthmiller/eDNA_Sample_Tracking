### Sample collections page


collections_page_ui <- function(id) {
  
  ns <- NS(id)

  tagList(
    fluidRow(
      column(
        width = 2,
        actionButton(
          ns("add_sample"),
          "Add",
          class = "btn-success",
          style = "color: #fff;",
          icon = icon('plus'),
          width = '100%'
        ),
        tags$br(),
        tags$br()
      )
    ),
    fluidRow(
      column(
        width = 12,
        title = "Samples to add to the database",
        DTOutput(ns('sample_table')) %>%
          withSpinner(),
        tags$br(),
        tags$br()
      )
    ),
    ##includeScript(path = "sample_table_module.js"),
    tags$script(src = "sample_table_module.js"),
    tags$script(paste0("Database_js('", ns(''), "')"))
  )
}

collections_page_server <- function(id) {

      display_col <- c('tube_label','batch','project','site1','site2','matrix','type','collected_date','filtered_date',"created_at", "modified_at")
      edit_col <- c('tube_label','project','site1','site2','matrix','type','collected_date','filtered_date')
      sample_table_module("collections_page", display_col, edit_col)

}