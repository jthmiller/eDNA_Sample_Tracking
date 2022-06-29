
moduleServer <- function(id, module) {
  callModule(module, id)
}

button_ui <- function(id) {
  actionButton(NS(id, "btn"), label = "Go")
}

button_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(input$btn)
  })
}
