#' Sample Table Module Server
#'
#' The Server portion of the module for displaying the sample datatable
#'
#' @importFrom shiny reactive reactiveVal observeEvent req callModule eventReactive
#' @importFrom DT renderDT datatable replaceData dataTableProxy
#' @importFrom dplyr tbl collect mutate arrange select filter pull
#' @importFrom purrr map_chr
#' @importFrom tibble tibble
#'
#' @param None
#'
#' @return None ()


## output a df, inport df() in other functions
## use df() inside server (bc values are reactive)
## , display_col_pcr , display_col_pcr
sample_table_module <- function(id, display_col, edit_col, edit_values) {

  moduleServer(
    id,
    function(input, output, session){

      print('loaded module server for the database')

      session$userData$samples_trigger <- reactiveVal(0)


      # Read in table from the database      
      samples <- reactive({

        session$userData$samples_trigger()

        out <- NULL
        tryCatch({
          out <- conn %>%
            tbl('filtersdb') %>%
            collect() %>%
            mutate(
              created_at = as.POSIXct(created_at, tz = "UTC", format="%m/%d/%Y, %H:%M:%S"),
              modified_at = as.POSIXct(modified_at, tz = "UTC", format="%m/%d/%Y, %H:%M:%S")
            ) %>%
            arrange(desc(modified_at))
        }, error = function(err) {
          msg <- "Database Connection Error"
          # print `msg` so that we can find it in the logs
          print(msg)
          # print the actual error to log it
          print(error)
          # show error `msg` to user.  User can then tell us about error and we can
          # quickly identify where it cam from based on the value in `msg`
          showToast("error", msg)
        })
        out
      })
      #### full table ######

      ## Prep interactive dt
      sample_table_prep <- reactiveVal(NULL)

      ## react to samples() edit
      observeEvent(samples(), {
        out <- samples()

        ids <- out$uid
        actions <- purrr::map_chr(ids, function(id_) {
          paste0(
            '<div class="btn-group" style="width: 75px;" role="group" aria-label="Basic example">
              <button class="btn btn-primary btn-sm edit_btn" data-toggle="tooltip" data-placement="top" title="Edit" id = ', id_, ' style="margin: 0"><i class="fa fa-pencil-square-o"></i></button>
              <button class="btn btn-danger btn-sm delete_btn" data-toggle="tooltip" data-placement="top" title="Delete" id = ', id_, ' style="margin: 0"><i class="fa fa-trash-o"></i></button>
            </div>'
          )
        })

        # Remove the `uid` column. We don't want to show this column to the user
        out <- out %>% select(-uid)

        # Set the Action Buttons row to the first column of the `samples` table
        out <- cbind(tibble(" " = actions), out)

        if (is.null(sample_table_prep())) {
            # loading data into the table for the first time, so we render the entire table
            # rather than using a DT proxy
            # set prep to out
            sample_table_prep(out)

        } else {
            # table has already rendered, so use DT proxy to update the data in the
            # table without rerendering the entire table
            replaceData(sample_table_proxy, out, resetPaging = FALSE, rownames = FALSE)
        }
      }) 
      #### initialize samples from database ####

      ## render collections interactive dt
      output$sample_table <- renderDT({
        req(sample_table_prep())
        out <- sample_table_prep()
        
        out <- data.frame(cbind( edit = out[,1],out[,display_col]))

        datatable(
          out,
          rownames = FALSE,
          colnames = colnames(out),
          selection = "none",
          class = "compact stripe row-border nowrap",
          # Escape the HTML in all except 1st column (which has the buttons)
          escape = -1,
          extensions = c("Buttons"),
          options = list(
              scrollX = TRUE,
              dom = 'Bftip',
              buttons = list(
                  list(
                      columnDefs = list(list(className = 'dt-center', targets = "_all")),
                      extend = "excel",
                      text = "Download",
                      title = paste0("samples-", Sys.Date()),
                      exportOptions = list(
                          columns = 1:(length(out) - 1)
                      )
                  )
              ),
              columnDefs = list(
                  list(className = 'dt-center', targets = "_all"),
                  list(targets = 10, orderable = TRUE)
              ),
              drawCallback = JS("function(settings) {
                  // removes any lingering tooltips
                  $('.tooltip').remove()
                  }"
              ),
              pageLength = 20
          )
        ) %>%
          formatDate(
              columns = c("created_at", "modified_at"),
              method = 'toLocaleString'
          ) 
      })
      sample_table_proxy <- DT::dataTableProxy('sample_table')
      ##############################################
      ##############################################

      #Holds all samples to be selected
      sample_select <- reactive({
        out <- samples()
        ##mydata(out)
        # out <- out[,which(colnames(out) %in% display_col)]
        return(out)
      })


      ### Top table ###
      ## View subset of columns specific to tab
      sample_view <- reactive({
        out <- sample_select()
        # out <- out[,which(colnames(out) %in% display_col)]
        out <- out[,display_col]
        return(out)
      })

      output$sample_view <- renderDT({  
        out <- sample_view()
        #print(out)
        return(out)
      })
      ### Top table ###

      ## Second row dynamic table ## 
      samples_selected <- eventReactive(input$sample_view_rows_selected,{
        ## out <- sample_view()
        out <- sample_select()
        s = input$sample_view_rows_selected 
        out <- out[s,edit_col]
        #print(out)
        return(out)        
      })

      ## Returns names of columns that will be edited 
      selected_cols <- eventReactive(input$sample_selected_columns_selected,{
          out <- samples_selected()
          out <- colnames(out)
          inx <- input$sample_selected_columns_selected + 1
          inx <- sort(inx)
          out <- out[inx]
          return(out)
        })
   
      batch <- eventReactive(input$sample_view_rows_selected,{
          out <- samples()
          s = input$sample_view_rows_selected
          #print(out[s,])
          return(out[s,])
        })
        
      output$sample_selected <- DT::renderDT({
          out <- samples_selected()
          datatable(out,
            rownames = FALSE,
            colnames = colnames(out),
            selection = list(target = 'column'),
            class = "compact stripe row-border nowrap",
            # Escape the HTML in all except 1st column (which has the buttons)
            # escape = -1,
            extensions = c("Buttons"),
            options = list(
              buttons = list(
                list(
                  columnDefs = list(list(className = 'dt-center', targets = "_all")),
                  extend = "excel",
                  text = "Edit",
                  title = paste0("samples-", Sys.Date())
                  #exportOptions = list(
                  #  columns = 1:(length(out) - 1)
                  #)
                )
              )      
            )
          )
        })
      ## Second row dynamic table ## 


      #output$sample_selected <- renderDT({  
      #  out <- samples_selected()
      #  print(out)
      #  return(out)
      #})
      #edit_results <- dtedit(
      #  input, output,
      #  name = 'display_edits',
      #  thedata = mydata
      #  #useairDatepicker = TRUE
      #)
        
      #observeEvent(edit_results$thedata, {
      #  # the data has been added
      #  # copy the changes to our own copy
      #  mydata(edit_results$thedata)
      #})
  
      #observeEvent(samples_selected(),{
      #  # out <- out[,which(colnames(out) %in% display_col)]
      #  out <- samples_selected()
      #    mydata(out)
      #})
      #observeEvent(Edit_Results$thedata, {
      #  # the data has been added
      #  # copy the changes to our own copy
      #  mydata(Edit_Results$thedata)
      #})
        ##samples_selected() <- reactiveVal(NULL)

	      ###### Create the DTedit object when samples are selected
        #observeEvent(samples_selected(), {
        #  #eventReactive(input$sample_select_rows_selected,{
        #  cols <- c('uid','FID','replicate','matrix','type')
        #  print('observed')
        #  out <- samples_selected()
        #  ##print(out)
        #  str(out)
        #  print(cols)
        #  print(colnames(out))
        #  #callModule(editModule, 'display_editsModule', out = out)
        #  #print(session)
  	    #  #DTedit::dtedit(input, output,
	      #	#   name = 'edits',
	      #	#   thedata = out,
	      #	#   edit.cols = cols,
	      #	#   #edit.label.cols = cols,
	      #	#   #input.types = c(notes='textAreaInput'),
	      #	#   #view.cols = cols,
	      #	#   callback.update = my.update.callback,
	      #	#   callback.insert = my.insert.callback,
	      #	#   callback.delete = my.delete.callback)
        #})





        ### Modules for editing ###
        ## Assign each bactch of added samples a new batch number
        batch_num <- eventReactive(input$add_sample,{
          batch <- samples()
          batch <- max(batch$batch) + 1
          #print(batch)
        })

        ## Adding a new batch of samples
        submodule_add(
            "add_sample",
            modal_title = "Add a Batch of Samples",
            sample_to_edit = function(){NULL},
            batch_num = batch_num,
            modal_trigger = reactive({input$add_sample})
        )

        ## Get all columns for the sample to edit
        sample_to_edit <- eventReactive(input$sample_id_to_edit, {
            samples() %>%
            filter(uid == input$sample_id_to_edit)
            ##print(samples() %>% filter(uid == input$sample_id_to_edit))
        })

        ## looks for sample id input from sample_table_module.js
        submodule_edit(
            "edit_sample",
            modal_title = "Edit sample",
            sample_to_edit = sample_to_edit,
            modal_trigger = reactive({input$sample_id_to_edit})
        )

        ## looks for sample id input from sample_table_module.js
        sample_to_delete <- eventReactive(input$sample_id_to_delete, {
          out <- samples() %>%
            filter(uid == input$sample_id_to_delete) %>%
            as.list()
        })

        submodule_delete(
            "delete_sample",
            modal_title = "Delete sample",
            sample_to_delete = sample_to_delete,
            modal_trigger = reactive({input$sample_id_to_delete})
        )


        submodule_edit_batch(
          "edit_batch",
          modal_title = "Edit Batch",
          batch = batch,
          selected_cols = selected_cols,
          modal_trigger = reactive({input$edit_batch})
        )

        submodule_edit_qbit(
          "edit_qbit",
          modal_title = "Edit Qbit Values",
          batch = batch,
          modal_trigger = reactive({input$edit_pcr_qbit})
        )

        submodule_edit_values(
          "edit_values",
          modal_title = "Edit Values",
          batch = batch,
          selected_cols = selected_cols,
          modal_trigger = reactive({input$edit_values})
        )

        submodule_add_column(
          "add_column",
          modal_title = "Add a New Column"
        )
    }
  )
}

