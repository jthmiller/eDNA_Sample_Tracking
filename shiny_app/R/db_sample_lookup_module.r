
sample_lookup_ui <- 
    fluidPage(
        fileInput('file', 'Select samples with csv file', accept=c('text/csv','text/comma-separated-values,text/plain','.csv')),
        selectInput('in_dataset', 'Choose Database', c('Filters', 'Lab', 'Sequence')),
        uiOutput('columns1'),
        uiOutput('levels1'),
        checkboxGroupInput("print", "Print", c('QR labels')),
        uiOutput('button'),
        tableOutput('table')
    )


sample_lookup_server <- function(input, output){

    ## col selection in dataset
    output$columns1 = renderUI({
        mydata = get(input$in_dataset)
        selectInput('columns2', 'Columns', names(mydata))
    })
    
    ## levels in col selection
    output$levels1 = renderUI({
        mydata = get(input$in_dataset)
        col <- input$columns2
        work <- levels(mydata[,col])
        selectInput('levels', 'Levels', choices = work) 
    })
    
    output$columns2 = renderUI({
        mydata = get(input$in_dataset)
        selectInput('columns3', 'Columns', names(mydata))
    })
    
    output$levels2 = renderUI({
        mydata = get(input$in_dataset)
        col <- input$columns3
        work <- levels(mydata[,col])
        selectInput('levels2', 'Levels', choices = work) 
    })
    
    
    
    
    
    ## TABLE 1
    out_dataset <- reactive({
        mydata = get(input$in_dataset)
        col <- input$columns2
        selection <- input$levels
        selection <- which( mydata[,col] == selection )
        mydata[selection,]
    })
    output$table1 <- renderTable({ out_dataset() })
    
    
    
    
    ## TABLE 2
    out_dataset2 <- reactive({
        mydata = get(input$in_dataset)
        col <- input$columns2
        selection1 <- input$levels
        selection1 <- which( mydata[,col] == selection1 )
        col <- input$columns3
        selection2 <- input$levels
        selection2 <- which( mydata[,col] == selection2 )
        selection <- intersect(selection1,selection2)
        mydata[selection,]
    })
    output$table2 <- renderTable({ out_dataset2() })
    
    
    
    
    
    
    ## buttons
    output$button = renderUI({
        actionButton("button", "Print sample sheet")
    })

}