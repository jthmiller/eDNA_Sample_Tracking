### Species ID database

### database simple

tax_page_ui <- function(id) {

  ns <- NS(id)

  tagList(

    fluidRow(
      column(width = 12,
        title = "Taxa found",
        DTOutput(ns('taxa_select'))
      )
    ),
    fluidRow(
      column(width = 12,
        DTOutput(ns('taxa_selected'))
      )
    ),
    fluidRow(  
      column(width = 3,
        fluidRow(
          actionButton(ns("saveBtn"),"Edit taxa notes")
        )
      ),
    ),
    tags$br()
  )
}

tax_page_server <- function(id, disp, lines = NA, button) {

      tax_module("tax_page")

}