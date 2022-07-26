#editModuleUI <- function(id) {
#  ns <- shiny::NS(id)
#  shiny::tagList(
#    dteditmodUI(ns('editsModule'))
#  )
#}
#
#editModule <- function(input, output, session, samples_selected) {
#  editModule_results <- shiny::callModule(
#    dteditmod,
#    id = 'editsModule',
#    thedata = samples_selected,
#    useairDatepicker = TRUE
#  )
#}
