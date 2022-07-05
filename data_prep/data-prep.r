library(dplyr)
library(tidyr)
library(tibble)
library(RSQLite)
library(lubridate)

##filtersdb <- read.csv('data_prep/filtersdb.csv', stringsAsFactors=F)
filtersdb <- read.csv('data_prep/filtersdb.new.csv', stringsAsFactors=F)

filtersdb$Collected_Date <- as.character(as.POSIXlt(as.Date(filtersdb$Collected_Date)))
filtersdb$Filtered_Date <- as.character(as.POSIXlt(as.Date(filtersdb$Filtered_Date)))
filtersdb$created_at <- as.character(lubridate::with_tz(Sys.time(), tzone = "UTC"))
filtersdb$modified_at <- as.character(lubridate::with_tz(Sys.time(), tzone = "UTC"))

filtersdb$created_by <- 'jeffrey.miller@unh.edu'
filtersdb$modified_by <- 'jeffrey.miller@unh.edu'

filtersdb$replicate <- 0

write.table(filtersdb,'shiny_app/data/filtersdb.csv', sep = ",", quote = FALSE, row.names = FALSE)
saveRDS(filtersdb, file = 'shiny_app/data/filtersdb.RDS')

# Create a connection object with SQLite
conn <- dbConnect(
  RSQLite::SQLite(),
  "shiny_app/data/filtersdb.sqlite3"
)

# Create a query to prepare the 'filters' table with additional 'uid', 'id',
# & the 4 created/modified columns
create_filter_query = "CREATE TABLE filtersdb (
  uid                             TEXT PRIMARY KEY,
  project                         TEXT,
  site1                           TEXT,
  site2                           TEXT,
  Collected_Date                  DATE,
  Filtered_Date                   DATE,
  matrix                          TEXT,
  type                            TEXT,
  set_number                      REAL,
  blank                           TEXT,
  FID                             REAL,
  created_at                      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by                      TEXT,
  modified_at                     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified_by                     TEXT
)"

# dbExecute() executes a SQL statement with a connection object
# Drop the table if it already exists
dbExecute(conn, "DROP TABLE IF EXISTS filtersdb")
# Execute the query created above
dbExecute(conn, create_filter_query)

# Read in the RDS file created in 'data_prep.R'
dat <- readRDS("shiny_app/data/filtersdb.RDS")

# add uid column to the `dat` data frame (the first filter lables)
dat$uid <- uuid::UUIDgenerate(n = nrow(dat))

# reorder the columns
dat <- dat %>%
  select(uid, everything())

# Fill in the SQLite table with the values from the RDS file
DBI::dbWriteTable(
  conn,
  name = "filtersdb",
  value = dat,
  overwrite = TRUE
)

#DBI::dbWriteTable(
#  conn,
#  name = "filtersdb",
#  value = dat,
#  overwrite = FALSE,
#  append = TRUE
#)

# List tables to confirm 'filtersdb' table exists
dbListTables(conn)

# disconnect from SQLite before continuing
dbDisconnect(conn)

# TEST DATABASE 
 conn <- dbConnect(
   RSQLite::SQLite(),
   "shiny_app/data/filtersdb.sqlite3"
 )
 dbGetQuery(conn, 'SELECT * FROM filtersdb LIMIT 5')
 trys <- dbGetQuery(conn, 'SELECT * FROM filtersdb')


dbExecute(conn, 'ALTER TABLE filtersdb ADD Extracted_date TEXT')