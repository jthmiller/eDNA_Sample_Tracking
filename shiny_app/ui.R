ui <- dashboardPage(


    dashboardHeader(title = "NERRs eDNA Database"),

    dashboardSidebar(
        sidebarMenu(
            menuItem("Sample Collection", tabName = "sample_collection_tab", icon = icon("water")),
            menuItem("Extractions Input", tabName = "sample_extractions_tab", icon = icon("vial")),
            menuItem("PCR Input", tabName = "sample_amplified_tab", icon = icon("vials")),
            menuItem("Sequencing", tabName = "sample_sequencing_tab", icon = icon("dna")),
            menuItem("Sample Lookup", tabName = "sample_lookup_tab", icon = icon("eye")),
            menuItem("Scan QR Labels", tabName = "sample_scan_tab", icon = icon("qrcode")),
            menuItem("Database", tabName = "database_tab", icon = icon("server"))
        )
    ),
    dashboardBody(
        tabItems(
            #tabItem(tabName = "sample_collection_tab", sample_collection_module_ui("collection_module")),
            tabItem(tabName = "sample_collection_tab", collections_page_ui("collections_page")),
            tabItem(tabName = "sample_amplified_tab", PCR_page_ui("PCR_page")),
            tabItem(tabName = "sample_extractions_tab", extractions_page_ui("extractions_page")),
            tabItem(tabName = "database_tab",  add_col_page_ui("add_col_page"))
            #tabItem(tabName = "sample_extractions_tab", sample_extraction_ui("text"))
            #tabItem(tabName = "sample_lookup_tab", sample_select_download_ui("sample_selected"))
        )
    )
)
