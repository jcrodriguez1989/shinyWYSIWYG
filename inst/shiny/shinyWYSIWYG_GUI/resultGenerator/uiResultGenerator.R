resultGenerator <- function() {
  fluidPage(
    tags$style(type = "text/css", "textarea {width:100%}"),
    actionButton(inputId = "resultGeneratebtn", label = "Generate"),
    textAreaInput(inputId = "resultGenerated", label = NULL, height = "400px", width = "100%")
  )
}
