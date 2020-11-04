canvas <- function() {
  wellPanel(
    h4("Canvas"),
    plotOutput(
      outputId = "canvas",
      dblclick = "canvasDblclick",
      brush = brushOpts(
        id = "canvasbrush",
        fill = "red"
      )
    ),
    hidden(numericInput(inputId = "canvasHeight", label = "", value = 768)),
    hidden(numericInput(inputId = "canvasWidth", label = "", value = 1024))
  )
}
