library('shiny');

source('uiCreator/uiCreator.R');
source('serverCreator/uiServerCreator.R');
source('globalCreator/uiGlobalCreator.R');
source('resultGenerator/uiResultGenerator.R');
source('helpPage/uiHelpPage.R');

shinyUI(
  fluidPage(
    # tag to have textAreaInput of width 100%
    tags$style(HTML("
      .shiny-input-container:not(.shiny-input-container-inline) {
      width: 100%;
    }")),
    useShinyjs(),
    h1('shinyWYSIWYG'),
    tabsetPanel(id='maintabset', type='tabs',
      tabPanel('UI', wellPanel(
        uiCreator()
      )),
      tabPanel('Server', wellPanel(
        serverCreator()
      )),
      tabPanel('Global', wellPanel(
        globalCreator()
      )),
      tabPanel('Save/Load', wellPanel(
        downloadButton(outputId='creatorSavebtn', label='Save shinyWYSIWYG data'),
        fileInput(inputId='creatorLoadbtn', label='', accept='.RData', buttonLabel='Load shinyWYSIWYG data')
      )),
      tabPanel('Help', wellPanel(
        helpPage()
      ))
    ),
    fluidRow(column(12,
      wellPanel(resultGenerator())
    ))
  )
)
