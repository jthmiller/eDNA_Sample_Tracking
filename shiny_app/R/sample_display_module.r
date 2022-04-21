### display sample module
sample_display_module_ui <- function(id) {
  
  ns <- NS(id)

  tagList(

    fluidRow(
      column(
        width = 12,
        title = "Select Samples",
        DTOutput(ns('sample_selected')) %>%
          withSpinner(),
        tags$br(),
        tags$br()
      )
    )
  )
}


sample_display_module <- function(input, output, session) {

  test <- callModule(
    sample_select_module,
    "sample_select"
  )

  head(test)


  #head(output$sample_selected)
  #print('and')
  #head(input$sample_select_rows_selected)


  #sample_to_display <- eventReactive(input$sample_id_to_display, {
  #  samples() %>%
  #    filter(uid == input$sample_id_to_display)
  #})

  #callModule(
  #  sample_display_module,
  #  "display_sample",
  #  modal_title = "display sample",
  #  sample_to_display = sample_to_display,
  #  modal_trigger = reactive({input$sample_id_to_display})
  #)

  output$sample_selected <- DT::renderDataTable(
    datatable( data = myCSV()
               , extensions = 'Buttons',
               selection = 'single'
               , options = list( 
                 dom = "Blfrtip"
                 , buttons = 
                   list("copy", list(
                     extend = "collection"
                     , buttons = c("csv", "excel", "pdf")
                     , text = "Download"
                   ) ) # end of buttons customization
                 
                 # customize the length menu
                 , lengthMenu = list( c(10, 20, -1) # declare values
                                      , c(10, 20, "All") # declare titles
                 ) # end of lengthMenu customization
                 , pageLength = 10
               ) # end of options
               
    ) # end of datatables
  )
}  
