
# Library in packages used in this application
library(shiny)
library(DT)
library(DBI)
library(RSQLite)
library(shinyjs)
library(shinycssloaders)
library(lubridate)
library(shinyFeedback)
library(dplyr)
library(dbplyr)

library(qrcode)
library(shinydashboard)

library(config)

library(sqldf)

db_config <- config::get()$db

# Create database connection
conn <- dbConnect(
  RSQLite::SQLite(),
  dbname = db_config$dbname
)

rows <- dbGetQuery(conn, "SELECT * FROM filtersdb")

# Stop database connection when application stops
shiny::onStop(function() {
  dbDisconnect(conn)
})

# Turn off scientific notation
options(scipen = 999)

# Set spinner type (for loading)
options(spinner.type = 8)

### DATABASE #########
#Filters <- read.csv('data/FID.csv', stringsAsFactors=T)
### Filters$uid <- 
#
#Lab <- read.csv('data/LID.csv', stringsAsFactors=T)
#Sequence <- read.csv('data/SID_RID.csv', stringsAsFactors=T)
#extraction_sheet <- colnames(Lab)[!colnames(Lab) %in% colnames(Filters)]

## TO DO: Make this SQLite database
sites <- read.csv('data/site_info.csv', stringsAsFactors=T)

display_col_extract <- c('project','site1','site2','set_number','matrix','Type','Collected_Date','Filtered_Date')
    display_col_pcr <- c('project','site1','site2','matrix','Type','Collected_Date','Filtered_Date')


### load all modules
#list.files("modules") %>%
#    purrr::map(~ source(paste0("modules/", .)))


######################