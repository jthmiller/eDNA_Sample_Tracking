server <- function(input, output, session) {

  session$userData$email <- 'jeffrey.miller@unh.edu'

  #moduleServer(
  #  id,
  #  function(input, output, session) {
  #    sample_table_module("sample_table")
  #    # outer logic here
  #  }
  #)


  #sample_table_module("sample_table", display_col_pcr)

  #sample_amp_module(
  # data <- sample_table_module("sample_table", display_col_pcr)
  #output$table <- renderDataTable({
  #  data()
  #})



  #plot1vars <- callModule(sample_table_module, "collection")
  #plot2vars <- callModule(sample_table_module, "plot2_vars")
  
  # this is helpful: https://stackoverflow.com/questions/47576792/how-to-use-callmodule-from-within-another-module-can-i-use-the-same-id
  button <- button_server("mod1")
  sample_table_module("collection_module", disp = display_col_pcr, button)
  sample_PCR_page("PCR_module",  disp = display_col_pcr, button)
  sample_extractions_module("extractions_module",  disp = display_col_pcr)
  

  ## dat <- sample_table_module("sample_table", disp = display_col_pcr)
  ## dat <- sample_table_module("sample_table", disp = display_col_pcr)

  #sample_PCR_module("PCR_module",  disp = display_col_pcr, data = dat )
  #sample_collection_module("collection_module",  disp = display_col_pcr, data = dat )


  #callModule(sample_table_module,"sample_table")
  #callModule(sample_PCR_module,"PCR_module")


}
