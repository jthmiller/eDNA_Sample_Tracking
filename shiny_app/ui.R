
filterdb_ui <- fluidPage(
  shinyFeedback::useShinyFeedback(),
  shinyjs::useShinyjs(),
  # Application Title
  titlePanel(
    h1("eDNA Sample Database", align = 'center'),
    windowTitle = "eDNA Sample Database"
  ),
  sample_table_module_ui("sample_table")
)


ui <- dashboardPage(

    dashboardHeader(title = "NERRs eDNA Database"),

    dashboardSidebar(
        sidebarMenu(
            menuItem("Sample Collection", tabName = "sample_collection_tab", icon = icon("water")),
            menuItem("Scan QR Labels", tabName = "sample_scan_tab", icon = icon("qrcode")),
            menuItem("Extractions Input", tabName = "sample_extractions_tab", icon = icon("vial")),
            menuItem("PCR Input", tabName = "sample_amplified_tab", icon = icon("vials")),
            menuItem("Sequencing", tabName = "sample_sequencing_tab", icon = icon("dna")),
            menuItem("Sample Lookup", tabName = "sample_lookup_tab", icon = icon("eye"))
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "sample_collection_tab", sample_table_module_ui("sample_table")),
            tabItem(tabName = "sample_amplified_tab", sample_select_pcr_ui("sample_selected"))
            ## tabItem(tabName = "sample_extractions_tab", sample_extraction_ui())

            ##tabItem(tabName = "sample_scan_tab", sample_display_module_ui("sample_select"))
            ## tabItem(tabName = "sample_extractions_tab", sample_extraction_ui("sample_selected"))
            #tabItem(tabName = "sample_lookup_tab", sample_lookup_ui),
            #tabItem(tabName = "sample_sequencing_tab", sample_sequencing_ui),
            #tabItem(tabName = "sample_lookup_tab", sample_select_module_ui("sample_select")),
            #tabItem(tabName = "sample_sequencing_tab", sample_select_module_ui("sample_select")),
            #tabItem(tabName = "sample_extractions_tab", sample_select_module_ui("sample_select"))
        )
    )
)
