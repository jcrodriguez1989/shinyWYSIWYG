library('shiny');

source('utils.R');

source('uiCreator/serverObjCreator.R');
source('uiCreator/serverCanvas.R');
source('resultGenerator/serverResultGenerator.R');

shinyServer(function(input, output, session) {
  canvasObjects <- list(
    objList=list(),
    canvasLayout=list()
  );

  # it is created when shinyWYSIWYG starts, and never modified.
  # to avoid calling the function several times.
  # it is a list with 'Inputs' = shiny valid inputs
  # and 'Outputs' = shiny valid outputs.
  validObjects <- initializeUi(input, output, session); # returns the list of posible objects to create

  globalVars <- list();
  events <- list();

  ################### uiCreator

  ############### objCreator

  observeEvent(input$objOkbtn, {
    canvasObjects <<- createObj(input, output, session, canvasObjects, validObjects);
  })

  observeEvent(input$objDelbtn, {
    canvasObjects <<- delObj(input, output, session, canvasObjects, validObjects);
  })

  updateObjId <- !FALSE; # avoids updating objId when not desired
  observeEvent(input$selectedObject, {
    if (updateObjId) {
      objCreatorSelected(input, output, session, canvasObjects);
    } else {
      updateObjId <<- !FALSE;
    }
  })

  ############### canvas

  observeEvent(input$canvasbrush, {
    canvasbrushing(input, output, session);
  })

  observeEvent(input$canvasDblclick, {
    updateObjId <<- FALSE;
    canvasDblclick(input, output, session, canvasObjects);
  })

  ################### serverCreator

  ########### global vars

  observeEvent(input$globalVarCreatebtn, {
    createGlobalVarModal(input, output, session);
  })

  observeEvent(input$newGlobalVarCreated, {
    globalVars <<- createGlobalVar(input, output, session, globalVars);
  })

  observeEvent(input$globalVarDelbtn, {
    globalVars <<- delGlobalVar(input, output, session, globalVars);
  })

  ########### events

  observeEvent(input$newEventCreatebtn, {
    events <<- createEvent(input, output, session, events);
  })

  observeEvent(input$newEventDelbtn, {
    events <<- delEvent(input, output, session, events);
  })

  observeEvent(input$events, {
    eventSelChange(input, output, session, events);
  })

  ################### resultGenerator

  observeEvent(input$resultGeneratebtn, {
    getObjParams(input, output, session, canvasObjects);
  })

  observeEvent(input$filledObjArgsbtn, {
    canvasObjects <<- saveObjParams(input, output, session, canvasObjects);
    generateResult(input, output, session, canvasObjects, globalVars, events);
  })

  ################### save / load creator data

  output$creatorSavebtn <- downloadHandler(
    filename = function() {
      paste0('shinyWYSIWYG-', Sys.Date(), '.RData')
    },
    content = function(con) {
      shinyWYSIWYG_data <- list(
        canvasObjects=canvasObjects,
        validObjects=validObjects,
        globalVars=globalVars,
        events=events,
        global=input$globalInput
      );
      save(shinyWYSIWYG_data, file=con);
    }
  )

  observeEvent(input$creatorLoadbtn, {
    inFile <- input$creatorLoadbtn;
    env <- get(load(inFile$datapath));
    error <- !all(c(
      "canvasObjects",
      "validObjects",
      "globalVars",
      "events",
      "global") %in% names(env));
    if (error) {
      showNotification('Incorrect input file', type='error');
      return();
    }
    canvasObjects <<- env$canvasObjects;
    validObjects <<- env$validObjects;
    globalVars <<- env$globalVars;
    events <<- env$events;
    loadUi(input, output, session, env);
  })

})
