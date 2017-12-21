objCreator <- function() {
  fluidPage(
    wellPanel(
      textInput(inputId='objId', label='ID', value=''),
      h6('Position:'),
      fluidRow(
        # todo: set max and min canvas sizes as vars
        column(6, disabled(numericInput(inputId='objX', label=NULL, value=0, min=0, max=1000, step=1))),
        column(6, disabled(numericInput(inputId='objY', label=NULL, value=0, min=0, max=1000, step=1)))
      ),
      h6('Size:'),
      fluidRow(
        # todo: set max and min canvas sizes as vars
        column(6, disabled(numericInput(inputId='objWidth', label=NULL, value=0, min=0, max=1000, step=1))),
        column(6, disabled(numericInput(inputId='objHeight', label=NULL, value=0, min=0, max=1000, step=1)))
      ),
      fluidRow(
        column(6, actionButton(inputId='objOkbtn', label='Ok'), align='center'),
        column(6, actionButton(inputId='objDelbtn', label='Del'), align='center')
      )
    ),
    wellPanel(
      a('Functions reference',
        href=paste0('https://shiny.rstudio.com/reference/shiny/', packageVersion('shiny'), '/'), target='blank'),
      selectInput(inputId='selectedObject', label=NULL, choices=list(), size=8, selectize=FALSE)
    )
  )
}
