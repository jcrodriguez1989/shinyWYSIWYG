source("uiCreator/serverCanvas.R")
# Initializes the ui.
# Depending on the used shiny version, it fills with possible inputs, outputs,
# and rendering functions.
# Returns the list of possible objects (inputs, outputs).
initializeUi <- function(input, output, session) {
  objects <- getObjects()
  updateSelectInput(session,
    inputId = "selectedObject", choices = objects,
    selected = objects[[1]]
  )

  renderFnctns <- getShinyRenderFnctns()
  updateSelectInput(session,
    inputId = "newEventRenderFnctn", choices =
      c("NA", renderFnctns)
  )

  drawCanvas(input, output, session, list())
  return(objects)
}

# Gets every possible input/ouput that current shiny version could create.
getObjects <- function() {
  shinyNspace <- as.list(loadNamespace("shiny"))[getNamespaceExports("shiny")]

  # get only functions from shiny exports
  shinyFunctions <- shinyNspace[unlist(lapply(shinyNspace, class)) ==
    "function"]

  # inputs would be the functions that have 'inputId' as input,
  # and does not have 'session'
  shinyInputs <- shinyFunctions[unlist(lapply(shinyFunctions, function(fnctn) {
    actFnArgs <- names(as.list(args(fnctn)))
    res <- "inputId" %in% actFnArgs & !"session" %in% actFnArgs
    return(res)
  }))]

  # inputs would be the functions that have 'outputId' as input
  shinyOutputs <- shinyFunctions[unlist(lapply(
    shinyFunctions,
    function(fnctn) {
      actFnArgs <- names(as.list(args(fnctn)))
      res <- "outputId" %in% actFnArgs
      return(res)
    }
  ))]

  objects <- list(
    "Inputs" = sort(names(shinyInputs)),
    "Outputs" = sort(names(shinyOutputs))
  )
  return(objects)
}

# Gets every possible rendering function that current shiny version has.
getShinyRenderFnctns <- function() {
  shinyNspace <- as.list(loadNamespace("shiny"))[getNamespaceExports("shiny")]
  shinyFunctions <- shinyNspace[unlist(lapply(shinyNspace, class)) ==
    "function"]
  names(shinyFunctions)[grepl("^render", names(shinyFunctions))]
}
# Initializes the Ui with data loaded from an RData
loadUi <- function(input, output, session, env) {
  drawCanvas(input, output, session, env$canvasObjects)
  refreshServerCreatorUi(
    input, output, session, env$canvasObjects,
    env$validObjects
  )
  updateGlobalVarsInput(input, output, session, globalVars = env$globalVars)
  updateNewEvtInput(input, output, session, env$events)
  updateTextAreaInput(session, inputId = "globalInput", value = env$global)
  updateTabsetPanel(session, inputId = "maintabset", selected = "UI") # move to UI panel
}
