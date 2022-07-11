library(dplyr)
library(tidyr)
library(tibble)
library(RSQLite)

setwd('eDNA_Sample_Tracking/shiny_app/')

Filters <- read.csv('data/FID.csv', stringsAsFactors=T)
filtersdb <- Filters[,c('sample_name','project','site','set_number','matrix','Collected_Date','filtered_date')]
saveRDS(filtersdb, file = 'data/filtersdb.RDS')
# Create a connection object with SQLite
conn <- dbConnect(
  RSQLite::SQLite(),
  "data/filters.sqlite3"
)
# Create a query to prepare the 'filters' table with additional 'uid', 'id',
# & the 4 created/modified columns
create_samples_query = "CREATE TABLE filtersdb (
  uid                             TEXT PRIMARY KEY,
  project                         TEXT,
  site1                           TEXT,
  site2                           TEXT,
  Collected_Date                  TEXT,
  filtered_date                   TEXT,
  matrix                          TEXT,
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
dbExecute(conn, create_samples_query)
# Read in the RDS file created in 'data_prep.R'
dat <- readRDS("data/filtersdb.RDS")
# add uid column to the `dat` data frame
dat$uid <- uuid::UUIDgenerate(n = nrow(dat))
# reorder the columns
dat <- dat %>%
  select(uid, everything())

DBI::dbWriteTable(
  conn,
  name = "filtersdb",
  value = dat,
  overwrite = FALSE,
  append = TRUE
)




### REINIT DATABASE
library(dplyr)
library(tidyr)
library(tibble)
library(RSQLite)
setwd('eDNA_Sample_Tracking/shiny_app/')


conn <- dbConnect(
  RSQLite::SQLite(),
  "data/filters.sqlite3"
)

create_samples_query = "CREATE TABLE filtersdb (
  uid                             TEXT PRIMARY KEY,
  project                         TEXT,
  site1                           TEXT,
  site2                           TEXT,
  collected_date                  TEXT,
  filtered_date                   TEXT,
  extracted_date                  TEXT,
  type                            TEXT
  matrix                          TEXT,
  set_number                      REAL,
  blank                           TEXT,
  FID                             REAL,
  created_at                      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by                      TEXT,
  modified_at                     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified_by                     TEXT,
  replicate                       REAL,
  cut_in_half_date                TEXT,
  PCR_Step_1_date                 TEXT,
  qbited_date                     TEXT,
  storage                         TEXT,
  extracted_initials              TEXT,
  dil_1_10_date                   TEXT,
  given_to_HCGS_date              TEXT,
  sequenced_date                  TEXT
)"

dbExecute(conn, "DROP TABLE IF EXISTS filtersdb")
# Execute the query created above
dbExecute(conn, create_samples_query)
# Read in the RDS file created in 'data_prep.R'
dat <- readRDS("data/filtersdb.RDS")
# add uid column to the `dat` data frame

dat <- data.frame(dat, 
  PCR_Step_1_date = NA, qbited_date = NA, storage = NA, extracted_initials = NA,
  dil_1_10_date = NA, given_to_HCGS_date = NA, sequenced_date = NA  )

## dat <- dat[,c("uid","project","site1","site2","set_number","matrix","type","collected_date","filtered_date", "created_at","modified_at","created_by","modified_by", "replicate", "extracted_date","FID", "cut_in_half")]  

saveRDS(dat, file = 'data/filtersdb.RDS')


# reorder the columns
dat <- dat %>%
  select(uid, everything())

DBI::dbWriteTable(
  conn,
  name = "filtersdb",
  value = dat,
  overwrite = TRUE,
  append = FALSE
)
dbListTables(conn)
dbDisconnect(conn)
quit()


