source("serverCreator/serverCreator.R")
# Creates a new object (if not colliding in positions). And draws it.
# Called when objOkbtn pressed
createObj <- function(input, output, session, canvasObjects, validObjects) {
  objtype <- input$selectedObject
  objId <- gsub("%", "", input$objId) # '%' not allowed in names
  objX <- input$objX
  objY <- input$objY
  objWidth <- input$objWidth
  objHeight <- input$objHeight

  maxHeight <- input$canvasHeight
  maxWidth <- input$canvasWidth

  if (objX < 0 || objX > maxWidth || # x must be in canvas
    objY < 0 || objY > maxHeight || # y must be in canvas
    objWidth <= 0 || objHeight <= 0 || # cant be a line
    objX + objWidth > maxWidth || # cant exceed max canvas width
    objY + objHeight > maxHeight) { # cant exceed max canvas height
    showNotification("Incorrect dimensions!", type = "error")
    return(canvasObjects)
  }

  objList <- canvasObjects$objList
  objtypeList <- objList[[objtype]] # if it was present, then it updates
  objtypeList[[objId]] <- list(
    id = objId,
    type = objtype,
    x = objX,
    y = objY,
    width = objWidth,
    height = objHeight
  )

  objList[[objtype]] <- objtypeList

  canvasLayout <- createCanvasLayout(input, objList)
  if (all(is.na(canvasLayout))) {
    showNotification("Objects are colliding!", type = "error")
    return(canvasObjects)
  }

  canvasObjects <- list(objList = objList, canvasLayout = canvasLayout)
  drawCanvas(input, output, session, canvasObjects)

  # just to change name for new object
  objCreatorSelected(input, output, session, canvasObjects)

  # in the serverCreator ui, fill with this new object
  refreshServerCreatorUi(input, output, session, canvasObjects, validObjects)

  return(canvasObjects)
}

# Delete an object. And redraws canvas.
# Called when objDelbtn pressed
delObj <- function(input, output, session, canvasObjects, validObjects) {
  objtype <- input$selectedObject
  objId <- gsub("%", "", input$objId) # '%' not allowed in names

  objList <- canvasObjects$objList
  objtypeList <- objList[[objtype]]
  objtypeList <- objtypeList[names(objtypeList) != objId] # deleting it

  objList[[objtype]] <- objtypeList
  # if there is no more objects of this type, then delete the name from list
  objList <- objList[unlist(lapply(objList, function(x) length(x) > 0))]

  canvasLayout <- createCanvasLayout(input, objList)
  if (all(is.na(canvasLayout))) {
    # should not happen, because we are deleting, but, however
    showNotification("Objects are colliding!", type = "error")
    return(canvasObjects)
  }

  canvasObjects <- list(objList = objList, canvasLayout = canvasLayout)
  drawCanvas(input, output, session, canvasObjects)

  # in the serverCreator ui, remove this deleted object
  refreshServerCreatorUi(input, output, session, canvasObjects, validObjects)

  return(canvasObjects)
}

# Checks that objects dont collide, an generate the canvas matrices.
createCanvasLayout <- function(input, objList) {
  canvasWide <- do.call(rbind, lapply(names(objList), function(actObjsName) {
    # actObjsName <- names(objList)[[1]];
    actObjs <- objList[[actObjsName]]
    actRes <- do.call(rbind, lapply(actObjs, function(actObj) {
      # actObj <- actObjs[[1]];
      unlist(actObj)
    }))
    actRes[, c("id", "type", "x", "y", "width", "height")]
  }))
  # todo: better alternative for this! :@
  canvasWide <- data.frame(canvasWide)
  canvasWide$x <- as.numeric(as.character(canvasWide$x))
  canvasWide$y <- as.numeric(as.character(canvasWide$y))
  canvasWide$width <- as.numeric(as.character(canvasWide$width))
  canvasWide$height <- as.numeric(as.character(canvasWide$height))
  canvasWide$xmax <- canvasWide$x + canvasWide$width
  canvasWide$ymax <- canvasWide$y + canvasWide$height

  canvasLayout <- matrix("", ncol = input$canvasWidth, nrow = input$canvasHeight)
  for (i in seq_len(nrow(canvasWide))) {
    actObj <- canvasWide[i, , drop = FALSE]
    presentObjs <- canvasLayout[actObj$y:actObj$ymax, actObj$x:actObj$xmax]
    collidingObs <- presentObjs != "" & presentObjs != as.character(actObj$id)
    if (any(collidingObs)) {
      return(NA)
    }
    canvasLayout[actObj$y:actObj$ymax, actObj$x:actObj$xmax] <-
      as.character(actObj$id)
  }
  return(list(wide = canvasWide, long = canvasLayout))
}

# Depending on the type of the desired object to create, it generates a name
# for the new object.
# Called usually when selectedObject changes selection
objCreatorSelected <- function(input, output, session, canvasObjects) {
  selObj <- input$selectedObject

  # current objects of this type
  presentObjs <- names(canvasObjects$objList[[selObj]])
  nObjs <- length(presentObjs)
  res <- nObjs + 1
  if (nObjs > 0) {
    presentObjs <- presentObjs[grepl("_", presentObjs)]
    # only the ones which end in number
    actNums <- suppressWarnings(unlist(lapply(presentObjs, function(x) {
      as.numeric(rev(strsplit(x, "_")[[1]])[[1]])
    })))
    actNums <- actNums[!is.na(actNums)]
    if (length(actNums) == 0) {
      actNums <- 0
    }
    res <- min(setdiff(seq_len(max(actNums) + 1), actNums))
  }

  resName <- paste(input$selectedObject, res, sep = "_")
  updateTextInput(session, inputId = "objId", value = resName)
}

# Updates values depending on the current selected object (in canvas).
selectObject <- function(input, output, session, clickedObj) {
  updateSelectInput(session,
    inputId = "selectedObject", selected =
      clickedObj$type
  )

  updateNumericInput(session, inputId = "objX", value = clickedObj$x)
  updateNumericInput(session, inputId = "objY", value = clickedObj$y)
  updateNumericInput(session, inputId = "objWidth", value = clickedObj$width)
  updateNumericInput(session, inputId = "objHeight", value = clickedObj$height)
  updateTextInput(session, inputId = "objId", value = clickedObj$id)
}
