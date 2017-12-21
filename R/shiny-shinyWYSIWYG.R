#'shinyWYSIWYG GUI
#'
#'shinyWYSIWYG package shiny-based graphical user interface (GUI)
#'\code{shinyWYSIWYG} starts the GUI.
#'
#'@docType methods
#'@name shinyWYSIWYG-GUI
#'@rdname shinyWYSIWYG-GUI
#'
#'@examples
#'## Start the GUI
#'\dontrun{
#'shinyWYSIWYG();
#'}
#'
#'@import ggplot2
#'@import shiny
#'@import shinyjs
#'@export shinyWYSIWYG
#'
shinyWYSIWYG <- function() {
  appDir <- system.file('shiny', 'shinyWYSIWYG_GUI', package='shinyWYSIWYG');
  if (appDir == '') {
    stop('Could not find GUI directory. Try re-installing `shinyWYSIWYG`.',
         call.=FALSE);
  }

  runApp(appDir);
}
