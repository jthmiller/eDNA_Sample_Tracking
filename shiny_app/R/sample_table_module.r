#' Sample Table Module UI
#'
#' The UI portion of the module for displaying the sample datatable
#'
#' @importFrom shiny NS tagList fluidRow column actionButton tags
#' @importFrom DT DTOutput
#' @importFrom shinycssloaders withSpinner
#'
#' @param id The id for this module
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#'
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
    ##includeScript(path = "sample_table_module.js"),
    tags$script(src = "sample_table_module.js"),
    tags$script(paste0("sample_table_module_js('", ns(''), "')"))
  )
}




sample_select_pcr_ui <- function(id) {
  
  ns <- NS(id)

  tagList(
    fluidRow(
      column(
        width = 6,
        title = "Samples to add to the database",
        DTOutput(ns('sample_select'))
      ),
      column(
        width = 6,
        DTOutput(ns('sample_selected'))
      )
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
    ) 
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
#' @return None

#sample_table_module <- function(id, prefix = "") {
#  moduleServer(
#    id,
#    function(input, output, session) {

sample_table_module <- function(input, output, session, display_col_extract){

  # trigger to reload data from the "samples" table
  session$userData$samples_trigger <- reactiveVal(0)

  # Read in table from the database
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

    # Remove 
      # %>%
      #select(-)

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

    } else {

      # table has already rendered, so use DT proxy to update the data in the
      # table without rerendering the entire table
      replaceData(sample_table_proxy, out, resetPaging = FALSE, rownames = FALSE)

    }
  })




  ### TRY TO MAKE SELECTABLE TABLE
  output$sample_select <- DT::renderDT({
    req(sample_table_prep())
    out <- sample_table_prep()

    ## drop html button column
    out <- out[,-1]

    out <- out[,display_col] 

    print(head(out))
    datatable(data = out,
               # Escape the HTML in all except 1st column (which has the buttons)
               #escape = -1,
               rownames = FALSE,
               colnames = colnames(out),
               extensions = 'Buttons',
               selection = 'multiple',
               options = list( 
                dom = "Blfrtip",
                buttons = 
                   list("copy", 
                     list(
                       extend = "collection",
                       buttons = c("csv", "excel", "pdf"),
                       text = "Download"
                      ) 
                    ), # end of buttons customization
                 
                  # customize the length menu
                lengthMenu = list(
                              c(10, 20, -1), # declare values
                              c(10, 20, "All") # declare titles
                              ), # end of lengthMenu customization
                pageLength = 10,
                columnDefs = list(
                  list(className = 'dt-center', targets = "_all")
                  #list(targets = 10, orderable = TRUE)
                )
              ) # end of options
    ) # end of datatables

  })
  ### TRY TO MAKE SELECTABLE TABLE


  ### Display table
  output$sample_selected <- renderDT({
    req(sample_table_prep())
    out <- sample_table_prep()

    ## drop html button column
    out <- out[,-1]
    s = input$sample_select_rows_selected
    out <- out[s,]
    out <- out[,display_col] 

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
  ### Display table

  ## Main sample edit table
  output$sample_table <- renderDT({
    req(sample_table_prep())
    out <- sample_table_prep()

    print(head(out))
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
        }")
      )
    ) %>%
      formatDate(
        columns = c("Filtered_Date","created_at", "modified_at"),
        method = 'toLocaleString'
      ) 
  })
  ## Original output espression


  sample_table_proxy <- DT::dataTableProxy('sample_table')

  callModule(
    submodule_edit,
    "add_sample",
    modal_title = "Add sample",
    sample_to_edit = function() NULL,
    modal_trigger = reactive({input$add_sample})
  )

  sample_to_edit <- eventReactive(input$sample_id_to_edit, {
    samples() %>%
      filter(uid == input$sample_id_to_edit)
  })

  callModule(
    submodule_edit,
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

  callModule(
    submodule_delete,
    "delete_sample",
    modal_title = "Delete sample",
    sample_to_delete = sample_to_delete,
    modal_trigger = reactive({input$sample_id_to_delete})
  )




}