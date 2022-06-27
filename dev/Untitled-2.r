# 1. ns <- NS(id)
# 2. input and output IDs wrapped in ns()
# 3. results are wrapped in tagList, instead of fluidPage

sample_db_function <- function(id){

  moduleServer(
    id,
    function(input, output, session){

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







server <- function(input, output, session, display_col_extract) {

  datafile <- sample_db_function("datafile", stringsAsFactors = FALSE)





  output$sample_table <- renderDT({
    req(sample_table_prep())
    out <- sample_table_prep()

    print(head(out))
    print(table(out$replicate))
    
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
}

