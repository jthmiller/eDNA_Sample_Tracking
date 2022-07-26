library(dplyr)
library(tidyr)
library(tibble)
library(RSQLite)
library(readxl)
setwd('/Users/jeffreymiller/Documents/projects/shiny_sample_database/eDNA_Sample_Tracking/shiny_app/')

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




### for testing
#setwd('eDNA_Sample_Tracking/shiny_app/')
conn <- dbConnect(
  RSQLite::SQLite(),
  "data/filtersdb.sqlite3"
)
dbGetQuery(conn, 'SELECT * FROM filtersdb LIMIT 2')

## MANUAL ADD COLUMN
col_nme <- 'batch'
dat_type <- 'REAL'
sql <- paste('ALTER TABLE filtersdb ADD COLUMN', col_nme, dat_type  )
dbExecute(conn, sql)


col_nme <- 'tube_label'
dat_type <- 'TEXT'
sql <- paste('ALTER TABLE filtersdb ADD COLUMN', col_nme, dat_type  )
dbExecute(conn, sql)


col_nme <- 'cut_in_half_date'
dat_type <- 'DATE'
sql <- paste('ALTER TABLE filtersdb ADD COLUMN', col_nme, dat_type  )
dbExecute(conn, sql)


for (i in c('PCR_Step_1_date', 'qbited_date', 'dil_1_10_date', 'given_to_HCGS_date')) {

dat_type <- 'DATE'
sql <- paste('ALTER TABLE filtersdb ADD COLUMN', i, dat_type  )
dbExecute(conn, sql)
}

col_nme <- 'extracted_initials'
dat_type <- 'TEXT'
sql <- paste('ALTER TABLE filtersdb ADD COLUMN', col_nme, dat_type  )
dbExecute(conn, sql)



col_nme <- 'sequenced_date'
dat_type <- 'DATE'
sql <- paste('ALTER TABLE filtersdb ADD COLUMN',col_nme, dat_type  )
dbExecute(conn, sql)


col_nme <- 'storage'
dat_type <- 'TEXT'
sql <- paste('ALTER TABLE filtersdb ADD COLUMN', col_nme, dat_type  )
dbExecute(conn, sql)


add a uid first time 



conn <- dbConnect(
  RSQLite::SQLite(),
  "data/filtersdb.sqlite3"
)



X <- '/Users/jeffreymiller/Downloads/database_test_samples7-19-22.xlsx'
update_db <- function(X){

  db <- read_xlsx(X)
  colnames(db) <- db[1,]
  db <- db[-1,]
  #db$uid <- uuid::UUIDgenerate(n = nrow(db))

  prev_db <- dbGetQuery(conn, 'SELECT * FROM filtersdb')

  if (any(!colnames(db) %in% dbColNames)){
    ## update cols
  }

  if (any(!db$uid %in% prev_db$uid)){
    ## add samples

    db.add <- db[!db$uid %in% prev_db$uid,]
    db.add <- as.list(db.add[,colnames(db)])
    dates <- grep('date',colnames(db), value = T)
    conv_dates <- lapply(db.add[dates], function(X){
      as.character(openxlsx::convertToDate(X))
    })

    #uid <- list(db.add$uid)
    db.add[dates] <- conv_dates
    db.add <- do.call(cbind.data.frame,db.add)
    
    
    
    #db.add <- db.add[names(db.add) != "uid"]
   

    ## format sqlite request
    update_cols <- grep('uid',colnames(db.add), value = T, invert = T)
    update_cols <- c('uid',update_cols)
    
    

    sql_cols <- paste(update_cols, collapse=', ')
    r_cols <- paste( '$',1:length(update_cols),sep ='', collapse=', ')
    sql_l1 <- paste0("INSERT INTO filtersdb (",sql_cols,") VALUES")
    sql_l2 <- paste0("(",r_cols,")")
    req <- paste(sql_l1,sql_l2, sep = "\n")

    db.add <- setNames(split( db.add, seq(nrow( db.add))), rownames( db.add))

    ## update
    lapply(db.add,function(X){

      params <- c(list(X[,'uid']), unname(  X[,colnames(X) != "uid"]   ))
      print(params)
      #dbExecute(conn, req, params = params)

    })    

  }



}



DBI::dbWriteTable(
  conn,
  name = "filtersdb",
  value = dat,
  overwrite = TRUE,
  append = FALSE
)


dbname <- paste0('data/backups/filtersdb_', format(Sys.time(), "%b%d%Y_%X"),'.sqlite3')

bk_conn <- dbConnect(
  RSQLite::SQLite(),
  dbname
)


dat <- db.add[,update_cols]

DBI::dbWriteTable(
  bk_conn,
  name = 'filtersdb',
  value = dat,
  overwrite = TRUE,
  append = FALSE
)




tt <- dbGetQuery(conn, 'SELECT * FROM filtersdb')
write.table(tt,'filtersdb_backup_jul20.csv', sep = ',')


DBI::dbWriteTable(
  conn,
  name = "test_table",
  value = dat,
  overwrite = TRUE,
  append = FALSE
)

getdb <- function(X){

  conn <- dbConnect(
    RSQLite::SQLite(),
    "data/filtersdb.sqlite3"
  )
  return( dbGetQuery(conn, paste0('SELECT * FROM filtersdb LIMIT ',X)) )
}

conn <- dbConnect(
  RSQLite::SQLite(),
  dbname = db_config$dbname
)

### use date in all DB fields
dbColNames <- dbListFields(conn, "filtersdb")




Also, I'm personally very partial to the package data.table. It's fast and has a syntax which is pure R but has a nice mapping onto SQL concepts. 
E.g. in dt[i, j, by=list(...)], i corresponds to "where", j correspond to "select", and by to "group by" and there are facilities for joins as well, 
although I wrote infix wrappers around those so it was easier to remember.





thetimes = chron(dates=dtparts[,1],times=dtparts[,2],
+                  format=c('y-m-d','h:m:s'))



time <- gsub(".*, ","",out$created_at)
time <- format(strptime(time, "%I:%M:%S %p", tz = "UTC"), "%H:%M:%S %z")
date <- as.Date(gsub(", .*","",out$created_at),format='%m/%d/%Y')


as.POSIXct(out$created_at[1], format="%m/%d/%Y, %H:%M:%S")

paste(date,time)

write.table()




nms <- lapply(c('a','b'),print)

df <- data.frame( c(1,2), c(1,2),  c(1,2) )
colnames(df) <- c('dont use','10_M_gi_STD_S149_ME_L001_R', '10_M_gi_STD_S150_ME_L001_R')
index <- c(2,3)
nms <- colnames(df)[index]
nms <- lapply(strsplit(nms,"_"),"[",1:4)
nms <- unlist(lapply(nms, paste, collapse = '_'))
colnames(df)[index] <- nms




colnames(df) <- gsub("_S[0-9]+_.*","", colnames(df))