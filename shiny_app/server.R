server <- function(input, output, session) {

  session$userData$email <- 'jeffrey.miller@unh.edu'

  collections_page_server("collections_page")
  PCR_page_server("PCR_page")
  extractions_page_server("extractions_page")
  add_col_page_server("add_col_page")

}
