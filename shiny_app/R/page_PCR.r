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
      
      column(width = 6,
        fluidRow(
          box( 
            dateInput("Extracted", label = "Extracted:"),
            dateInput("PCR_Step_1", label = "PCR Step 1:"),
            dateInput("Qbited", label = "Qbited:"),
            selectInput('Storage',  label = 'Choose Storage', c('Strip Tubes','PCR Plate')),
            dateInput("Dil_1_10", label = "Straight DNA Diluted 1:10:"),
            dateInput("HCGS", label = "Undiluted Step 1 PCR given to Jeff with list of samples:"),
            dateInput("Sequenced", label = "Sequenced:"),
            fileInput('gels', label = 'Gel Picture Upload', multiple = T, accept='image/*')
          )
        ),
        fluidRow(
          actionButton(ns('edit_batch'),"Edit Batch")
        )  
      ),


      column(width = 6,
        fluidRow(
          box(   
            textInput('qbit_val', 'Qbit Conc.')
          )
        ),
        fluidRow(
          column(width = 6,
            actionButton("edit_sample","Edit Sample")
          )
        )
      )

    ) 
  )
}


PCR_page_server <- function(id, disp, lines = NA, button) {

      display_col <- c('project','site1','site2','matrix','Type','Collected_Date','Filtered_Date')

      button <- button_server("mod1")

      sample_table_module("PCR_page", display_col)

}