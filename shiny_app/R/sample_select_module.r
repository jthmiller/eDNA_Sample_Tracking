#' Sample Table Module UI

sample_select <- function(input, output, session) {

  ##moduleServer(
  ##  id,

  # trigegr to reload data from the "samples" table
  session$userData$samples_trigger <- reactiveVal(0)

  # Read in "samples" table from the database
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

  sample_select_prep <- reactiveVal(NULL)

  ## If samples changes:
  observeEvent(samples(), {

    out <- samples()

    ids <- out$uid

    # Remove the `uid` column. We don't want to show this column to the user
    out <- out %>%
      select(-uid)
      
    # Remove 
      # %>%
      #select(-)

    if (is.null(sample_select_prep())) {
      # loading data into the table for the first time, so we render the entire table
      # rather than using a DT proxy
      sample_select_prep(out)

    } else {

      # table has already rendered, so use DT proxy to update the data in the
      # table without rerendering the entire table
      replaceData(sample_select_proxy, out, resetPaging = FALSE, rownames = FALSE)

    }
  })


    req(sample_select_prep())
    out <- sample_select_prep()

  return(out)

}


# input$tableId_rows_selected


 