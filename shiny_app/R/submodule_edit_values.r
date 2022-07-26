
### Add sample module 
submodule_edit_values <- function(id, modal_title, modal_trigger, batch, selected_cols) {

    moduleServer(
      id,
      function(input, output, session) {
        
        print('loaded submodule edit')

        ns <- session$ns

        to_edit <- reactiveValues(data = NULL)

        ### Batch edit modal
        observeEvent(modal_trigger(), {
          print('modal triggered')
          edit_values <- selected_cols()

          #print(edit_values)
          ## https://stackoverflow.com/questions/70155520/how-to-make-datatable-editable-in-r-shiny
          hold <- batch()
          eds <- c('uid',edit_values)
          to_edit$data <- data.frame(isolate(hold)[,eds])
          showModal(valuesModal(input, output, session, modal_title, to_edit))   

        })


        sql <- eventReactive(input$submit, {

          edit_values <- selected_cols()
          
          uids <- unlist(to_edit$data[,'uid'])

          sql_vars <- c(colnames(to_edit$data[,edit_values]),'modified_at','modified_by')
          vars <- paste0('"',sql_vars,'" = ?', collapse = ', ')

 
          sql <- lapply(uids, function(uid){

            df <- to_edit$data[to_edit$data$uid == uid, edit_values]
            df$modified_at <- as.character(lubridate::with_tz(Sys.time(), tzone = "UTC"))
            df$modified_by <- 'temp'

            params <- as.list(df)
            suid <- uid
            req <- sprintf(paste0('UPDATE filtersdb SET ',vars, ' WHERE "uid" = "%s"' ),uid)
            sample <- list(suid, req, params)
            names(sample) <- c('suid', 'req', 'params')
            return(sample) 
          })

          return(sql)
        })


        observeEvent(sql(),{

          removeModal()

          sql <- sql()

          ##print(str(sql))
          sapply(sql, function(X){

            tryCatch({
              # editing an existing sample
              print('editing values ...')
              ## write to the database
              dbExecute(conn, X$req, param = unname( X$params ))               
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
            session$userData$samples_trigger(session$userData$samples_trigger() + 1)
          })
        })
      })
}


