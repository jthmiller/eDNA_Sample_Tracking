library(qrcode)
library(shinydashboard)
library(shiny)
library(DT)


### DATABASE #########
Filters <- read.csv('data/FID.csv', stringsAsFactors=T)
Lab <- read.csv('data/LID.csv', stringsAsFactors=T)
Sequence <- read.csv('data/SID_RID.csv', stringsAsFactors=T)
extraction_sheet <- colnames(Lab)[!colnames(Lab) %in% colnames(Filters)]
sites <- read.csv('data/site_info.csv', stringsAsFactors=T)
######################