library(dplyr)
library(tidyr)
library(tibble)
library(RSQLite)
Filters <- read.csv('data/FID.csv', stringsAsFactors=T)
filtersdb <- Filters[,c('sample_name','project','site','replicate','matrix','Collected_Date','Filtered_Date')]
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
  Filtered_Date                   TEXT,
  matrix                          TEXT,
  replicate                       REAL,
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
head(Filters)
Filters <- read.csv('data/FID.csv', stringsAsFactors=T)
Filters$site2 <- NA
head(Filters)
filtersdb <- Filters[,c('project','site1','site2','replicate','matrix','Collected_Date','Filtered_Date')]
saveRDS(filtersdb, file = 'data/filtersdb.RDS')
conn <- dbConnect(
  RSQLite::SQLite(),
  "data/filters.sqlite3"
)
create_samples_query = "CREATE TABLE filtersdb (
  uid                             TEXT PRIMARY KEY,
  project                         TEXT,
  site1                           TEXT,
  site2                           TEXT,
  Collected_Date                  TEXT,
  Filtered_Date                   TEXT,
  matrix                          TEXT,
  replicate                       REAL,
  blank                           TEXT,
  FID                             REAL,
  created_at                      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by                      TEXT,
  modified_at                     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified_by                     TEXT
)"
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
dbListTables(conn)
dbDisconnect(conn)
quit()
