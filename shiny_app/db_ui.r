
### Dashboard tabs
source("R/db_sample_collection_module.r")
source("R/db_sample_lookup_module.r")
source("R/db_sample_extraction_module.r")
source("R/db_sample_sequencing_module.r")
source("R/db_sample_amp_module.r")

ui <- dashboardPage(

    dashboardHeader(title = "NERRs eDNA Database"),

    dashboardSidebar(
        sidebarMenu(
            menuItem("Sample Collection", tabName = "sample_collection_tab", icon = icon("water")),
            menuItem("Extractions Input", tabName = "sample_extractions_tab", icon = icon("vials")),
            menuItem("PCR Input", tabName = "amp_input", icon = icon("vials")),
            menuItem("Sequencing", tabName = "sample_sequencing_tab", icon = icon("dna")),
            menuItem("Sample Lookup", tabName = "sample_lookup_tab", icon = icon("eye"))
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "sample_collection_tab", sample_collection_ui),
            tabItem(tabName = "sample_lookup_tab", sample_lookup_ui),
            tabItem(tabName = "sample_sequencing_tab", sample_sequencing_ui),
            tabItem(tabName = "sample_extractions_tab", sample_extraction_ui)
        )
    )
)


