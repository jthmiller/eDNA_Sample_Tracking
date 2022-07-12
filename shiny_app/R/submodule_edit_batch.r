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
submodule_edit_batch <- function(id, modal_title, batch, selected_cols, modal_trigger) {

    moduleServer(
      id,
      function(input, output, session) {
        
        ns <- session$ns
      
        ### Batch edit modal
        observeEvent(modal_trigger(), {
            hold <- batch()
            cols <- selected_cols()
            showModal(batchModal(input, output, session, modal_title, selected_cols )) 
        })


        ### Batch edit table
        edit_sample_dat <- reactive({
          
          hold <- batch()
          time_now <- as.character(lubridate::with_tz(Sys.time(), tzone = "UTC"))

          cols <- selected_cols()
          print(names(input))
          print(cols)

          listval <- lapply(cols, fmtInputType, input)
          names(listval) <- cols

          ## temp table to write
          out <- list(
            uid = hold$uid,
            data = list(
              listval,
              "modified_at" = time_now,
              "modified_by" = session$userData$email
            )
          )
          out
        })
        ### Batch edit modal

        validate_edit <- eventReactive(input$submit, {
          dat <- edit_sample_dat()
          ## Set filtered_date to NA if it wasnt selected
          ##dat$data$filtered_date <- ifelse(!identical(dat$data$filtered_date, character(0)), dat$data$filtered_date, NA)
          # Logic to validate inputs...
          ## sqlite has issue with date. Change to character
          #dat$data$collected_date <- as.character(dat$data$collected_date)
          #dat$data$filtered_date <- as.character(dat$data$filtered_date)
          dat
        })

        ## I can remove validate_edit(), and use edit_sample_dat() directly 
        observeEvent(validate_edit(), {
          removeModal()
          dat <- validate_edit()
          uid <- dat$uid
          dat <- as.data.frame(dat$data)
          dat <- cbind(uid, dat)

          ## write table to overwrite main table
          DBI::dbWriteTable(
            conn,
            name = "temp_batch",
            value = dat,
            overwrite = TRUE)

          tryCatch({
            # editing an existing sample
            print('editing batch ...')
            updates <- dat %>% select(-uid) %>% colnames()
            ## print(updates)
            sql <- paste0("UPDATE filtersdb SET ",updates," = (SELECT temp_batch.", updates, " FROM temp_batch WHERE temp_batch.uid = filtersdb.uid ) WHERE EXISTS ( SELECT * FROM temp_batch WHERE temp_batch.uid = filtersdb.uid)")
            sapply(sql, FUN = dbExecute, conn = conn)
            showToast("success", paste0(modal_title, " Successs"))
            session$userData$samples_trigger(session$userData$samples_trigger() + 1)
            print('thru session update')
  
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

