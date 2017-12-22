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
#'@import shiny
#'
#'@importFrom ggplot2 ggplot geom_rect geom_text aes scale_y_reverse scale_x_continuous coord_fixed
#'@importFrom ggplot2 theme element_blank
#'@importFrom shinyjs disabled hidden useShinyjs
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
