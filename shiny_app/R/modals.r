## submodule modals


### https://mastering-shiny.org/action-dynamic.html#dynamic-visibility





extractionModal <- function(input, output, session, modal_title, selected_cols ) {
      
    # load the namespace
    ns <- session$ns

    inputList <- pmap(vars, InputFunction, ns)
    names(inputList) <- display_col
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


pcrModal <- function(input, output, session, modal_title) {
      
    # load the namespace
    ns <- session$ns



    modalDialog(
      fluidRow(
        box( 
          dateInput(ns("Extracted"), label = "Extracted:"),
          dateInput(ns("PCR_Step_1"), label = "PCR Step 1:"),
          dateInput(ns("Qbited"), label = "Qbited:"),
          selectInput(ns('Storage'),  label = 'Choose Storage', c('Strip Tubes','PCR Plate')),
          dateInput(ns("Dil_1_10"), label = "Straight DNA Diluted 1:10:"),
          dateInput(ns("HCGS"), label = "Undiluted Step 1 PCR given to Jeff with list of samples:"),
          dateInput(ns("Sequenced"), label = "Sequenced:"),
          fileInput(ns('gels'), label = 'Gel Picture Upload', multiple = T, accept='image/*'),
          actionButton(ns('edit_pcr_batch'),"Edit Batch")
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