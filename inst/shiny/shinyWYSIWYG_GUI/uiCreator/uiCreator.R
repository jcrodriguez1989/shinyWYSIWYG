source("uiCreator/uiObjCreator.R")
source("uiCreator/uiCanvas.R")
uiCreator <- function() {
  fluidRow(
    column(4, objCreator()),
    column(8, canvas())
  )
}
