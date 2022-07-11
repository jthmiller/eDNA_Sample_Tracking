library(shiny)

ui <- fluidPage(
  actionButton('add', 'Add'),
  div(id = 'placeholder')
)

server <- function(input, output, session) {

  ctn <- reactiveVal(0)

  # Id of each var input
  Id <- reactive({
    function(id){
      paste0(id, ctn())
    }
  })

  observeEvent(input$add, {

    ctn(ctn() + 1)

    insertUI(
      selector = '#placeholder',
      ui = div(
        id = Id()('div'),
        selectInput(Id()('Column'), 'Column:', display_col),
        uiOutput(Id()('input'))
      )
    )

  })

  observeEvent(ctn(), {

    id <- Id()('input')
    selection <- Id()('Column')

    print(selection)

    all_ins <-  list(
            collected_date = dateInput(inputId = ns('collected_date'), label = "Collected:"),
            extracted_date = dateInput(inputId = ns('extracted_date'), label = "Extracted:"),
            filtered_date = dateInput(inputId = ns('filtered_date'), label = "Filtered:"),
            cut_in_half = selectInput(inputId = ns('cut_in_half'), label = 'Cut in half?', c('Yes','No'))
        )
    
    to_ui <- all_ins['collected_date'] 

    output[[id]] <- renderUI({
      req(input[[Id()('Column')]])
      switch(
        display_col_type[input[[selection]]],
        'dateInput' = dateInput(Id()('date'), 'ENTER DATE', ''),
        'textInput' = textInput(Id()('text'), 'ENTER TEXT', '')
      )
    })
  }, ignoreInit = TRUE)

}





    all_ins <-  list(
            collected_date = dateInput(inputId = ns('collected_date'), label = "Collected:"),
            extracted_date = dateInput(inputId = ns('extracted_date'), label = "Extracted:"),
            filtered_date = dateInput(inputId = ns('filtered_date'), label = "Filtered:"),
            cut_in_half = selectInput(inputId = ns('cut_in_half'), label = 'Cut in half?', c('Yes','No'))
        )




        'dateInput' = dateInput(Id()('date'), 'ENTER DATE', ''),
        'textInput' = textInput(Id()('text'), 'ENTER TEXT', '')








names(display_col_type) <- display_col

shinyApp(ui,server)




### 
selectizeInput("filter", label = "Filter",
                 multiple = FALSE








library(shiny)

ui <- fluidPage(
  actionButton('add', 'Add'),
  div(id = 'placeholder')
)

server <- function(input, output, session) {






    output[[display_col]] <- renderUI({
        pmap(vars, InputFunction)
    })
  }, ignoreInit = TRUE)


}