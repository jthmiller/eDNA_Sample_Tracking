### PCR

### database simple

sample_PCR_module_ui <- function(id) {

  ns <- NS(id)

  tagList(
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
    ##includeScript(path = "sample_table_module.js"),
    tags$script(src = "sample_table_module.js"),
    tags$script(paste0("Database_js('", ns(''), "')"))
  )
}


sample_PCR_module <- function(id, disp) {

  sample_table_module("PCR_module", disp = display_col_pcr)

  
}

