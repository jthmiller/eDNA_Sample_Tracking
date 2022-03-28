sample_amplified_ui <- 
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
    )

sample_amp_server <- function(input, output){ }