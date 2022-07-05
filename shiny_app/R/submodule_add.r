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
#' @param sample_to_edit reactive returning a 1 row data frame of the sample to edit
#' from the sample database ("mt_cars" in example) table
#' @param modal_trigger reactive trigger to open the modal (Add or Edit buttons)
#'
#' @return None
#'
#sample_edit_module <- function(input, output, session, modal_title, sample_to_edit, modal_trigger) {
#function(input, output, session, modal_title, sample_to_edit, modal_trigger) {

#display_col_pcr
### Add sample module 
submodule_add <- function(id, modal_title, sample_to_edit, modal_trigger) {

    moduleServer(
      id,
      function(input, output, session) {
        
        ns <- session$ns
        
        observeEvent(modal_trigger(), {
          hold <- sample_to_edit()
          showModal(
            modalDialog(
              fluidRow(
                column(
                  width = 6,
                  numericInput(ns('batch'), 'Number of Samples to Add', 1, min = 1, max = 20),
                  selectInput(ns('project'), 'Choose Project', c('NERRs','SWMP', 'Other'), selected = ifelse(is.null(hold), "", hold$project)),
                  selectInput(ns('site1'), 'Site1', levels(sites$site)),
                  selectInput(ns('site2'), 'Site2', levels(sites$site2)),
                  dateInput(ns("Collected_Date"), "Date collected", value = as.Date('1984-02-02')),
                  dateInput(ns("Filtered_Date"), "Date Filtered", value = as.Date('1984-02-02')),
                  selectInput(ns('matrix'), 'Choose matrix', c('sediment','water'), selected = ifelse(is.null(hold), "", hold$matrix)),
                  #selectInput(ns('set_number'), 'Choose Replicate', c(0:10), selected = ifelse(is.null(hold), "", hold$set_number)),
                  selectInput(ns('Type'), 'Choose Sample type', c('Sample','Trip Blank', 'Filter Blank', 'Lab Blank','Extraction Blank','PCR Blank'), selected = ifelse(is.null(hold), "", hold$Type)),
                  selectInput(ns('user'), "Username", c('Jmiller', 'Awatts'))
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
          observeEvent(input$project, {
            if (input$project == "") {
              shinyFeedback::showFeedbackDanger(
                "project",
                text = "Must choose project!"
              )
              shinyjs::disable('submit')
            } else {
              shinyFeedback::hideFeedback("project")
              shinyjs::enable('submit')
            }
          })
        })

        edit_sample_dat <- reactive({
          hold <- sample_to_edit()
          out <- list(
            uid = if (is.null(hold)) NA else hold$uid,
            data = list(
              "project" = if (is.null(input$project)) 'NA' else input$project,
              "site1" = if (is.null(input$site1)) 'NA' else input$site1,
              "site2" = if (is.null(input$site2)) 'NA' else input$site2,
              "Collected_Date" = if (is.null(input$Collected_Date)) 'NA' else input$Collected_Date,
              "Filtered_Date" = if (is.null(input$Filtered_Date)) 'NA' else input$Filtered_Date,
              "matrix" = if (is.null(input$matrix)) 'NA' else input$matrix,
              "Type" = if (is.null(input$Type)) 'NA' else input$Type,
              "set_number" = if (is.null(input$set_number)) 'NA' else input$set_number
              ## "add_sample" = input$add_sample,
            )
          )
          time_now <- as.character(lubridate::with_tz(Sys.time(), tzone = "UTC"))
          #input$Collected_Date <- as.character(lubridate::with_tz(input$Collected_Date, tzone = "UTC"))
          #input$Filtered_Date <- as.character(lubridate::with_tz(input$Filtered_Date, tzone = "UTC"))
          if (is.null(hold)) {
          # adding a new sample
            out$data$created_at <- time_now
            out$data$created_by <- session$userData$email

            out$data$Collected_Date <- 'NA'
            out$data$Filtered_Date <- 'NA'
            out$data$matrix <- 'NA'
            out$data$Type <- 'NA'

          } else {
          # Editing existing sample
            out$data$created_at <- as.character(hold$created_at)
            out$data$created_by <- hold$created_by
            ## Convert when edited 
            #out$data$Collected_Date <- as.character(as.POSIXlt(input$Collected_Date))
            #out$data$Filtered_Date <- as.character(as.POSIXlt(input$Filtered_Date))
          } 
            out$data$modified_at <- time_now
            out$data$modified_by <- session$userData$email
            


            #print(input$Collected_Date)
            #print(out$data$Collected_Date)
            #print(out$data$modified_at)
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

        observeEvent(validate_edit(), {
          removeModal()
          dat <- validate_edit()
          tryCatch({
            if (is.na(dat$uid)) {
              print(dat)
              for (rep in 1:input$batch ){
                print('creating new samples ...')
                uid <- uuid::UUIDgenerate()
                dat$data$set_number <- rep
                ##print(c('adding',
                ##    list(uid),
                ##    unname(dat$data)
                ##  ))
                dbExecute(
                  conn,
                  "INSERT INTO filtersdb (uid, project, site1, site2, Collected_date, Filtered_Date, matrix, type, set_number, created_at, created_by, modified_at, modified_by) VALUES
                  ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)",
                  params = c(
                    list(uid),
                    unname(dat$data)
                  )
                )
              }

            } else {
          # editing an existing car

          print('editing sample ...')

          dbExecute(
            conn,
            "UPDATE filtersdb SET project=$1, site1=$2, site2=$3, set_number=$4, matrix=$5, Type=$6, Collected_date=$6, Filtered_Date=$7, created_at=$8, created_by=$9, modified_at=$10, modified_by=$11 WHERE uid=$12",
            params = c(
              unname(dat$data),
              list(dat$uid)
            )
          )
        }

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

