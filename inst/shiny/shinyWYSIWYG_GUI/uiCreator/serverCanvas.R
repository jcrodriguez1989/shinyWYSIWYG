# Draws the canvas (with objects).
drawCanvas <- function(input, output, session, canvasObjects) {
  canvas <- ggplot()

  maxHeight <- 768 # input$canvasHeight;
  maxWidth <- 1024 # input$canvasWidth;

  canvasWide <- canvasObjects$canvasLayout$wide
  if (is.null(canvasWide) || nrow(canvasWide) == 0) {
    canvasWide <- data.frame(x = -1, y = -1, xmax = -1, ymax = -1, id = "", type = "")
  }
  canvas <- canvas +
    geom_rect(data = canvasWide, mapping = aes(
      xmin = x, ymin = y, xmax = xmax, ymax = ymax,
      fill = type
    ), color = "black") +
    geom_text(
      data = canvasWide, aes(x = x + (xmax - x) / 2, y = y + (ymax - y) / 2, label = id),
      size = 5
    )

  canvas <- canvas +
    # theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank()) +
    scale_y_reverse() +
    scale_x_continuous() +
    coord_fixed(
      xlim = c(-0.1, maxWidth + .1), ylim = c(-0.1, maxHeight + .1),
      expand = FALSE
    ) +
    theme(
      axis.title.x = element_blank(), axis.text.x = element_blank(),
      axis.ticks.x = element_blank()
    ) +
    theme(
      axis.title.y = element_blank(), axis.text.y = element_blank(),
      axis.ticks.y = element_blank()
    ) +
    theme(legend.position = "none")

  output$canvas <- renderPlot(canvas)
}

# Updates creator values depending on the brushed area (pos and size).
# Called when canvas is being brushed
canvasbrushing <- function(input, output, session) {
  click <- input$canvasbrush
  xmin <- ceiling(click$xmin)
  ymin <- ceiling(click$ymin)
  width <- floor(click$xmax) - xmin
  height <- floor(click$ymax) - ymin
  updateNumericInput(session, inputId = "objX", value = xmin)
  updateNumericInput(session, inputId = "objY", value = ymin)
  updateNumericInput(session, inputId = "objWidth", value = width)
  updateNumericInput(session, inputId = "objHeight", value = height)
}

# Selects the (double) clicked object, in the creator input.
# Called when canvas is double clicked
canvasDblclick <- function(input, output, session, canvasObjects) {
  click <- input$canvasDblclick
  clickedObjId <- canvasObjects$canvasLayout$long[click$y, click$x]

  if (is.null(clickedObjId) || clickedObjId == "") {
    return()
  }

  clickedObj <- unlist(unname(canvasObjects$objList),
    recursive = FALSE
  )[[clickedObjId]]
  selectObject(input, output, session, clickedObj)
  return()
}
