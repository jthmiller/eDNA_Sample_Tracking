### Species ID database

### database simple

sites_page_ui <- function(id) {

  ns <- NS(id)

  tagList(

    fluidRow(
      column(width = 10,
        title = "Site Info",
        DTOutput(ns('sites'))
      )
    ),
    tags$br()
  )
}

sites_page_server <- function(id) {

  moduleServer(
    id,
    function(input, output, session){

        output$sites <- DT::renderDT({ datatable(sites) })
    })

}