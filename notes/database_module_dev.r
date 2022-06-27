### database module





database_mod <- function(input, output, session){

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

  sample_table_prep <- reactiveVal(NULL)

  observeEvent(samples(), {

    out <- samples()

    ids <- out$uid

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

    sample_table_proxy <- DT::dataTableProxy('sample_table')
