### database

### database simple

database_page_ui <- function(id) {

  ns <- NS(id)

  tagList(
        fluidRow(
          column(width = 6,
            actionButton("database_backup","Backup the database")
          )
        )
      )
 

}


database_page_server <- function(id) {

      database_module("database_page")

}



database_module <- function(id) {

    moduleServer(
      id,
      function(input, output, session) {

        


      }
        
    )
}