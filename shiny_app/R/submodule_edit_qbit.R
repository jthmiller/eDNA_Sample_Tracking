#' Sample Add & Edit Module
#'
#' Module to add & edit Samples in the field sample database 
#' Structure adapted from: https://github.com/Tychobra/shiny_crud
#'
#' @importFrom shiny observeEvent showModal modalDialog removeModal fluidRow column textInput numericInput selectInput modalButton actionButton reactive eventReactive
#' @importFrom shinyFeedback showFeedbackDanger hideFeedback showToast
#' @importFrom shinyjs enable disable
#' @importFrom lubridate with_tz
#' @importFrom uuid UUIDgenerate
#' @importFrom DBI dbExecute
#'
#' @param modal_title string - the title for the modal
#' @param uids reactive returning a 1 row data frame of the sample to edit
#' from the sample database ("mt_cars" in example) table
#' @param modal_trigger reactive trigger to open the modal (Add or Edit buttons)
#'
#' @return None
#'
#sample_edit_module <- function(input, output, session, modal_title, uids, modal_trigger) {
#function(input, output, session, modal_title, uids, modal_trigger) {

#display_col_pcr
### Add sample module 
submodule_edit_qbit <- function(id, modal_title, modal_trigger, batch) {

    moduleServer(
      id,
      function(input, output, session) {
        
        ns <- session$ns

        ### Batch edit modal
        observeEvent(modal_trigger(), {
            hold <- batch()

            edits <- batch()

            print('modal triggered')

            showModal(qbitModal(input, output, session, modal_title, batch )) 
            


            observeEvent(input$to_edit_cell_edit, {
              print(names(input))
              row  <- input$to_edit_cell_edit$row
              clmn <- input$to_edit_cell_edit$col
              edits$data[row, clmn] <- input$to_edit_cell_edit$value
              
              })

            #observeEvent(input$replacevalues, {
            #  rv$data <- fillvalues(rv$data, input$textbox, input$selectcolumn)
            #})
          
        })

        edit_sample_dat <- reactive({

          hold <- batch()
          time_now <- as.character(lubridate::with_tz(Sys.time(), tzone = "UTC"))

          print(names(input))

          out <- list(
            uid = hold$uid,
            data = list(
              "qbit_conc" = input$qbit_conc,
              "qbited_date" = input$qbited_date,
              "modified_at" = time_now,
              "modified_by" = session$userData$email
            )
          )
          
          out
        })


        validate_edit <- eventReactive(input$submit, {
          dat <- edit_sample_dat()
          dat
        })

        observeEvent(validate_edit(), {
          removeModal()
          dat <- validate_edit()
          uid <- dat$uid
          dat <- as.data.frame(dat$data)
          dat <- cbind(uid, dat)

          ## write table to update main table
          DBI::dbWriteTable(
            conn,
            name = "temp_batch",
            value = dat,
            overwrite = TRUE)

          tryCatch({
            # editing an existing sample
            print('editing batch ...')



          }, error = function(error) { 
            msg <- paste0(modal_title, " Error")
            # print `msg` so that we can find it in the logs
            print(msg)
            # print the actual error to log it
            print(error)
            # show error `msg` to user.  User can then tell us about error and we can
            # quickly identify where it cam from based on the value in `msg`
            showToast("error", msg)
          })
        })
      })
}


