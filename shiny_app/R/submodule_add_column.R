### Add column to table:



submodule_add_column <- function(id, modal_title, batch, selected_cols, modal_trigger) {

  moduleServer(
    id,
    function(input, output, session) {
        
      ns <- session$ns
      
      ### Batch edit modal
      observeEvent(input$add_col, {

        sql <- paste('ALTER TABLE filtersdb ADD COLUMN', input$col_nme, input$dat_type  )
        dbExecute(conn, sql)

      })
    }
  )
}



