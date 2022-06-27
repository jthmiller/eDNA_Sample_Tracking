


app_name <- config::get(file = "shiny_app/config.yml")$app_name
rsconnect::deployApp(
  appDir = "shiny_app",
  account = "tychobra",
  appName = app_name
)


library(shiny)

setwd('/Users/jeffreymiller/Documents/projects/eDNA/eDNA_Sample_Tracking/shiny_app')

runApp()





library(rsconnect)
rsconnect::setAccountInfo(name='nerrs-edna', token='04137FDBBD1628B431C484F66C037887', secret='4bm0Tten0wqlhTCf8xDAHWrwtvlIEZuMqe3glsGE')
rsconnect::deployApp()