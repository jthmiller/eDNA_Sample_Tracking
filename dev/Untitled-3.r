
server <- function(input, output, session) {

  # Use session$userData to store user data that will be needed throughout
  # the Shiny application
  session$userData$email <- '@unh.edu'

  # Call the server function portion of the `samples_table_module.R` module file
  callModule(
    sample_table_module,
    "sample_table"
  )





moduleServer()



database_ui <- function(id) {
  
  ns <- NS(id)

  tagList(
    textInput(ns("file"), 'email')
  )
}



sample_database <-  function(id, stringsAsFactors) {

  moduleServer(
    id,
    ## Below is the module function
    function(input, output, session) {
        



  # trigger to reload data from the "samples" table
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

    ## return(out)
    output$sample_table <- renderTable(out)

}




ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      csvFileUI("datafile", "User data (.csv format)")
    ),
    mainPanel(
      dataTableOutput("table")
    )
  )
)

server <- function(input, output, session) {
  datafile <- sample_database("datafile")

  output$table <- renderDataTable({
    datafile()
  })

shinyApp(ui,server)