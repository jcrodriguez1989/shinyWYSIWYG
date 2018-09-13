ShinyWYSIWYG
================

Shiny What You See Is What You Get (WYSIWYG) editor
---------------------------------------------------

Features
--------

-   Create [Shiny](http://shiny.rstudio.com/) apps easily with this editor.

-   Helps to create the UI and the server.

-   Helps to learn how to develop Shiny apps.

Installation
------------

ShinyWYSIWYG is currently only available as a GitHub package. To install it run the following from an R console:

``` r
if (!require("devtools"))
  install.packages("devtools")
devtools::install_github("jcrodriguez1989/shinyWYSIWYG")
```

Usage
-----

From an R console type:

``` r
library("shinyWYSIWYG");

# will open the app in a web browser
shinyWYSIWYG();
```

Or visit the [example app](https://jcrodriguez.shinyapps.io/shinyWYSIWYG/) at shinyapps.io

Example
-------

Watch the [example video](https://youtu.be/mfEwWn2mxpU) of how to create a Shiny app with ShinyWYSIWYG.
