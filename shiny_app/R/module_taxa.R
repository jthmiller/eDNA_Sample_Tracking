#' Taxa Table Module Server
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
tax_module <- function(id) {

  moduleServer(
    id,
    function(input, output, session){

      #taxa <- reactive({
      ## Read in table from the database      
      #  out <- NULL
      #  tryCatch({
      #    out <- read.table('eDNA_Sample_Tracking/shiny_app/data/site_species_id.Rtable')
      #   }, error = function(err) {
      #    msg <- "Database Connection Error"
      #    # print `msg` so that we can find it in the logs
      #    print(msg)
      #    # print the actual error to log it
      #    print(error)
      #    # show error `msg` to user.  User can then tell us about error and we can
      #    # quickly identify where it cam from based on the value in `msg`
      #    showToast("error", msg)
      #  })
      #  out
      #})
      ##### full table #####
      display_col <- c("Kingdom","Phylum","Class","Order","Family","Genus","Species","MA","JC","ANERR","SS","WL","GB","PDB","GTM","SFB","HE")
      edit_col <- c("missid_in_MA","likely_replacement_in_MA","MA_notes","missid_in_JC","likely_replacement_in_JC","JC_notes","missid_in_ANERR","likely_replacement_in_ANERR","ANERR_notes","missid_in_SS","likely_replacement_in_SS","SS_notes","missid_in_WL","likely_replacement_in_WL","WL_notes","missid_in_GB","likely_replacement_in_GB","GB_notes","missid_in_PDB","likely_replacement_in_PDB","PDB_notes","missid_in_GTM","likely_replacement_in_GTM","GTM_notes","missid_in_SFB","likely_replacement_in_SFB","SFB_notes","missid_in_HE","likely_replacement_in_HE","HE_notes")


      taxa_select <- reactive({
        out <- species
        return(out)
      })

      output$taxa_select <- renderDT({
        out <- taxa_select()
        out <- out[,which(colnames(out) %in% display_col)]
        out <- out[,display_col]
        return(out)
      })

      ### This is 2nd row, where cols are selected
      taxa_selected <- eventReactive(input$taxa_select_rows_selected,{
        out <- taxa_select()
        s = input$taxa_select_rows_selected 
        out <- out[s,edit_col]
        return(out)
      })

      selected_cols <- eventReactive(input$edit_batch,{
          out <-  taxa_selected()
          out <- out[,edit_col]
          out <- colnames(out)
          inx <- input$sample_selected_columns_selected + 1
          out <- out[inx]
          out
        })

        ## sample display table
        output$taxa_selected <- DT::renderDT({
          out <-  taxa_selected()
          out <- out[,edit_col]
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



      observeEvent(input$taxa_selected_cell_edit, {
        species[input$taxa_selected_cell_edit$row,input$taxa_selected_cell_edit$col] <<- input$taxa_selected_cell_edit$value
      })


      observeEvent(input$saveBtn,{
        nm <- paste0(Sys.time(),'_species_save.table')
        write.csv(species,nm)
      })



    }
  )
}

