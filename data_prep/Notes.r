### Notes



sliderInput01 <- function(id) {
  sliderInput(id, label = id, min = 0, max = 1, value = 0.5, step = 0.1)
}

ui <- fluidRow(
  sliderInput01("alpha"),
  sliderInput01("beta"),
  sliderInput01("gamma"),
  sliderInput01("delta")
)


dateInput(inputId = ns('collected_date'), label = "Collected:")





display_col <- c('project','site1','site2','matrix','type','collected_date','filtered_date','extracted_date', 'cut_in_half')
dates <- grep('date',display_col, value = T)
display_col_type <- ifelse(display_col %in% dates, 'dateInput', 'textInput')



input_chooser <- function(id,type) {

  if(type == 'dateInput'){
    dateInput(ns(id), label = id)
  } else if (type == 'textInput') {
    textInput(ns(id), label = id)
  }

} 

cols <- c('project','site1','site2')
inputs <- map(id = cols, type = display_col_type, function = input_chooser)



mapply(input_chooser, cols, display_col_type)



vars <- tibble::tribble(
  ~ id,   ~ min, ~ max,
  "alpha",     0,     1,
  "beta",      0,    10,
  "gamma",    -1,     1,
  "delta",     0,     1,
)

tibble::tribble(
  ~ var, ~ type, display_col, display_col_type)


col_type <- data.frame(cbind( display_col, display_col_type))
tribble(tibble(col_type))





display_col <- c('project','site1','site2','matrix','type','collected_date','filtered_date','extracted_date', 'cut_in_half')
dates <- grep('date',display_col, value = T)
display_col_type <- ifelse(display_col %in% dates, 'dateInput', 'textInput')
vars <- list(display_col, display_col_type)


InputFunction <- function(display_col,display_col_type) {

  if(display_col_type == 'dateInput'){
    dateInput(display_col, label = display_col)
  } else if (display_col_type == 'textInput') {
    textInput(display_col, label = display_col)
  }

} 


## in_UI <- pmap(vars, InputFunction)


    output$inputGroup = renderUI({
      input_list <- lapply(1:input$numInputs, function(i) {
        # for each dynamically generated input, give a different name
        inputName <- paste("input", i, sep = "")
        numericInput(inputName, inputName, 1)
      })
      do.call(tagList, input_list)
    })



output$inputGroup = renderUI({
      input_list <- lapply(input$sample_select_columns_selected, function(i) {
        # for each dynamically generated input, give a different name
        inputName <- paste("input", i, sep = "")
        numericInput(inputName, inputName, 1)
      })
      do.call(tagList, input_list)



