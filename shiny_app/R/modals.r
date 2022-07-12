## submodule modals


### https://mastering-shiny.org/action-dynamic.html#dynamic-visibility





batchModal <- function(input, output, session, modal_title, selected_cols ) {
      
    # load the namespace
    ns <- session$ns

    vars <- list(dbColNames,dbColNames_type)
    inputList <- pmap(vars, InputFunction, ns)
    names(inputList) <- dbColNames

    print(inputList)


    cols <- selected_cols()
    inputList <- inputList[cols]

    # build the modal
    modalDialog(
        fluidRow(
            column(
              width = 6,

                inputList

            )
        ),
        title = modal_title,
        size = 'm',
        footer = list(
          modalButton('Cancel'),
          actionButton(
            ns('submit'),
            'Submit',
            class = "btn btn-primary",
            style = "color: white"
          )
        )
    )
}

qbitModal <- function(input, output, session, modal_title, batch ) {
      
    # load the namespace
    ns <- session$ns


    to_edit <- batch()
    cols <- c('tube_label','qbit_conc','qbited_date')
    to_edit <- to_edit[cols]

    # build the modal
    modalDialog(
        fluidRow(
            column(
              width = 6,

                renderDT(to_edit, editable = 'column')

            )
        ),
        title = modal_title,
        size = 'm',
        footer = list(
          modalButton('Cancel'),
          actionButton(
            ns('submit'),
            'Submit',
            class = "btn btn-primary",
            style = "color: white"
          )
        )
    )



}