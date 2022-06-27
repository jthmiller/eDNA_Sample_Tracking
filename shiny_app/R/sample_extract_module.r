### extractions module



#' Sample Select Module UI
sample_extraction_ui <- function(id) {
  
    ns <- NS(id)

    tagList(
        fluidRow(
            textOutput("text")
        ),
        fluidRow(
            box( 
              title = 'Dates',
              dateInput(inputId = "Collected", label = "Collected:"),
              dateInput(inputId = "Extracted", label = "Extracted:"),
              dateInput(inputId = "Filtered", label = "Filtered:"),
              dateInput(inputId = "Cut_Half", label = "Cut in Half:")
            )
        ) 
    )

}



sample_extraction_module <- function(input, output, session){


      output$text <- renderText({ "You have selected this"})
 }