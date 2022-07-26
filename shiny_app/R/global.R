
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
library(purrr)
library(readxl)

library(qrcode)
library(shinydashboard)

library(config)

library(sqldf)
library(DTedit)

source('R/functions.R')
##source('R/DTedit.R')
db_config <- config::get()$db

# Create database connection
conn <- dbConnect(
  RSQLite::SQLite(),
  dbname = db_config$dbname
)

### use date in all DB fields
dbColNames <- dbListFields(conn, "filtersdb")
dates <- grep('date',dbColNames, value = T)
dbColNames_type <- ifelse(dbColNames %in% dates, 'dateInput', 'textInput')
names(dbColNames_type) <- dbColNames
## print(dbColNames_type)


# Stop database connection when application stops
shiny::onStop(function() {
  dbDisconnect(conn)
})

# Turn off scientific notation
options(scipen = 999)

# Set spinner type (for loading)
options(spinner.type = 8)

## TO DO: Make this SQLite database
sites <- read.csv('data/site.info.csv', stringsAsFactors=T)
species <- read.table('data/site_species_id.Rtable')
######################