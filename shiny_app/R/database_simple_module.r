### database simple

sample_table_module_ui <- function(id) {
  
  ns <- NS(id)

  tagList(
    fluidRow(
      column(
        width = 2,
        actionButton(
          ns("add_sample"),
          "Add",
          class = "btn-success",
          style = "color: #fff;",
          icon = icon('plus'),
          width = '100%'
        ),
        tags$br(),
        tags$br()
      )
    ),
    fluidRow(
      column(
        width = 12,
        title = "Samples to add to the database",
        DTOutput(ns('sample_table')) %>%
          withSpinner(),
        tags$br(),
        tags$br()
      )
    ),
    fluidRow(
      column(
        width = 12,
        title = "Samples",
        DTOutput(ns('table')) %>%
          withSpinner(),
        tags$br(),
        tags$br()
      )
    ),
    ##includeScript(path = "sample_table_module.js"),
    tags$script(src = "sample_table_module.js"),
    tags$script(paste0("Database_js('", ns(''), "')"))
  )
}






#' Sample Table Module Server
#'
#' The Server portion of the module for displaying the sample datatable
#'
#' @importFrom shiny reactive reactiveVal observeEvent req callModule eventReactive
#' @importFrom DT renderDT datatable replaceData dataTableProxy
#' @importFrom dplyr tbl collect mutate arrange select filter pull
#' @importFrom purrr map_chr
#' @importFrom tibble tibble
#'
#' @param None
#'
#' @return None ()


## output a df, inport df() in other functions
## use df() inside server (bc values are reactive)
## , display_col_pcr , display_col_pcr
sample_table_module <- function(id, disp, lines = NA) {

### sample_table_module <- function(id, disp) {
  ## print(disp)
  # trigger to reload data from the "samples" table
  
  moduleServer(
    id,
    function(input, output, session){

      ## print('made it inside moduleServer')

      session$userData$samples_trigger <- reactiveVal(0)
      #sample_table_module <- function(input, output, session, display_col_pcr){
      # Read in table from the database

      ## initialize from database
      samples <- reactive({

        session$userData$samples_trigger()

        out <- NULL
        tryCatch({
          out <- conn %>%
            tbl('filtersdb') %>%
            collect() %>%
            mutate(
              created_at = as.POSIXct(created_at, tz = "UTC"),
              modified_at = as.POSIXct(modified_at, tz = "UTC")
            ) %>%
            arrange(desc(modified_at))
        }, error = function(err) {
          msg <- "Database Connection Error"
          # print `msg` so that we can find it in the logs
          print(msg)
          # print the actual error to log it
          print(error)
          # show error `msg` to user.  User can then tell us about error and we can
          # quickly identify where it cam from based on the value in `msg`
          showToast("error", msg)
        })
        out
      })

      ## first run set null
      sample_table_prep <- reactiveVal(NULL)

      ## react to samples() edit
      observeEvent(samples(), {
        out <- samples()
        ids <- out$uid
        actions <- purrr::map_chr(ids, function(id_) {
          paste0(
            '<div class="btn-group" style="width: 75px;" role="group" aria-label="Basic example">
              <button class="btn btn-primary btn-sm edit_btn" data-toggle="tooltip" data-placement="top" title="Edit" id = ', id_, ' style="margin: 0"><i class="fa fa-pencil-square-o"></i></button>
              <button class="btn btn-danger btn-sm delete_btn" data-toggle="tooltip" data-placement="top" title="Delete" id = ', id_, ' style="margin: 0"><i class="fa fa-trash-o"></i></button>
            </div>'
          )
        })
        # Remove the `uid` column. We don't want to show this column to the user
        out <- out %>%
            #select(-c(uid,created_at,created_by,modified_at,modified_by))
            select(-uid)
            # Set the Action Buttons row to the first column of the `samples` table
        out <- cbind(
            tibble(" " = actions),
            out
        )
        if (is.null(sample_table_prep())) {
            # loading data into the table for the first time, so we render the entire table
            # rather than using a DT proxy
            # set prep to out
            sample_table_prep(out)
            output$table <- renderDT({  
              out <- sample_table_prep()
              out <- out[,-1]
              datatable(out)
            })
        } else {
            # table has already rendered, so use DT proxy to update the data in the
            # table without rerendering the entire table
            replaceData(sample_table_proxy, out, resetPaging = FALSE, rownames = FALSE)
            output$table <- renderDT({  
              out <- out[,-1]
              datatable(out)
            })
        }
      }) 
    
      ## export data to other modules

      ## THIS WORKS
      #return( 
      #  reactive({
      #    df <- sample_table_prep()
      #    return(df)   
      #  })
      #)     


      ##return(
      ##  list(
      ##    sample_table_prep = reactive({ sample_table_prep() }),
      ##    samples = reactive({ samples() }),
      ##    sample_table_proxy = reactive({ sample_table_proxy() })
      ##  )
      ##)
        
        ## Lookup table
      ##observeEvent(samples(), {  
      ##  output$table <- renderDT({  
      ##          out <- sample_table_prep()
      ##          out <- out[,-1]
      ##          datatable(out)
      ##  })
      ##}


        ## Main sample edit table
        output$sample_table <- renderDT({
          req(sample_table_prep())
          out <- sample_table_prep()
          #print(head(out))
          #print(table(out$replicate))
          datatable(
            out,
            rownames = FALSE,
            colnames = colnames(out),
            selection = "none",
            class = "compact stripe row-border nowrap",
            # Escape the HTML in all except 1st column (which has the buttons)
            escape = -1,
            extensions = c("Buttons"),
            options = list(
                scrollX = TRUE,
                dom = 'Bftip',
                buttons = list(
                    list(
                        columnDefs = list(list(className = 'dt-center', targets = "_all")),
                        extend = "excel",
                        text = "Download",
                        title = paste0("samples-", Sys.Date()),
                        exportOptions = list(
                            columns = 1:(length(out) - 1)
                        )
                    )
                ),
                columnDefs = list(
                    list(className = 'dt-center', targets = "_all"),
                    list(targets = 10, orderable = TRUE)
                ),
                drawCallback = JS("function(settings) {
                    // removes any lingering tooltips
                    $('.tooltip').remove()
                    }"
                ),
                pageLength = 20
            )
          ) %>%
            formatDate(
                columns = c("Filtered_Date","created_at", "modified_at"),
                method = 'toLocaleString'
            ) 
        })
        sample_table_proxy <- DT::dataTableProxy('sample_table')





        ## sample_select table
        output$sample_select <- renderDT({
          req(sample_table_prep())
          out <- sample_table_prep()
          #print(head(  out[,which(colnames(out) %in% display_col_pcr)]   ))
          out <- out[,which(colnames(out) %in% display_col_pcr)]
        })
        sample_select_proxy <- DT::dataTableProxy('sample_select')


        output$sample_selected <- DT::renderDT({
          req(sample_table_prep())
          out <- sample_table_prep()
          out <- out[,which(colnames(out) %in% display_col_pcr)]
          s = input$sample_select_rows_selected
          out <- out[s,]
   
          datatable(out,
            rownames = FALSE,
            colnames = colnames(out),
            selection = "none",
            class = "compact stripe row-border nowrap",
            # Escape the HTML in all except 1st column (which has the buttons)
            escape = -1,
            extensions = c("Buttons"),
            options = list(
              buttons = list(
                list(
                  columnDefs = list(list(className = 'dt-center', targets = "_all")),
                  extend = "excel",
                  text = "Edit",
                  title = paste0("samples-", Sys.Date()),
                  exportOptions = list(
                    columns = 1:(length(out) - 1)
                  )
                )
              )      
            )
          )
        })
        sample_selected_proxy <- DT::dataTableProxy('sample_selected')

        ### Modules for editing ###
        submodule_add(
            "add_sample",
            modal_title = "Add a Batch of Samples",
            sample_to_edit = function(){NULL},
            modal_trigger = reactive({input$add_sample})
        )

        sample_to_edit <- eventReactive(input$sample_id_to_edit, {
            samples() %>%
            filter(uid == input$sample_id_to_edit)
            ##print(samples() %>% filter(uid == input$sample_id_to_edit))
        })

        submodule_edit(
            "edit_sample",
            modal_title = "Edit sample",
            sample_to_edit = sample_to_edit,
            modal_trigger = reactive({input$sample_id_to_edit})
        )


        sample_to_delete <- eventReactive(input$sample_id_to_delete, {
          out <- samples() %>%
            filter(uid == input$sample_id_to_delete) %>%
            as.list()
        })

        submodule_delete(
            "delete_sample",
            modal_title = "Delete sample",
            sample_to_delete = sample_to_delete,
            modal_trigger = reactive({input$sample_id_to_delete})
        )

        ### ### ### ### ### ### ### ### ### ### ### ### 
        ### Edit selected samples on action button ### 

        
        #samples_to_edit <- eventReactive(input$`extractions_module-table_rows_selected`, {
        #    #samples() %>%
        #    #filter(uid == input$sample_id_to_edit)
        #    #print(samples() %>% filter(uid == input$sample_id_to_edit))
        #    modal_trigger = reactive({input$edit_samples}),
        #    print('got inside edit mod')
        #})

        #samples_to_edit <- eventReactive(input$sample_select_rows_selected, {
        #  out <- samples() %>%
        #    filter(uid == input$sample_select_rows_selected) %>%
        #    as.list()
        #    ##print(input$sample_select_rows_selected)
        #})


        #Get this to work


        #samples_to_edit <- eventReactive(input$edit_samples, {
        #  #out <- samples() %>%
        #  #  filter(uid == input$sample_select_rows_selected) %>%
        #  #  as.list()
        #  #  print(input$sample_select_rows_selected)
        #  out <- samples()
        #  s = input$sample_select_rows_selected
        #  out <- out[s,]
#
        #})
#

        ## observeEvent(button(), { print('hw button works') })

        #samples_to_edit <- eventReactive(input$sample_select_rows_selected, {
        #  #out <- samples() %>%
        #  #  filter(uid == input$sample_select_rows_selected) %>%
        #  #  as.list()
        #  #  print(input$sample_select_rows_selected)
        #  out <- samples()
        #  s = input$sample_select_rows_selected
        #  out <- out[s,]
        #  print(head(out))
        #})
        

        #sample_to_edit <- eventReactive(input$sample_id_to_edit, {
        #    samples() %>%
        #    filter(uid == input$sample_id_to_edit)
        #    print(samples() %>% filter(uid == input$sample_id_to_edit))
        #})
#
#
        #submodule_edit_samples(
        #    "edit_samples",
        #    modal_title = "Edit a Batch of Samples",
        #    samples_to_edit =  samples_to_edit,
        #    modal_trigger = reactive({input$edit_samples})
        #)

        ### Edit selected samples on action button

    }
  )
}

