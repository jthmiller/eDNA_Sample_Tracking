 
sample_collection_ui <- fluidRow(
                    box( 
                        selectInput('project', 'Choose Project', c('NERRs', 'Other')),
                        uiOutput('site1'),
                        uiOutput('site2'),
                        ## selectInput('site2', 'Choose NERR', unique(sites$site2)),
                        ## textInput('site_sample', 'Sample Site'),
                        dateInput("date_collected", "Date collected"),
                        selectInput('matrix', 'Choose matrix', c('sediment','water')),
                        selectInput('rep', 'Choose Replicate', c(1:5)),
                        selectInput('blank', 'Choose Sample type', c('Sample','Trip Blank', 'Filter Blank', 'Lab Blank','Extraction Blank','PCR Blank')),
                        uiOutput('add_sample')
                        ##checkboxGroupInput("data-sheet", "Print", c('qrcodes')),
                    ),
                    box(
                        uiOutput('collection_qr')
                    ),
                    box(
                        tableOutput('col_table')
                    ),
                    box(
                        plotOutput("qr_plot")
                    ),
                    box(
                        ## fluidPage(DTOutput('current_tbl'))
                    )
                )
            


sample_collection_server <- function(input, output){

    output$collection_qr = renderUI({
        actionButton("collection_qr", "Print QR Codes")
    })

    output$add_sample = renderUI({
        actionButton("add_sample", "Add Sample")
    })

    to_add <- reactive({
        df <- data.frame(
            project = input$project, 
            site = input$site, 
            sample_site = input$site_sample, 
            date = input$date_collected, 
            matrix = input$matrix, 
            replicate = input$rep, 
            newname = NA, FID = NA)
    })

    ## output$date <- renderPrint({ input$date })

    output$col_table <- renderTable({ to_add() })

    output$qr_plot <- renderPlot({ 
        input$collection_qr
        qr_code("C2iw052721a,aquaculture,Piscataqua,1")
    })

    ### bind together samples to add to field database
    output$current_tbl = renderDT(
      to_add, options = list(lengthChange = FALSE)
    )    


    ## col selection in dataset
    output$site1 = renderUI({
        ## mydata = get(input$sites)
        selectInput('sel_site', 'Choose NERR', unique(sites$site))
    })

    ## 
    output$site2 = renderUI({

        
        selection <- as.character(input$sel_site)
        ind <- which( sites$site == selection )
        site_out <- levels(sites[ind, 'site2'])
        ## selectInput('site2', 'Site 2', choices = site_out)

        selectInput('sel_site2', 'Choose Sample Site', site_out)

    })
}
#######################################
