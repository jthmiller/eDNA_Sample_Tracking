### PCR

### database simple

sample_PCR_module_ui <- function(id) {

  ns <- NS(id)

  tagList(

    fluidRow(
        width = 12,
        title = "Samples to add to the database",
        DTOutput(ns('sample_select'))
    ),
    fluidRow(

        width = 12,
        DTOutput(ns('sample_selected'))

    ),
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
        actionButton("edit_samples","Edit Samples")
    )
  )
}


sample_PCR_module <- function(id, disp) {

  sample_table_module("PCR_module", disp = display_col_pcr)
  
}