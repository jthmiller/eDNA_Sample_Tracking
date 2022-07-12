#' Sample Delete Module
#'
#' This module is for deleting a row's information from the mtSamples database file
#'
#' @importFrom shiny observeEvent req showModal h3 modalDialog removeModal actionButton modalButton
#' @importFrom DBI dbExecute
#' @importFrom shinyFeedback showToast
#'
#' @param modal_title string - the title for the modal
#' @param Sample_to_delete string - the model of the Sample to be deleted
#' @param modal_trigger reactive trigger to open the modal (Delete button)
#'
#' @return None
#'### , display_col_pcr
#function(input, output, session, modal_title, sample_to_delete, modal_trigger) {


submodule_delete <- function(id, modal_title, sample_to_delete, modal_trigger) {

  moduleServer(
    id,
    function(input, output, session) {

      ns <- session$ns

      # Observes trigger for this module (here, the Delete Button)
      observeEvent(modal_trigger(), {
        # Authorize who is able to access particular buttons (here, modules)
        req(session$userData$email == 'jeffrey.miller@unh.edu')

        showModal(
          modalDialog(
            div(
              style = "padding: 30px;",
              class = "text-center",
              h2(
                style = "line-height: 1.75;",
                paste0(
                  'Are you sure you want to delete the "',
                  sample_to_delete()$uid,
                  '"?'
                )
              )
            ),
            title = modal_title,
            size = "m",
            footer = list(
              modalButton("Cancel"),
              actionButton(
                ns("submit_delete"),
                "Delete sample",
                class = "btn-danger",
                style="color: #fff;"
              )
            )
          )
        )
        })

      observeEvent(input$submit_delete, {
        req(sample_to_delete())
        removeModal()
        tryCatch({
          uid <- sample_to_delete()$uid
          DBI::dbExecute(
          conn,
          "DELETE FROM filtersdb WHERE uid=$1",
          params = c(uid)
          )
          session$userData$samples_trigger(session$userData$samples_trigger() + 1)
          showToast("success", "sample Successfully Deleted")
        }, error = function(error) {
          msg <- "Error Deleting sample"
          # print `msg` so that we can find it in the logs
          print(msg)
          # print the actual error to log it
          print(error)
          # show error `msg` to user.  User can then tell us about error and we can
          # quickly identify where it cam from based on the value in `msg`
          showToast("error", msg)
        })
      })
    }
  )
}
