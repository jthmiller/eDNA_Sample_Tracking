## Select module
## Edit PCR module 
## Display Module

sample_amplified_ui <- function(id) {

  ns <- NS(id)

    tagList(
        fluidPage(
            fluidRow(
                sample_select(ns("sample_select"))
            ),
            fluidRow(
                #sample_display_module_ui(ns("sample_selected"))
            ),
            fluidRow(
                box( 
                    ### edit PCR module
                    dateInput("Extracted", label = "Extracted:"),
                    dateInput("PCR_Step_1", label = "PCR Step 1:"),
                    dateInput("Qbited", label = "Qbited:"),
                    selectInput('Storage',  label = 'Choose Storage', c('Strip Tubes','PCR Plate')),
                    dateInput("Dil_1_10", label = "Straight DNA Diluted 1:10:"),
                    dateInput("HCGS", label = "Undiluted Step 1 PCR given to Jeff with list of samples:"),
                    dateInput("Sequenced", label = "Sequenced:"),
                    fileInput('gels', label = 'Gel Picture Upload', multiple = T, accept='image/*')
                )
            )    
        ),
        tags$script(src = "sample_table_module.js"),
        tags$script(paste0("sample_table_module_js('", ns(''), "')"))  
    )
}  

sample_amplified_module <- function(input, output, session){ 

  #filters <- conn %>% tbl('filtersdb')

  #print(filters)

  output$x1 = sample_select("sample_table")




  sample_to_disply <- eventReactive(input$sample_select_rows_selected, {
    out <- samples() %>%
      filter(uid == input$sample_id_to_disply) %>%
      as.list()
  })

  ##callModule(
  ##  sample_select_module,
  ##  "sample_select",
  ##  modal_title = "Select sample",
  ##  sample_to_display = sample_to_display,
  ##  modal_trigger = reactive({input$sample_id_to_delete})
  ##)


 