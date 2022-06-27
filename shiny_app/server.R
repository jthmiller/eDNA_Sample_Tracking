server <- function(input, output, session) {

  # Use session$userData to store user data that will be needed throughout
  # the Shiny application
  session$userData$email <- 'jeffrey.miller@unh.edu'


  ## Call the server function for the database


  # Call the server function portion of the `samples_table_module.R` module file

  # First call the database server

 #dat <- callModule(
 #   sample_table_module,
 #   "sample_table"
 # )

  



  callModule(
    sample_table_module,
    id = "sample_table"
  )

  callModule(
    sample_table_module,
    "sample_selected",
    display_col_pcr
  )

  callModule(
    sample_table_module,
    "sample_selected2",
    display_col_pcr
  )
  
  callModule(
    sample_extraction_module,
      "text"
  )




  #callModule(
  #  sample_select_module,
  #  "sample_select"
  #)

  #  callModule(
  #  sample_amplified_module,
  #  "sample_amplified"
  #)
}