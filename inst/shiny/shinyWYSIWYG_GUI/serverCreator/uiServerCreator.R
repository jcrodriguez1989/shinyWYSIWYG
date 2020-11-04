serverCreator <- function() {
  fluidRow(
    column(
      4, # left panel
      wellPanel(
        selectInput(inputId = "globalVars", label = "Global variables", choices = list()),
        fluidRow(
          column(6, actionButton(inputId = "globalVarCreatebtn", label = "Create"), align = "center"),
          column(6, actionButton(inputId = "globalVarDelbtn", label = "Del"), align = "center")
        )
      ),
      wellPanel(
        selectInput(inputId = "events", label = "Events", choices = list(), size = 9, selectize = FALSE),
        fluidRow(
          column(6, actionButton(inputId = "newEventCreatebtn", label = "Ok"), align = "center"),
          column(6, actionButton(inputId = "newEventDelbtn", label = "Del"), align = "center")
        )
      )
    ),
    column(8, wellPanel( # right panel
      h4("Event"),
      textInput(inputId = "newEventName", label = "Name"),
      selectInput(inputId = "newEventWhen", label = "When", choices = list()),
      selectInput(inputId = "newEventWith", label = "With", choices = list(), multiple = !FALSE),
      textAreaInput(inputId = "newEventWhat", label = "What"),
      fluidRow(
        column(6, selectInput(inputId = "newEventOutput", label = "Output", choices = list("NA"))),
        column(6, selectInput(inputId = "newEventRenderFnctn", label = "Rendering", choices = list("NA")))
      )
    ))
  )
}
