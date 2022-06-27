




#sample_table_module_ui("sample_table")





sample_collection_ui <- function(id) {
  
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
    tags$script(paste0("sample_table_module_js('", ns(''), "')"))
  )
}










sample_collection_server <- function(input, output, session) {




  sample_to_disply <- eventReactive(input$sample_id_to_disply, {
    out <- samples() %>%
      filter(uid == input$sample_id_to_disply) %>%
      as.list()
  })

  #callModule(
  #  sample_select_module,
  #  "sample_select",
  #  modal_title = "Select sample",
  #  sample_to_display = sample_to_display,
  #  modal_trigger = reactive({input$sample_id_to_delete})
  #)