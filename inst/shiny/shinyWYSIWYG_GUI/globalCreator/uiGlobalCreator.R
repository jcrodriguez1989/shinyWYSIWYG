globalCreator <- function() {
  fluidRow(
    column(12, textAreaInput(inputId='globalInput', label='', placeholder=
                               'Put here extra code that should be executed globally in your shiny app.\nFor example:\n\nrequire(MIGSA);\n\ndata(iris);',
                             height='400px',
                             width='100%'))
  )
}
