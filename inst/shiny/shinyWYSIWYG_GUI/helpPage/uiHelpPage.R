helpPage <- function() {
  tabsetPanel(type='tabs',
    tabPanel('UI', wellPanel(
      'Draw in the ', tags$strong('canvas'), ' the desired size and position for the object to be created.',
      br(),
      'Select which type of object should be created.',
      br(),
      'Change the object\'s id if wanted.',
      br(),
      'And create the object.',
      br(),
      br(),
      'Double click objects in the ', tags$strong('canvas'), ' to select them.'
    )),
    tabPanel('Server', wellPanel(
      'Create global variables for your shiny app (you will be able to use them in ', tags$strong('What'), ' field).',
      br(),
      br(),
      'Create events that will be activated when ', tags$strong('When'), ' object changes (or presents an event).',
      br(),
      'Use ', tags$strong('With'), ' inputs as variables into your ', tags$strong('What'), ' code (with their object id as variable name).',
      br(),
      'Fill the ', tags$strong('What'), ' field with the code that should be executed.',
      'Use global variables if wanted, and modify their value with ', tags$i('<<-'), ' operator.',
      br(),
      'Use ', tags$i('Output'), ' objects to render data.',
      'You should specify the ', tags$i('Rendering'), ' method corresponding to that type of data.',
      br(),
      'And your ', tags$strong('What'), ' code should return the corresponding input to the ', tags$i('Rendering'), ' function.'
    )),
    tabPanel('Global', wellPanel(
      'Put here all the code needed to run your shiny app correctly.',
      br(),
      'Needed libraries, datasets to be loaded with the ', tags$i('data()'), ' function, etc.'
    )),
    tabPanel('Generate', wellPanel(
      'Once the ', tags$i('Generate'), ' button is clicked, you should eneter every object additional argument.',
      br(),
      'More information about these arguments additional info can be found when clicking ', tags$i('Functions reference'), ' on UI tab.',
      br(),
      br(),
      'Generated code will be shown. It should be copied into a file called ', tags$i('app.R'),
      ' and saved into a folder with the name as the desired shiny app name.',
      br(),
      'Following steps are explained in the following ',
      a('Shiny tutorial.',
        href='https://shiny.rstudio.com/articles/app-formats.html', target='blank')
    ))
  )
}
