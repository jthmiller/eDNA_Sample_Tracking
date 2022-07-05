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
submodule_edit_batch <- function(id, modal_title, batch, modal_trigger) {

    moduleServer(
      id,
      function(input, output, session) {
        
        ns <- session$ns
      
        ### Batch edit modal
        observeEvent(modal_trigger(), {
          hold <- batch()
          showModal(
            modalDialog(
              fluidRow(
                column(
                  width = 6,
                  #numericInput(ns('batch'), 'Number of Samples to Add', 1, min = 1, max = 20),
                  dateInput(inputId = ns('Collected_date'), label = "Collected:"),
                  dateInput(inputId = ns('Extracted_date'), label = "Extracted:"),
                  dateInput(inputId = ns('Filtered_Date'), label = "Filtered:"),
                  selectInput(inputId = ns('Cut_in_half'), label = 'Cut in half?', c('Yes','No'))
                  ##uiOutput('add_sample')
                )
              ),
              title = modal_title,
              size = 'm',
              footer = list(
                modalButton('Cancel'),
                actionButton(
                  ns('submit'),
                  'Submit',
                  class = "btn btn-primary",
                  style = "color: white"
                )
              )
            )
          ) 
        

        # Observe event for "Model" text input in Add/Edit Sample Modal
        # `shinyFeedback`
        #  observeEvent(input$project, {
        #    if (input$project == "") {
        #      shinyFeedback::showFeedbackDanger(
        #        "project",
        #        text = "Must choose project!"
        #      )
        #      shinyjs::disable('submit')
        #    } else {
        #      shinyFeedback::hideFeedback("project")
        #      shinyjs::enable('submit')
        #    }
        #  })
        })
        ### Batch edit modal



        edit_sample_dat <- reactive({
          hold <- batch()
          time_now <- as.character(lubridate::with_tz(Sys.time(), tzone = "UTC"))
          



          out <- list(
            uid = hold$uid,
            data = list(
              'Collected_date' = if (is.null(input$Collected_date)) 'NA' else as.character(as.Date(input$Collected_date)),
              'Extracted_date' = if (is.null(input$Extracted_date)) 'NA' else as.character(as.Date(input$Extracted_date)),  
              'Filtered_Date' = if (is.null(input$Filtered_Date)) 'NA' else as.character(as.Date(input$Filtered_Date)),
              'Cut_in_half' = if (is.null(input$Cut_in_half)) 'NA' else input$Cut_in_half,
              "modified_at" = time_now,
              "modified_by" = session$userData$email
            )
          )
          out
        })



        validate_edit <- eventReactive(input$submit, {
          dat <- edit_sample_dat()

          ## Set filtered_date to NA if it wasnt selected
          ##dat$data$Filtered_Date <- ifelse(!identical(dat$data$Filtered_Date, character(0)), dat$data$Filtered_Date, NA)
          # Logic to validate inputs...
          ## sqlite has issue with date. Change to character
          #dat$data$Collected_Date <- as.character(dat$data$Collected_Date)
          #dat$data$Filtered_Date <- as.character(dat$data$Filtered_Date)
          dat
        })

        ## I can remove validate_edit(), and use edit_sample_dat() directly 
        observeEvent(validate_edit(), {
          removeModal()

          dat <- validate_edit()
          uid <- dat$uid
          dat <- as.data.frame(dat$data)
          dat <- cbind(uid, dat)
          print(dat)

          ## write table to overwrite main table
          DBI::dbWriteTable(
            conn,
            name = "temp_batch",
            value = dat,
            overwrite = TRUE)

         
          print(dbGetQuery(conn, 'SELECT * FROM temp_batch LIMIT 5'))

          tryCatch({
            # editing an existing sample
            print('editing batch ...')

            collections_updates <- c('Collected_date', 'Extracted_date', 'Filtered_Date', 'Cut_in_half', 'modified_at', 'modified_by')
            sql <- paste0("UPDATE filtersdb SET ",collections_updates," = (SELECT temp_batch.", collections_updates, " FROM temp_batch WHERE temp_batch.uid = filtersdb.uid ) WHERE EXISTS ( SELECT * FROM temp_batch WHERE temp_batch.uid = filtersdb.uid)")
            
            sapply(sql, FUN = dbExecute, conn = conn)
            session$userData$samples_trigger(session$userData$samples_trigger() + 1)
            showToast("success", paste0(modal_title, " Successs"))
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
      }
    )

}

