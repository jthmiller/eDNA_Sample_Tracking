

sample_db_ui <- function(id){

    
}



sample_db_module <- function(input, output, session, display_col_extract){

  callModule(
    sample_db_function,
    "sample_table"
  )

  sample_table_proxy <- DT::dataTableProxy('sample_table')

  callModule(
    submodule_edit,
    "add_sample",
    modal_title = "Add sample",
    sample_to_edit = function() NULL,
    modal_trigger = reactive({input$add_sample})
  )

  sample_to_edit <- eventReactive(input$sample_id_to_edit, {
    samples() %>%
      filter(uid == input$sample_id_to_edit)
  })

  callModule(
    submodule_edit,
    "edit_sample",
    modal_title = "Edit sample",
    sample_to_edit = sample_to_edit,
    modal_trigger = reactive({input$sample_id_to_edit})
  )

  sample_to_delete <- eventReactive(input$sample_id_to_delete, {
    out <- samples() %>%
      filter(uid == input$sample_id_to_delete) %>%
      as.list()
  })

  callModule(
    submodule_delete,
    "delete_sample",
    modal_title = "Delete sample",
    sample_to_delete = sample_to_delete,
    modal_trigger = reactive({input$sample_id_to_delete})
  )




}