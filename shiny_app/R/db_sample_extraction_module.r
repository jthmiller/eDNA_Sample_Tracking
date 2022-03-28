sample_extraction_ui <- 
    fluidRow(
        box( 
            title = 'Dates',
            dateInput(inputId = "Collected", label = "Collected:"),
            dateInput(inputId = "Extracted", label = "Extracted:"),
            dateInput(inputId = "Filtered", label = "Filtered:"),
            dateInput(inputId = "Cut_Half", label = "Cut in Half:")
        )
    )


sample_extraction_server <- function(input, output){ }