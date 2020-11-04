# Adds or removes ui objects from the with, what, etc fields
refreshServerCreatorUi <- function(input, output, session, canvasObjects,
                                   validObjects) {
  objList <- canvasObjects$objList
  inputObjects <- objList[names(objList) %in% validObjects$Inputs]
  outputObjects <- objList[names(objList) %in% validObjects$Outputs]

  inputObjsIds <- unname(do.call(c, lapply(inputObjects, names)))
  if (is.null(inputObjsIds)) {
    inputObjsIds <- list()
  }

  outputObjsIds <- unname(do.call(c, lapply(outputObjects, names)))
  if (is.null(outputObjsIds)) {
    outputObjsIds <- list()
  }

  updateSelectInput(session, inputId = "newEventWhen", choices = inputObjsIds)
  updateSelectInput(session,
    inputId = "newEventOutput", choices =
      c("NA", outputObjsIds)
  )

  # careful, maybe the user here selects an actionLink
  updateSelectInput(session, inputId = "newEventWith", choices = inputObjsIds)
}

#### global vars

# Displays a modal to create a new global variable.
# Called when globalVarCreatebtn is clicked
createGlobalVarModal <- function(input, output, session) {
  modal <- fluidPage(
    textInput(inputId = "newGlobalVarName", label = "Name"),
    textInput(
      inputId = "newGlobalVarInitVal", label = "Initialization",
      placeholder = "NA"
    )
  )
  btns <- column(12,
    align = "center",
    actionButton(inputId = "newGlobalVarCreated", "Create"),
    modalButton("Dismiss")
  )
  showModal(modalDialog(modal, footer = btns))
}

# Gets the global variable data from the modal, and creates it.
# Called when newGlobalVarCreated is clicked (from the modal created by
# createGlobalVarModal)
createGlobalVar <- function(input, output, session, globalVars) {
  name <- gsub(" ", "", input$newGlobalVarName) # no spaces
  init <- input$newGlobalVarInitVal

  if (name == "") {
    return()
  } # must have name
  init <- ifelse(init == "", "NA", init)
  globalVars[[name]] <- init
  updateGlobalVarsInput(input, output, session, globalVars)
  return(globalVars)
}

# Deletes selected global var. And updates the ui.
# Called when globalVarDelbtn is clicked
delGlobalVar <- function(input, output, session, globalVars) {
  actVar <- input$globalVars
  if (actVar == "") {
    return(globalVars)
  }

  globalVars <- globalVars[!unlist(lapply(
    names(globalVars),
    function(actGlob) {
      paste0(actGlob, " <- ", globalVars[[actGlob]], ";") == actVar
    }
  ))]
  updateGlobalVarsInput(input, output, session, globalVars)
  return(globalVars)
}

# Updates the input that shows current global vars.
updateGlobalVarsInput <- function(input, output, session, globalVars) {
  res <- lapply(names(globalVars), function(actGlob) {
    paste0(actGlob, " <- ", globalVars[[actGlob]], ";")
  })
  updateSelectInput(session, inputId = "globalVars", choices = res)
  removeModal() # careful, because when delete we dont have modalDialog
}

#### events

# Creates a new event. And updates Ui
# Called when newEventCreatebtn is clicked
createEvent <- function(input, output, session, events) {
  evtName <- input$newEventName
  if (evtName == "") {
    showNotification("Event must have a name!", type = "error")
    return(events)
  }

  evtWhen <- input$newEventWhen
  if (evtWhen == "") {
    showNotification('Event must have a "with" trigger!', type = "error")
    return(events)
  }

  evtWith <- input$newEventWith
  evtWhat <- input$newEventWhat
  evtOutput <- input$newEventOutput
  evtRender <- input$newEventRenderFnctn

  # both have to be NA, or different of NA
  if (!((evtOutput == "NA" && evtRender == "NA") ||
    (evtOutput != "NA" && evtRender != "NA"))) {
    showNotification("Output and Render must be both NA, or different of NA!", type = "error")
    return(events)
  }

  events[[evtName]] <- list(
    name = evtName,
    when = evtWhen,
    with = evtWith,
    what = evtWhat,
    output = evtOutput,
    render = evtRender
  )
  updateNewEvtInput(input, output, session, events)
  return(events)
}

# Deletes an event. And updates Ui
# Called when newEventDelbtn is clicked
delEvent <- function(input, output, session, events) {
  selEvent <- input$events
  if (is.null(selEvent)) {
    return(events)
  }
  events <- events[names(events) != selEvent]
  updateNewEvtInput(input, output, session, events)
  return(events)
}

# Updates event data Ui (existing event names).
updateNewEvtInput <- function(input, output, session, events) {
  evtNames <- names(events)
  updateSelectInput(session, inputId = "events", choices = evtNames)
}

# Updates event data Ui, when selection changes.
# Called when selection changes in events selectInput.
eventSelChange <- function(input, output, session, events) {
  selEvent <- input$events
  fillEventData(input, output, session, events[[selEvent]])
}

# Modifies Ui from event data creator.
fillEventData <- function(input, output, session, eventData) {
  updateTextInput(session, inputId = "newEventName", value = eventData$name)
  updateSelectInput(session, inputId = "newEventWhen", selected = eventData$when)

  actWith <- eventData$with
  if (is.null(actWith)) actWith <- list()
  updateSelectInput(session, inputId = "newEventWith", selected = actWith)

  updateTextAreaInput(session, inputId = "newEventWhat", value = eventData$what)
  updateSelectInput(session,
    inputId = "newEventOutput", selected =
      eventData$output
  )
  updateSelectInput(session,
    inputId = "newEventRenderFnctn", selected =
      eventData$render
  )
}
