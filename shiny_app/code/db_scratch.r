  output$banking.df_data <- renderDataTable(
    d1,
    selection = 'none', 
    editable = TRUE, 
    rownames = TRUE,
    extensions = 'Buttons',
    options = list(
      paging = TRUE,
      searching = TRUE,
      fixedColumns = TRUE,
      autoWidth = TRUE,
      ordering = TRUE,
      dom = 'Bfrtip',
      buttons = c('csv', 'excel')
    ),
    class = "display"
  )







                    selectInput('project', 'Choose Project', c('NERRs')),
                    selectInput('site', 'Choose NERR', c('Great Bay')),
                    textInput('site_sample', 'Sample Site'),
                    dateInput("date_collected", "Date collected"),
                    selectInput('matrix', 'Choose matrix', c('sediment','water')),
                    selectInput('rep', 'Choose Replicate', c(1:5)),
                    uiOutput('add_sample'),
                    checkboxGroupInput("data-sheet", "Print", c('extraction','amplification','qrcodes')),
                    uiOutput('collection_qr'),
                    plotOutput("qr_plot")





## make an editable data sheet for RNA extractions
https://stackoverflow.com/questions/58812512/how-to-edit-and-save-changes-made-on-shiny-datatable-using-dt-package


### Date select
dates <- c('Collected','Extracted', 'PCR Step 1', 'Filtered', 'Cut in Half', 'Qbited','Straight DNA Diluted 1:10','Undiluted Step 1 PCR given to Jeff with list of samples','Sequenced'

### Generate plate ID and QRCODE? Print button? 
ids <- 'Strip tubes/PCR Plate'

### Dropdown
primer <- 'PCR Step 1 Primer'

### Dropdown? 
protocol <- 'QiaCube Protocol'

### Upload ?
picture <- 'Gel Picture Name'

## dates <- c('Collected','Extracted', 'PCR Step 1', 'Filtered', 'Cut in Half', 'Qbited','Straight DNA Diluted 1:10','Undiluted Step 1 PCR given to Jeff with list of samples','Sequenced'


## must be able to add a sample in 'sample collection' (use 'add' button)
## editable tables (pull up )



### host db at google drive with sheets
library(googlesheets4)

table <- "responses"

saveData <- function(data) {
  # The data must be a dataframe rather than a named vector
  data <- data %>% as.list() %>% data.frame()
  # Add the data as a new row
  sheet_append(SHEET_ID, data)
}

loadData <- function() {
  # Read the data
  read_sheet(SHEET_ID)
}
